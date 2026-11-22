from typing import Optional, List
from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, desc

from app.db.session import get_db
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import (
    get_bolivia_now,
    get_client_ip,
    get_idusuariotenant,
    require_roles,
    resolve_tenant_id,
)
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Plan, Suscripcion
from app.models.cu005_bitacora.bitacora import Bitacora
from app.packages.p8_suscripciones.views.cu036_planes.subscription_views import (
    SuscribirEmpresaRequest,
    CambiarPlanRequest,
    UpdateSuscripcionEstadoRequest,
    SuscripcionResponse,
    SuscripcionListResponse,
)

router = APIRouter(prefix="/suscripciones", tags=["Suscripciones de Empresas (CU-037)"])

_requires_gestion_suscripcion = require_roles("SuperAdministrador")
_requires_lectura_suscripcion = require_roles("SuperAdministrador", "AdministradorEmpresa", "Auditor")


class SubscriptionService:

    @staticmethod
    def _to_response(db: Session, sub: Suscripcion) -> SuscripcionResponse:
        now = datetime.utcnow()
        fechafin_naive = sub.fechafin.replace(tzinfo=None) if sub.fechafin.tzinfo else sub.fechafin
        dias_restantes = max(0, (fechafin_naive - now).days)

        nombre_tenant = None
        if sub.tenant:
            nombre_tenant = sub.tenant.nombre
        else:
            t = db.execute(select(Tenant.nombre).where(Tenant.idtenant == sub.idtenant)).first()
            if t:
                nombre_tenant = t[0]

        codigo_plan = None
        nombre_plan = None
        limites = None
        if sub.plan:
            codigo_plan = sub.plan.codigo
            nombre_plan = sub.plan.nombre
            limites = {
                "usuarios": sub.plan.limiteusuarios,
                "unidades": sub.plan.limiteunidades,
                "reportes_mes": sub.plan.limitereportesmes,
                "almacenamiento_mb": sub.plan.limitealmacenamientomb,
            }
        else:
            p = db.execute(select(Plan).where(Plan.idplan == sub.idplan)).scalar_one_or_none()
            if p:
                codigo_plan = p.codigo
                nombre_plan = p.nombre
                limites = {
                    "usuarios": p.limiteusuarios,
                    "unidades": p.limiteunidades,
                    "reportes_mes": p.limitereportesmes,
                    "almacenamiento_mb": p.limitealmacenamientomb,
                }

        return SuscripcionResponse(
            idsuscripcion=sub.idsuscripcion,
            idtenant=sub.idtenant,
            nombretenant=nombre_tenant,
            idplan=sub.idplan,
            codigoplan=codigo_plan,
            nombreplan=nombre_plan,
            estado=sub.estado,
            fechainicio=sub.fechainicio,
            fechafin=sub.fechafin,
            diasrestantes=dias_restantes,
            renovacionautomatica=sub.renovacionautomatica,
            motivocancelacion=sub.motivocancelacion,
            limites=limites,
            creadoen=sub.creadoen,
            actualizadoen=sub.actualizadoen,
        )

    @staticmethod
    def asignar_trial_por_defecto(db: Session, idtenant: int) -> Suscripcion:
        """Crea automáticamente suscripción trial para un tenant si no tiene una activa."""
        plan_trial = db.execute(select(Plan).where(Plan.codigo == "trial")).scalar_one_or_none()
        if not plan_trial:
            # Fallback en caso de que aún no exista plan trial
            plan_trial = Plan(
                codigo="trial",
                nombre="Prueba Gratuita (Trial)",
                descripcion="Plan de evaluación con límites reducidos",
                preciomensual=0,
                precioanual=0,
                moneda="USD",
                limiteusuarios=3,
                limiteunidades=20,
                limitereportesmes=50,
                limitealmacenamientomb=100,
                diastrial=14,
                activo=True,
                creadoen=get_bolivia_now(),
                actualizadoen=get_bolivia_now(),
            )
            db.add(plan_trial)
            db.flush()

        inicio = get_bolivia_now()
        fin = inicio + timedelta(days=plan_trial.diastrial or 14)

        sub = Suscripcion(
            idtenant=idtenant,
            idplan=plan_trial.idplan,
            estado="trial",
            fechainicio=inicio,
            fechafin=fin,
            renovacionautomatica=False,
            creadoen=inicio,
            actualizadoen=inicio,
        )
        db.add(sub)
        db.flush()
        return sub


@router.post("", response_model=SuscripcionResponse, status_code=status.HTTP_201_CREATED, summary="Suscribir empresa a un plan")
def suscribir_empresa(
    body: SuscribirEmpresaRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_suscripcion),
):
    tenant = db.execute(select(Tenant).where(Tenant.idtenant == body.idtenant)).scalar_one_or_none()
    if not tenant:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Empresa (tenant) no encontrada.")

    plan = db.execute(select(Plan).where(Plan.idplan == body.idplan)).scalar_one_or_none()
    if not plan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan de suscripción no encontrado.")
    if not plan.activo:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="No se puede suscribir a un plan inactivo.")

    # Desactivar suscripciones activas previas
    subs_activas = db.execute(
        select(Suscripcion).where(
            Suscripcion.idtenant == body.idtenant,
            Suscripcion.estado.in_(["trial", "activa"]),
        )
    ).scalars().all()
    for sa in subs_activas:
        sa.estado = "cancelada"
        sa.motivocancelacion = f"Reemplazada por suscripción a plan {plan.nombre}."
        sa.actualizadoen = get_bolivia_now()

    dias = body.diasvigencia or (plan.diastrial if plan.codigo == "trial" else 30)
    inicio = get_bolivia_now()
    fin = inicio + timedelta(days=dias)
    nuevo_estado = "trial" if plan.codigo == "trial" else "activa"

    nueva_sub = Suscripcion(
        idtenant=body.idtenant,
        idplan=body.idplan,
        estado=nuevo_estado,
        fechainicio=inicio,
        fechafin=fin,
        renovacionautomatica=body.renovacionautomatica,
        creadoen=inicio,
        actualizadoen=inicio,
    )
    db.add(nueva_sub)
    db.flush()

    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion=f"suscribir_empresa_{plan.codigo}",
                entidad="suscripcion",
                identidad=nueva_sub.idsuscripcion,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    db.commit()
    db.refresh(nueva_sub)
    return SubscriptionService._to_response(db, nueva_sub)


@router.get("", response_model=SuscripcionListResponse, summary="Listar suscripciones")
def list_suscripciones(
    idtenant: Optional[int] = Query(None),
    estado: Optional[str] = Query(None),
    idplan: Optional[int] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_lectura_suscripcion),
):
    tenant_id = resolve_tenant_id(db, current_user, requested_tenant_id=idtenant)
    stmt = select(Suscripcion)

    # Si es SuperAdministrador y no pidió tenant específico, tenant_id suele ser 0 o de su perfil
    user_roles = getattr(current_user, "roles", []) or []
    if "SuperAdministrador" in user_roles:
        if idtenant:
            stmt = stmt.where(Suscripcion.idtenant == idtenant)
    else:
        stmt = stmt.where(Suscripcion.idtenant == tenant_id)

    if estado:
        stmt = stmt.where(Suscripcion.estado == estado.strip().lower())
    if idplan:
        stmt = stmt.where(Suscripcion.idplan == idplan)

    total = db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
    stmt = stmt.order_by(desc(Suscripcion.creadoen)).offset(skip).limit(limit)
    rows = db.execute(stmt).scalars().all()

    return SuscripcionListResponse(
        total=total,
        skip=skip,
        limit=limit,
        items=[SubscriptionService._to_response(db, s) for s in rows],
    )


@router.get("/{idsuscripcion}", response_model=SuscripcionResponse, summary="Detalle de una suscripción")
def get_suscripcion(
    idsuscripcion: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_lectura_suscripcion),
):
    sub = db.execute(select(Suscripcion).where(Suscripcion.idsuscripcion == idsuscripcion)).scalar_one_or_none()
    if not sub:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Suscripción no encontrada.")

    user_roles = getattr(current_user, "roles", []) or []
    if "SuperAdministrador" not in user_roles:
        tenant_id = resolve_tenant_id(db, current_user)
        if sub.idtenant != tenant_id:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Suscripción no encontrada.")

    return SubscriptionService._to_response(db, sub)


@router.get("/tenant/{idtenant}/actual", response_model=SuscripcionResponse, summary="Obtener suscripción vigente del tenant")
def get_suscripcion_actual_tenant(
    idtenant: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_lectura_suscripcion),
):
    user_roles = getattr(current_user, "roles", []) or []
    if "SuperAdministrador" not in user_roles:
        tenant_id = resolve_tenant_id(db, current_user)
        if idtenant != tenant_id:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="No autorizado a ver la suscripción de otro tenant.")

    sub = db.execute(
        select(Suscripcion)
        .where(
            Suscripcion.idtenant == idtenant,
            Suscripcion.estado.in_(["activa", "trial", "suspendida"]),
        )
        .order_by(desc(Suscripcion.creadoen))
    ).scalars().first()

    if not sub:
        # Si no existe suscripción previa, asignar trial automáticamente
        sub = SubscriptionService.asignar_trial_por_defecto(db, idtenant)
        db.commit()
        db.refresh(sub)

    return SubscriptionService._to_response(db, sub)


@router.post("/{idsuscripcion}/cambiar-plan", response_model=SuscripcionResponse, summary="Cambiar de plan conservando histórico")
def cambiar_plan_suscripcion(
    idsuscripcion: int,
    body: CambiarPlanRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_suscripcion),
):
    sub_actual = db.execute(select(Suscripcion).where(Suscripcion.idsuscripcion == idsuscripcion)).scalar_one_or_none()
    if not sub_actual:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Suscripción no encontrada.")

    nuevo_plan = db.execute(select(Plan).where(Plan.idplan == body.nuevoidplan)).scalar_one_or_none()
    if not nuevo_plan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Nuevo plan no encontrado.")
    if not nuevo_plan.activo:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="El plan seleccionado no está activo.")

    # Finalizar suscripción previa
    sub_actual.estado = "cancelada"
    sub_actual.motivocancelacion = f"Actualización a plan '{nuevo_plan.nombre}'."
    sub_actual.actualizadoen = get_bolivia_now()

    dias = body.diasvigencia or (nuevo_plan.diastrial if nuevo_plan.codigo == "trial" else 30)
    inicio = get_bolivia_now()
    fin = inicio + timedelta(days=dias)
    renovacion = body.renovacionautomatica if body.renovacionautomatica is not None else sub_actual.renovacionautomatica

    nueva_sub = Suscripcion(
        idtenant=sub_actual.idtenant,
        idplan=nuevo_plan.idplan,
        estado="trial" if nuevo_plan.codigo == "trial" else "activa",
        fechainicio=inicio,
        fechafin=fin,
        renovacionautomatica=renovacion,
        creadoen=inicio,
        actualizadoen=inicio,
    )
    db.add(nueva_sub)
    db.flush()

    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion=f"cambiar_plan_a_{nuevo_plan.codigo}",
                entidad="suscripcion",
                identidad=nueva_sub.idsuscripcion,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    db.commit()
    db.refresh(nueva_sub)
    return SubscriptionService._to_response(db, nueva_sub)


@router.patch("/{idsuscripcion}/estado", response_model=SuscripcionResponse, summary="Modificar estado de suscripción")
def update_suscripcion_estado(
    idsuscripcion: int,
    body: UpdateSuscripcionEstadoRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_suscripcion),
):
    estados_permitidos = {"trial", "activa", "vencida", "suspendida", "cancelada"}
    nuevo_estado = body.estado.strip().lower()
    if nuevo_estado not in estados_permitidos:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Estado inválido '{body.estado}'. Permitidos: {', '.join(sorted(estados_permitidos))}",
        )

    sub = db.execute(select(Suscripcion).where(Suscripcion.idsuscripcion == idsuscripcion)).scalar_one_or_none()
    if not sub:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Suscripción no encontrada.")

    sub.estado = nuevo_estado
    sub.actualizadoen = get_bolivia_now()
    if body.motivocancelacion:
        sub.motivocancelacion = body.motivocancelacion.strip()

    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion=f"actualizar_estado_suscripcion_{nuevo_estado}",
                entidad="suscripcion",
                identidad=sub.idsuscripcion,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    db.commit()
    db.refresh(sub)
    return SubscriptionService._to_response(db, sub)
