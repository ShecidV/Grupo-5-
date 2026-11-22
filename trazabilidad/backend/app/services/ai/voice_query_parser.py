"""Parser determinista de consultas en lenguaje natural para informes por voz.

No depende de servicios externos: extrae intención, rango temporal, tope,
métrica y filtros de la transcripción. Las fechas se calculan en hora oficial
de Bolivia (BOT, UTC-4) usando el ``datetime`` que recibe ``parse_query``.
"""
import re
from dataclasses import dataclass, field
from datetime import datetime, time, timedelta
from typing import Any, Dict, List, Optional, Tuple


_MESES_ABBR = [
    "ene", "feb", "mar", "abr", "may", "jun",
    "jul", "ago", "sep", "oct", "nov", "dic",
]

_NUMEROS = {
    "un": 1, "una": 1, "dos": 2, "tres": 3, "cuatro": 4, "cinco": 5,
    "seis": 6, "siete": 7, "ocho": 8, "nueve": 9, "diez": 10, "doce": 12,
}

_INTENTES = [
    (
        "ventas",
        (
            "mas vendido", "vendido", "venta", "ranking", "top", "factur",
            "mejor producto", "mayor ingreso", "ingresos", "rentable",
            "clientes que mas compran", "unidades vendidas",
        ),
    ),
    (
        "compras",
        ("compra", "orden", "proveedor", "adquisicion", "gasto", "pedido", "factura de compra"),
    ),
    (
        "logistica",
        (
            "envio", "transporte", "despacho", "telemetria", "sensor",
            "temperatura", "humedad", "vibracion", "ruta", "tracking", "camion",
        ),
    ),
    (
        "auditoria",
        (
            "auditoria", "bitacora", "seguridad", "direccion ip",
            "intentos de acceso", "inicios de sesion", "quien accedio",
        ),
    ),
]

_ESTADOS = {
    "pendiente": ("pendiente", "pendientes"),
    "pagada": ("pagada", "pagadas", "pagado", "pagados"),
    "enviada": ("enviada", "enviadas", "enviado", "enviados"),
    "entregada": ("entregada", "entregadas", "entregado", "entregados"),
    "cancelada": ("cancelada", "canceladas", "cancelado", "cancelados"),
    "devuelta": ("devuelta", "devueltas", "devuelto", "devueltos"),
}

_INGRESOS = (
    "ingreso", "factur", "monto", "rentable", "dinero", "dolar", "usd", "valor",
)

_RANKING = ("mas vendido", "vendido", "ranking", "top", "mejor", "mayor")

_DETALLE = (
    "analisis detallado", "analisis del producto", "analisis de", "detalle de",
    "ficha de", "desglose de", "informacion detallada", "perfil de",
)

# El análisis detallado ignora el período de la consulta: siempre usa el
# histórico completo cargado en el seed (36 meses).
DETAIL_MONTHS = 36


def normalize_text(text: str) -> str:
    """Minúsculas sin acentos: comparaciones tolerantes a la transcripción de voz."""
    t = (text or "").lower()
    for src, dst in (
        ("á", "a"), ("é", "e"), ("í", "i"), ("ó", "o"), ("ú", "u"), ("ñ", "n"),
    ):
        t = t.replace(src, dst)
    return t


def _numero(valor: str) -> int:
    return int(valor) if valor.isdigit() else _NUMEROS.get(valor, 1)


def _inicio_mes_anio(anio: int, mes: int) -> datetime:
    return datetime(anio, mes, 1)


def _siguiente_mes(fecha: datetime) -> datetime:
    return _inicio_mes_anio(
        fecha.year + (fecha.month == 12),
        1 if fecha.month == 12 else fecha.month + 1,
    )


def _meses_atras(fecha: datetime, meses: int) -> datetime:
    total = fecha.year * 12 + fecha.month - 1 - meses
    return _inicio_mes_anio(total // 12, total % 12 + 1)


def _etiqueta(fecha: datetime) -> str:
    return f"{_MESES_ABBR[fecha.month - 1]} {fecha.year}"


def _rango_meses(now: datetime, meses: int) -> Tuple[datetime, datetime, str]:
    desde = _meses_atras(now, meses - 1)
    hasta = _siguiente_mes(now)
    if meses == 1:
        etiqueta = f"ultimo mes ({_etiqueta(desde)})"
    else:
        etiqueta = f"ultimos {meses} meses ({_etiqueta(desde)} - {_etiqueta(hasta - timedelta(days=1))})"
    return desde, hasta, etiqueta


def _rango_dias(now: datetime, dias: int) -> Tuple[datetime, datetime, str]:
    desde = datetime.combine((now - timedelta(days=dias - 1)).date(), time.min)
    hasta = datetime.combine((now + timedelta(days=1)).date(), time.min)
    fin = hasta - timedelta(days=1)
    etiqueta = (
        "hoy" if dias == 1 else
        f"ultimos {dias} dias ({desde:%d/%m} - {fin:%d/%m/%Y})"
    )
    return desde, hasta, etiqueta


def parse_period(q: str, now: datetime) -> Tuple[Optional[datetime], Optional[datetime], str]:
    """Devuelve ``(desde, hasta, etiqueta)``; ``hasta`` es exclusivo."""
    if any(k in q for k in ("hoy", "este dia")):
        return _rango_dias(now, 1)
    if any(k in q for k in ("ayer", "dia anterior")):
        ayer = now - timedelta(days=1)
        return (
            datetime.combine(ayer.date(), time.min),
            datetime.combine(now.date(), time.min),
            "ayer",
        )
    if any(k in q for k in ("semana pasada", "ultima semana", "última semana", "7 dias")):
        return _rango_dias(now, 7)
    if any(k in q for k in ("30 dias", "ultimo mes", "último mes", "este mes", "mes actual")):
        return _rango_meses(now, 1)
    if "semestre" in q:
        return _rango_meses(now, 6)
    if any(k in q for k in ("trimestre", "3 meses", "tres meses")):
        return _rango_meses(now, 3)
    if any(k in q for k in ("este ano", "ano actual")):
        return (
            datetime(now.year, 1, 1),
            _siguiente_mes(now),
            f"este ano ({now.year})",
        )

    match = None
    if any(k in q for k in ("ultimos", "últimos")):
        match = re.search(
            r"\b(?:ultimos|últimos)\s+(?:el\s+)?(\d{1,2}|un|dos|tres|cuatro|seis|doce)\s+mes(?:es)?\b",
            q,
        )
    if match is None:
        match = re.search(
            r"\b(\d{1,2}|un|dos|tres|cuatro|seis|doce)\s+mes(?:es)?\b", q
        )
    if match:
        return _rango_meses(now, _numero(match.group(1)))

    match = re.search(r"\b(\d{1,3})\s+dias\b", q)
    if match:
        return _rango_dias(now, max(1, int(match.group(1))))

    match = re.search(r"\b(20\d{2})\b", q)
    if match:
        anio = int(match.group(1))
        hoy_anio = now.year
        hasta = (
            _siguiente_mes(now) if anio >= hoy_anio
            else datetime(anio + 1, 1, 1)
        )
        return datetime(anio, 1, 1), hasta, f"ano {anio}"

    return None, None, "todo el historico"


def parse_limit(q: str, intent: str) -> Optional[int]:
    """Extrae el ``top N`` y lo acota a 1..50."""
    for patron in (
        r"\btop\s*(\d{1,3})\b",
        r"\b(?:los|las|primer[oa]s?)\s+(\d{1,3})\b",
        r"\b(\d{1,3})\s+(?:productos|articulos|modelos|ventas|clientes)\b",
    ):
        match = re.search(patron, q)
        if match:
            return max(1, min(50, int(match.group(1))))
    return 10 if intent == "ventas" and any(k in q for k in _RANKING) else None


def parse_intent(q: str) -> str:
    for intent, palabras in _INTENTES:
        if any(palabra in q for palabra in palabras):
            return intent
    return "inventario"


def parse_detail_period(now: datetime) -> Tuple[datetime, datetime, str]:
    """Rango fijo del análisis detallado: 36 meses escalonados a Bolivia."""
    return _rango_meses(now, DETAIL_MONTHS)


@dataclass
class ParsedQuery:
    intent: str
    desde: Optional[datetime] = None
    hasta: Optional[datetime] = None
    period_label: str = "todo el historico"
    limit: Optional[int] = None
    metric: str = "unidades"
    estado: Optional[str] = None
    producto: Optional[str] = None
    proveedor: Optional[str] = None
    wants_detail: bool = False
    keywords: List[str] = field(default_factory=list)

    def filters_applied(self) -> Dict[str, Any]:
        return {
            "periodo": self.period_label,
            "desde": self.desde.date().isoformat() if self.desde else None,
            "hasta": self.hasta.date().isoformat() if self.hasta else None,
            "limite": self.limit,
            "metrica": self.metric,
            "estado": self.estado,
            "producto": self.producto,
            "proveedor": self.proveedor,
            "analisis_detallado": self.wants_detail,
        }

    def interpretation(self) -> str:
        partes: List[str] = []
        if self.wants_detail:
            partes.append("Análisis detallado de producto (36 meses)")
        if self.limit:
            partes.append(f"Top {self.limit} por {self.metric}")
        elif self.intent == "ventas":
            partes.append(f"Ranking por {self.metric}")
        partes.append(self.period_label)
        if self.estado:
            partes.append(f"estado: {self.estado}")
        if self.producto:
            partes.append(f"producto: {self.producto}")
        if self.proveedor:
            partes.append(f"proveedor: {self.proveedor}")
        return " · ".join(partes)


def parse_query(query: str, now: Optional[datetime] = None) -> ParsedQuery:
    """Interpreta la transcripción y devuelve los filtros estructurados."""
    q = normalize_text(query)
    now = now or datetime.now()
    wants_detail = any(frase in q for frase in _DETALLE)
    intent = "ventas" if wants_detail else parse_intent(q)
    desde, hasta, etiqueta = parse_period(q, now)

    estado = None
    for canonico, variantes in _ESTADOS.items():
        if any(variante in q for variante in variantes):
            estado = canonico
            break

    metric = "ingresos" if any(palabra in q for palabra in _INGRESOS) else "unidades"
    return ParsedQuery(
        intent=intent,
        desde=desde,
        hasta=hasta,
        period_label=etiqueta,
        limit=parse_limit(q, intent),
        metric=metric,
        estado=estado,
        wants_detail=wants_detail,
        keywords=[palabra for _, palabras in _INTENTES for palabra in palabras if palabra in q],
    )
