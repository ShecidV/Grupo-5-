from datetime import datetime
from decimal import Decimal
from typing import List, Optional

from pydantic import BaseModel, ConfigDict, Field


class FacturaDetalleItem(BaseModel):
    concepto: str = Field(..., max_length=200)
    cantidad: int = Field(1, gt=0)
    preciounitario: Decimal = Field(..., gt=0)


class CrearFacturaRequest(BaseModel):
    idsuscripcion: Optional[int] = None
    numero: Optional[str] = Field(None, max_length=32)
    fechavencimiento: datetime
    moneda: str = Field("USD", max_length=3)
    items: List[FacturaDetalleItem] = Field(..., min_length=1)


class RegistrarCobroRequest(BaseModel):
    monto: Decimal = Field(..., gt=0)
    metodopago: str = Field(..., max_length=40)
    referencia: Optional[str] = Field(None, max_length=100)


class CobroResponse(BaseModel):
    idcobro: int
    fechacobro: datetime
    monto: Decimal
    metodopago: str
    referencia: Optional[str] = None
    estado: str

    model_config = ConfigDict(from_attributes=True)


class FacturaResponse(BaseModel):
    idfactura: int
    idtenant: int
    idsuscripcion: Optional[int] = None
    numero: str
    fechaemision: datetime
    fechavencimiento: datetime
    monto: Decimal
    moneda: str
    estado: str
    saldo: Decimal
    items: List[dict] = Field(default_factory=list)
    cobros: List[CobroResponse] = Field(default_factory=list)

    model_config = ConfigDict(from_attributes=True)


class FacturaListResponse(BaseModel):
    total: int
    items: List[FacturaResponse]


class HistorialFacturacionResponse(BaseModel):
    idtenant: int
    totalfacturado: Decimal
    totalcobrado: Decimal
    saldopendiente: Decimal
    facturas: int
    cobros: int
    items: List[FacturaResponse]
