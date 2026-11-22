from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column

from app.db.base import Base


class UsoPlan(Base):
    """Consumo mensual por empresa, contrastado con los límites del plan (CU-038)."""

    __tablename__ = "usoplan"
    __table_args__ = (
        UniqueConstraint("idtenant", "periodo", name="uq_usoplan_tenant_periodo"),
    )

    iduso: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idtenant: Mapped[int] = mapped_column(Integer, ForeignKey("tenant.idtenant"), nullable=False, index=True)
    periodo: Mapped[str] = mapped_column(String(7), nullable=False)  # YYYY-MM
    reportesgenerados: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    unidadesregistradas: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    usuariosactivos: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    actualizadoen: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
