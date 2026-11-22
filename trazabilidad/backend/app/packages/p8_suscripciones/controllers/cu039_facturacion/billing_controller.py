"""CU-039 - Gestionar facturación e historial de cobros (P8)."""
from datetime import datetime
from decimal import Decimal
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_bolivia_now, require_roles, resolve_tenant_id
from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.packages.p8_suscripciones.controllers.cu040_notificaciones.billing_notifier import billing_notifier
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Suscripcion
from app.packages.p8_suscripciones.models.cu039_facturacion.factura import Cobro, Factura, FacturaDetalle
from app.packages.p8_suscripciones.views.cu039_facturacion.billing_views import (
    CrearFacturaRequest, FacturaListResponse, FacturaResponse,
    HistorialFacturacionResponse, RegistrarCobroRequest,
)

router = APIRouter(prefix="/invoices", tags=["Facturación e Historial (CU-039)"])
history_router = APIRouter(prefix="/billing", tags=["Historial de Facturación (CU-039)"])
requires_facturacion = require_roles("SuperAdministrador", "AdministradorEmpresa")


class BillingController:

    @staticmethod
    def _get_factura(db: Session, tenant_id: int, idfactura: int) -> Factura:
        factura = db.execute(
            select(Factura).where(
                Factura.idfactura == idfactura, Factura.idtenant == tenant_id
            )
        ).scalar_one_or_none()
        if not factura:
            raise HTTPException(status_code=404, detail=f"Factura {idfactura} no encontrada.")
        return factura

    @staticmethod
    def _saldo(db: Session, factura: Factura) -> Decimal:
        cobrado = db.execute(
            select(func.coalesce(func.sum(Cobro.monto), 0)).where(
                Cobro.idfactura == factura.idfactura, Cobro.estado == "completado"
            )
        ).scalar() or Decimal("0")
        return Decimal(str(factura.monto)) - Decimal(str(cobrado))

    @staticmethod
    def _to_response(db: Session, factura: Factura) -> FacturaResponse:
        items = db.execute(
            select(FacturaDetalle).where(FacturaDetalle.idfactura == factura.idfactura)
            .order_by(FacturaDetalle.idfacturadetalle)
        ).scalars().all()
        cobros = db.execute(
            select(Cobro).where(Cobro.idfactura == factura.idfactura)
            .order_by(Cobro.fechacobro)
        ).scalars().all()
        saldo = BillingController._saldo(db, factura)
        return FacturaResponse(
            idfactura=factura.idfactura,
            idtenant=factura.idtenant,
            idsuscripcion=factura.idsuscripcion,
            numero=factura.numero,
            fechaemision=factura.fechaemision,
            fechavencimiento=factura.fechavencimiento,
            monto=factura.monto,
            moneda=factura.moneda,
            estado=str(factura.estado) if saldo > 0 else "pagada",
            saldo=max(Decimal("0.00"), saldo).quantize(Decimal("0.01")),
            items=[{
                "idfacturadetalle": i.idfacturadetalle,
                "concepto": i.concepto,
                "cantidad": i.cantidad,
                "preciounitario": i.preciounitario,
                "subtotal": i.subtotal,
            } for i in items],
            cobros=cobros,
        )

    @staticmethod
    def list_facturas(db: Session, user: User, estado: Optional[str],
                      skip: int, limit: int) -> FacturaListResponse:
        tenant_id = resolve_tenant_id(db, user)
        query = select(Factura).where(Factura.idtenant == tenant_id)
        if estado:
            query = query.where(Factura.estado == estado)
        total = db.execute(select(func.count()).select_from(query.subquery())).scalar_one()
        facturas = db.execute(
            query.order_by(Factura.fechaemision.desc()).offset(skip).limit(limit)
        ).scalars().all()
        return FacturaListResponse(
            total=total,
            items=[BillingController._to_response(db, f) for f in facturas],
        )

    @staticmethod
    def create_factura(db: Session, user: User, body: CrearFacturaRequest) -> FacturaResponse:
        tenant_id = resolve_tenant_id(db, user)
        if body.fechavencimiento <= get_bolivia_now():
            raise HTTPException(status_code=400, detail="fechavencimiento debe ser futura.")

        if body.idsuscripcion is not None:
            sus = db.execute(
                select(Suscripcion).where(
                    Suscripcion.idsuscripcion == body.idsuscripcion,
                    Suscripcion.idtenant == tenant_id,
                )
            ).scalar_one_or_none()
            if not sus:
                raise HTTPException(status_code=404, detail="Suscripción no encontrada en su empresa.")

        numero = body.numero or f"FAC-{tenant_id}-{int(get_bolivia_now().timestamp())}"
        existe = db.execute(
            select(Factura).where(Factura.idtenant == tenant_id, Factura.numero == numero)
        ).scalar_one_or_none()
        if existe:
            raise HTTPException(status_code=409, detail=f"La factura {numero} ya existe.")

        monto = sum(
            (Decimal(str(i.preciounitario)) * i.cantidad for i in body.items), Decimal("0")
        )
        factura = Factura(
            idtenant=tenant_id,
            idsuscripcion=body.idsuscripcion,
            numero=numero,
            fechaemision=get_bolivia_now(),
            fechavencimiento=body.fechavencimiento,
            monto=monto,
            moneda=body.moneda,
            estado="pendiente",
        )
        db.add(factura)
        db.flush()
        for item in body.items:
            db.add(FacturaDetalle(
                idfactura=factura.idfactura,
                concepto=item.concepto,
                cantidad=item.cantidad,
                preciounitario=item.preciounitario,
                subtotal=Decimal(str(item.preciounitario)) * item.cantidad,
            ))
        db.flush()
        billing_notifier.notificar_factura_emitida(db, factura)
        db.commit()
        db.refresh(factura)
        return BillingController._to_response(db, factura)

    @staticmethod
    def registrar_cobro(db: Session, user: User, idfactura: int,
                        body: RegistrarCobroRequest) -> FacturaResponse:
        tenant_id = resolve_tenant_id(db, user)
        factura = BillingController._get_factura(db, tenant_id, idfactura)
        saldo = BillingController._saldo(db, factura)
        if saldo <= 0:
            raise HTTPException(status_code=409, detail="La factura ya está cancelada.")
        if Decimal(str(body.monto)) > saldo:
            raise HTTPException(
                status_code=400, detail=f"El monto supera el saldo pendiente ({saldo})."
            )
        db.add(Cobro(
            idfactura=idfactura,
            fechacobro=get_bolivia_now(),
            monto=body.monto,
            metodopago=body.metodopago,
            referencia=body.referencia,
            estado="completado",
        ))
        db.flush()
        if BillingController._saldo(db, factura) <= 0:
            factura.estado = "pagada"
        billing_notifier.notificar_cobro(db, factura, body.monto)
        db.commit()
        db.refresh(factura)
        return BillingController._to_response(db, factura)

    @staticmethod
    def historial(db: Session, user: User) -> HistorialFacturacionResponse:
        tenant_id = resolve_tenant_id(db, user)
        facturas = db.execute(
            select(Factura).where(Factura.idtenant == tenant_id)
            .order_by(Factura.fechaemision.desc())
        ).scalars().all()
        items = [BillingController._to_response(db, f) for f in facturas]
        total_facturado = sum((i.monto for i in items), Decimal("0"))
        total_cobrado = sum((i.monto - i.saldo for i in items), Decimal("0"))
        cobros = db.execute(
            select(func.count()).select_from(Cobro)
            .join(Factura, Factura.idfactura == Cobro.idfactura)
            .where(Factura.idtenant == tenant_id)
        ).scalar_one()
        return HistorialFacturacionResponse(
            idtenant=tenant_id,
            totalfacturado=total_facturado,
            totalcobrado=total_cobrado,
            saldopendiente=total_facturado - total_cobrado,
            facturas=len(items),
            cobros=cobros,
            items=items,
        )


@router.get("", response_model=FacturaListResponse)
def list_facturas(
    estado: Optional[str] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_facturacion),
):
    return BillingController.list_facturas(db, current_user, estado, skip, limit)


@router.get("/{idfactura}", response_model=FacturaResponse)
def get_factura(
    idfactura: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_facturacion),
):
    tenant_id = resolve_tenant_id(db, current_user)
    return BillingController._to_response(
        db, BillingController._get_factura(db, tenant_id, idfactura)
    )


@router.post("", response_model=FacturaResponse, status_code=status.HTTP_201_CREATED)
def create_factura(
    body: CrearFacturaRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_facturacion),
):
    return BillingController.create_factura(db, current_user, body)


@router.post("/{idfactura}/charges", response_model=FacturaResponse)
def registrar_cobro(
    idfactura: int,
    body: RegistrarCobroRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_facturacion),
):
    return BillingController.registrar_cobro(db, current_user, idfactura, body)


@history_router.get("/history", response_model=HistorialFacturacionResponse)
def historial_facturacion(
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_facturacion),
):
    return BillingController.historial(db, current_user)
