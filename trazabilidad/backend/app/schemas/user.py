from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict, field_validator
from app.schemas.tenant import TenantResponse


class UserResponse(BaseModel):
    id: UUID
    tenant_id: UUID
    email: EmailStr
    first_name: str
    last_name: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
    tenant: TenantResponse

    model_config = ConfigDict(from_attributes=True)


class UserCreate(BaseModel):
    tenant_id: UUID
    email: EmailStr
    password: str
    first_name: str
    last_name: str

    @field_validator("email", mode="before")
    def normalize_email(cls, v: str) -> str:
        if isinstance(v, str):
            return v.strip().lower()
        return v
