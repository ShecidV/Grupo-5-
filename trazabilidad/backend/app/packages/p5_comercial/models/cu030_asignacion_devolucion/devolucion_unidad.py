from sqlalchemy import Integer, ForeignKey, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.base import Base


class DevolucionUnidad(Base):
    __tablename__ = "devolucionunidad"
    __table_args__ = (
        UniqueConstraint("idunidad", name="uq_devolucionunidad_idunidad"),
    )

    iddevolucionunidad: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    iddevolucion: Mapped[int] = mapped_column(Integer, ForeignKey("devolucion.iddevolucion"), nullable=False)
    idunidad: Mapped[int] = mapped_column(Integer, ForeignKey("unidadproducto.idunidad"), nullable=False)

    devolucion = relationship("Devolucion", back_populates="unidades")
    unidad = relationship("UnidadProducto")
