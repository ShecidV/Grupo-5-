from datetime import datetime
from decimal import Decimal
from typing import List, Optional

from pydantic import BaseModel, ConfigDict


class UnidadHistorialResponse(BaseModel):
    idunidad: int
    numeroserie: str
    uuidpublico: str
    estado: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class CompraConsumidorResponse(BaseModel):
    idventa: int
    fechaventa: datetime
    total: Decimal
    estado: str
    unidades: List[UnidadHistorialResponse]

    model_config = ConfigDict(from_attributes=True)


class HistorialConsumidorResponse(BaseModel):
    idcliente: int
    clientenombre: str
    totalcompras: int
    montototal: Decimal
    items: List[CompraConsumidorResponse]
