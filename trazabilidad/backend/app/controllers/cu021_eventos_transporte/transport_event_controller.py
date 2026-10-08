import hashlib
from typing import List
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.db.session import get_db
from app.models.cu019_envios_logisticos.shipment import Envio
from app.models.cu020_asignacion_unidades_envio.shipment_unit import EnvioUnidad
from app.models.cu021_eventos_transporte.transport_event import (
    EventoTrazabilidad,
    EventoUnidad,
    CondicionTransporte,
    Alerta
)
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu002_usuarios.user import User
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_bolivia_now, get_client_ip, require_roles
from app.views.cu019_envios_logisticos.shipment_views import EnvioResponse
from app.views.cu021_eventos_transporte.transport_views import (
    EnvioTimelineResponse,
    EventoTrazabilidadResponse,
    CondicionTransporteResponse,
    CreateTransportEventRequest
)

router = APIRouter(prefix="/shipments", tags=["Eventos y Condiciones de Transporte (CU-021)"])

# Roles autorizados a registrar hitos de trazabilidad y telemetría (shipments:telemetry).
ROLES_EVENTOS_TRANSPORTE = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones")

requires_eventos_transporte = require_roles(*ROLES_EVENTOS_TRANSPORTE)


def _calculate_payload_hash(idenvio: int, tipoevento: str, idubicacion: int, timestamp: datetime) -> str:
    raw = f"{idenvio}:{tipoevento}:{idubicacion}:{timestamp.isoformat()}"
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


class TransportEventController:

    @staticmethod
    def get_timeline(
        db: Session,
        current_user: User,
        idenvio: int
    ) -> EnvioTimelineResponse:
        tenant_id = current_user.tenant.idtenant if current_user.tenant else 1
        stmt = select(Envio).where(Envio.idenvio == idenvio, Envio.idtenant == tenant_id)
        s = db.execute(stmt).scalar_one_or_none()

        if not s:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Envío con ID {idenvio} no encontrado."
            )

        actor_orig = db.execute(select(ActorCadena.razonsocial).where(ActorCadena.idactor == s.idactororigen)).scalar_one_or_none()
        actor_dest = db.execute(select(ActorCadena.razonsocial).where(ActorCadena.idactor == s.idactordestino)).scalar_one_or_none()
        transp = None
        if s.idtransportista:
            transp = db.execute(select(ActorCadena.razonsocial).where(ActorCadena.idactor == s.idtransportista)).scalar_one_or_none()

        # Obtener IDs de unidades del envío
        stmt_units = (
            select(UnidadProducto.numeroserie)
            .join(EnvioUnidad, UnidadProducto.idunidad == EnvioUnidad.idunidad)
            .where(EnvioUnidad.idenvio == s.idenvio)
        )
        numeros_serie = db.execute(stmt_units).scalars().all()

        envio_resp = EnvioResponse(
            idenvio=s.idenvio,
            idtenant=s.idtenant,
            codigoenvio=s.codigoenvio,
            idactororigen=s.idactororigen,
            idactordestino=s.idactordestino,
            idtransportista=s.idtransportista,
            actor_origen_nombre=actor_orig or f"Origen #{s.idactororigen}",
            actor_destino_nombre=actor_dest or f"Destino #{s.idactordestino}",
            transportista_nombre=transp,
            fechasalida=s.fechasalida,
            fechaestimada=s.fechaestimada,
            fechaentrega=s.fechaentrega,
            estado=str(s.estado),
            trackingexterno=s.trackingexterno,
            total_unidades=len(numeros_serie)
        )

        # Buscar eventos vinculados a las unidades del envío o eventos directos
        stmt_events = (
            select(EventoTrazabilidad)
            .join(EventoUnidad, EventoTrazabilidad.idevento == EventoUnidad.idevento)
            .join(EnvioUnidad, EventoUnidad.idunidad == EnvioUnidad.idunidad)
            .where(EnvioUnidad.idenvio == s.idenvio)
            .distinct()
            .order_by(EventoTrazabilidad.fechahora.asc())
        )
        eventos = db.execute(stmt_events).scalars().all()

        eventos_resp = []
        for ev in eventos:
            ubic_nombre = db.execute(select(Ubicacion.nombre).where(Ubicacion.idubicacion == ev.idubicacion)).scalar_one_or_none()
            user_nombre = db.execute(select(User.nombrecompleto).where(User.idusuario == ev.idusuarioresponsable)).scalar_one_or_none()

            cond_resp = None
            stmt_cond = select(CondicionTransporte).where(CondicionTransporte.idevento == ev.idevento)
            cond = db.execute(stmt_cond).scalar_one_or_none()
            if cond:
                cond_resp = CondicionTransporteResponse.model_validate(cond)

            eventos_resp.append(
                EventoTrazabilidadResponse(
                    idevento=ev.idevento,
                    idtenant=ev.idtenant,
                    tipoevento=str(ev.tipoevento),
                    fechahora=ev.fechahora,
                    idubicacion=ev.idubicacion,
                    ubicacion_nombre=ubic_nombre or f"Ubicación #{ev.idubicacion}",
                    usuario_nombre=user_nombre or f"Usuario #{ev.idusuarioresponsable}",
                    descripcion=ev.descripcion,
                    payloadhash=ev.payloadhash,
                    estadoverificacion=str(ev.estadoverificacion),
                    condiciones=cond_resp
                )
            )

        return EnvioTimelineResponse(
            envio=envio_resp,
            eventos=eventos_resp,
            unidades_numeros=list(numeros_serie)
        )

    @staticmethod
    def record_event(
        db: Session,
        current_user: User,
        request: Request,
        idenvio: int,
        body: CreateTransportEventRequest
    ) -> EventoTrazabilidadResponse:
        tenant_id = current_user.tenant.idtenant if current_user.tenant else 1
        stmt = select(Envio).where(Envio.idenvio == idenvio, Envio.idtenant == tenant_id)
        envio = db.execute(stmt).scalar_one_or_none()

        if not envio:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Envío con ID {idenvio} no encontrado o no pertenece a la empresa."
            )

        # Validar ubicación existente
        stmt_ubic = select(Ubicacion).where(Ubicacion.idubicacion == body.idubicacion)
        ubic = db.execute(stmt_ubic).scalar_one_or_none()
        if not ubic:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"La ubicación con ID {body.idubicacion} no existe."
            )

        hora_bolivia = get_bolivia_now()
        client_ip = get_client_ip(request)
        payload_hash = _calculate_payload_hash(envio.idenvio, body.tipoevento, body.idubicacion, hora_bolivia)

        # 1. Crear Evento de Trazabilidad
        evento = EventoTrazabilidad(
            idtenant=tenant_id,
            tipoevento=body.tipoevento,
            fechahora=hora_bolivia,
            idactororigen=envio.idactororigen,
            idactordestino=body.idactordestino or envio.idactordestino,
            idubicacion=body.idubicacion,
            idusuarioresponsable=current_user.idusuario,
            descripcion=body.descripcion,
            payloadhash=payload_hash,
            estadoverificacion="verificado"
        )
        db.add(evento)
        db.flush()

        # 2. Asociar a todas las unidades del envío
        stmt_unidades = select(EnvioUnidad.idunidad).where(EnvioUnidad.idenvio == envio.idenvio)
        unidades_ids = db.execute(stmt_unidades).scalars().all()
        for uid in unidades_ids:
            db.add(EventoUnidad(idevento=evento.idevento, idunidad=uid))

        # 3. Guardar condiciones de transporte si vienen en el request
        cond_resp = None
        if body.condiciones:
            c_in = body.condiciones
            cond = CondicionTransporte(
                idevento=evento.idevento,
                temperatura=c_in.temperatura,
                humedad=c_in.humedad,
                presion=c_in.presion,
                nivelvibracion=c_in.nivelvibracion,
                timestampregistro=hora_bolivia,
                fuentedatos=c_in.fuentedatos or "App Móvil"
            )
            db.add(cond)
            db.flush()
            cond_resp = CondicionTransporteResponse.model_validate(cond)

            # 4. Evaluación de umbrales para Alertas automáticas
            first_unit_id = unidades_ids[0] if unidades_ids else None
            if c_in.temperatura is not None:
                if c_in.temperatura > 30.0 or c_in.temperatura < -5.0:
                    gravedad = "critica" if c_in.temperatura > 38.0 or c_in.temperatura < -15.0 else "alta"
                    db.add(Alerta(
                        idtenant=tenant_id,
                        idunidad=first_unit_id,
                        idevento=evento.idevento,
                        tipoalerta="temperatura",
                        descripcion=f"Alerta Térmica: {c_in.temperatura}°C fuera del rango seguro en envío {envio.codigoenvio} ({ubic.nombre})",
                        gravedad=gravedad,
                        fechadeteccion=hora_bolivia,
                        estado="pendiente"
                    ))

            if c_in.nivelvibracion is not None and c_in.nivelvibracion > 2.0:
                gravedad = "critica" if c_in.nivelvibracion > 3.5 else "alta"
                db.add(Alerta(
                    idtenant=tenant_id,
                    idunidad=first_unit_id,
                    idevento=evento.idevento,
                    tipoalerta="vibracion",
                    descripcion=f"Alerta de Impacto: {c_in.nivelvibracion}G detectado en envío {envio.codigoenvio} ({ubic.nombre})",
                    gravedad=gravedad,
                    fechadeteccion=hora_bolivia,
                    estado="pendiente"
                ))

        # 5. Actualizar estado del envío según el hito registrado
        if body.tipoevento in ("transporte_terrestre", "transporte_aereo", "transporte_maritimo"):
            if str(envio.estado).lower() == "preparacion":
                envio.estado = "en_transito"
                if not envio.fechasalida:
                    envio.fechasalida = hora_bolivia
        elif body.tipoevento in ("recepcion_almacen", "entrega_cliente"):
            if str(envio.estado).lower() in ("en_transito", "preparacion"):
                envio.estado = "entregado"
                envio.fechaentrega = hora_bolivia

        # 6. Registrar en bitácora de auditoría
        stmt_ut = select(UsuarioTenant.idusuariotenant).where(
            UsuarioTenant.idusuario == current_user.idusuario,
            UsuarioTenant.idtenant == tenant_id
        )
        idut = db.execute(stmt_ut).scalar()
        if idut:
            db.add(Bitacora(
                idusuariotenant=idut,
                accion="REGISTRAR_EVENTO_TRANSPORTE",
                entidad="EventoTrazabilidad",
                identidad=evento.idevento,
                ip=client_ip,
                fechahora=hora_bolivia
            ))

        db.commit()
        db.refresh(evento)

        return EventoTrazabilidadResponse(
            idevento=evento.idevento,
            idtenant=evento.idtenant,
            tipoevento=str(evento.tipoevento),
            fechahora=evento.fechahora,
            idubicacion=evento.idubicacion,
            ubicacion_nombre=ubic.nombre,
            usuario_nombre=current_user.nombrecompleto,
            descripcion=evento.descripcion,
            payloadhash=evento.payloadhash,
            estadoverificacion=str(evento.estadoverificacion),
            condiciones=cond_resp
        )


# Rutas FastAPI
@router.get("/{idenvio}/timeline", response_model=EnvioTimelineResponse)
def get_timeline_route(
    idenvio: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener línea de tiempo completa y condiciones de un envío (CU-021)."""
    return TransportEventController.get_timeline(db, current_user, idenvio)


@router.post("/{idenvio}/events", response_model=EventoTrazabilidadResponse)
def record_event_route(
    idenvio: int,
    body: CreateTransportEventRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_eventos_transporte)
):
    """Registrar un nuevo hito de trazabilidad con telemetría ambiental (CU-021)."""
    return TransportEventController.record_event(db, current_user, request, idenvio, body)
