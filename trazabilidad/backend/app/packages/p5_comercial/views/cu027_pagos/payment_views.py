from datetime import datetime
from decimal import Decimal
from typing import List

from pydantic import BaseModel, ConfigDict, Field


class CreatePagoRequest(BaseModel):
    idventa: int
    metodopago: str = Field(..., description="efectivo, tarjeta_credito, tarjeta_debito, transferencia o criptomoneda")
    monto: Decimal = Field(..., gt=0)
    estado: str = Field("pendiente", description="pendiente, completado, rechazado o reembolsado")


class UpdatePagoEstadoRequest(BaseModel):
    estado: str


class PagoResponse(BaseModel):
    idpago: int
    idventa: int
    metodopago: str
    monto: Decimal
    fechapago: datetime
    estado: str
    venta_estado: str | None = None

    model_config = ConfigDict(from_attributes=True)


class PagoListResponse(BaseModel):
    total: int
    items: List[PagoResponse]
