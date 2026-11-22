from datetime import datetime
from decimal import Decimal
from typing import List, Optional

from pydantic import BaseModel, ConfigDict, Field


class VentaDetalleItem(BaseModel):
    idvariante: int
    cantidad: int = Field(gt=0)
    preciounitario: Decimal = Field(gt=0)
    idunidades: List[int] = Field(default_factory=list)


class CreateVentaRequest(BaseModel):
    idcliente: int
    detalles: List[VentaDetalleItem] = Field(..., min_length=1)
    observacion: Optional[str] = Field(None, max_length=500)


class UpdateVentaEstadoRequest(BaseModel):
    estado: str = Field(..., description="pendiente, pagada, enviada, entregada, cancelada o devuelta")


class UnidadAsignadaResponse(BaseModel):
    idunidad: int
    numeroserie: str
    estado: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class VentaDetalleResponse(BaseModel):
    idventadetalle: int
    idvariante: int
    cantidad: int
    preciounitario: Decimal
    subtotal: Decimal
    unidades: List[UnidadAsignadaResponse] = Field(default_factory=list)

    model_config = ConfigDict(from_attributes=True)


class VentaResponse(BaseModel):
    idventa: int
    idtenant: int
    idcliente: int
    clientenombre: Optional[str] = None
    fechaventa: datetime
    total: Decimal
    estado: str
    observacion: Optional[str] = None
    detalles: List[VentaDetalleResponse] = Field(default_factory=list)
    monto_pagado: Decimal = Decimal("0")
    saldo: Decimal = Decimal("0")

    model_config = ConfigDict(from_attributes=True)


class VentaListResponse(BaseModel):
    total: int
    items: List[VentaResponse]
