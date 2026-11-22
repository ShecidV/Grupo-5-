"""CU-030 - Asignar unidades físicas a una devolución."""
from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import (
    get_bolivia_now, get_client_ip, get_idusuariotenant, require_roles, resolve_tenant_id,
)
from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p5_comercial.controllers.cu029_devoluciones.return_controller import ReturnController
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta
from app.packages.p5_comercial.models.cu030_asignacion_devolucion.devolucion_unidad import DevolucionUnidad
from app.packages.p5_comercial.views.cu029_devoluciones.return_views import DevolucionResponse
from app.packages.p5_comercial.views.cu030_asignacion_devolucion.return_unit_views import AssignReturnUnitsRequest

router = APIRouter(prefix="/returns", tags=["Unidades de Devolución (CU-030)"])
requires_devoluciones = require_roles(
    "SuperAdministrador", "AdministradorEmpresa", "GestorVentasPostventa"
)


@router.post("/{iddevolucion}/units", response_model=DevolucionResponse)
def assign_return_units(
    iddevolucion: int,
    body: AssignReturnUnitsRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_devoluciones),
):
    tenant_id = resolve_tenant_id(db, current_user)
    dev = ReturnController._get_devolucion(db, tenant_id, iddevolucion)
    permitidas = set(ReturnController._unidades_de_venta(db, dev.idventa))
    if not set(body.idunidades).issubset(permitidas):
        raise HTTPException(
            status_code=400,
            detail="Todas las unidades deben pertenecer a la venta de la devolución.",
        )
    for idunidad in body.idunidades:
        existe = db.execute(
            select(DevolucionUnidad).where(
                DevolucionUnidad.iddevolucion == iddevolucion,
                DevolucionUnidad.idunidad == idunidad,
            )
        ).scalar_one_or_none()
        if not existe:
            db.add(DevolucionUnidad(iddevolucion=iddevolucion, idunidad=idunidad))
    db.add(Bitacora(
        idusuariotenant=get_idusuariotenant(db, current_user),
        accion="ASIGNAR_UNIDADES_DEVOLUCION", entidad="Devolucion",
        identidad=iddevolucion, ip=get_client_ip(request), fechahora=get_bolivia_now(),
    ))
    db.commit()
    db.refresh(dev)
    return ReturnController._to_response(db, dev)


@router.delete("/{iddevolucion}/units/{idunidad}", response_model=DevolucionResponse)
def unassign_return_unit(
    iddevolucion: int,
    idunidad: int,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_devoluciones),
):
    tenant_id = resolve_tenant_id(db, current_user)
    dev = ReturnController._get_devolucion(db, tenant_id, iddevolucion)
    vinculo = db.execute(
        select(DevolucionUnidad).where(
            DevolucionUnidad.iddevolucion == iddevolucion,
            DevolucionUnidad.idunidad == idunidad,
        )
    ).scalar_one_or_none()
    if not vinculo:
        raise HTTPException(status_code=404, detail="La unidad no está en la devolución.")
    db.delete(vinculo)
    db.add(Bitacora(
        idusuariotenant=get_idusuariotenant(db, current_user),
        accion="DESASIGNAR_UNIDAD_DEVOLUCION", entidad="Devolucion",
        identidad=iddevolucion, ip=get_client_ip(request), fechahora=get_bolivia_now(),
    ))
    db.commit()
    db.refresh(dev)
    return ReturnController._to_response(db, dev)
