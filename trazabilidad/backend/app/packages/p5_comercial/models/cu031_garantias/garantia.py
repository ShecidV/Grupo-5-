from datetime import date
from typing import Optional

from sqlalchemy import Integer, Date, String, Text, ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base


class GarantiaUnidad(Base):
    __tablename__ = "garantiaunidad"
    __table_args__ = (
        UniqueConstraint("idunidad", name="uq_garantiaunidad_idunidad"),
    )

    idgarantia: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idunidad: Mapped[int] = mapped_column(Integer, ForeignKey("unidadproducto.idunidad"), nullable=False)
    fechainicio: Mapped[date] = mapped_column(Date, nullable=False)
    fechafin: Mapped[date] = mapped_column(Date, nullable=False)
    proveedor: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    condiciones: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    unidad = relationship("UnidadProducto")
