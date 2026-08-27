import logging
from datetime import datetime
from app.core.config import settings
from app.core.mail import send_email, jinja_env

logger = logging.getLogger("uvicorn.error")


class MailService:
    @staticmethod
    async def send_reset_password_email(
        email: str,
        first_name: str,
        tenant_name: str,
        raw_token: str
    ) -> bool:
        """Render password reset template and send email or log development URL."""
        reset_url = f"{settings.FRONTEND_URL}/reset-password?token={raw_token}"
        
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
