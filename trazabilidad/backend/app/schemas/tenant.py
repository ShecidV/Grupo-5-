from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, ConfigDict


class TenantResponse(BaseModel):
    id: UUID
    name: str
    slug: str
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
