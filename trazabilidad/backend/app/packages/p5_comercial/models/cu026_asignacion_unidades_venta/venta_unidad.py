from sqlalchemy import Integer, ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base


class VentaUnidad(Base):
    __tablename__ = "ventaunidad"
    __table_args__ = (
        UniqueConstraint("idunidad", name="uq_ventaunidad_idunidad"),
    )

    idventaunidad: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    idventadetalle: Mapped[int] = mapped_column(Integer, ForeignKey("ventadetalle.idventadetalle"), nullable=False)
    idunidad: Mapped[int] = mapped_column(Integer, ForeignKey("unidadproducto.idunidad"), nullable=False)

    detalle = relationship("VentaDetalle")
    unidad = relationship("UnidadProducto")
