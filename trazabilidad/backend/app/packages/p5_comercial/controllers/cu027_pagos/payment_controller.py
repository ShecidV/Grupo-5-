"""CU-027 - Gestión de pagos de ventas."""
from decimal import Decimal
from typing import Optional

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
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta
from app.packages.p5_comercial.models.cu027_pagos.pago import Pago, METODO_PAGO_ENUM, ESTADO_PAGO_ENUM
from app.packages.p5_comercial.views.cu027_pagos.payment_views import (
    CreatePagoRequest, UpdatePagoEstadoRequest, PagoResponse, PagoListResponse,
)

router = APIRouter(prefix="/payments", tags=["Pagos de Ventas (CU-027)"])

ROLES_PAGOS = ("SuperAdministrador", "AdministradorEmpresa", "GestorVentasPostventa")
requires_pagos = require_roles(*ROLES_PAGOS)
_METODOS = set(METODO_PAGO_ENUM.enums)
_ESTADOS = set(ESTADO_PAGO_ENUM.enums)


class PaymentController:

    @staticmethod
    def _query_tenant(db: Session, tenant_id: int):
        return select(Pago).join(Venta, Venta.idventa == Pago.idventa).where(Venta.idtenant == tenant_id)

    @staticmethod
    def _get_pago(db: Session, tenant_id: int, idpago: int) -> Pago:
        pago = db.execute(
            PaymentController._query_tenant(db, tenant_id).where(Pago.idpago == idpago)
        ).scalar_one_or_none()
        if not pago:
            raise HTTPException(status_code=404, detail=f"Pago {idpago} no encontrado.")
        return pago

    @staticmethod
    def _to_response(db: Session, pago: Pago) -> PagoResponse:
        venta_estado = db.execute(
            select(Venta.estado).where(Venta.idventa == pago.idventa)
        ).scalar_one_or_none()
        return PagoResponse(
            idpago=pago.idpago,
            idventa=pago.idventa,
            metodopago=str(pago.metodopago),
            monto=pago.monto,
            fechapago=pago.fechapago,
            estado=str(pago.estado),
            venta_estado=str(venta_estado) if venta_estado else None,
        )

    @staticmethod
    def _bitacora(db: Session, user: User, tenant_id: int, accion: str, identidad: int, ip: str) -> None:
        db.add(Bitacora(
            idusuariotenant=get_idusuariotenant(db, user),
            accion=accion, entidad="Pago", identidad=identidad,
            ip=ip, fechahora=get_bolivia_now(),
        ))

    @staticmethod
    def list_pagos(db: Session, user: User, estado: Optional[str], idventa: Optional[int],
                   skip: int, limit: int) -> PagoListResponse:
        tenant_id = resolve_tenant_id(db, user)
        query = PaymentController._query_tenant(db, tenant_id)
        if estado:
            if estado not in _ESTADOS:
                raise HTTPException(status_code=400, detail=f"Estado inválido: {estado}.")
            query = query.where(Pago.estado == estado)
        if idventa:
            query = query.where(Pago.idventa == idventa)
        total = db.execute(select(func.count()).select_from(query.subquery())).scalar_one()
        pagos = db.execute(
            query.order_by(Pago.fechapago.desc()).offset(skip).limit(limit)
        ).scalars().all()
        return PagoListResponse(
            total=total, items=[PaymentController._to_response(db, p) for p in pagos]
        )

    @staticmethod
    def create_pago(db: Session, user: User, request: Request, body: CreatePagoRequest) -> PagoResponse:
        tenant_id = resolve_tenant_id(db, user)
        if body.metodopago not in _METODOS:
            raise HTTPException(
                status_code=400,
                detail=f"Método de pago inválido. Permitidos: {sorted(_METODOS)}.",
            )
        if body.estado not in _ESTADOS:
            raise HTTPException(status_code=400, detail=f"Estado inválido: {body.estado}.")
        venta = db.execute(
            select(Venta).where(Venta.idventa == body.idventa, Venta.idtenant == tenant_id)
        ).scalar_one_or_none()
        if not venta:
            raise HTTPException(status_code=404, detail="La venta no existe en su empresa.")
        if str(venta.estado) in ("cancelada", "devuelta"):
            raise HTTPException(status_code=409, detail="No se pueden registrar pagos de una venta cancelada.")

        pago = Pago(
            idventa=body.idventa, metodopago=body.metodopago,
            monto=body.monto, fechapago=get_bolivia_now(), estado=body.estado,
        )
        db.add(pago)
        db.flush()
        PaymentController._sync_venta_estado(db, venta)
        PaymentController._bitacora(
            db, user, tenant_id, "REGISTRAR_PAGO", pago.idpago, get_client_ip(request)
        )
        db.commit()
        db.refresh(pago)
        return PaymentController._to_response(db, pago)

    @staticmethod
    def _sync_venta_estado(db: Session, venta: Venta) -> None:
        pagado = db.execute(
            select(func.coalesce(func.sum(Pago.monto), 0)).where(
                Pago.idventa == venta.idventa, Pago.estado == "completado"
            )
        ).scalar() or Decimal("0")
        if Decimal(str(pagado)) >= Decimal(str(venta.total)):
            venta.estado = "pagada"

    @staticmethod
    def update_estado(db: Session, user: User, request: Request,
                      idpago: int, estado: str) -> PagoResponse:
        tenant_id = resolve_tenant_id(db, user)
        if estado not in _ESTADOS:
            raise HTTPException(status_code=400, detail=f"Estado inválido: {estado}.")
        pago = PaymentController._get_pago(db, tenant_id, idpago)
        pago.estado = estado
        venta = db.execute(
            select(Venta).where(Venta.idventa == pago.idventa)
        ).scalar_one_or_none()
        if venta:
            PaymentController._sync_venta_estado(db, venta)
        PaymentController._bitacora(
            db, user, tenant_id, f"CAMBIAR_ESTADO_PAGO_{estado.upper()}",
            idpago, get_client_ip(request),
        )
        db.commit()
        db.refresh(pago)
        return PaymentController._to_response(db, pago)


@router.get("", response_model=PagoListResponse)
def list_pagos_route(
    estado: Optional[str] = Query(None),
    idventa: Optional[int] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_pagos),
):
    return PaymentController.list_pagos(db, current_user, estado, idventa, skip, limit)


@router.get("/{idpago}", response_model=PagoResponse)
def get_pago_route(
    idpago: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_pagos),
):
    tenant_id = resolve_tenant_id(db, current_user)
    return PaymentController._to_response(db, PaymentController._get_pago(db, tenant_id, idpago))


@router.post("", response_model=PagoResponse, status_code=status.HTTP_201_CREATED)
def create_pago_route(
    body: CreatePagoRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_pagos),
):
    return PaymentController.create_pago(db, current_user, request, body)


@router.patch("/{idpago}/estado", response_model=PagoResponse)
def update_estado_route(
    idpago: int,
    body: UpdatePagoEstadoRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_pagos),
):
    return PaymentController.update_estado(db, current_user, request, idpago, body.estado)
