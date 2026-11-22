"""CU-025 / CU-026 - Gestión de ventas y asignación de unidades físicas."""
from decimal import Decimal
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
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta, VentaDetalle, ESTADO_VENTA_ENUM
from app.packages.p5_comercial.models.cu026_asignacion_unidades_venta.venta_unidad import VentaUnidad
from app.packages.p5_comercial.models.cu027_pagos.pago import Pago
from app.packages.p5_comercial.views.cu025_ventas.sale_views import (
    CreateVentaRequest, UpdateVentaEstadoRequest, VentaResponse, VentaListResponse,
)
from app.packages.p5_comercial.views.cu026_asignacion_unidades_venta.sale_unit_views import AssignUnitsRequest
from app.services.sales_notarization_service import sales_notarization_service
from app.services.unit_state_service import unit_availability_service

router = APIRouter(prefix="/sales", tags=["Ventas y Postventa (CU-025/CU-026)"])

ROLES_VENTAS = ("SuperAdministrador", "AdministradorEmpresa", "GestorVentasPostventa")
requires_ventas = require_roles(*ROLES_VENTAS)
_ESTADOS = set(ESTADO_VENTA_ENUM.enums)


class SaleController:

    @staticmethod
    def _get_venta(db: Session, tenant_id: int, idventa: int) -> Venta:
        venta = db.execute(
            select(Venta).where(Venta.idventa == idventa, Venta.idtenant == tenant_id)
        ).scalar_one_or_none()
        if not venta:
            raise HTTPException(status_code=404, detail=f"Venta {idventa} no encontrada.")
        return venta

    @staticmethod
    def _to_response(db: Session, venta: Venta) -> VentaResponse:
        cliente = db.execute(
            select(ActorCadena.nombre).where(ActorCadena.idactor == venta.idcliente)
        ).scalar_one_or_none()
        detalles = db.execute(
            select(VentaDetalle).where(VentaDetalle.idventa == venta.idventa)
            .order_by(VentaDetalle.idventadetalle)
        ).scalars().all()

        items = []
        for detalle in detalles:
            unidades = db.execute(
                select(VentaUnidad.idunidad, UnidadProducto.numeroserie, UnidadProducto.estado)
                .join(UnidadProducto, UnidadProducto.idunidad == VentaUnidad.idunidad)
                .where(VentaUnidad.idventadetalle == detalle.idventadetalle)
            ).all()
            items.append({
                "idventadetalle": detalle.idventadetalle,
                "idvariante": detalle.idvariante,
                "cantidad": detalle.cantidad,
                "preciounitario": detalle.preciounitario,
                "subtotal": detalle.subtotal,
                "unidades": [
                    {"idunidad": u[0], "numeroserie": u[1], "estado": str(u[2]) if u[2] else None}
                    for u in unidades
                ],
            })

        pagado = db.execute(
            select(func.coalesce(func.sum(Pago.monto), 0)).where(
                Pago.idventa == venta.idventa, Pago.estado == "completado"
            )
        ).scalar() or Decimal("0")

        return VentaResponse(
            idventa=venta.idventa,
            idtenant=venta.idtenant,
            idcliente=venta.idcliente,
            clientenombre=cliente,
            fechaventa=venta.fechaventa,
            total=venta.total,
            estado=str(venta.estado),
            observacion=None,
            detalles=items,
            monto_pagado=Decimal(str(pagado)),
            saldo=Decimal(str(venta.total)) - Decimal(str(pagado)),
        )

    @staticmethod
    def _bitacora(db: Session, user: User, tenant_id: int, accion: str, identidad: int, ip: str) -> None:
        db.add(Bitacora(
            idusuariotenant=get_idusuariotenant(db, user),
            accion=accion,
            entidad="Venta",
            identidad=identidad,
            ip=ip,
            fechahora=get_bolivia_now(),
        ))

    @staticmethod
    def list_ventas(db: Session, user: User, estado: Optional[str], idcliente: Optional[int],
                    skip: int, limit: int) -> VentaListResponse:
        tenant_id = resolve_tenant_id(db, user)
        query = select(Venta).where(Venta.idtenant == tenant_id)
        if estado:
            if estado not in _ESTADOS:
                raise HTTPException(status_code=400, detail=f"Estado inválido: {estado}.")
            query = query.where(Venta.estado == estado)
        if idcliente:
            query = query.where(Venta.idcliente == idcliente)
        total = db.execute(select(func.count()).select_from(query.subquery())).scalar_one()
        ventas = db.execute(
            query.order_by(Venta.fechaventa.desc()).offset(skip).limit(limit)
        ).scalars().all()
        return VentaListResponse(
            total=total, items=[SaleController._to_response(db, v) for v in ventas]
        )

    @staticmethod
    def create_venta(db: Session, user: User, request: Request, body: CreateVentaRequest) -> VentaResponse:
        tenant_id = resolve_tenant_id(db, user)

        cliente = db.execute(
            select(ActorCadena).where(
                ActorCadena.idactor == body.idcliente, ActorCadena.idtenant == tenant_id
            )
        ).scalar_one_or_none()
        if not cliente:
            raise HTTPException(status_code=404, detail="El cliente no existe en su empresa.")

        total = Decimal("0")
        for detalle in body.detalles:
            total += Decimal(str(detalle.preciounitario)) * detalle.cantidad

        venta = Venta(
            idtenant=tenant_id, idcliente=body.idcliente,
            fechaventa=get_bolivia_now(), total=total, estado="pendiente",
        )
        db.add(venta)
        db.flush()

        todas_unidades = []
        for detalle in body.detalles:
            subtotal = Decimal(str(detalle.preciounitario)) * detalle.cantidad
            vd = VentaDetalle(
                idventa=venta.idventa, idvariante=detalle.idvariante,
                cantidad=detalle.cantidad, preciounitario=detalle.preciounitario, subtotal=subtotal,
            )
            db.add(vd)
            db.flush()
            if detalle.idunidades:
                if len(detalle.idunidades) != detalle.cantidad:
                    raise HTTPException(
                        status_code=400,
                        detail="La cantidad de unidades debe coincidir con la cantidad del detalle.",
                    )
                unidades = unit_availability_service.lock_units(db, tenant_id, detalle.idunidades)
                unit_availability_service.assert_available(unidades)
                for unidad in unidades:
                    db.add(VentaUnidad(idventadetalle=vd.idventadetalle, idunidad=unidad.idunidad))
                todas_unidades.extend(unidades)

        if todas_unidades:
            unit_availability_service.mark_sold(todas_unidades, venta.fechaventa)

        SaleController._bitacora(
            db, user, tenant_id, "CREAR_VENTA", venta.idventa, get_client_ip(request)
        )
        try:
            sales_notarization_service.notarize_sale(
                db, tenant_id, user.idusuario, venta.idventa, todas_unidades
            )
        except Exception:
            # La notarización es best-effort: no revierte la venta.
            pass
        db.commit()
        db.refresh(venta)
        return SaleController._to_response(db, venta)

    @staticmethod
    def assign_units(db: Session, user: User, request: Request, idventa: int,
                     idventadetalle: int, ids_unidad: List[int]) -> VentaResponse:
        tenant_id = resolve_tenant_id(db, user)
        venta = SaleController._get_venta(db, tenant_id, idventa)
        detalle = db.execute(
            select(VentaDetalle).where(
                VentaDetalle.idventadetalle == idventadetalle,
                VentaDetalle.idventa == idventa,
            )
        ).scalar_one_or_none()
        if not detalle:
            raise HTTPException(status_code=404, detail="Línea de venta no encontrada.")

        ya_asignadas = db.execute(
            select(func.count()).select_from(VentaUnidad).where(
                VentaUnidad.idventadetalle == idventadetalle
            )
        ).scalar_one()
        if ya_asignadas + len(ids_unidad) > detalle.cantidad:
            raise HTTPException(status_code=409, detail="Se excede la cantidad de la línea de venta.")

        unidades = unit_availability_service.lock_units(db, tenant_id, ids_unidad)
        unit_availability_service.assert_available(unidades)
        for unidad in unidades:
            db.add(VentaUnidad(idventadetalle=idventadetalle, idunidad=unidad.idunidad))
        unit_availability_service.mark_sold(unidades, get_bolivia_now())

        SaleController._bitacora(
            db, user, tenant_id, "ASIGNAR_UNIDADES_VENTA", idventa, get_client_ip(request)
        )
        db.commit()
        db.refresh(venta)
        return SaleController._to_response(db, venta)

    @staticmethod
    def unassign_unit(db: Session, user: User, request: Request,
                      idventa: int, idunidad: int) -> VentaResponse:
        tenant_id = resolve_tenant_id(db, user)
        venta = SaleController._get_venta(db, tenant_id, idventa)
        vinculo = db.execute(
            select(VentaUnidad)
            .join(VentaDetalle, VentaDetalle.idventadetalle == VentaUnidad.idventadetalle)
            .where(VentaDetalle.idventa == idventa, VentaUnidad.idunidad == idunidad)
        ).scalar_one_or_none()
        if not vinculo:
            raise HTTPException(status_code=404, detail="La unidad no está asignada a esta venta.")
        unidad = db.execute(
            select(UnidadProducto).where(
                UnidadProducto.idunidad == idunidad, UnidadProducto.idtenant == tenant_id
            )
        ).scalar_one_or_none()
        if unidad:
            unidad.estado = "disponible"
            unidad.fechaventa = None
        db.delete(vinculo)
        SaleController._bitacora(
            db, user, tenant_id, "DESASIGNAR_UNIDAD_VENTA", idventa, get_client_ip(request)
        )
        db.commit()
        db.refresh(venta)
        return SaleController._to_response(db, venta)

    @staticmethod
    def update_estado(db: Session, user: User, request: Request,
                      idventa: int, estado: str) -> VentaResponse:
        tenant_id = resolve_tenant_id(db, user)
        if estado not in _ESTADOS:
            raise HTTPException(status_code=400, detail=f"Estado inválido: {estado}.")
        venta = SaleController._get_venta(db, tenant_id, idventa)
        venta.estado = estado
        if estado in ("cancelada", "devuelta"):
            ids = db.execute(
                select(VentaUnidad.idunidad)
                .join(VentaDetalle, VentaDetalle.idventadetalle == VentaUnidad.idventadetalle)
                .where(VentaDetalle.idventa == idventa)
            ).scalars().all()
            unidades = unit_availability_service.lock_units(db, tenant_id, ids)
            unit_availability_service.mark_returned(unidades)
        SaleController._bitacora(
            db, user, tenant_id, f"CAMBIAR_ESTADO_VENTA_{estado.upper()}",
            idventa, get_client_ip(request),
        )
        db.commit()
        db.refresh(venta)
        return SaleController._to_response(db, venta)


@router.get("", response_model=VentaListResponse)
def list_ventas_route(
    estado: Optional[str] = Query(None),
    idcliente: Optional[int] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_ventas),
):
    return SaleController.list_ventas(db, current_user, estado, idcliente, skip, limit)


@router.get("/{idventa}", response_model=VentaResponse)
def get_venta_route(
    idventa: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_ventas),
):
    tenant_id = resolve_tenant_id(db, current_user)
    return SaleController._to_response(db, SaleController._get_venta(db, tenant_id, idventa))


@router.post("", response_model=VentaResponse, status_code=status.HTTP_201_CREATED)
def create_venta_route(
    body: CreateVentaRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_ventas),
):
    return SaleController.create_venta(db, current_user, request, body)


@router.post("/{idventa}/units", response_model=VentaResponse)
def assign_units_route(
    idventa: int,
    body: AssignUnitsRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_ventas),
):
    return SaleController.assign_units(
        db, current_user, request, idventa, body.idventadetalle, body.idunidades
    )


@router.delete("/{idventa}/units/{idunidad}", response_model=VentaResponse)
def unassign_unit_route(
    idventa: int,
    idunidad: int,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_ventas),
):
    return SaleController.unassign_unit(db, current_user, request, idventa, idunidad)


@router.patch("/{idventa}/estado", response_model=VentaResponse)
def update_estado_route(
    idventa: int,
    body: UpdateVentaEstadoRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_ventas),
):
    return SaleController.update_estado(db, current_user, request, idventa, body.estado)

