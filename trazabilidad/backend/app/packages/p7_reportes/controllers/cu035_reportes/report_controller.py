"""CU-035 - Consultar Reportes y Dashboards (P7)."""
from datetime import datetime
from decimal import Decimal
from io import BytesIO
from typing import Dict, List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy import Integer, func, select
from sqlalchemy.orm import Session

from reportlab.lib.pagesizes import A4
from reportlab.lib.units import mm
from reportlab.pdfgen import canvas

from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_bolivia_now, require_roles, resolve_tenant_id
from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p4_trazabilidad.models.cu021_eventos_transporte.transport_event import (
    Alerta, EventoTrazabilidad,
)
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta
from app.packages.p5_comercial.models.cu027_pagos.pago import Pago
from app.packages.p6_blockchain.models.cu033_blockchain.registro_blockchain import RegistroBlockchain
from app.packages.p7_reportes.controllers.cu035_reportes.report_analytics_service import ReportAnalyticsService
from app.packages.p7_reportes.views.cu035_reportes.report_analytics_views import ReporteAnalyticsResponse
from app.packages.p7_reportes.views.cu035_reportes.report_views import (
    DashboardResponse, ReporteResumenResponse, ReporteTrazabilidadResponse, SerieTemporalItem,
)
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Plan, Suscripcion
from app.packages.p8_suscripciones.models.cu038_cuotas.uso_plan import UsoPlan

router = APIRouter(prefix="/reports", tags=["Reportes y Dashboards (CU-035)"])
dashboard_router = APIRouter(prefix="/dashboard", tags=["Reportes y Dashboards (CU-035)"])

requires_reportes = require_roles(
    "SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones",
    "GestorVentasPostventa", "Auditor",
)


def resolve_analytics_tenant(
    idtenant: Optional[int] = Query(None, ge=1),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> int:
    """Resuelve el tenant del panel integral (ADR-001/005)."""
    return resolve_tenant_id(db, current_user, idtenant)


def _clave(valor) -> str:
    return str(valor.value if hasattr(valor, "value") else valor)


class ReportController:

    @staticmethod
    def _conteo_por_estado(db: Session, tenant_id: int) -> Dict[str, int]:
        filas = db.execute(
            select(UnidadProducto.estado, func.count())
            .where(UnidadProducto.idtenant == tenant_id)
            .group_by(UnidadProducto.estado)
        ).all()
        return {_clave(estado) or "desconocido": total for estado, total in filas}

    @staticmethod
    def resumen(db: Session, user: User) -> ReporteResumenResponse:
        tenant_id = resolve_tenant_id(db, user)

        unidades = db.execute(
            select(func.count()).select_from(UnidadProducto).where(
                UnidadProducto.idtenant == tenant_id
            )
        ).scalar_one()

        venta_query = select(func.count(), func.coalesce(func.sum(Venta.total), 0)).where(
            Venta.idtenant == tenant_id
        )
        total_ventas, ingresos = db.execute(venta_query).one()

        pagos = db.execute(
            select(func.count()).select_from(Pago)
            .join(Venta, Venta.idventa == Pago.idventa)
            .where(Venta.idtenant == tenant_id, Pago.estado == "completado")
        ).scalar_one()

        total_alertas, alertas_abiertas = db.execute(
            select(func.count(), func.sum(func.cast(Alerta.estado != "resuelta", Integer))).where(
                Alerta.idtenant == tenant_id
            )
        ).one()

        eventos = db.execute(
            select(func.count()).select_from(EventoTrazabilidad).where(
                EventoTrazabilidad.idtenant == tenant_id
            )
        ).scalar_one()

        blockchain = db.execute(
            select(func.count()).select_from(RegistroBlockchain)
            .join(EventoTrazabilidad, EventoTrazabilidad.idevento == RegistroBlockchain.idevento)
            .where(EventoTrazabilidad.idtenant == tenant_id)
        ).scalar_one()

        suscripcion = db.execute(
            select(Plan.nombre, Suscripcion.estado)
            .join(Plan, Plan.idplan == Suscripcion.idplan)
            .where(Suscripcion.idtenant == tenant_id)
            .order_by(Suscripcion.idsuscripcion.desc())
            .limit(1)
        ).first()

        periodo = get_bolivia_now().strftime("%Y-%m")
        uso = db.execute(
            select(UsoPlan).where(UsoPlan.idtenant == tenant_id, UsoPlan.periodo == periodo)
        ).scalar_one_or_none()

        return ReporteResumenResponse(
            idtenant=tenant_id,
            generadoen=get_bolivia_now(),
            totalunidades=unidades,
            unidades_por_estado=ReportController._conteo_por_estado(db, tenant_id),
            totalventas=total_ventas,
            ingresos=Decimal(str(ingresos or 0)),
            totalpagoscompletados=pagos,
            totalalertas=total_alertas,
            alertasabiertas=int(alertas_abiertas or 0),
            totaleventos=eventos,
            eventosblockchain=blockchain,
            planesusados=f"{suscripcion[0]} ({suscripcion[1]})" if suscripcion else None,
            consumomes={
                "reportesgenerados": uso.reportesgenerados,
                "unidadesregistradas": uso.unidadesregistradas,
                "usuariosactivos": uso.usuariosactivos,
            } if uso else None,
        )

    @staticmethod
    def trazabilidad(db: Session, user: User) -> ReporteTrazabilidadResponse:
        tenant_id = resolve_tenant_id(db, user)

        por_tipo = db.execute(
            select(EventoTrazabilidad.tipoevento, func.count())
            .where(EventoTrazabilidad.idtenant == tenant_id)
            .group_by(EventoTrazabilidad.tipoevento)
        ).all()

        periodo = func.to_char(EventoTrazabilidad.fechahora, "YYYY-MM").label("periodo")
        serie = db.execute(
            select(periodo, func.count())
            .where(EventoTrazabilidad.idtenant == tenant_id)
            .group_by(periodo)
            .order_by(periodo)
        ).all()

        gravedades = db.execute(
            select(Alerta.gravedad, func.count())
            .where(Alerta.idtenant == tenant_id)
            .group_by(Alerta.gravedad)
        ).all()

        return ReporteTrazabilidadResponse(
            idtenant=tenant_id,
            eventosportipo={_clave(tipo): n for tipo, n in por_tipo},
            eventosportipo_camion=[
                SerieTemporalItem(periodo=str(periodo), cantidad=n)
                for periodo, n in serie if periodo is not None
            ],
            alertasporgravedad={_clave(g): n for g, n in gravedades},
            unidades_por_estado=ReportController._conteo_por_estado(db, tenant_id),
        )

    @staticmethod
    def dashboard(db: Session, user: User) -> DashboardResponse:
        tenant_id = resolve_tenant_id(db, user)
        resumen = ReportController.resumen(db, user)

        eventos = db.execute(
            select(EventoTrazabilidad.idevento, EventoTrazabilidad.tipoevento,
                   EventoTrazabilidad.fechahora, EventoTrazabilidad.descripcion)
            .where(EventoTrazabilidad.idtenant == tenant_id)
            .order_by(EventoTrazabilidad.fechahora.desc())
            .limit(10)
        ).all()
        alertas = db.execute(
            select(Alerta.idalerta, Alerta.tipoalerta, Alerta.gravedad, Alerta.estado,
                   Alerta.fechadeteccion)
            .where(Alerta.idtenant == tenant_id)
            .order_by(Alerta.fechadeteccion.desc())
            .limit(10)
        ).all()

        return DashboardResponse(
            idtenant=tenant_id,
            resumen=resumen,
            ultimoseventos=[{
                "idevento": e[0], "tipoevento": _clave(e[1]),
                "fechahora": e[2], "descripcion": e[3],
            } for e in eventos],
            alertasrecientes=[{
                "idalerta": a[0], "tipoalerta": _clave(a[1]), "gravedad": _clave(a[2]),
                "estado": _clave(a[3]), "fechadeteccion": a[4],
            } for a in alertas],
        )

    @staticmethod
    def pdf(db: Session, user: User) -> bytes:
        resumen = ReportController.resumen(db, user)
        buf = BytesIO()
        c = canvas.Canvas(buf, pagesize=A4)
        width, height = A4
        y = height - 25 * mm

        c.setFont("Helvetica-Bold", 16)
        c.drawString(20 * mm, y, "Reporte de Trazabilidad - Sprint 4")
        y -= 12 * mm
        c.setFont("Helvetica", 10)
        c.drawString(20 * mm, y, f"Empresa (tenant): {resumen.idtenant}")
        y -= 6 * mm
        c.drawString(20 * mm, y, f"Generado: {resumen.generadoen:%Y-%m-%d %H:%M}")

        filas = [
            ("Unidades registradas", resumen.totalunidades),
            ("Ventas", resumen.totalventas),
            ("Ingresos (USD)", resumen.ingresos),
            ("Pagos completados", resumen.totalpagoscompletados),
            ("Alertas", resumen.totalalertas),
            ("Alertas abiertas", resumen.alertasabiertas),
            ("Eventos de trazabilidad", resumen.totaleventos),
            ("Eventos anclados en blockchain", resumen.eventosblockchain),
            ("Plan", resumen.planesusados or "Sin suscripción"),
        ]
        y -= 12 * mm
        for etiqueta, valor in filas:
            c.drawString(20 * mm, y, etiqueta)
            c.drawRightString(width - 20 * mm, y, str(valor))
            y -= 7 * mm

        y -= 8 * mm
        c.setFont("Helvetica-Bold", 11)
        c.drawString(20 * mm, y, "Unidades por estado")
        y -= 7 * mm
        c.setFont("Helvetica", 10)
        for estado, total in sorted(resumen.unidades_por_estado.items()):
            c.drawString(25 * mm, y, estado)
            c.drawRightString(width - 20 * mm, y, str(total))
            y -= 6 * mm

        c.showPage()
        c.save()
        return buf.getvalue()


@router.get("/summary", response_model=ReporteResumenResponse)
def get_summary(db: Session = Depends(get_db), current_user: User = Depends(requires_reportes)):
    return ReportController.resumen(db, current_user)


@router.get("/traceability", response_model=ReporteTrazabilidadResponse)
def get_traceability(db: Session = Depends(get_db), current_user: User = Depends(requires_reportes)):
    return ReportController.trazabilidad(db, current_user)


@router.get("/pdf")
def get_pdf(db: Session = Depends(get_db), current_user: User = Depends(requires_reportes)):
    contenido = ReportController.pdf(db, current_user)
    return Response(
        content=contenido,
        media_type="application/pdf",
        headers={"Content-Disposition": 'attachment; filename="reporte-trazabilidad.pdf"'},
    )


@router.get("/analytics", response_model=ReporteAnalyticsResponse)
def get_analytics(
    meses: int = Query(36, ge=1, le=36),
    db: Session = Depends(get_db),
    tenant_id: int = Depends(resolve_analytics_tenant),
    current_user: User = Depends(requires_reportes),
):
    """Panel integral por tenant con series mensuales y todos los reportes."""
    return ReportAnalyticsService(db, tenant_id, meses).build()


@dashboard_router.get("", response_model=DashboardResponse)
def get_dashboard(db: Session = Depends(get_db), current_user: User = Depends(requires_reportes)):
    return ReportController.dashboard(db, current_user)
