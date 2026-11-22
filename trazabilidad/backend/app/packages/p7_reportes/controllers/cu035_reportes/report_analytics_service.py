"""Servicio de agregacion analitica por tenant para el panel integral (CU-035).

Todas las consultas se filtran por ``idtenant`` (o por join a la tabla padre que
lo contiene, ADR-001). No modifica datos ni incrementa contadores de plan.
"""
from datetime import datetime
from typing import Any, Dict, List, Optional, Sequence, Tuple

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.controllers.shared import get_bolivia_now
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu005_bitacora.notification import Notificacion
from app.packages.p2_catalogo.models.cu006_productos_variantes.product import Producto
from app.packages.p2_catalogo.models.cu006_productos_variantes.variant import VarianteProducto
from app.packages.p4_trazabilidad.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p4_trazabilidad.models.cu016_codigos_qr.qr_code import CodigoQR
from app.packages.p4_trazabilidad.models.cu018_trazabilidad.consulta_trazabilidad import ConsultaTrazabilidad
from app.packages.p4_trazabilidad.models.cu019_envios_logisticos.shipment import Envio
from app.packages.p4_trazabilidad.models.cu021_eventos_transporte.transport_event import (
    Alerta, CondicionTransporte, EventoTrazabilidad,
)
from app.packages.p4_trazabilidad.models.cu023_reporte_sospecha.suspicion_report import ReporteSospecha
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta, VentaDetalle
from app.packages.p5_comercial.models.cu027_pagos.pago import Pago
from app.packages.p5_comercial.models.cu029_devoluciones.devolucion import Devolucion
from app.packages.p5_comercial.models.cu031_garantias.garantia import GarantiaUnidad
from app.packages.p6_blockchain.models.cu033_blockchain.registro_blockchain import RegistroBlockchain
from app.packages.p7_reportes.views.cu035_reportes.report_analytics_views import (
    AnalyticsActividad, AnalyticsAlertas, AnalyticsComparacion, AnalyticsComercial,
    AnalyticsDistribucionItem, AnalyticsFacturacion, AnalyticsKpi, AnalyticsLogistica,
    AnalyticsPeriodo, AnalyticsPunto, AnalyticsRankingItem, AnalyticsSerie,
    AnalyticsSuscripcion, ReporteAnalyticsResponse,
)
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Plan, Suscripcion
from app.packages.p8_suscripciones.models.cu038_cuotas.uso_plan import UsoPlan
from app.packages.p8_suscripciones.models.cu039_facturacion.factura import Cobro, Factura


JoinSpec = Tuple[Any, Any]


def _clave(valor: Any) -> str:
    return str(valor.value if hasattr(valor, "value") else valor)


def _num(valor: Any, decimales: int = 2) -> float:
    if valor is None:
        return 0.0
    return round(float(valor), decimales)


def _periodos(ahora: datetime, meses: int) -> List[str]:
    total = ahora.year * 12 + ahora.month - 1
    return [
        f"{(total - desplazamiento) // 12:04d}-{(total - desplazamiento) % 12 + 1:02d}"
        for desplazamiento in range(meses - 1, -1, -1)
    ]


def _inicio_periodo(periodo: str) -> datetime:
    anio, mes = (int(parte) for parte in periodo.split("-"))
    return datetime(anio, mes, 1)


def _siguiente_mes(periodo: str) -> datetime:
    anio, mes = (int(parte) for parte in periodo.split("-"))
    return datetime(anio + (mes == 12), 1 if mes == 12 else mes + 1, 1)


def _desplazar(periodo: str, delta_meses: int) -> str:
    """Devuelve ``periodo`` desplazado ``delta_meses`` (positivo o negativo)."""
    anio, mes = (int(parte) for parte in periodo.split("-"))
    total = anio * 12 + mes - 1 + delta_meses
    return f"{total // 12:04d}-{total % 12 + 1:02d}"


def _periodos_entre(desde: str, hasta: str) -> int:
    anio_d, mes_d = (int(p) for p in desde.split("-"))
    anio_h, mes_h = (int(p) for p in hasta.split("-"))
    return (anio_h - anio_d) * 12 + (mes_h - mes_d) + 1


class ReportAnalyticsService:
    """Construye el payload del panel integral de un tenant."""

    def __init__(self, db: Session, tenant_id: int, meses: int):
        self.db = db
        self.tenant_id = tenant_id
        self.meses = meses
        self.ahora = get_bolivia_now()
        self.periodos = _periodos(self.ahora, meses)
        self.desde = _inicio_periodo(self.periodos[0])
        self.hasta = _siguiente_mes(self.periodos[-1])

    # ---------------------------------------------------------------- helpers
    def _fill(self, valores: Dict[str, Any]) -> List[float]:
        return [_num(valores.get(periodo, 0)) for periodo in self.periodos]

    def _serie(
        self,
        base: Any,
        columna: Any,
        condiciones: Sequence[Any],
        joins: Sequence[JoinSpec] = (),
        agregado: Any = None,
    ) -> List[float]:
        periodo = func.to_char(columna, "YYYY-MM").label("periodo")
        valor = (agregado if agregado is not None else func.count()).label("valor")
        stmt = select(periodo, valor)
        for modelo, condicion in joins:
            stmt = stmt.join(modelo, condicion)
        stmt = stmt.where(
            columna >= self.desde,
            columna < self.hasta,
            *condiciones,
        ).group_by(periodo)
        filas = self.db.execute(stmt).all()
        return self._fill({str(f[0]): f[1] for f in filas if f[0] is not None})

    def _count(
        self,
        base: Any,
        condiciones: Sequence[Any] = (),
        joins: Sequence[JoinSpec] = (),
    ) -> int:
        stmt = select(func.count()).select_from(base)
        for modelo, condicion in joins:
            stmt = stmt.join(modelo, condicion)
        stmt = stmt.where(*condiciones)
        return int(self.db.execute(stmt).scalar_one() or 0)

    def _sum(
        self,
        columna: Any,
        condiciones: Sequence[Any] = (),
        joins: Sequence[JoinSpec] = (),
    ) -> float:
        stmt = select(func.coalesce(func.sum(columna), 0))
        for modelo, condicion in joins:
            stmt = stmt.join(modelo, condicion)
        stmt = stmt.where(*condiciones)
        return _num(self.db.execute(stmt).scalar_one())

    def _promedio(
        self,
        columna: Any,
        condiciones: Sequence[Any] = (),
        joins: Sequence[JoinSpec] = (),
    ) -> float:
        stmt = select(func.avg(columna))
        for modelo, condicion in joins:
            stmt = stmt.join(modelo, condicion)
        stmt = stmt.where(*condiciones)
        return _num(self.db.execute(stmt).scalar_one())

    def _distribucion(
        self,
        columna: Any,
        condiciones: Sequence[Any] = (),
        joins: Sequence[JoinSpec] = (),
        limite: Optional[int] = None,
    ) -> List[AnalyticsDistribucionItem]:
        stmt = select(columna, func.count()).group_by(columna)
        for modelo, condicion in joins:
            stmt = stmt.join(modelo, condicion)
        stmt = stmt.where(*condiciones).order_by(func.count().desc())
        filas = self.db.execute(stmt).all()
        if limite:
            filas = filas[:limite]
        total = sum(int(n or 0) for _, n in filas)
        return [
            AnalyticsDistribucionItem(
                clave=_clave(clave) or "desconocido",
                cantidad=int(cantidad or 0),
                porcentaje=round(100 * int(cantidad or 0) / total, 1) if total else 0.0,
            )
            for clave, cantidad in filas
        ]

    @staticmethod
    def _serie_item(clave: str, etiqueta: str, unidad: str, puntos: List[float], periodos: List[str]) -> AnalyticsSerie:
        return AnalyticsSerie(
            clave=clave,
            etiqueta=etiqueta,
            unidad=unidad,
            puntos=[AnalyticsPunto(periodo=p, valor=v) for p, v in zip(periodos, puntos)],
            total=_num(sum(puntos)),
            promediomensual=_num(sum(puntos) / len(puntos)) if puntos else 0.0,
        )

    def _kpi(
        self,
        clave: str,
        etiqueta: str,
        valor: float,
        unidad: str,
        puntos: Optional[List[float]],
        base: str,
    ) -> AnalyticsKpi:
        variacion: Optional[float] = None
        texto_base: Optional[str] = base
        if puntos is not None:
            actual = sum(puntos[-12:])
            anterior = sum(puntos[-24:-12])
            if anterior:
                variacion = round((actual - anterior) / anterior * 100, 1)
            elif actual:
                texto_base = f"{base} (base 0)"
            else:
                texto_base = None
        return AnalyticsKpi(
            clave=clave,
            etiqueta=etiqueta,
            valor=_num(valor),
            unidad=unidad,
            variacion=variacion,
            base=texto_base,
        )

    # --------------------------------------------------------------- agregados
    def _construir_series(self) -> Dict[str, List[float]]:
        tid = self.tenant_id
        especificaciones = [
            ("unidades", UnidadProducto, UnidadProducto.fechaingreso, (), [UnidadProducto.idtenant == tid], func.count()),
            ("ventas", Venta, Venta.fechaventa, (), [Venta.idtenant == tid], func.count()),
            ("ingresos", Venta, Venta.fechaventa, (), [Venta.idtenant == tid], func.coalesce(func.sum(Venta.total), 0)),
            ("pagos", Pago, Pago.fechapago, ((Venta, Venta.idventa == Pago.idventa),), [Venta.idtenant == tid, Pago.estado == "completado"], func.count()),
            ("eventos", EventoTrazabilidad, EventoTrazabilidad.fechahora, (), [EventoTrazabilidad.idtenant == tid], func.count()),
            ("eventosblockchain", RegistroBlockchain, RegistroBlockchain.fechaenvio, ((EventoTrazabilidad, EventoTrazabilidad.idevento == RegistroBlockchain.idevento),), [EventoTrazabilidad.idtenant == tid], func.count()),
            ("alertas", Alerta, Alerta.fechadeteccion, (), [Alerta.idtenant == tid], func.count()),
            ("consultasqr", ConsultaTrazabilidad, ConsultaTrazabilidad.fechahora, (
                (CodigoQR, CodigoQR.idcodigoqr == ConsultaTrazabilidad.idcodigoqr),
                (UnidadProducto, UnidadProducto.idunidad == CodigoQR.idunidad),
            ), [UnidadProducto.idtenant == tid], func.count()),
            ("facturado", Factura, Factura.fechaemision, (), [Factura.idtenant == tid], func.coalesce(func.sum(Factura.monto), 0)),
            ("cobrado", Cobro, Cobro.fechacobro, ((Factura, Factura.idfactura == Cobro.idfactura),), [Factura.idtenant == tid, Cobro.estado == "completado"], func.coalesce(func.sum(Cobro.monto), 0)),
        ]
        resultado: Dict[str, List[float]] = {}
        for clave, base, columna, joins, condiciones, agregado in especificaciones:
            resultado[clave] = self._serie(base, columna, condiciones, joins, agregado)

        filas_uso = self.db.execute(
            select(UsoPlan.periodo, UsoPlan.reportesgenerados).where(
                UsoPlan.idtenant == tid, UsoPlan.periodo.in_(self.periodos)
            )
        ).all()
        resultado["reportesgenerados"] = self._fill({str(p): n for p, n in filas_uso})
        return resultado

    def _comercial(self, series: Dict[str, List[float]]) -> AnalyticsComercial:
        tid = self.tenant_id
        devoluciones = self._count(
            Devolucion,
            [Venta.idtenant == tid, Venta.fechaventa >= self.desde, Venta.fechaventa < self.hasta],
            ((Venta, Venta.idventa == Devolucion.idventa),),
        )
        garantias = self._count(
            GarantiaUnidad,
            [UnidadProducto.idtenant == tid, GarantiaUnidad.fechafin >= self.ahora.date()],
            ((UnidadProducto, UnidadProducto.idunidad == GarantiaUnidad.idunidad),),
        )
        ventas = int(sum(series["ventas"]))
        ingresos = _num(sum(series["ingresos"]))
        return AnalyticsComercial(
            ventas=ventas,
            ingresos=ingresos,
            pagoscompletados=int(sum(series["pagos"])),
            ticketpromedio=_num(ingresos / ventas) if ventas else 0.0,
            devoluciones=devoluciones,
            garantiasactivas=garantias,
        )

    def _alertas(self) -> AnalyticsAlertas:
        tid = self.tenant_id
        total = self._count(Alerta, [Alerta.idtenant == tid])
        abiertas = self._count(Alerta, [Alerta.idtenant == tid, Alerta.estado != "resuelta"])
        criticas = self._count(Alerta, [Alerta.idtenant == tid, Alerta.gravedad == "critica"])
        reportes = self._count(ReporteSospecha, [ReporteSospecha.idtenant == tid])
        score = self._promedio(ReporteSospecha.score_ml, [ReporteSospecha.idtenant == tid])
        return AnalyticsAlertas(
            total=total,
            abiertas=abiertas,
            criticas=criticas,
            reportessospecha=reportes,
            tasaresolucion=round(100 * (total - abiertas) / total, 1) if total else 0.0,
            scoremlpromedio=score,
        )

    def _logistica(self) -> AnalyticsLogistica:
        tid = self.tenant_id
        filas = self.db.execute(
            select(Envio.estado, Envio.fechaestimada, Envio.fechaentrega).where(
                Envio.idtenant == tid,
                Envio.fechasalida >= self.desde,
                Envio.fechasalida < self.hasta,
            )
        ).all()
        a_tiempo = sum(
            1 for estado, estimada, entrega in filas
            if estado == "entregado" and entrega is not None and (estimada is None or entrega <= estimada)
        )
        tipos_transporte = (
            "fabricacion", "control_calidad_apple", "exportacion", "transporte_maritimo",
            "transporte_aereo", "llegada_puerto", "despacho_aduanero", "transporte_terrestre",
            "recepcion_almacen",
        )
        eventos = self._count(
            EventoTrazabilidad,
            [EventoTrazabilidad.idtenant == tid, EventoTrazabilidad.tipoevento.in_(tipos_transporte)],
        )
        joins = ((EventoTrazabilidad, EventoTrazabilidad.idevento == CondicionTransporte.idevento),)
        condiciones = [EventoTrazabilidad.idtenant == tid]
        return AnalyticsLogistica(
            envios=len(filas),
            entregasatiempo=a_tiempo,
            eventos=eventos,
            temperatura_promedio=self._promedio(CondicionTransporte.temperatura, condiciones, joins),
            humedad_promedio=self._promedio(CondicionTransporte.humedad, condiciones, joins),
            vibracion_promedio=self._promedio(CondicionTransporte.nivelvibracion, condiciones, joins),
        )

    def _facturacion(self, series: Dict[str, List[float]]) -> AnalyticsFacturacion:
        tid = self.tenant_id
        facturas = self._count(Factura, [Factura.idtenant == tid])
        cobros = self._count(
            Cobro,
            [Factura.idtenant == tid],
            ((Factura, Factura.idfactura == Cobro.idfactura),),
        )
        facturado = _num(sum(series["facturado"]))
        cobrado = _num(sum(series["cobrado"]))
        return AnalyticsFacturacion(
            facturado=facturado,
            cobrado=cobrado,
            saldo=_num(facturado - cobrado),
            facturas=facturas,
            cobros=cobros,
        )

    def _actividad(self, series: Dict[str, List[float]], total_unidades: int) -> AnalyticsActividad:
        tid = self.tenant_id
        join_ut = ((UsuarioTenant, UsuarioTenant.idusuariotenant == Bitacora.idusuariotenant),)
        bitacora = self._count(
            Bitacora,
            [UsuarioTenant.idtenant == tid, Bitacora.fechahora >= self.desde, Bitacora.fechahora < self.hasta],
            join_ut,
        )
        join_not = ((UsuarioTenant, UsuarioTenant.idusuariotenant == Notificacion.idusuariotenant),)
        notificaciones = self._count(
            Notificacion,
            [UsuarioTenant.idtenant == tid, Notificacion.fechaenvio >= self.desde, Notificacion.fechaenvio < self.hasta],
            join_not,
        )
        leidas = self._count(
            Notificacion,
            [UsuarioTenant.idtenant == tid, Notificacion.leida.is_(True), Notificacion.fechaenvio >= self.desde, Notificacion.fechaenvio < self.hasta],
            join_not,
        )
        consultas = int(sum(series["consultasqr"]))
        certificados = self._count(
            RegistroBlockchain,
            [EventoTrazabilidad.idtenant == tid, RegistroBlockchain.estado == "confirmado"],
            ((EventoTrazabilidad, EventoTrazabilidad.idevento == RegistroBlockchain.idevento),),
        )
        return AnalyticsActividad(
            bitacora=bitacora,
            notificaciones=notificaciones,
            notificaciones_leidas=leidas,
            consultas_qr=consultas,
            consultas_por_unidad=_num(consultas / total_unidades) if total_unidades else 0.0,
            certificados=certificados,
        )

    def _suscripcion(self) -> AnalyticsSuscripcion:
        tid = self.tenant_id
        fila = self.db.execute(
            select(Plan.nombre, Suscripcion.estado)
            .join(Plan, Plan.idplan == Suscripcion.idplan)
            .where(Suscripcion.idtenant == tid)
            .order_by(Suscripcion.idsuscripcion.desc())
        ).first()
        uso = self.db.execute(
            select(UsoPlan).where(
                UsoPlan.idtenant == tid,
                UsoPlan.periodo == self.ahora.strftime("%Y-%m"),
            )
        ).scalar_one_or_none()
        return AnalyticsSuscripcion(
            plan=fila[0] if fila else None,
            estado=_clave(fila[1]) if fila and fila[1] else None,
            consumomes={
                "reportesgenerados": uso.reportesgenerados,
                "unidadesregistradas": uso.unidadesregistradas,
                "usuariosactivos": uso.usuariosactivos,
            } if uso else None,
        )

    def _ranking(self) -> Dict[str, List[AnalyticsRankingItem]]:
        tid = self.tenant_id
        filas = self.db.execute(
            select(
                Producto.nombre,
                func.coalesce(func.sum(VentaDetalle.cantidad), 0),
                func.coalesce(func.sum(VentaDetalle.subtotal), 0),
            )
            .join(Venta, Venta.idventa == VentaDetalle.idventa)
            .join(VarianteProducto, VarianteProducto.idvariante == VentaDetalle.idvariante)
            .join(Producto, Producto.idproducto == VarianteProducto.idproducto)
            .where(
                Venta.idtenant == tid,
                Venta.fechaventa >= self.desde,
                Venta.fechaventa < self.hasta,
            )
            .group_by(Producto.nombre)
            .order_by(func.sum(VentaDetalle.subtotal).desc())
            .limit(8)
        ).all()
        eventos = self._distribucion(
            EventoTrazabilidad.tipoevento,
            [EventoTrazabilidad.idtenant == tid],
            limite=8,
        )
        return {
            "productos": [
                AnalyticsRankingItem(clave=str(nombre), cantidad=int(cantidad or 0), monto=_num(monto))
                for nombre, cantidad, monto in filas
            ],
            "tipos_evento": [
                AnalyticsRankingItem(clave=item.clave, cantidad=item.cantidad, monto=0.0)
                for item in eventos
            ],
        }

    def build(self) -> ReporteAnalyticsResponse:
        tid = self.tenant_id
        tenant = self.db.execute(
            select(Tenant.nombre).where(Tenant.idtenant == tid)
        ).scalar_one_or_none()
        series_valores = self._construir_series()

        etiquetas = {
            "unidades": ("Unidades ingresadas", "u"),
            "ventas": ("Ventas", ""),
            "ingresos": ("Ingresos", "USD"),
            "pagos": ("Pagos completados", ""),
            "eventos": ("Eventos de trazabilidad", ""),
            "eventosblockchain": ("Eventos anclados", ""),
            "alertas": ("Alertas detectadas", ""),
            "consultasqr": ("Consultas QR", ""),
            "facturado": ("Facturación emitida", "USD"),
            "cobrado": ("Cobros", "USD"),
            "reportesgenerados": ("Reportes generados", ""),
        }
        series = [
            self._serie_item(clave, etiquetas[clave][0], etiquetas[clave][1], puntos, self.periodos)
            for clave, puntos in series_valores.items()
        ]
        por_clave = {item.clave: item for item in series}
        total_unidades = self._count(UnidadProducto, [UnidadProducto.idtenant == tid])
        base = "vs 12 meses anteriores"
        kpis = [
            self._kpi("unidades", "Unidades registradas", total_unidades, "", [p.valor for p in por_clave["unidades"].puntos], base),
            self._kpi("ventas", "Ventas", por_clave["ventas"].total, "", [p.valor for p in por_clave["ventas"].puntos], base),
            self._kpi("ingresos", "Ingresos (USD)", por_clave["ingresos"].total, "USD", [p.valor for p in por_clave["ingresos"].puntos], base),
            self._kpi("pagos", "Pagos completados", por_clave["pagos"].total, "", [p.valor for p in por_clave["pagos"].puntos], base),
            self._kpi("eventos", "Eventos", por_clave["eventos"].total, "", [p.valor for p in por_clave["eventos"].puntos], base),
            self._kpi("blockchain", "Eventos anclados", por_clave["eventosblockchain"].total, "", [p.valor for p in por_clave["eventosblockchain"].puntos], base),
            self._kpi("alertas", "Alertas", por_clave["alertas"].total, "", [p.valor for p in por_clave["alertas"].puntos], base),
            self._kpi("consultasqr", "Consultas QR", por_clave["consultasqr"].total, "", [p.valor for p in por_clave["consultasqr"].puntos], base),
            self._kpi("facturado", "Facturado (USD)", por_clave["facturado"].total, "USD", [p.valor for p in por_clave["facturado"].puntos], base),
            self._kpi("reportes", "Reportes generados", por_clave["reportesgenerados"].total, "", [p.valor for p in por_clave["reportesgenerados"].puntos], base),
        ]

        condiciones_tenant = [UnidadProducto.idtenant == tid]
        condiciones_evento = [EventoTrazabilidad.idtenant == tid]
        condiciones_alerta = [Alerta.idtenant == tid]
        actual_desde = self.periodos[-12] if self.meses >= 12 else self.periodos[0]
        actual_hasta = self.periodos[-1]
        anterior_hasta = _desplazar(actual_desde, -1)
        anterior_desde = _desplazar(
            actual_desde, -(_periodos_entre(actual_desde, actual_hasta))
        )
        return ReporteAnalyticsResponse(
            idtenant=tid,
            tenantnombre=str(tenant or ""),
            generadoen=self.ahora,
            periodo=AnalyticsPeriodo(desde=self.periodos[0], hasta=self.periodos[-1], meses=len(self.periodos)),
            comparacion=AnalyticsComparacion(
                etiqueta=base,
                desde=actual_desde,
                hasta=actual_hasta,
                anterior_desde=anterior_desde,
                anterior_hasta=anterior_hasta,
            ),
            kpis=kpis,
            series=series,
            distribuciones={
                "unidades_por_estado": self._distribucion(UnidadProducto.estado, condiciones_tenant),
                "eventos_por_tipo": self._distribucion(EventoTrazabilidad.tipoevento, condiciones_evento),
                "eventos_por_verificacion": self._distribucion(EventoTrazabilidad.estadoverificacion, condiciones_evento),
                "alertas_por_gravedad": self._distribucion(Alerta.gravedad, condiciones_alerta),
                "alertas_por_estado": self._distribucion(Alerta.estado, condiciones_alerta),
                "alertas_por_tipo": self._distribucion(Alerta.tipoalerta, condiciones_alerta),
                "ventas_por_estado": self._distribucion(Venta.estado, [Venta.idtenant == tid]),
                "pagos_por_metodo": self._distribucion(Pago.metodopago, [Venta.idtenant == tid], ((Venta, Venta.idventa == Pago.idventa),)),
                "reportes_sospecha_por_estado": self._distribucion(ReporteSospecha.estado, [ReporteSospecha.idtenant == tid]),
                "facturas_por_estado": self._distribucion(Factura.estado, [Factura.idtenant == tid]),
            },
            ranking=self._ranking(),
            comercial=self._comercial(series_valores),
            alertas=self._alertas(),
            logistica=self._logistica(),
            facturacion=self._facturacion(series_valores),
            actividad=self._actividad(series_valores, total_unidades),
            suscripcion=self._suscripcion(),
        )
