from typing import Optional, List
from datetime import datetime
from decimal import Decimal
from pydantic import BaseModel, Field


# -----------------------------------------------------------------------------
# DTOs para CU-036: Planes de Suscripción
# -----------------------------------------------------------------------------

class PlanBase(BaseModel):
    codigo: str = Field(..., max_length=32, description="Código único legible del plan, ej: basic, pro, enterprise")
    nombre: str = Field(..., max_length=100, description="Nombre descriptivo del plan")
    descripcion: Optional[str] = Field(None, description="Descripción de características")
    preciomensual: Decimal = Field(default=Decimal("0.00"), ge=0, description="Precio en USD mensual")
    precioanual: Decimal = Field(default=Decimal("0.00"), ge=0, description="Precio en USD anual")
    moneda: str = Field(default="USD", max_length=3)
    limiteusuarios: Optional[int] = Field(None, ge=1, description="Máximo de usuarios permitidos (null = ilimitado)")
    limiteunidades: Optional[int] = Field(None, ge=1, description="Máximo de unidades Apple (null = ilimitado)")
    limitereportesmes: Optional[int] = Field(None, ge=1, description="Límite de reportes/mes (null = ilimitado)")
    limitealmacenamientomb: Optional[int] = Field(None, ge=1, description="Límite de almacenamiento en MB")
    diastrial: int = Field(default=0, ge=0, description="Días de prueba si es plan trial")
    activo: bool = Field(default=True)


class CreatePlanRequest(PlanBase):
    pass


class UpdatePlanRequest(BaseModel):
    nombre: Optional[str] = Field(None, max_length=100)
    descripcion: Optional[str] = None
    preciomensual: Optional[Decimal] = Field(None, ge=0)
    precioanual: Optional[Decimal] = Field(None, ge=0)
    moneda: Optional[str] = Field(None, max_length=3)
    limiteusuarios: Optional[int] = Field(None, ge=1)
    limiteunidades: Optional[int] = Field(None, ge=1)
    limitereportesmes: Optional[int] = Field(None, ge=1)
    limitealmacenamientomb: Optional[int] = Field(None, ge=1)
    diastrial: Optional[int] = Field(None, ge=0)
    activo: Optional[bool] = None


class UpdatePlanEstadoRequest(BaseModel):
    activo: bool = Field(..., description="Nuevo estado activo/inactivo del plan")


class PlanResponse(PlanBase):
    idplan: int
    creadoen: datetime
    actualizadoen: datetime

    class Config:
        from_attributes = True


class PlanListResponse(BaseModel):
    total: int
    skip: int
    limit: int
    items: List[PlanResponse]


# -----------------------------------------------------------------------------
# DTOs para CU-037: Suscripciones de Empresas
# -----------------------------------------------------------------------------

class SuscribirEmpresaRequest(BaseModel):
    idtenant: int = Field(..., description="ID de la empresa/tenant a suscribir")
    idplan: int = Field(..., description="ID del plan a asignar")
    diasvigencia: Optional[int] = Field(None, ge=1, description="Días de vigencia específicos (si omite se calcula según plan)")
    renovacionautomatica: bool = Field(default=False)


class CambiarPlanRequest(BaseModel):
    nuevoidplan: int = Field(..., description="ID del nuevo plan")
    diasvigencia: Optional[int] = Field(None, ge=1, description="Días de vigencia del nuevo plan")
    renovacionautomatica: Optional[bool] = None


class UpdateSuscripcionEstadoRequest(BaseModel):
    estado: str = Field(..., description="trial, activa, vencida, suspendida, cancelada")
    motivocancelacion: Optional[str] = Field(None, description="Motivo en caso de suspensión o cancelación")


class SuscripcionResponse(BaseModel):
    idsuscripcion: int
    idtenant: int
    nombretenant: Optional[str] = None
    idplan: int
    codigoplan: Optional[str] = None
    nombreplan: Optional[str] = None
    estado: str
    fechainicio: datetime
    fechafin: datetime
    diasrestantes: int
    renovacionautomatica: bool
    motivocancelacion: Optional[str] = None
    limites: Optional[dict] = None
    creadoen: datetime
    actualizadoen: datetime

    class Config:
        from_attributes = True


class SuscripcionListResponse(BaseModel):
    total: int
    skip: int
    limit: int
    items: List[SuscripcionResponse]

