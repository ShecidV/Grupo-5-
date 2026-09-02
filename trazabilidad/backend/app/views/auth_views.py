from typing import Optional
from pydantic import BaseModel, EmailStr, field_validator
from app.views.user_views import UserResponse


class LoginRequest(BaseModel):
    tenant_slug: str
    email: EmailStr
    password: str

    @field_validator("email", mode="before")
    def normalize_email(cls, v: str) -> str:
        if isinstance(v, str):
            return v.strip().lower()
        return v

    @field_validator("tenant_slug", mode="before")
    def normalize_slug(cls, v: str) -> str:
        if isinstance(v, str):
            return v.strip().lower()
        return v


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


class ForgotPasswordRequest(BaseModel):
    tenant_slug: str
    email: EmailStr

    @field_validator("email", mode="before")
    def normalize_email(cls, v: str) -> str:
        if isinstance(v, str):
            return v.strip().lower()
        return v

    @field_validator("tenant_slug", mode="before")
    def normalize_slug(cls, v: str) -> str:
        if isinstance(v, str):
            return v.strip().lower()
        return v


class ResetPasswordRequest(BaseModel):
    token: str
    new_password: str
    confirm_password: str


class MessageResponse(BaseModel):
    message: str
