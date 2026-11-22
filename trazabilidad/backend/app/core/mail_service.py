import logging
from datetime import datetime
from typing import Optional, Any
from app.core.config import settings
from app.core.mail import send_email, jinja_env

logger = logging.getLogger("uvicorn.error")


class MailService:
    @staticmethod
    async def send_reset_password_email(
        email: str,
        first_name: str,
        tenant_name: str,
        raw_token: str,
        frontend_origin: Optional[str] = None
    ) -> bool:
        """Renderizar plantilla de restablecimiento de contraseña y enviar correo."""
        base_url = (frontend_origin.rstrip("/") if frontend_origin else None) or settings.FRONTEND_URL.rstrip("/")
        reset_url = f"{base_url}/reset-password?token={raw_token}"
        
        template = jinja_env.get_template("emails/reset_password.html")
        html_content = template.render(
            first_name=first_name,
            tenant_name=tenant_name,
            reset_url=reset_url,
            app_name=settings.APP_NAME,
            expire_minutes=settings.RESET_TOKEN_EXPIRE_MINUTES,
            year=datetime.now().year
        )

        logger.info(f"[PASSWORD RESET LINK] Email: {email} | URL: {reset_url}")
        print(f"\n=======================================================")
        print(f"[PASSWORD RESET LINK FOR {email}]:")
        print(f"{reset_url}")
        print(f"=======================================================\n")

        return await send_email(
            to_email=email,
            subject=f"Restablecer Contraseña - {settings.APP_NAME}",
            html_content=html_content
        )

    @staticmethod
    async def send_purchase_order_email(
        to_email: str,
        compra: Any,
        tenant_name: str,
        environment_label: str = "localhost"
    ) -> bool:
        """Renderizar plantilla de orden de compra y enviar correo (CU-010)."""
        template = jinja_env.get_template("emails/purchase_order.html")
        html_content = template.render(
            app_name=settings.APP_NAME,
            tenant_name=tenant_name,
            compra=compra,
            target_email=to_email,
            environment_label=environment_label,
            year=datetime.now().year
        )

        logger.info(
            f"[CU-010 EMAIL COMPRA] Notificando orden {compra.numeroorden} (${compra.totalusd} USD) "
            f"a {to_email} (Entorno: {environment_label})"
        )
        print(f"\n=======================================================")
        print(f"[CU-010 ORDEN DE COMPRA REGISTRADA -> EMAIL: {to_email}]:")
        print(f"Orden: {compra.numeroorden} | Proveedor: {compra.proveedor_nombre}")
        print(f"Total: ${compra.totalusd} USD | Items: {compra.total_items} unidades")
        print(f"Empresa: {tenant_name} | Entorno: {environment_label}")
        print(f"=======================================================\n")

        return await send_email(
            to_email=to_email,
            subject=f"Nueva Orden de Compra {compra.numeroorden} - {tenant_name} ({settings.APP_NAME})",
            html_content=html_content
        )

    @staticmethod
    async def send_purchase_action_email(
        to_email: str,
        action: str,
        compra: Any,
        tenant_name: str,
        motivo: Optional[str] = None,
        user_name: Optional[str] = None
    ) -> bool:
        """Renderizar plantilla de aprobación o rechazo de compra y enviar correo (CU-011)."""
        template = jinja_env.get_template("emails/purchase_approval_action.html")
        html_content = template.render(
            app_name=settings.APP_NAME,
            tenant_name=tenant_name,
            action=action.upper(),
            compra=compra,
            motivo=motivo,
            user_name=user_name or "Administrador de Compras",
            target_email=to_email,
            year=datetime.now().year
        )

        subject = f"Orden de Compra {compra.numeroorden} {action.upper()} - {tenant_name} ({settings.APP_NAME})"

        logger.info(
            f"[CU-011 EMAIL APROBACION/RECHAZO] Orden {compra.numeroorden} {action.upper()} "
            f"notificada a {to_email}"
        )
        print(f"\n=======================================================")
        print(f"[CU-011 ACCION DE COMPRA: {action.upper()} -> EMAIL: {to_email}]:")
        print(f"Orden: {compra.numeroorden} | Proveedor: {compra.proveedor_nombre}")
        if motivo:
            print(f"Motivo de Rechazo: {motivo}")
        print(f"Total: ${compra.totalusd} USD | Responsable: {user_name}")
        print(f"Empresa: {tenant_name}")
        print(f"=======================================================\n")

        return await send_email(
            to_email=to_email,
            subject=subject,
            html_content=html_content
        )
