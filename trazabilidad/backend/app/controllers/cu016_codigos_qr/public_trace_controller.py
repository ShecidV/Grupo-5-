from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import select
from sqlalchemy.orm import aliased

from app.db.session import get_db
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu021_eventos_transporte.transport_event import EventoTrazabilidad, EventoUnidad
from app.views.cu016_codigos_qr.public_trace_views import (
    PublicTraceResponse,
    TraceActorInfo,
    TraceUbicacionInfo,
    TraceProductoInfo,
    TraceVarianteInfo,
    TraceEventoInfo,
)

router = APIRouter(prefix="/trace", tags=["Trazabilidad Pública (CU-016/018)"])

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
    def get_trace(db: Session, uuidpublico: str) -> PublicTraceResponse:
        """Historial publico de trazabilidad de una unidad a partir de su UUID.

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
def get_public_trace(uuidpublico: str, db: Session = Depends(get_db)):
    """Consulta publica de trazabilidad escaneando el QR de una unidad (sin autenticacion)."""
    return PublicTraceController.get_trace(db, uuidpublico)
