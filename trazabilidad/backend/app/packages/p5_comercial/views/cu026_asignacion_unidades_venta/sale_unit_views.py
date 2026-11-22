from typing import List

from pydantic import BaseModel, ConfigDict, Field


class AssignUnitsRequest(BaseModel):
    idventadetalle: int
    idunidades: List[int] = Field(..., min_length=1)


class VentaUnidadResponse(BaseModel):
    idventaunidad: int
    idventadetalle: int
    idunidad: int
    numeroserie: str

    model_config = ConfigDict(from_attributes=True)


class VentaUnidadListResponse(BaseModel):
    total: int
    items: List[VentaUnidadResponse]
