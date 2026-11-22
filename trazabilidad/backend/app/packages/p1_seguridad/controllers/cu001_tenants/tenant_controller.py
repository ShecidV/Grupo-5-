from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, or_

from app.db.session import get_db
from app.packages.p1_seguridad.models.cu001_tenants.tenant import Tenant
from app.packages.p1_seguridad.models.cu002_usuarios.user import User
from app.packages.p1_seguridad.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.packages.p1_seguridad.views.cu001_tenants.tenant_views import (
    TenantCreate,
    TenantUpdate,
    TenantResponse,
    TenantListResponse
)

router = APIRouter(prefix="/tenants", tags=["Gestión de Empresas (CU-001)"])


class TenantController:
    @staticmethod
    def list_tenants(
        db: Session,
        search: Optional[str] = None,
        skip: int = 0,
        limit: int = 50,
        only_active: bool = False
    ) -> TenantListResponse:
        query = select(Tenant)

        if only_active:
            query = query.where(Tenant.activo == True)

        if search and search.strip():
            term = f"%{search.strip().lower()}%"
            query = query.where(
                or_(
                    func.lower(Tenant.nombre).like(term),
                    func.lower(Tenant.razonsocial).like(term),
                    func.lower(Tenant.nit).like(term),
                    func.lower(Tenant.email).like(term)
                )
            )

        # Contar total
        count_stmt = select(func.count()).select_from(query.subquery())
        total = db.execute(count_stmt).scalar_one()

        # Ejecutar consulta paginada
        query = query.order_by(Tenant.idtenant.asc()).offset(skip).limit(limit)
        items = db.execute(query).scalars().all()

        return TenantListResponse(
            total=total,
            items=[TenantResponse.model_validate(t) for t in items]
        )

    @staticmethod
    def create_tenant(db: Session, data: TenantCreate) -> TenantResponse:
        # Validar unicidad del NIT
        stmt_nit = select(Tenant).where(Tenant.nit == data.nit.strip())
        existing = db.execute(stmt_nit).scalar_one_or_none()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Ya existe una empresa registrada con el NIT '{data.nit}'."
            )

        tenant = Tenant(
            nombre=data.nombre.strip(),
            razonsocial=data.razonsocial.strip(),
            nit=data.nit.strip(),
            email=data.email.strip().lower(),
            telefono=data.telefono.strip() if data.telefono else None,
            activo=data.activo if data.activo is not None else True
        )
        db.add(tenant)
        db.commit()
        db.refresh(tenant)

        try:
            from app.packages.p8_suscripciones.controllers.cu036_planes.subscription_controller import SubscriptionService
            SubscriptionService.asignar_trial_por_defecto(db, tenant.idtenant)
            db.commit()
        except Exception:
            pass

        return TenantResponse.model_validate(tenant)

    @staticmethod
    def get_tenant(db: Session, idtenant: int) -> TenantResponse:
        stmt = select(Tenant).where(Tenant.idtenant == idtenant)
        tenant = db.execute(stmt).scalar_one_or_none()
        if not tenant:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Empresa con ID {idtenant} no encontrada."
            )
        return TenantResponse.model_validate(tenant)

    @staticmethod
    def update_tenant(db: Session, idtenant: int, data: TenantUpdate) -> TenantResponse:
        stmt = select(Tenant).where(Tenant.idtenant == idtenant)
        tenant = db.execute(stmt).scalar_one_or_none()
        if not tenant:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Empresa con ID {idtenant} no encontrada."
            )

        if data.nit and data.nit.strip() != tenant.nit:
            stmt_nit = select(Tenant).where(
                Tenant.nit == data.nit.strip(),
                Tenant.idtenant != idtenant
            )
            if db.execute(stmt_nit).scalar_one_or_none():
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Ya existe otra empresa registrada con el NIT '{data.nit}'."
                )
            tenant.nit = data.nit.strip()

        if data.nombre is not None:
            tenant.nombre = data.nombre.strip()
        if data.razonsocial is not None:
            tenant.razonsocial = data.razonsocial.strip()
        if data.email is not None:
            tenant.email = data.email.strip().lower()
        if data.telefono is not None:
            tenant.telefono = data.telefono.strip() if data.telefono else None
        if data.activo is not None:
            tenant.activo = data.activo

        db.commit()
        db.refresh(tenant)
        return TenantResponse.model_validate(tenant)

    @staticmethod
    def delete_tenant(db: Session, idtenant: int) -> TenantResponse:
        stmt = select(Tenant).where(Tenant.idtenant == idtenant)
        tenant = db.execute(stmt).scalar_one_or_none()
        if not tenant:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Empresa con ID {idtenant} no encontrada."
            )

        tenant.activo = False
        db.commit()
        db.refresh(tenant)
        return TenantResponse.model_validate(tenant)


# Endpoints (Rutas HTTP)
@router.get("", response_model=TenantListResponse)
def get_tenants(
    search: Optional[str] = Query(None, description="Buscador por nombre, razón social o NIT"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    only_active: bool = Query(False),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar todas las empresas registradas (CU-001)."""
    return TenantController.list_tenants(db, search, skip, limit, only_active)


@router.post("", response_model=TenantResponse, status_code=status.HTTP_201_CREATED)
def create_tenant(
    data: TenantCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Registrar una nueva empresa (CU-001)."""
    return TenantController.create_tenant(db, data)


@router.get("/{idtenant}", response_model=TenantResponse)
def get_tenant_by_id(
    idtenant: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener los detalles de una empresa específica por su ID (CU-001)."""
    return TenantController.get_tenant(db, idtenant)


@router.put("/{idtenant}", response_model=TenantResponse)
def update_tenant(
    idtenant: int,
    data: TenantUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Actualizar datos de una empresa existente (CU-001)."""
    return TenantController.update_tenant(db, idtenant, data)


@router.delete("/{idtenant}", response_model=TenantResponse)
def delete_tenant(
    idtenant: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Desactivación lógica de una empresa (CU-001)."""
    return TenantController.delete_tenant(db, idtenant)
