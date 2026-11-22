"""CU-038 - Controlar cuotas y consumo por plan de suscripción (P8)."""
from datetime import datetime
from typing import Dict, Optional

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_bolivia_now, require_roles, resolve_tenant_id
from app.db.session import get_db
from app.models.cu002_usuarios.user import User
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Plan, Suscripcion
from app.packages.p8_suscripciones.models.cu038_cuotas.uso_plan import UsoPlan
from app.packages.p8_suscripciones.views.cu038_cuotas.quota_views import (
    ConsumirCuotaRequest, CuotaResponse, LimiteItem,
)

router = APIRouter(prefix="/quotas", tags=["Cuotas y Consumo (CU-038)"])
requires_quotas = require_roles(
    "SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones",
    "GestorVentasPostventa", "Auditor",
)

CONCEPTOS = ("reportesgenerados", "unidadesregistradas", "usuariosactivos")
_LIMITES_PLAN = {
    "reportesgenerados": "limitereportesmes",
    "unidadesregistradas": "limiteunidades",
    "usuariosactivos": "limiteusuarios",
}


def _suscripcion_activa(db: Session, tenant_id: int):
    ahora = get_bolivia_now()
    return db.execute(
        select(Suscripcion)
        .where(
            Suscripcion.idtenant == tenant_id,
            Suscripcion.estado.in_(["trial", "activa"]),
            Suscripcion.fechafin >= ahora,
        )
        .order_by(Suscripcion.idsuscripcion.desc())
        .limit(1)
    ).scalar_one_or_none()


def _uso_actual(db: Session, tenant_id: int, periodo: str) -> UsoPlan:
    uso = db.execute(
        select(UsoPlan).where(UsoPlan.idtenant == tenant_id, UsoPlan.periodo == periodo)
    ).scalar_one_or_none()
    if uso is None:
        uso = UsoPlan(idtenant=tenant_id, periodo=periodo)
        db.add(uso)
        db.flush()
    return uso


def _armar_response(db: Session, tenant_id: int) -> CuotaResponse:
    periodo = get_bolivia_now().strftime("%Y-%m")
    suscripcion = _suscripcion_activa(db, tenant_id)
    plan = db.execute(
        select(Plan).where(Plan.idplan == suscripcion.idplan)
    ).scalar_one_or_none() if suscripcion else None
    uso = db.execute(
        select(UsoPlan).where(UsoPlan.idtenant == tenant_id, UsoPlan.periodo == periodo)
    ).scalar_one_or_none()

    limites: Dict[str, LimiteItem] = {}
    for concepto in CONCEPTOS:
        permitido = getattr(plan, _LIMITES_PLAN[concepto], None) if plan else 0
        usado = getattr(uso, concepto, 0) if uso else 0
        disponible = None if permitido is None else max(0, permitido - usado)
        limites[concepto] = LimiteItem(
            permitido=permitido,
            usado=usado,
            disponible=disponible,
            excedido=permitido is not None and usado >= permitido,
        )

    return CuotaResponse(
        idtenant=tenant_id,
        periodo=periodo,
        plan=plan.nombre if plan else None,
        estado_suscripcion=str(suscripcion.estado) if suscripcion else None,
        limites=limites,
        actualizadoen=uso.actualizadoen if uso else None,
    )


class QuotaController:
    @staticmethod
    def get_quotas(db: Session, user: User) -> CuotaResponse:
        return _armar_response(db, resolve_tenant_id(db, user))

    @staticmethod
    def consumir(db: Session, user: User, body: ConsumirCuotaRequest) -> CuotaResponse:
        tenant_id = resolve_tenant_id(db, user)
        if body.concepto not in CONCEPTOS:
            raise HTTPException(
                status_code=400,
                detail=f"Concepto inválido. Permitidos: {', '.join(CONCEPTOS)}.",
            )
        periodo = get_bolivia_now().strftime("%Y-%m")
        suscripcion = _suscripcion_activa(db, tenant_id)
        plan = db.execute(
            select(Plan).where(Plan.idplan == suscripcion.idplan)
        ).scalar_one_or_none() if suscripcion else None

        uso = _uso_actual(db, tenant_id, periodo)
        permitido = getattr(plan, _LIMITES_PLAN[body.concepto], None) if plan else 0
        usado = getattr(uso, body.concepto)
        if permitido is not None and usado + body.cantidad > permitido:
            raise HTTPException(
                status_code=429,
                detail=(
                    f"Límite excedido para {body.concepto}: "
                    f"usado {usado}, permitido {permitido}."
                ),
            )
        setattr(uso, body.concepto, usado + body.cantidad)
        uso.actualizadoen = get_bolivia_now()
        db.commit()
        db.refresh(uso)
        return _armar_response(db, tenant_id)


@router.get("", response_model=CuotaResponse)
def get_quotas(db: Session = Depends(get_db), current_user: User = Depends(requires_quotas)):
    return QuotaController.get_quotas(db, current_user)


@router.post("/consume", response_model=CuotaResponse)
def consumir_cuota(
    body: ConsumirCuotaRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_quotas),
):
    return QuotaController.consumir(db, current_user, body)
