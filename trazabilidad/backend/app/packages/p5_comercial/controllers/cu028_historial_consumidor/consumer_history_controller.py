"""CU-028 - Historial de compras del consumidor (Web + Móvil)."""
from decimal import Decimal
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import (
    get_idusuariotenant, get_user_role_names, require_roles, resolve_tenant_id,
)
from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta
from app.packages.p5_comercial.models.cu026_asignacion_unidades_venta.venta_unidad import VentaUnidad
from app.packages.p5_comercial.models.cu025_ventas.venta import VentaDetalle
from app.packages.p5_comercial.views.cu028_historial_consumidor.consumer_history_views import (
    HistorialConsumidorResponse, CompraConsumidorResponse,
)

router = APIRouter(prefix="/consumer", tags=["Historial del Consumidor (CU-028)"])
requires_historial = require_roles(
    "SuperAdministrador", "AdministradorEmpresa", "Consumidor", "Auditor"
)


def _resolve_cliente(db: Session, user: User, tenant_id: int,
                     idcliente: Optional[int]) -> ActorCadena:
    """El consumidor solo ve su propio historial; soporte/auditoría pueden consultar
    el de un cliente dentro de su tenant."""
    roles = get_user_role_names(db, get_idusuariotenant(db, user))
    es_consumidor = "Consumidor" in roles and "SuperAdministrador" not in roles

    if idcliente is not None:
        actor = db.execute(
            select(ActorCadena).where(
                ActorCadena.idactor == idcliente, ActorCadena.idtenant == tenant_id
            )
        ).scalar_one_or_none()
        if not actor:
            raise HTTPException(status_code=404, detail="Cliente no encontrado en su empresa.")
        if es_consumidor and (actor.email or "").lower() != (user.email or "").lower():
            raise HTTPException(
                status_code=403, detail="Un consumidor solo puede consultar su propio historial."
            )
        return actor

    actor = db.execute(
        select(ActorCadena).where(
            ActorCadena.idtenant == tenant_id,
            ActorCadena.email == user.email,
        ).order_by(ActorCadena.idactor).limit(1)
    ).scalar_one_or_none()
    if not actor:
        raise HTTPException(
            status_code=404,
            detail="No hay un perfil de consumidor asociado a su correo en esta empresa.",
        )
    return actor


def _to_compra(db: Session, venta: Venta) -> CompraConsumidorResponse:
    unidades = db.execute(
        select(UnidadProducto.idunidad, UnidadProducto.numeroserie,
               UnidadProducto.uuidpublico, UnidadProducto.estado)
        .join(VentaUnidad, VentaUnidad.idunidad == UnidadProducto.idunidad)
        .join(VentaDetalle, VentaDetalle.idventadetalle == VentaUnidad.idventadetalle)
        .where(VentaDetalle.idventa == venta.idventa)
    ).all()
    return CompraConsumidorResponse(
        idventa=venta.idventa,
        fechaventa=venta.fechaventa,
        total=venta.total,
        estado=str(venta.estado),
        unidades=[
            {
                "idunidad": u[0], "numeroserie": u[1],
                "uuidpublico": u[2], "estado": str(u[3]) if u[3] else None,
            }
            for u in unidades
        ],
    )


@router.get("/history", response_model=HistorialConsumidorResponse)
def historial_consumidor(
    idcliente: Optional[int] = Query(None, description="Solo para roles de soporte/auditoría"),
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_historial),
):
    tenant_id = resolve_tenant_id(db, current_user)
    cliente = _resolve_cliente(db, current_user, tenant_id, idcliente)
    ventas = db.execute(
        select(Venta).where(
            Venta.idtenant == tenant_id, Venta.idcliente == cliente.idactor
        ).order_by(Venta.fechaventa.desc())
    ).scalars().all()
    items = [_to_compra(db, v) for v in ventas]
    return HistorialConsumidorResponse(
        idcliente=cliente.idactor,
        clientenombre=cliente.nombre,
        totalcompras=len(items),
        montototal=sum((i.total for i in items), Decimal("0")),
        items=items,
    )


@router.get("/history/{idventa}", response_model=CompraConsumidorResponse)
def detalle_compra_consumidor(
    idventa: int,
    idcliente: Optional[int] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_historial),
):
    tenant_id = resolve_tenant_id(db, current_user)
    cliente = _resolve_cliente(db, current_user, tenant_id, idcliente)
    venta = db.execute(
        select(Venta).where(
            Venta.idventa == idventa,
            Venta.idtenant == tenant_id,
            Venta.idcliente == cliente.idactor,
        )
    ).scalar_one_or_none()
    if not venta:
        raise HTTPException(status_code=404, detail="Compra no encontrada en su historial.")
    return _to_compra(db, venta)
