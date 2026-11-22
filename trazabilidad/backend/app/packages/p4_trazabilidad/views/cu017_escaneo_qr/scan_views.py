from typing import Optional
from pydantic import BaseModel, Field


class ScanQRRequest(BaseModel):
    """Payload de entrada para el escaneo de código QR (CU-017)."""
    raw_content: str = Field(
        ...,
        description="Contenido escaneado mediante la cámara nativa (URL completa o UUID directo)."
    )
    formato: Optional[str] = Field(default="QR_CODE", description="Formato del código (QR_CODE, NFC, BARCODE).")


class ScanQRResponse(BaseModel):
    """Resultado del procesamiento y validación del código QR escaneado (CU-017)."""
    es_valido: bool
    uuidpublico: Optional[str] = None
    idunidad: Optional[int] = None
    numeroserie: Optional[str] = None
    producto_nombre: Optional[str] = None
    modelo: Optional[str] = None
    estado_unidad: Optional[str] = None
    qr_activo: bool = False
    trace_url: Optional[str] = None
    mensaje: str


class ScanVerifyResponse(BaseModel):
    """Verificación rápida de autenticidad y activación del código QR escaneado."""
    es_valido: bool
    uuidpublico: Optional[str] = None
    qr_activo: bool = False
    idunidad: Optional[int] = None
    mensaje: str
