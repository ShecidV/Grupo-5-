import os
import logging
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import aiosmtplib
from jinja2 import Environment, FileSystemLoader

from app.core.config import settings

logger = logging.getLogger("uvicorn.error")

# Setup Jinja2 template loader
templates_dir = os.path.join(os.path.dirname(os.path.dirname(__file__)), "templates")
jinja_env = Environment(loader=FileSystemLoader(templates_dir))


async def send_email(to_email: str, subject: str, html_content: str) -> bool:
    """Send an HTML email via SMTP asynchronously."""
    if not settings.SMTP_HOST or not settings.SMTP_USER:
        logger.warning(
            f"[SMTP MOCK] SMTP host/user not configured. Email to {to_email} skipped."
        )
        return True

    message = MIMEMultipart("alternative")
    message["From"] = settings.SMTP_FROM
    message["To"] = to_email
    message["Subject"] = subject
    message.attach(MIMEText(html_content, "html", "utf-8"))

    try:
        smtp = aiosmtplib.SMTP(
            hostname=settings.SMTP_HOST,
            port=settings.SMTP_PORT,
            start_tls=settings.SMTP_STARTTLS,
        )
        await smtp.connect()
        if settings.SMTP_USER and settings.SMTP_PASSWORD:
            await smtp.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
        await smtp.send_message(message)
        await smtp.quit()
        logger.info(f"Email successfully sent to {to_email}")
        return True
    except Exception as e:
        logger.error(f"Failed to send email to {to_email}: {e}")
        return False
