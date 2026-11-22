from typing import Optional, List
from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, desc

from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import (
    get_bolivia_now,
    get_client_ip,
    get_idusuariotenant,
    require_roles,
    resolve_tenant_id,
)
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Plan
from app.models.cu005_bitacora.bitacora import Bitacora
from app.packages.p8_suscripciones.views.cu036_planes.subscription_views import (
    CreatePlanRequest,
    UpdatePlanRequest,
    UpdatePlanEstadoRequest,
    PlanResponse,
    PlanListResponse,
)

router = APIRouter(prefix="/planes", tags=["Planes de Suscripción (CU-036)"])

_requires_gestion_planes = require_roles("SuperAdministrador")
_requires_lectura_planes = require_roles("SuperAdministrador", "AdministradorEmpresa", "Auditor")


class PlanController:

    @staticmethod
    def _to_response(plan: Plan) -> PlanResponse:
        return PlanResponse.model_validate(plan)


@router.get("", response_model=PlanListResponse, summary="Listar catálogo de planes")
def list_planes(
    activo: Optional[bool] = Query(None, description="Filtrar por estado activo/inactivo"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_lectura_planes),
):
    stmt = select(Plan)
    if activo is not None:
        stmt = stmt.where(Plan.activo == activo)

    total = db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
    stmt = stmt.order_by(Plan.preciomensual.asc()).offset(skip).limit(limit)
    rows = db.execute(stmt).scalars().all()

    return PlanListResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[PlanController._to_response(p) for p in rows],
    )


@router.get("/{idplan}", response_model=PlanResponse, summary="Obtener detalle de un plan")
def get_plan(
    idplan: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_lectura_planes),
):
    plan = db.execute(select(Plan).where(Plan.idplan == idplan)).scalar_one_or_none()
    if not plan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan no encontrado.")
    return PlanController._to_response(plan)


@router.post("", response_model=PlanResponse, status_code=status.HTTP_201_CREATED, summary="Crear nuevo plan")
def create_plan(
    body: CreatePlanRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_planes),
):
    codigo_clean = body.codigo.strip().lower()
    existe = db.execute(select(Plan).where(Plan.codigo == codigo_clean)).scalar_one_or_none()
    if existe:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Ya existe un plan con el código '{codigo_clean}'.",
        )

    plan = Plan(
        codigo=codigo_clean,
        nombre=body.nombre.strip(),
        descripcion=body.descripcion.strip() if body.descripcion else None,
        preciomensual=body.preciomensual,
        precioanual=body.precioanual,
        moneda=body.moneda.strip().upper(),
        limiteusuarios=body.limiteusuarios,
        limiteunidades=body.limiteunidades,
        limitereportesmes=body.limitereportesmes,
        limitealmacenamientomb=body.limitealmacenamientomb,
        diastrial=body.diastrial,
        activo=body.activo,
        creadoen=get_bolivia_now(),
        actualizadoen=get_bolivia_now(),
    )
    db.add(plan)
    db.flush()

    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion="crear_plan",
                entidad="plan",
                identidad=plan.idplan,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    db.commit()
    db.refresh(plan)
    return PlanController._to_response(plan)


@router.put("/{idplan}", response_model=PlanResponse, summary="Actualizar características y límites de un plan")
def update_plan(
    idplan: int,
    body: UpdatePlanRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_planes),
):
    plan = db.execute(select(Plan).where(Plan.idplan == idplan)).scalar_one_or_none()
    if not plan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan no encontrado.")

    if body.nombre is not None:
        plan.nombre = body.nombre.strip()
    if body.descripcion is not None:
        plan.descripcion = body.descripcion.strip() if body.descripcion else None
    if body.preciomensual is not None:
        plan.preciomensual = body.preciomensual
    if body.precioanual is not None:
        plan.precioanual = body.precioanual
    if body.moneda is not None:
        plan.moneda = body.moneda.strip().upper()
    if body.limiteusuarios is not None:
        plan.limiteusuarios = body.limiteusuarios
    if body.limiteunidades is not None:
        plan.limiteunidades = body.limiteunidades
    if body.limitereportesmes is not None:
        plan.limitereportesmes = body.limitereportesmes
    if body.limitealmacenamientomb is not None:
        plan.limitealmacenamientomb = body.limitealmacenamientomb
    if body.diastrial is not None:
        plan.diastrial = body.diastrial
    if body.activo is not None:
        plan.activo = body.activo

    plan.actualizadoen = get_bolivia_now()

    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion="editar_plan",
                entidad="plan",
                identidad=plan.idplan,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    db.commit()
    db.refresh(plan)
    return PlanController._to_response(plan)


@router.patch("/{idplan}/estado", response_model=PlanResponse, summary="Activar o desactivar plan")
def toggle_plan_estado(
    idplan: int,
    body: UpdatePlanEstadoRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_planes),
):
    plan = db.execute(select(Plan).where(Plan.idplan == idplan)).scalar_one_or_none()
    if not plan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan no encontrado.")

    plan.activo = body.activo
    plan.actualizadoen = get_bolivia_now()

    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion=f"cambiar_estado_plan_{'activo' if body.activo else 'inactivo'}",
                entidad="plan",
                identidad=plan.idplan,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    db.commit()
    db.refresh(plan)
    return PlanController._to_response(plan)
