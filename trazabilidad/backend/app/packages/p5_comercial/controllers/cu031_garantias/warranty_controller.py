"""CU-031 - Garantías por unidad."""
from datetime import date
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
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p5_comercial.models.cu031_garantias.garantia import GarantiaUnidad
from app.packages.p5_comercial.views.cu031_garantias.warranty_views import (
    CreateGarantiaRequest, GarantiaResponse, GarantiaListResponse,
)

router = APIRouter(prefix="/warranties", tags=["Garantías por Unidad (CU-031)"])
requires_garantias = require_roles(
    "SuperAdministrador", "AdministradorEmpresa", "GestorVentasPostventa"
)


class WarrantyController:

    @staticmethod
    def _get_garantia(db: Session, tenant_id: int, idgarantia: int) -> GarantiaUnidad:
        garantia = db.execute(
            select(GarantiaUnidad)
            .join(UnidadProducto, UnidadProducto.idunidad == GarantiaUnidad.idunidad)
            .where(GarantiaUnidad.idgarantia == idgarantia, UnidadProducto.idtenant == tenant_id)
        ).scalar_one_or_none()
        if not garantia:
            raise HTTPException(status_code=404, detail=f"Garantía {idgarantia} no encontrada.")
        return garantia

    @staticmethod
    def _to_response(db: Session, g: GarantiaUnidad) -> GarantiaResponse:
        serie = db.execute(
            select(UnidadProducto.numeroserie).where(UnidadProducto.idunidad == g.idunidad)
        ).scalar_one_or_none()
        hoy = get_bolivia_now().date()
        return GarantiaResponse(
            idgarantia=g.idgarantia, idunidad=g.idunidad, numeroserie=serie or "",
            fechainicio=g.fechainicio, fechafin=g.fechafin, proveedor=g.proveedor,
            condiciones=g.condiciones,
            diasrestantes=max(0, (g.fechafin - hoy).days),
            vigente=g.fechainicio <= hoy <= g.fechafin,
        )

    @staticmethod
    def _bitacora(db, user, tenant_id, accion, identidad, ip) -> None:
        db.add(Bitacora(
            idusuariotenant=get_idusuariotenant(db, user), accion=accion,
            entidad="Garantia", identidad=identidad, ip=ip, fechahora=get_bolivia_now(),
        ))


@router.get("", response_model=GarantiaListResponse)
def list_warranties(
    idunidad: Optional[int] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_garantias),
):
    tenant_id = resolve_tenant_id(db, current_user)
    query = select(GarantiaUnidad).join(
        UnidadProducto, UnidadProducto.idunidad == GarantiaUnidad.idunidad
    ).where(UnidadProducto.idtenant == tenant_id)
    if idunidad:
        query = query.where(GarantiaUnidad.idunidad == idunidad)
    total = db.execute(select(func.count()).select_from(query.subquery())).scalar_one()
    garantias = db.execute(
        query.order_by(GarantiaUnidad.fechafin.desc()).offset(skip).limit(limit)
    ).scalars().all()
    return GarantiaListResponse(
        total=total, items=[WarrantyController._to_response(db, g) for g in garantias]
    )


@router.get("/{idgarantia}", response_model=GarantiaResponse)
def get_warranty(
    idgarantia: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_garantias),
):
    tenant_id = resolve_tenant_id(db, current_user)
    return WarrantyController._to_response(
        db, WarrantyController._get_garantia(db, tenant_id, idgarantia)
    )


@router.get("/units/{idunidad}/current", response_model=GarantiaResponse)
def get_unit_warranty(
    idunidad: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_garantias),
):
    tenant_id = resolve_tenant_id(db, current_user)
    unidad = db.execute(
        select(UnidadProducto).where(
            UnidadProducto.idunidad == idunidad, UnidadProducto.idtenant == tenant_id
        )
    ).scalar_one_or_none()
    if not unidad:
        raise HTTPException(status_code=404, detail="Unidad no encontrada.")
    garantia = db.execute(
        select(GarantiaUnidad)
        .where(GarantiaUnidad.idunidad == idunidad)
        .order_by(GarantiaUnidad.fechafin.desc())
        .limit(1)
    ).scalar_one_or_none()
    if not garantia:
        raise HTTPException(status_code=404, detail="La unidad no tiene garantía registrada.")
    return WarrantyController._to_response(db, garantia)


@router.post("", response_model=GarantiaResponse, status_code=status.HTTP_201_CREATED)
def create_warranty(
    body: CreateGarantiaRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_garantias),
):
    tenant_id = resolve_tenant_id(db, current_user)
    if body.fechafin < body.fechainicio:
        raise HTTPException(status_code=400, detail="fechafin debe ser >= fechainicio.")
    unidad = db.execute(
        select(UnidadProducto).where(
            UnidadProducto.idunidad == body.idunidad, UnidadProducto.idtenant == tenant_id
        )
    ).scalar_one_or_none()
    if not unidad:
        raise HTTPException(status_code=404, detail="Unidad no encontrada en su empresa.")
    garantia = GarantiaUnidad(
        idunidad=body.idunidad, fechainicio=body.fechainicio, fechafin=body.fechafin,
        proveedor=body.proveedor, condiciones=body.condiciones,
    )
    db.add(garantia)
    db.flush()
    WarrantyController._bitacora(
        db, current_user, tenant_id, "CREAR_GARANTIA", garantia.idgarantia, get_client_ip(request)
    )
    db.commit()
    db.refresh(garantia)
    return WarrantyController._to_response(db, garantia)
