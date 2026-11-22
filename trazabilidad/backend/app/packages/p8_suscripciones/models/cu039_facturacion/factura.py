from datetime import datetime
from decimal import Decimal
from typing import Optional

from sqlalchemy import DateTime, ForeignKey, Integer, Numeric, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base


class Factura(Base):
    __tablename__ = "factura"
    __table_args__ = (
        UniqueConstraint("idtenant", "numero", name="uq_factura_tenant_numero"),
    )

    idfactura: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idtenant: Mapped[int] = mapped_column(Integer, ForeignKey("tenant.idtenant"), nullable=False, index=True)
    idsuscripcion: Mapped[Optional[int]] = mapped_column(
        Integer, ForeignKey("suscripcion.idsuscripcion"), nullable=True
    )
    numero: Mapped[str] = mapped_column(String(32), nullable=False)
    fechaemision: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    fechavencimiento: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    monto: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)
    moneda: Mapped[str] = mapped_column(String(3), default="USD", nullable=False)
    estado: Mapped[str] = mapped_column(String(20), default="pendiente", nullable=False)

    tenant = relationship("Tenant")
    items = relationship("FacturaDetalle", back_populates="factura", cascade="all, delete-orphan")
    cobros = relationship("Cobro", back_populates="factura", cascade="all, delete-orphan")


class FacturaDetalle(Base):
    __tablename__ = "facturadetalle"

    idfacturadetalle: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idfactura: Mapped[int] = mapped_column(Integer, ForeignKey("factura.idfactura"), nullable=False)
    concepto: Mapped[str] = mapped_column(String(200), nullable=False)
    cantidad: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    preciounitario: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)
    subtotal: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)

    factura = relationship("Factura", back_populates="items")


class Cobro(Base):
    __tablename__ = "cobro"

    idcobro: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idfactura: Mapped[int] = mapped_column(Integer, ForeignKey("factura.idfactura"), nullable=False)
    fechacobro: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    monto: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)
    metodopago: Mapped[str] = mapped_column(String(40), nullable=False)
    referencia: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    estado: Mapped[str] = mapped_column(String(20), default="completado", nullable=False)

    factura = relationship("Factura", back_populates="cobros")
