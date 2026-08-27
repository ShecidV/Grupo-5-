from typing import Optional
from fastapi import APIRouter, Depends, Response, Request, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.user import User
from app.schemas.auth import (
    LoginRequest,
    TokenResponse,
    ForgotPasswordRequest,
    ResetPasswordRequest,
    MessageResponse
)
from app.schemas.user import UserResponse
from app.services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["Autenticación"])
security = HTTPBearer()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    """Dependency to retrieve current authenticated user from Bearer JWT token."""
    return AuthService.get_current_user_from_token(db, credentials.credentials)


@router.post("/login", response_model=TokenResponse)
def login(
    login_data: LoginRequest,
    response: Response,
    db: Session = Depends(get_db)
):
    """Authenticate user with tenant_slug, email, and password."""
    access_token, refresh_token, user = AuthService.authenticate_user(
        db, login_data.tenant_slug, login_data.email, login_data.password
    )

    # Set HttpOnly cookie for refresh token
    response.set_cookie(
        key="refresh_token",
        value=refresh_token,
        httponly=True,
        samesite="lax",
        path="/api/v1/auth",
        max_age=7 * 24 * 3600
    )

    return TokenResponse(
        access_token=access_token,
        token_type="bearer",
        user=UserResponse.model_validate(user)
    )


@router.post("/refresh", response_model=TokenResponse)
def refresh_token(
    request: Request,
    response: Response,
    db: Session = Depends(get_db)
):
    """Refresh access token using HttpOnly refresh token cookie."""
    raw_refresh = request.cookies.get("refresh_token")
    if not raw_refresh:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Cookie de refresh token no proporcionada."
        )

    new_access_token, user = AuthService.refresh_access_token(db, raw_refresh)

    return TokenResponse(
        access_token=new_access_token,
        token_type="bearer",
        user=UserResponse.model_validate(user)
    )


@router.post("/logout", response_model=MessageResponse)
def logout(
    request: Request,
    response: Response,
    db: Session = Depends(get_db)
):
    """Logout user and invalidate refresh token."""
    raw_refresh = request.cookies.get("refresh_token")
    if raw_refresh:
        AuthService.logout(db, raw_refresh)

    response.delete_cookie(key="refresh_token", path="/api/v1/auth")
    return MessageResponse(message="Sesión cerrada correctamente.")


@router.get("/me", response_model=UserResponse)
def get_me(current_user: User = Depends(get_current_user)):
    """Get current authenticated user profile."""
    return UserResponse.model_validate(current_user)


@router.post("/forgot-password", response_model=MessageResponse)
async def forgot_password(
    forgot_data: ForgotPasswordRequest,
    db: Session = Depends(get_db)
):
    """Request password reset link via email."""
    msg = await AuthService.request_password_reset(
        db, forgot_data.tenant_slug, forgot_data.email
    )
    return MessageResponse(message=msg)


@router.post("/reset-password", response_model=MessageResponse)
def reset_password(
    reset_data: ResetPasswordRequest,
    db: Session = Depends(get_db)
):
    """Reset user password using valid token."""
    msg = AuthService.reset_password(
        db, reset_data.token, reset_data.new_password, reset_data.confirm_password
    )
    return MessageResponse(message=msg)
