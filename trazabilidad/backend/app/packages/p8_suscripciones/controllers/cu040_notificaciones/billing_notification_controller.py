"""CU-040 - Notificar eventos de facturación (Web + Móvil)."""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import require_roles, resolve_tenant_id
from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.packages.p8_suscripciones.controllers.cu040_notificaciones.billing_notifier import billing_notifier
from app.packages.p8_suscripciones.views.cu040_notificaciones.billing_notification_views import (
    NotificacionFacturacionItem, NotificacionesFacturacionResponse,
    ProcesarNotificacionesRequest,
)

router = APIRouter(prefix="/billing", tags=["Notificaciones de Facturación (CU-040)"])
requires_notificaciones = require_roles("SuperAdministrador", "AdministradorEmpresa")


@router.post("/notifications/process", response_model=NotificacionesFacturacionResponse)
def procesar_notificaciones(
    body: ProcesarNotificacionesRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_notificaciones),
):
    if body.diasanticipacion < 0:
        raise HTTPException(status_code=400, detail="diasanticipacion debe ser >= 0.")
    tenant_id = resolve_tenant_id(db, current_user)
    eventos = billing_notifier.procesar_programadas(
        db, body.diasanticipacion, body.incluirvencidas, idtenant=tenant_id
    )
    return NotificacionesFacturacionResponse(
        enviadas=len(eventos),
        items=[NotificacionFacturacionItem(**e) for e in eventos],
    )


@router.get("/notifications", response_model=NotificacionesFacturacionResponse)
def historial_notificaciones(
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_notificaciones),
):
    tenant_id = resolve_tenant_id(db, current_user)
    notificaciones = billing_notifier.historial(db, tenant_id)
    items = [
        NotificacionFacturacionItem(
            id=f"notificacion-{n.idnotificacion}",
            tipo="facturacion",
            titulo=n.titulo,
            contenido=n.contenido,
            destinatarios=1,
            enviadoen=n.fechaenvio,
            enlaceaccion=n.enlaceaccion,
        )
        for n in notificaciones
    ]
    return NotificacionesFacturacionResponse(enviadas=len(items), items=items)
