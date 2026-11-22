from datetime import datetime
from decimal import Decimal
from typing import Dict, List, Optional

from pydantic import BaseModel, ConfigDict


class SerieTemporalItem(BaseModel):
    periodo: str
    cantidad: int


class ReporteResumenResponse(BaseModel):
    idtenant: int
    generadoen: datetime
    totalunidades: int
    unidades_por_estado: Dict[str, int] = {}
    totalventas: int
    ingresos: Decimal
    totalpagoscompletados: int
    totalalertas: int
    alertasabiertas: int
    totaleventos: int
    eventosblockchain: int
    planesusados: Optional[str] = None
    consumomes: Optional[Dict[str, int]] = None


class ReporteTrazabilidadResponse(BaseModel):
    idtenant: int
    eventosportipo: Dict[str, int]
    eventosportipo_camion: List[SerieTemporalItem]
    alertasporgravedad: Dict[str, int]
    unidades_por_estado: Dict[str, int]


class DashboardResponse(BaseModel):
    idtenant: int
    resumen: ReporteResumenResponse
    ultimoseventos: List[dict]
    alertasrecientes: List[dict]

    model_config = ConfigDict(from_attributes=True)
