"""Seam de transiciones de estado de unidades física (P4 -> P5).

Evita que P5 importe modelos de P4 directamente y bloquea la fila para impedir
que una misma unidad sea asignada a dos ventas o devoluciones en concurrencia.
"""
from typing import Iterable

from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.cu015_unidades_producto.unit import UnidadProducto

ESTADOS_PERMITIDOS = ("disponible", "vendido", "en_transito", "devuelto", "retirado")


class UnitAvailabilityService:
    @staticmethod
    def lock_units(db: Session, tenant_id: int, ids: Iterable[int]) -> list:
        """Bloquea y devuelve las unidades del tenant; falla si alguna no existe."""
        ids = list(dict.fromkeys(ids))
        if not ids:
            return []
        unidades = db.execute(
            select(UnidadProducto)
            .where(
                UnidadProducto.idunidad.in_(ids),
                UnidadProducto.idtenant == tenant_id,
            )
            .with_for_update()
        ).scalars().all()
        if len(unidades) != len(ids):
            encontrados = {u.idunidad for u in unidades}
            faltan = [i for i in ids if i not in encontrados]
            raise HTTPException(
                status_code=404,
                detail=f"Unidades no encontradas en su empresa: {faltan}.",
            )
        return unidades

    @staticmethod
    def assert_available(unidades: Iterable) -> None:
        """Solo se pueden vender unidades disponibles."""
        bloqueadas = [u.idunidad for u in unidades if str(u.estado) != "disponible"]
        if bloqueadas:
            raise HTTPException(
                status_code=409,
                detail=f"Las unidades {bloqueadas} no están disponibles para venta.",
            )

    @staticmethod
    def mark_sold(unidades: Iterable, fecha) -> None:
        for unidad in unidades:
            unidad.estado = "vendido"
            unidad.fechaventa = fecha

    @staticmethod
    def mark_returned(unidades: Iterable) -> None:
        for unidad in unidades:
            unidad.estado = "devuelto"
            unidad.fechaventa = None


unit_availability_service = UnitAvailabilityService()
