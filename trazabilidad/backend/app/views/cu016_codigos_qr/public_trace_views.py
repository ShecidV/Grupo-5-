from datetime import datetime
from typing import Optional, List
from pydantic import BaseModel


class TraceActorInfo(BaseModel):
    nombre: str
    tipo: Optional[str] = None


class TraceUbicacionInfo(BaseModel):
    nombre: str
    ciudad: Optional[str] = None
    pais: Optional[str] = None


class TraceEventoInfo(BaseModel):
    fechahora: datetime
    tipoevento: str
    descripcion: Optional[str] = None
    estadoverificacion: Optional[str] = None
    ubicacion: Optional[TraceUbicacionInfo] = None
    actor_origen: Optional[TraceActorInfo] = None
    actor_destino: Optional[TraceActorInfo] = None


class TraceProductoInfo(BaseModel):
    nombre: str
    paisorigen: Optional[str] = None
    imagenurl: Optional[str] = None


class TraceVarianteInfo(BaseModel):
    sku: Optional[str] = None
    color: Optional[str] = None
    capacidad: Optional[str] = None


class PublicTraceResponse(BaseModel):
    """Payload publico de trazabilidad: sin IMEI, precios, emails ni IDs internos."""
    uuidpublico: str
    numeroserie: str
    estado: Optional[str] = None
    fechaingreso: Optional[datetime] = None
    empresa: Optional[str] = None
    producto: Optional[TraceProductoInfo] = None
    variante: Optional[TraceVarianteInfo] = None
    custodio_actual: Optional[TraceActorInfo] = None
    ubicacion_actual: Optional[TraceUbicacionInfo] = None
    qr_fechageneracion: Optional[datetime] = None
    eventos: List[TraceEventoInfo] = []
