from typing import Optional
from datetime import datetime
from decimal import Decimal

from sqlalchemy import String, Integer, Numeric, DateTime, ForeignKey, Enum
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base

ESTADO_VENTA_ENUM = Enum(
    'pendiente',
    'pagada',
    'enviada',
    'entregada',
    'cancelada',
    'devuelta',
    name='estado_venta_enum',
    create_type=False,
)


class Venta(Base):
    __tablename__ = "venta"

    idventa: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idtenant: Mapped[int] = mapped_column(Integer, ForeignKey("tenant.idtenant"), nullable=False, index=True)
    idcliente: Mapped[int] = mapped_column(Integer, ForeignKey("actorcadena.idactor"), nullable=False)
    fechaventa: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    total: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    estado: Mapped[str] = mapped_column(ESTADO_VENTA_ENUM, default="pendiente")

    tenant = relationship("Tenant")
    cliente = relationship("ActorCadena")
    detalles = relationship("VentaDetalle", back_populates="venta", cascade="all, delete-orphan")


class VentaDetalle(Base):
    __tablename__ = "ventadetalle"

    idventadetalle: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idventa: Mapped[int] = mapped_column(Integer, ForeignKey("venta.idventa"), nullable=False)
    idvariante: Mapped[int] = mapped_column(Integer, ForeignKey("varianteproducto.idvariante"), nullable=False)
    cantidad: Mapped[int] = mapped_column(Integer, nullable=False)
    preciounitario: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    subtotal: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)

    venta = relationship("Venta", back_populates="detalles")
    variante = relationship("VarianteProducto")
