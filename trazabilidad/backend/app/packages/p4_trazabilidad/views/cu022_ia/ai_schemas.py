from typing import List, Dict, Any, Optional
from pydantic import BaseModel, Field


class VoiceQueryRequest(BaseModel):
    query: str = Field(..., description="Transcripción del comando de voz o consulta en lenguaje natural")
    context: Optional[str] = Field(None, description="Contexto opcional (ej. vista actual, filtro)")


class KPIItem(BaseModel):
    label: str
    value: str
    trend: Optional[str] = None  # e.g. "+12%", "Alerta", "Estable"
    color: Optional[str] = "#38BDF8"


class ChartData(BaseModel):
    chart_type: str = "pie"  # 'pie', 'bar', 'line', 'kpi'
    title: str = "Resumen Gráfico"
    labels: List[str] = []
    datasets: List[Dict[str, Any]] = []


class VoiceReportResponse(BaseModel):
    report_id: str
    query_interpreted: str
    category: str  # 'inventario', 'compras', 'logistica', 'auditoria', 'general'
    voice_summary: str  # Respuesta concisa para ser sintetizada por voz (TTS)
    executive_summary: str  # Análisis en Markdown con insights y recomendaciones
    kpis: List[KPIItem] = []
    chart: ChartData
    table_headers: List[str] = []
    table_rows: List[List[Any]] = []
    period_label: str = "todo el historico"
    interpretation: str = ""
    filters_applied: Dict[str, Any] = {}
    suggested_followups: List[str] = []
    product_detail: Optional[Dict[str, Any]] = None
    generated_at: str
    pdf_download_url: str
    excel_download_url: str
