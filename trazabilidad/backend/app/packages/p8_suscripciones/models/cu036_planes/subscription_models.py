from datetime import datetime, timezone
from decimal import Decimal
from typing import Optional, List
from sqlalchemy import String, Boolean, DateTime, Integer, Numeric, Text, ForeignKey, Enum
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base

ESTADO_SUSCRIPCION_ENUM = Enum(
    'trial',
    'activa',
    'vencida',
    'suspendida',
    'cancelada',
    name='estado_suscripcion_enum',
    create_type=False
)


class Plan(Base):
    __tablename__ = "plan"

    idplan: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    codigo: Mapped[str] = mapped_column(String(32), unique=True, index=True, nullable=False)
    nombre: Mapped[str] = mapped_column(String(100), nullable=False)
    descripcion: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    preciomensual: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0.00, nullable=False)
    precioanual: Mapped[Decimal] = mapped_column(Numeric(12, 2), default=0.00, nullable=False)
    moneda: Mapped[str] = mapped_column(String(3), default='USD', nullable=False)
    limiteusuarios: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    limiteunidades: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    limitereportesmes: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    limitealmacenamientomb: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    diastrial: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    activo: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    creadoen: Mapped[datetime] = mapped_column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )
    actualizadoen: Mapped[datetime] = mapped_column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    suscripciones: Mapped[List["Suscripcion"]] = relationship("Suscripcion", back_populates="plan")


class Suscripcion(Base):
    __tablename__ = "suscripcion"

    idsuscripcion: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idtenant: Mapped[int] = mapped_column(Integer, ForeignKey("tenant.idtenant"), index=True, nullable=False)
    idplan: Mapped[int] = mapped_column(Integer, ForeignKey("plan.idplan"), index=True, nullable=False)
    estado: Mapped[str] = mapped_column(ESTADO_SUSCRIPCION_ENUM, default='trial', index=True, nullable=False)
    fechainicio: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    fechafin: Mapped[datetime] = mapped_column(DateTime, index=True, nullable=False)
    renovacionautomatica: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    motivocancelacion: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    creadoen: Mapped[datetime] = mapped_column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        nullable=False
    )
    actualizadoen: Mapped[datetime] = mapped_column(
        DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
        nullable=False
    )

    tenant = relationship("Tenant")
    plan: Mapped["Plan"] = relationship("Plan", back_populates="suscripciones")

