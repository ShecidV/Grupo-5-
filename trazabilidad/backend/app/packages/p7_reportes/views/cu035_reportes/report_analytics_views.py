"""Esquemas del panel integral por tenant (extension de CU-035)."""
from datetime import datetime
from typing import Dict, List, Optional

from pydantic import BaseModel


class AnalyticsPeriodo(BaseModel):
    desde: str
    hasta: str
    meses: int


class AnalyticsComparacion(BaseModel):
    etiqueta: str
    desde: str
    hasta: str
    anterior_desde: str
    anterior_hasta: str


class AnalyticsKpi(BaseModel):
    clave: str
    etiqueta: str
    valor: float
    unidad: str = ""
    variacion: Optional[float] = None
    base: Optional[str] = None


class AnalyticsPunto(BaseModel):
    periodo: str
    valor: float


class AnalyticsSerie(BaseModel):
    clave: str
    etiqueta: str
    unidad: str = ""
    puntos: List[AnalyticsPunto]
    total: float = 0
    promediomensual: float = 0


class AnalyticsDistribucionItem(BaseModel):
    clave: str
    cantidad: int
    porcentaje: float = 0


class AnalyticsRankingItem(BaseModel):
    clave: str
    cantidad: int
    monto: float = 0


class AnalyticsComercial(BaseModel):
    ventas: int = 0
    ingresos: float = 0
    pagoscompletados: int = 0
    ticketpromedio: float = 0
    devoluciones: int = 0
    garantiasactivas: int = 0


class AnalyticsAlertas(BaseModel):
    total: int = 0
    abiertas: int = 0
    criticas: int = 0
    reportessospecha: int = 0
    tasaresolucion: float = 0
    scoremlpromedio: float = 0


class AnalyticsLogistica(BaseModel):
    envios: int = 0
    entregasatiempo: int = 0
    eventos: int = 0
    temperatura_promedio: float = 0
    humedad_promedio: float = 0
    vibracion_promedio: float = 0


class AnalyticsFacturacion(BaseModel):
    facturado: float = 0
    cobrado: float = 0
    saldo: float = 0
    facturas: int = 0
    cobros: int = 0


class AnalyticsActividad(BaseModel):
    bitacora: int = 0
    notificaciones: int = 0
    notificaciones_leidas: int = 0
    consultas_qr: int = 0
    consultas_por_unidad: float = 0
    certificados: int = 0


class AnalyticsSuscripcion(BaseModel):
    plan: Optional[str] = None
    estado: Optional[str] = None
    consumomes: Optional[Dict[str, int]] = None


class ReporteAnalyticsResponse(BaseModel):
    idtenant: int
    tenantnombre: str = ""
    generadoen: datetime
    moneda: str = "USD"
    zonahoraria: str = "America/La_Paz"
    periodo: AnalyticsPeriodo
    comparacion: AnalyticsComparacion
    kpis: List[AnalyticsKpi] = []
    series: List[AnalyticsSerie] = []
    distribuciones: Dict[str, List[AnalyticsDistribucionItem]] = {}
    ranking: Dict[str, List[AnalyticsRankingItem]] = {}
    comercial: AnalyticsComercial = AnalyticsComercial()
    alertas: AnalyticsAlertas = AnalyticsAlertas()
    logistica: AnalyticsLogistica = AnalyticsLogistica()
    facturacion: AnalyticsFacturacion = AnalyticsFacturacion()
    actividad: AnalyticsActividad = AnalyticsActividad()
    suscripcion: AnalyticsSuscripcion = AnalyticsSuscripcion()
