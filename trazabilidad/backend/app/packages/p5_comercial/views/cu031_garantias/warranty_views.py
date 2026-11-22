from datetime import date
from typing import List, Optional

from pydantic import BaseModel, ConfigDict, Field


class CreateGarantiaRequest(BaseModel):
    idunidad: int
    fechainicio: date
    fechafin: date
    proveedor: Optional[str] = Field(None, max_length=100)
    condiciones: Optional[str] = None


class GarantiaResponse(BaseModel):
    idgarantia: int
    idunidad: int
    numeroserie: str
    fechainicio: date
    fechafin: date
    proveedor: Optional[str] = None
    condiciones: Optional[str] = None
    diasrestantes: int
    vigente: bool

    model_config = ConfigDict(from_attributes=True)


class GarantiaListResponse(BaseModel):
    total: int
    items: List[GarantiaResponse]
