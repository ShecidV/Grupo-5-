from datetime import datetime, timedelta, timezone
from uuid import UUID
from typing import Tuple, Optional
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.core.config import settings
from app.core.security import (
    hash_password,
    verify_password,
    validate_password_strength,
    create_access_token,
    decode_access_token,
    generate_secure_raw_token,
    hash_token
)
from app.models.tenant import Tenant
from app.models.user import User
from app.models.password_reset_token import PasswordResetToken
from app.models.refresh_token import RefreshToken
from app.services.mail_service import MailService


class AuthService:
    @staticmethod
    def authenticate_user(
        db: Session, tenant_slug: str, email: str, password: str
    ) -> Tuple[str, str, User]:
        """Authenticate user by tenant_slug, email, and password."""
        # 1. Search tenant by slug
        stmt_tenant = select(Tenant).where(
            Tenant.slug == tenant_slug, Tenant.is_active == True
        )
        tenant = db.execute(stmt_tenant).scalar_one_or_none()
        if not tenant:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Empresa o credenciales inválidas."
            )

        # 2. Search user within tenant
        email_clean = email.strip().lower()
        stmt_user = select(User).where(
            User.tenant_id == tenant.id,
            User.email == email_clean
        )
        user = db.execute(stmt_user).scalar_one_or_none()
        if not user or not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Empresa o credenciales inválidas."
            )

        # 3. Verify password
        if not verify_password(password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Empresa o credenciales inválidas."
            )

        # 4. Generate JWT access token
        access_token_payload = {
            "sub": str(user.id),
            "tenant_id": str(user.tenant_id),
            "email": user.email
        }
        access_token = create_access_token(access_token_payload)

        # 5. Generate Refresh Token
        raw_refresh_token = generate_secure_raw_token()
        refresh_token_hash = hash_token(raw_refresh_token)
        expires_at = datetime.now(timezone.utc) + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)

        db_refresh_token = RefreshToken(
            tenant_id=user.tenant_id,
            user_id=user.id,
            token_hash=refresh_token_hash,
            expires_at=expires_at,
            revoked=False
        )
        db.add(db_refresh_token)
        db.commit()

        return access_token, raw_refresh_token, user

    @staticmethod
    def refresh_access_token(db: Session, raw_refresh_token: str) -> Tuple[str, User]:
        """Refresh JWT access token using a valid refresh token."""
        token_hash = hash_token(raw_refresh_token)
        stmt = select(RefreshToken).where(
            RefreshToken.token_hash == token_hash,
            RefreshToken.revoked == False
        )
        refresh_token = db.execute(stmt).scalar_one_or_none()

        if not refresh_token:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token de refresco inválido o revocado."
            )

        now = datetime.now(timezone.utc)
        if refresh_token.expires_at < now:
            refresh_token.revoked = True
            db.commit()
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token de refresco expirado."
            )

        # Retrieve user ensuring user and tenant are active
        stmt_user = select(User).where(
            User.id == refresh_token.user_id,
            User.tenant_id == refresh_token.tenant_id,
            User.is_active == True
        )
        user = db.execute(stmt_user).scalar_one_or_none()
        if not user or not user.tenant.is_active:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Usuario o empresa inactivos."
            )

        access_token_payload = {
            "sub": str(user.id),
            "tenant_id": str(user.tenant_id),
            "email": user.email
        }
        access_token = create_access_token(access_token_payload)
        return access_token, user

    @staticmethod
    def logout(db: Session, raw_refresh_token: Optional[str]) -> None:
        """Revoke refresh token on logout."""
        if not raw_refresh_token:
            return
        token_hash = hash_token(raw_refresh_token)
        stmt = select(RefreshToken).where(RefreshToken.token_hash == token_hash)
        refresh_token = db.execute(stmt).scalar_one_or_none()
        if refresh_token:
            refresh_token.revoked = True
            db.commit()

    @staticmethod
    async def request_password_reset(
        db: Session, tenant_slug: str, email: str
    ) -> str:
        """Generate reset token and send email asynchronously. Returns generic response message."""
        generic_message = (
            "Si la cuenta existe, recibirás un correo con las instrucciones "
            "para restablecer tu contraseña."
        )

        tenant_slug_clean = tenant_slug.strip().lower()
        email_clean = email.strip().lower()

        stmt_tenant = select(Tenant).where(
            Tenant.slug == tenant_slug_clean, Tenant.is_active == True
        )
        tenant = db.execute(stmt_tenant).scalar_one_or_none()
        if not tenant:
            return generic_message

        stmt_user = select(User).where(
            User.tenant_id == tenant.id,
            User.email == email_clean,
            User.is_active == True
        )
        user = db.execute(stmt_user).scalar_one_or_none()
        if not user:
            return generic_message

        # Generate reset token
        raw_token = generate_secure_raw_token()
        token_hash_val = hash_token(raw_token)
        expires_at = datetime.now(timezone.utc) + timedelta(
            minutes=settings.RESET_TOKEN_EXPIRE_MINUTES
        )

        db_token = PasswordResetToken(
            tenant_id=tenant.id,
            user_id=user.id,
            token_hash=token_hash_val,
            expires_at=expires_at
        )
        db.add(db_token)
        db.commit()

        # Send email via MailService
        await MailService.send_reset_password_email(
            email=user.email,
            first_name=user.first_name,
            tenant_name=tenant.name,
            raw_token=raw_token
        )

        return generic_message

    @staticmethod
    def reset_password(
        db: Session, token: str, new_password: str, confirm_password: str
    ) -> str:
        """Reset password using reset token."""
        if new_password != confirm_password:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Las contraseñas no coinciden."
            )

        is_valid, msg = validate_password_strength(new_password)
        if not is_valid:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=msg
            )

        token_hash_val = hash_token(token)
        stmt = select(PasswordResetToken).where(
            PasswordResetToken.token_hash == token_hash_val,
            PasswordResetToken.used_at.is_(None)
        )
        reset_token = db.execute(stmt).scalar_one_or_none()
        if not reset_token:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="El token de recuperación es inválido o ya ha sido utilizado."
            )

        now = datetime.now(timezone.utc)
        if reset_token.expires_at < now:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="El token de recuperación ha expirado."
            )

        # Update user password
        stmt_user = select(User).where(User.id == reset_token.user_id)
        user = db.execute(stmt_user).scalar_one_or_none()
        if not user or not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Usuario no encontrado o inactivo."
            )

        user.password_hash = hash_password(new_password)
        reset_token.used_at = now

        # Revoke all active refresh tokens for security
        stmt_refreshes = select(RefreshToken).where(
            RefreshToken.user_id == user.id,
            RefreshToken.revoked == False
        )
        refresh_tokens = db.execute(stmt_refreshes).scalars().all()
        for rt in refresh_tokens:
            rt.revoked = True

        db.commit()
        return "Contraseña restablecida correctamente."

    @staticmethod
    def get_current_user_from_token(db: Session, token: str) -> User:
        """Validate JWT access token and return active authenticated user."""
        payload = decode_access_token(token)
        if not payload:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token de acceso inválido o expirado.",
                headers={"WWW-Authenticate": "Bearer"}
            )

        user_id_str: Optional[str] = payload.get("sub")
        tenant_id_str: Optional[str] = payload.get("tenant_id")
        if not user_id_str or not tenant_id_str:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Payload de token incompleto.",
                headers={"WWW-Authenticate": "Bearer"}
            )

        try:
            user_id = UUID(user_id_str)
            tenant_id = UUID(tenant_id_str)
        except ValueError:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Identificadores inválidos en token.",
                headers={"WWW-Authenticate": "Bearer"}
            )

        # Query user enforcing tenant_id match for strict multi-tenant isolation
        stmt = select(User).where(
            User.id == user_id,
            User.tenant_id == tenant_id,
            User.is_active == True
        )
        user = db.execute(stmt).scalar_one_or_none()
        if not user or not user.tenant.is_active:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Usuario o empresa inactivos o no encontrados.",
                headers={"WWW-Authenticate": "Bearer"}
            )

        return user
