"""CU-029 - Gestión de devoluciones."""
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy import select, func
from sqlalchemy.orm import Session

from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import (
    get_bolivia_now, get_client_ip, get_idusuariotenant, require_roles, resolve_tenant_id,
)
from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta
from app.packages.p5_comercial.models.cu026_asignacion_unidades_venta.venta_unidad import VentaUnidad
from app.packages.p5_comercial.models.cu025_ventas.venta import VentaDetalle
from app.packages.p5_comercial.models.cu029_devoluciones.devolucion import (
    Devolucion, MOTIVO_DEVOLUCION_ENUM, ESTADO_DEVOLUCION_ENUM,
)
from app.packages.p5_comercial.models.cu030_asignacion_devolucion.devolucion_unidad import DevolucionUnidad
from app.packages.p5_comercial.views.cu029_devoluciones.return_views import (
    CreateDevolucionRequest, UpdateDevolucionEstadoRequest, DevolucionResponse, DevolucionListResponse,
)
from app.services.unit_state_service import unit_availability_service

router = APIRouter(prefix="/returns", tags=["Devoluciones (CU-029)"])

ROLES_DEVOLUCIONES = ("SuperAdministrador", "AdministradorEmpresa", "GestorVentasPostventa")
requires_devoluciones = require_roles(*ROLES_DEVOLUCIONES)
_MOTIVOS = set(MOTIVO_DEVOLUCION_ENUM.enums)
_ESTADOS = set(ESTADO_DEVOLUCION_ENUM.enums)


class ReturnController:

    @staticmethod
    def _get_devolucion(db: Session, tenant_id: int, iddevolucion: int) -> Devolucion:
        dev = db.execute(
            select(Devolucion)
            .join(Venta, Venta.idventa == Devolucion.idventa)
            .where(Devolucion.iddevolucion == iddevolucion, Venta.idtenant == tenant_id)
        ).scalar_one_or_none()
        if not dev:
            raise HTTPException(status_code=404, detail=f"Devolución {iddevolucion} no encontrada.")
        return dev

    @staticmethod
    def _to_response(db: Session, dev: Devolucion) -> DevolucionResponse:
        unidades = db.execute(
            select(DevolucionUnidad.iddevolucionunidad, DevolucionUnidad.idunidad,
                   UnidadProducto.numeroserie)
            .join(UnidadProducto, UnidadProducto.idunidad == DevolucionUnidad.idunidad)
            .where(DevolucionUnidad.iddevolucion == dev.iddevolucion)
        ).all()
        return DevolucionResponse(
            iddevolucion=dev.iddevolucion,
            idventa=dev.idventa,
            fechadevolucion=dev.fechadevolucion,
            motivo=str(dev.motivo),
            descripcion=dev.descripcion,
            estado=str(dev.estado),
            unidades=[
                {"iddevolucionunidad": u[0], "idunidad": u[1], "numeroserie": u[2]}
                for u in unidades
            ],
        )

    @staticmethod
    def _bitacora(db, user, tenant_id, accion, identidad, ip) -> None:
        db.add(Bitacora(
            idusuariotenant=get_idusuariotenant(db, user), accion=accion,
            entidad="Devolucion", identidad=identidad, ip=ip, fechahora=get_bolivia_now(),
        ))

    @staticmethod
    def _unidades_de_venta(db: Session, idventa: int) -> List[int]:
        return db.execute(
            select(VentaUnidad.idunidad)
            .join(VentaDetalle, VentaDetalle.idventadetalle == VentaUnidad.idventadetalle)
            .where(VentaDetalle.idventa == idventa)
        ).scalars().all()

    @staticmethod
    def list_devoluciones(db: Session, user: User, estado: Optional[str],
                          skip: int, limit: int) -> DevolucionListResponse:
        tenant_id = resolve_tenant_id(db, user)
        query = select(Devolucion).join(Venta, Venta.idventa == Devolucion.idventa).where(
            Venta.idtenant == tenant_id
        )
        if estado:
            if estado not in _ESTADOS:
                raise HTTPException(status_code=400, detail=f"Estado inválido: {estado}.")
            query = query.where(Devolucion.estado == estado)
        total = db.execute(select(func.count()).select_from(query.subquery())).scalar_one()
        devs = db.execute(
            query.order_by(Devolucion.fechadevolucion.desc()).offset(skip).limit(limit)
        ).scalars().all()
        return DevolucionListResponse(
            total=total, items=[ReturnController._to_response(db, d) for d in devs]
        )

    @staticmethod
    def create_devolucion(db: Session, user: User, request: Request,
                          body: CreateDevolucionRequest) -> DevolucionResponse:
        tenant_id = resolve_tenant_id(db, user)
        if body.motivo not in _MOTIVOS:
            raise HTTPException(status_code=400, detail=f"Motivo inválido: {body.motivo}.")
        venta = db.execute(
            select(Venta).where(Venta.idventa == body.idventa, Venta.idtenant == tenant_id)
        ).scalar_one_or_none()
        if not venta:
            raise HTTPException(status_code=404, detail="La venta no existe en su empresa.")

        permitidas = set(ReturnController._unidades_de_venta(db, venta.idventa))
        if not set(body.idunidades).issubset(permitidas):
            raise HTTPException(
                status_code=400, detail="Todas las unidades deben pertenecer a la venta indicada."
            )

        dev = Devolucion(
            idventa=body.idventa, fechadevolucion=get_bolivia_now(),
            motivo=body.motivo, descripcion=body.descripcion, estado="solicitada",
        )
        db.add(dev)
        db.flush()
        for idunidad in body.idunidades:
            db.add(DevolucionUnidad(iddevolucion=dev.iddevolucion, idunidad=idunidad))
        ReturnController._bitacora(
            db, user, tenant_id, "CREAR_DEVOLUCION", dev.iddevolucion, get_client_ip(request)
        )
        db.commit()
        db.refresh(dev)
        return ReturnController._to_response(db, dev)

    @staticmethod
    def update_estado(db: Session, user: User, request: Request,
                      iddevolucion: int, estado: str) -> DevolucionResponse:
        tenant_id = resolve_tenant_id(db, user)
        if estado not in _ESTADOS:
            raise HTTPException(status_code=400, detail=f"Estado inválido: {estado}.")
        dev = ReturnController._get_devolucion(db, tenant_id, iddevolucion)
        dev.estado = estado
        if estado in ("aprobada", "procesada"):
            ids = db.execute(
                select(DevolucionUnidad.idunidad).where(
                    DevolucionUnidad.iddevolucion == iddevolucion
                )
            ).scalars().all()
            unidades = unit_availability_service.lock_units(db, tenant_id, ids)
            unit_availability_service.mark_returned(unidades)
            venta = db.execute(
                select(Venta).where(Venta.idventa == dev.idventa)
            ).scalar_one_or_none()
            if venta:
                venta.estado = "devuelta"
        ReturnController._bitacora(
            db, user, tenant_id, f"CAMBIAR_ESTADO_DEVOLUCION_{estado.upper()}",
            iddevolucion, get_client_ip(request),
        )
        db.commit()
        db.refresh(dev)
        return ReturnController._to_response(db, dev)


@router.get("", response_model=DevolucionListResponse)
def list_devoluciones_route(
    estado: Optional[str] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_devoluciones),
):
    return ReturnController.list_devoluciones(db, current_user, estado, skip, limit)


@router.get("/{iddevolucion}", response_model=DevolucionResponse)
def get_devolucion_route(
    iddevolucion: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_devoluciones),
):
    tenant_id = resolve_tenant_id(db, current_user)
    return ReturnController._to_response(
        db, ReturnController._get_devolucion(db, tenant_id, iddevolucion)
    )


@router.post("", response_model=DevolucionResponse, status_code=status.HTTP_201_CREATED)
def create_devolucion_route(
    body: CreateDevolucionRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_devoluciones),
):
    return ReturnController.create_devolucion(db, current_user, request, body)


@router.patch("/{iddevolucion}/estado", response_model=DevolucionResponse)
def update_estado_route(
    iddevolucion: int,
    body: UpdateDevolucionEstadoRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_devoluciones),
):
    return ReturnController.update_estado(db, current_user, request, iddevolucion, body.estado)
