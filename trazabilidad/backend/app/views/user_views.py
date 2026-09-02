from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict
from app.views.tenant_views import TenantResponse


class UserBase(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str


class UserCreate(UserBase):
    password: str
    tenant_id: UUID


class UserResponse(UserBase):
    id: UUID
    tenant_id: UUID
    is_active: bool
    created_at: datetime
    updated_at: datetime
    tenant: TenantResponse

    model_config = ConfigDict(from_attributes=True)
