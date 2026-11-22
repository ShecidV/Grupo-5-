from datetime import datetime
from typing import Optional

from sqlalchemy import DateTime, ForeignKey, Enum, Integer, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base

MOTIVO_DEVOLUCION_ENUM = Enum(
    'defecto_fabrica',
    'daño_transporte',
    'producto_incorrecto',
    'insatisfaccion_cliente',
    'garantia',
    name='motivo_devolucion_enum',
    create_type=False,
)

ESTADO_DEVOLUCION_ENUM = Enum(
    'solicitada',
    'aprobada',
    'rechazada',
    'procesada',
    name='estado_devolucion_enum',
    create_type=False,
)


class Devolucion(Base):
    __tablename__ = "devolucion"

    iddevolucion: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idventa: Mapped[int] = mapped_column(Integer, ForeignKey("venta.idventa"), nullable=False, index=True)
    fechadevolucion: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    motivo: Mapped[str] = mapped_column(MOTIVO_DEVOLUCION_ENUM, nullable=False)
    descripcion: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    estado: Mapped[str] = mapped_column(ESTADO_DEVOLUCION_ENUM, default="solicitada")

    venta = relationship("Venta")
    unidades = relationship("DevolucionUnidad", back_populates="devolucion", cascade="all, delete-orphan")
