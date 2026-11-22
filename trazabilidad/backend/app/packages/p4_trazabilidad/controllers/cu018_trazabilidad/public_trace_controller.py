from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy.orm import Session, aliased
from sqlalchemy import select

from app.db.session import get_db
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu018_trazabilidad.consulta_trazabilidad import ConsultaTrazabilidad
from app.models.cu021_eventos_transporte.transport_event import EventoTrazabilidad, EventoUnidad
from app.packages.p4_trazabilidad.views.cu018_trazabilidad.public_trace_views import (
    PublicTraceResponse,
    TraceActorInfo,
    TraceUbicacionInfo,
    TraceProductoInfo,
    TraceVarianteInfo,
    TraceEventoInfo,
)

router = APIRouter(prefix="/trace", tags=["Registrar Consulta de Trazabilidad (CU-018)"])

_DETAIL_NO_ENCONTRADO = "Unidad no encontrada."


def _actor_info(actor: Optional[ActorCadena]) -> Optional[TraceActorInfo]:
    if not actor:
        return None
    return TraceActorInfo(nombre=actor.nombre, tipo=actor.tipoactor)


def _ubicacion_info(ubicacion: Optional[Ubicacion]) -> Optional[TraceUbicacionInfo]:
    if not ubicacion:
        return None
    return TraceUbicacionInfo(nombre=ubicacion.nombre, ciudad=ubicacion.ciudad, pais=ubicacion.pais)


class PublicTraceController:

    @staticmethod
    def _log_consulta(db: Session, qr: CodigoQR, request: Optional[Request]) -> None:
        """CU-018: registra el escaneo/consulta publica del QR (best-effort)."""
        ip = None
        useragent = None
        if request is not None:
            ip = (
                request.headers.get("x-forwarded-for", "").split(",")[0].strip()
                or (request.client.host if request.client else None)
            )
            useragent = request.headers.get("user-agent")
        db.add(
            ConsultaTrazabilidad(
                idcodigoqr=qr.idcodigoqr,
                ip=ip,
                useragent=useragent,
            )
        )
        db.commit()

    @staticmethod
    def get_trace(
        db: Session, uuidpublico: str, request: Optional[Request] = None
    ) -> PublicTraceResponse:
        """Historial publico de trazabilidad de una unidad a partir de su UUID (CU-018).

        Solo responde si la unidad tiene un QR activo: evita sondear UUIDs de
        unidades que nunca fueron etiquetadas con QR.
        """
        unit = db.execute(
            select(UnidadProducto).where(UnidadProducto.uuidpublico == uuidpublico)
        ).scalar_one_or_none()
        if not unit:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=_DETAIL_NO_ENCONTRADO)

        qr = db.execute(
            select(CodigoQR).where(CodigoQR.idunidad == unit.idunidad, CodigoQR.activo == True)
        ).scalar_one_or_none()
        if not qr:
            # Mismo mensaje que un UUID inexistente: no revelar la existencia
            # de unidades sin QR activo.
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=_DETAIL_NO_ENCONTRADO)

        # CU-018: registrar el escaneo sin bloquear la respuesta al consumidor.
        try:
            PublicTraceController._log_consulta(db, qr, request)
        except Exception:  # pragma: no cover - la consulta pública nunca debe fallar
            db.rollback()

        tenant = db.execute(
            select(Tenant).where(Tenant.idtenant == unit.idtenant)
        ).scalar_one_or_none()

        variante = db.execute(
            select(VarianteProducto).where(VarianteProducto.idvariante == unit.idvariante)
        ).scalar_one_or_none()

        producto = None
        if variante:
            producto = db.execute(
                select(Producto).where(Producto.idproducto == variante.idproducto)
            ).scalar_one_or_none()

        custodio = None
        if unit.idcustodioactual:
            custodio = db.execute(
                select(ActorCadena).where(ActorCadena.idactor == unit.idcustodioactual)
            ).scalar_one_or_none()

        ubicacion_actual = None
        if unit.idubicacionactual:
            ubicacion_actual = db.execute(
                select(Ubicacion).where(Ubicacion.idubicacion == unit.idubicacionactual)
            ).scalar_one_or_none()

        actor_origen = aliased(ActorCadena)
        actor_destino = aliased(ActorCadena)
        stmt_ev = (
            select(EventoTrazabilidad, Ubicacion, actor_origen, actor_destino)
            .join(EventoUnidad, EventoUnidad.idevento == EventoTrazabilidad.idevento)
            .outerjoin(Ubicacion, EventoTrazabilidad.idubicacion == Ubicacion.idubicacion)
            .outerjoin(actor_origen, EventoTrazabilidad.idactororigen == actor_origen.idactor)
            .outerjoin(actor_destino, EventoTrazabilidad.idactordestino == actor_destino.idactor)
            .where(EventoUnidad.idunidad == unit.idunidad)
            .order_by(EventoTrazabilidad.fechahora.asc())
        )
        eventos = [
            TraceEventoInfo(
                fechahora=ev.fechahora,
                tipoevento=ev.tipoevento,
                descripcion=ev.descripcion,
                estadoverificacion=ev.estadoverificacion,
                ubicacion=_ubicacion_info(ub),
                actor_origen=_actor_info(a_orig),
                actor_destino=_actor_info(a_dest),
            )
            for ev, ub, a_orig, a_dest in db.execute(stmt_ev).all()
        ]

        return PublicTraceResponse(
            uuidpublico=unit.uuidpublico,
            numeroserie=unit.numeroserie,
            estado=str(unit.estado) if unit.estado else None,
            fechaingreso=unit.fechaingreso,
            empresa=tenant.nombre if tenant else None,
            producto=TraceProductoInfo(
                nombre=producto.nombre,
                paisorigen=producto.paisorigen,
                imagenurl=producto.imagenurl,
            ) if producto else None,
            variante=TraceVarianteInfo(
                sku=variante.sku,
                color=variante.color,
                capacidad=variante.capacidad,
            ) if variante else None,
            custodio_actual=_actor_info(custodio),
            ubicacion_actual=_ubicacion_info(ubicacion_actual),
            qr_fechageneracion=qr.fechageneracion,
            eventos=eventos,
        )


@router.get("/{uuidpublico}", response_model=PublicTraceResponse)
def get_public_trace(uuidpublico: str, request: Request, db: Session = Depends(get_db)):
    """Consulta publica de trazabilidad escaneando el QR de una unidad (CU-018 / sin autenticacion)."""
    return PublicTraceController.get_trace(db, uuidpublico, request)
