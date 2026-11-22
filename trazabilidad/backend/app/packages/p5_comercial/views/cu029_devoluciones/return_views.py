from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, ConfigDict, Field


class CreateDevolucionRequest(BaseModel):
    idventa: int
    motivo: str = Field(..., description="defecto_fabrica, daño_transporte, producto_incorrecto, insatisfaccion_cliente o garantia")
    descripcion: Optional[str] = Field(None, max_length=1000)
    idunidades: List[int] = Field(default_factory=list)


class UpdateDevolucionEstadoRequest(BaseModel):
    estado: str = Field(..., description="solicitada, aprobada, rechazada o procesada")


class DevolucionUnidadItem(BaseModel):
    iddevolucionunidad: int
    idunidad: int
    numeroserie: str

    model_config = ConfigDict(from_attributes=True)


class DevolucionResponse(BaseModel):
    iddevolucion: int
    idventa: int
    fechadevolucion: datetime
    motivo: str
    descripcion: Optional[str] = None
    estado: str
    unidades: List[DevolucionUnidadItem] = Field(default_factory=list)

    model_config = ConfigDict(from_attributes=True)


class DevolucionListResponse(BaseModel):
    total: int
    items: List[DevolucionResponse]
