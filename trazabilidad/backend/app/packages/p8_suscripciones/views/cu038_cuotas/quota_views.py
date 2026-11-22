from datetime import datetime
from typing import Dict, Optional

from pydantic import BaseModel, ConfigDict, Field


class ConsumirCuotaRequest(BaseModel):
    concepto: str = Field(..., description="reportesgenerados, unidadesregistradas o usuariosactivos")
    cantidad: int = Field(1, gt=0)


class LimiteItem(BaseModel):
    permitido: Optional[int]
    usado: int
    disponible: Optional[int]
    excedido: bool


class CuotaResponse(BaseModel):
    idtenant: int
    periodo: str
    plan: Optional[str]
    estado_suscripcion: Optional[str]
    limites: Dict[str, LimiteItem]
    actualizadoen: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)
