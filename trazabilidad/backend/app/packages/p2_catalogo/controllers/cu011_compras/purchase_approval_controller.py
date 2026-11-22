from fastapi import APIRouter, Depends, HTTPException, Request, BackgroundTasks, status
from app.core.mail_service import MailService
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.cu010_ordenes_compra.purchase import Compra
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu005_bitacora.notification import Notificacion
from app.models.cu002_usuarios.user import User
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu001_tenants.tenant import Tenant
from app.controllers.cu010_ordenes_compra.purchase_controller import format_compra_response
from app.controllers.shared import get_bolivia_now, get_client_ip, require_roles, _es_superadmin, resolve_tenant_id
from app.views.cu011_compras.purchase_approval_views import (
    RejectPurchaseRequest,
    ActionPurchaseResponse
)

router = APIRouter(prefix="/purchases", tags=["Aprobar / Rechazar Compras (CU-011)"])

# Destinatario exclusivo para notificaciones en CU-011
LOCAL_NOTIFICATION_EMAIL_CU011 = "rafaelmontanoroca@gmail.com"

# Roles autorizados a aprobar o rechazar ordenes de compra.
ROLES_APROBACION_COMPRA = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones")

requires_compra_approval = require_roles(*ROLES_APROBACION_COMPRA)


def _resolve_notification_metadata(db: Session, current_user: User, compra_tenant_id: int):
    tenant_name = None
    if getattr(current_user, "tenant", None):
        tenant_name = getattr(current_user.tenant, "nombre", None)
    if not tenant_name and compra_tenant_id:
        t = db.execute(select(Tenant.nombre).where(Tenant.idtenant == compra_tenant_id)).scalar()
        tenant_name = t or f"Empresa #{compra_tenant_id}"
    if not tenant_name:
        tenant_name = "Empresa Demo"

    user_name = (
        getattr(current_user, "nombrecompleto", None)
        or getattr(current_user, "email", "Administrador")
    )
    return tenant_name, user_name


class PurchaseApprovalController:

    @staticmethod
    def _get_idusuariotenant(db: Session, current_user: User, tenant_id: int):
        stmt_ut = select(UsuarioTenant.idusuariotenant).where(
            UsuarioTenant.idusuario == current_user.idusuario,
            UsuarioTenant.idtenant == tenant_id
        )
        idut = db.execute(stmt_ut).scalar()
        if not idut:
            stmt_ut2 = select(UsuarioTenant.idusuariotenant).where(
                UsuarioTenant.idusuario == current_user.idusuario
            )
            idut = db.execute(stmt_ut2).scalar()
        if not idut:
            nuevo_ut = UsuarioTenant(idusuario=current_user.idusuario, idtenant=tenant_id)
            db.add(nuevo_ut)
            db.flush()
            idut = nuevo_ut.idusuariotenant
        return idut

    @staticmethod
    def approve_purchase(
        db: Session,
        current_user: User,
        request: Request,
        idcompra: int
    ) -> ActionPurchaseResponse:
        if _es_superadmin(db, current_user):
            stmt = select(Compra).where(Compra.idcompra == idcompra)
        else:
            tenant_id = resolve_tenant_id(db, current_user)
            stmt = select(Compra).where(Compra.idcompra == idcompra, Compra.idtenant == tenant_id)
        compra = db.execute(stmt).scalar_one_or_none()

        if not compra:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Orden de compra con ID {idcompra} no encontrada o no pertenece a la empresa."
            )

        if str(compra.estado).lower() != "pendiente":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Solo se pueden aprobar compras en estado 'pendiente'. El estado actual es '{compra.estado}'."
            )

        # Transición a enviada (orden aprobada y remitida al proveedor)
        compra.estado = "enviada"

        client_ip = get_client_ip(request)
        hora_bolivia = get_bolivia_now()

        # Auditoría en bitacora
        idut = PurchaseApprovalController._get_idusuariotenant(db, current_user, compra.idtenant)

        if idut:
            db.add(Bitacora(
                idusuariotenant=idut,
                accion="APROBAR_COMPRA",
                entidad="Compra",
                identidad=compra.idcompra,
                ip=client_ip,
                fechahora=hora_bolivia
            ))

            # Notificación de éxito
            db.add(Notificacion(
                idusuariotenant=idut,
                titulo=f"Compra #{compra.numeroorden} Aprobada",
                contenido=f"La orden de compra #{compra.numeroorden} por un total de ${compra.totalusd} USD ha sido aprobada exitosamente y enviada al proveedor.",
                leida=False,
                fechaenvio=hora_bolivia,
                enlaceaccion=f"/purchases/{compra.idcompra}"
            ))

        db.commit()
        db.refresh(compra)

        return ActionPurchaseResponse(
            message=f"Orden de compra #{compra.numeroorden} aprobada exitosamente.",
            compra=format_compra_response(compra, db)
        )

    @staticmethod
    def reject_purchase(
        db: Session,
        current_user: User,
        request: Request,
        idcompra: int,
        body: RejectPurchaseRequest
    ) -> ActionPurchaseResponse:
        if _es_superadmin(db, current_user):
            stmt = select(Compra).where(Compra.idcompra == idcompra)
        else:
            tenant_id = resolve_tenant_id(db, current_user)
            stmt = select(Compra).where(Compra.idcompra == idcompra, Compra.idtenant == tenant_id)
        compra = db.execute(stmt).scalar_one_or_none()

        if not compra:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Orden de compra con ID {idcompra} no encontrada o no pertenece a la empresa."
            )

        if str(compra.estado).lower() != "pendiente":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Solo se pueden rechazar compras en estado 'pendiente'. El estado actual es '{compra.estado}'."
            )

        # Transición a cancelada
        compra.estado = "cancelada"

        client_ip = get_client_ip(request)
        hora_bolivia = get_bolivia_now()

        # Auditoría en bitacora
        idut = PurchaseApprovalController._get_idusuariotenant(db, current_user, compra.idtenant)

        if idut:
            db.add(Bitacora(
                idusuariotenant=idut,
                accion="RECHAZAR_COMPRA",
                entidad="Compra",
                identidad=compra.idcompra,
                ip=client_ip,
                fechahora=hora_bolivia
            ))

            # Notificación con el motivo
            db.add(Notificacion(
                idusuariotenant=idut,
                titulo=f"Compra #{compra.numeroorden} Rechazada",
                contenido=f"La orden de compra #{compra.numeroorden} fue rechazada. Motivo: {body.motivo}",
                leida=False,
                fechaenvio=hora_bolivia,
                enlaceaccion=f"/purchases/{compra.idcompra}"
            ))

        db.commit()
        db.refresh(compra)

        return ActionPurchaseResponse(
            message=f"Orden de compra #{compra.numeroorden} ha sido rechazada.",
            compra=format_compra_response(compra, db)
        )


# Rutas FastAPI
@router.patch("/{idcompra}/approve", response_model=ActionPurchaseResponse)
def approve_purchase_route(
    idcompra: int,
    request: Request,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_compra_approval)
):
    """Aprobar orden de compra en estado pendiente (CU-011)."""
    result = PurchaseApprovalController.approve_purchase(db, current_user, request, idcompra)

    # Notificación por correo electrónico (CU-011)
    tenant_name, user_name = _resolve_notification_metadata(db, current_user, result.compra.idtenant)
    background_tasks.add_task(
        MailService.send_purchase_action_email,
        to_email=LOCAL_NOTIFICATION_EMAIL_CU011,
        action="APROBADA",
        compra=result.compra,
        tenant_name=tenant_name,
        user_name=user_name
    )

    return result


@router.patch("/{idcompra}/reject", response_model=ActionPurchaseResponse)
def reject_purchase_route(
    idcompra: int,
    body: RejectPurchaseRequest,
    request: Request,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_compra_approval)
):
    """Rechazar orden de compra en estado pendiente con motivo justificado (CU-011)."""
    result = PurchaseApprovalController.reject_purchase(db, current_user, request, idcompra, body)

    # Notificación por correo electrónico (CU-011)
    tenant_name, user_name = _resolve_notification_metadata(db, current_user, result.compra.idtenant)
    background_tasks.add_task(
        MailService.send_purchase_action_email,
        to_email=LOCAL_NOTIFICATION_EMAIL_CU011,
        action="RECHAZADA",
        compra=result.compra,
        tenant_name=tenant_name,
        motivo=body.motivo,
        user_name=user_name
    )

    return result
