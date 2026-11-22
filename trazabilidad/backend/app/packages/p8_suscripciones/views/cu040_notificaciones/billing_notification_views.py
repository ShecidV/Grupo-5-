from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, ConfigDict


class NotificacionFacturacionItem(BaseModel):
    id: str
    tipo: str
    titulo: str
    contenido: str
    destinatarios: int
    enviadoen: datetime
    enlaceaccion: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class NotificacionesFacturacionResponse(BaseModel):
    enviadas: int
    items: List[NotificacionFacturacionItem]


class ProcesarNotificacionesRequest(BaseModel):
    diasanticipacion: int = 7
    incluirvencidas: bool = True
