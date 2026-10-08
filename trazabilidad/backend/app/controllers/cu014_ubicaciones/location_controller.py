from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, or_

from app.db.session import get_db
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_user_tenant_id, require_roles
from app.views.cu014_ubicaciones.location_views import (
    LocationCreate,
    LocationUpdate,
    LocationResponse,
    LocationListResponse
)

router = APIRouter(tags=["Gestionar Ubicaciones Físicas (CU-014)"])

# Roles autorizados a crear/editar/eliminar ubicaciones (locations:manage).
ROLES_GESTION_UBICACION = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones")

requires_gestion_ubicacion = require_roles(*ROLES_GESTION_UBICACION)


class LocationController:

    @staticmethod
    def list_locations(
        db: Session,
        user: User,
        search: Optional[str] = None,
        tipo: Optional[str] = None,
        skip: int = 0,
        limit: int = 50
    ) -> LocationListResponse:
        tenant_id = get_user_tenant_id(db, user)
        query = select(Ubicacion).where(Ubicacion.idtenant == tenant_id)

        if tipo and tipo.strip():
            query = query.where(Ubicacion.tipo == tipo.strip())

        if search and search.strip():
            term = f"%{search.strip().lower()}%"
            query = query.where(
                or_(
                    func.lower(Ubicacion.nombre).like(term),
                    func.lower(Ubicacion.ciudad).like(term),
                    func.lower(Ubicacion.pais).like(term),
                    func.lower(Ubicacion.direccion).like(term)
                )
            )

        count_stmt = select(func.count()).select_from(query.subquery())
        total = db.execute(count_stmt).scalar_one()

        query = query.order_by(Ubicacion.idubicacion.asc()).offset(skip).limit(limit)
        items = db.execute(query).scalars().all()

        return LocationListResponse(
            total=total,
            items=[LocationResponse.model_validate(item) for item in items]
        )

    @staticmethod
    def create_location(db: Session, user: User, data: LocationCreate) -> LocationResponse:
        tenant_id = get_user_tenant_id(db, user)

        if data.idactor:
            stmt_a = select(ActorCadena).where(
                ActorCadena.idactor == data.idactor,
                ActorCadena.idtenant == tenant_id
            )
            if not db.execute(stmt_a).scalar_one_or_none():
                raise HTTPException(status_code=404, detail=f"Actor {data.idactor} no encontrado.")

        loc = Ubicacion(
            idtenant=tenant_id,
            idactor=data.idactor,
            nombre=data.nombre,
            direccion=data.direccion,
            latitud=data.latitud,
            longitud=data.longitud,
            ciudad=data.ciudad,
            pais=data.pais,
            tipo=data.tipo
        )
        db.add(loc)
        db.commit()
        db.refresh(loc)
        return LocationResponse.model_validate(loc)

    @staticmethod
    def update_location(db: Session, user: User, idubicacion: int, data: LocationUpdate) -> LocationResponse:
        tenant_id = get_user_tenant_id(db, user)
        stmt = select(Ubicacion).where(
            Ubicacion.idubicacion == idubicacion,
            Ubicacion.idtenant == tenant_id
        )
        loc = db.execute(stmt).scalar_one_or_none()
        if not loc:
            raise HTTPException(status_code=404, detail=f"Ubicación {idubicacion} no encontrada.")

        if data.nombre is not None:
            loc.nombre = data.nombre
        if data.idactor is not None:
            loc.idactor = data.idactor
        if data.direccion is not None:
            loc.direccion = data.direccion
        if data.latitud is not None:
            loc.latitud = data.latitud
        if data.longitud is not None:
            loc.longitud = data.longitud
        if data.ciudad is not None:
            loc.ciudad = data.ciudad
        if data.pais is not None:
            loc.pais = data.pais
        if data.tipo is not None:
            loc.tipo = data.tipo

        db.commit()
        db.refresh(loc)
        return LocationResponse.model_validate(loc)

    @staticmethod
    def delete_location(db: Session, user: User, idubicacion: int):
        tenant_id = get_user_tenant_id(db, user)
        stmt = select(Ubicacion).where(
            Ubicacion.idubicacion == idubicacion,
            Ubicacion.idtenant == tenant_id
        )
        loc = db.execute(stmt).scalar_one_or_none()
        if not loc:
            raise HTTPException(status_code=404, detail=f"Ubicación {idubicacion} no encontrada.")

        db.delete(loc)
        db.commit()
        return {"detail": f"Ubicación {idubicacion} eliminada."}


# Endpoints (Rutas HTTP)
@router.get("/locations", response_model=LocationListResponse)
def get_locations(
    search: Optional[str] = Query(None),
    tipo: Optional[str] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar ubicaciones físicas (CU-014)."""
    return LocationController.list_locations(db, current_user, search, tipo, skip, limit)


@router.post("/locations", response_model=LocationResponse, status_code=status.HTTP_201_CREATED)
def create_location(
    data: LocationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_ubicacion)
):
    """Crear una ubicación física (CU-014)."""
    return LocationController.create_location(db, current_user, data)


@router.put("/locations/{idubicacion}", response_model=LocationResponse)
def update_location(
    idubicacion: int,
    data: LocationUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_ubicacion)
):
    """Actualizar una ubicación física (CU-014)."""
    return LocationController.update_location(db, current_user, idubicacion, data)


@router.delete("/locations/{idubicacion}")
def delete_location(
    idubicacion: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_ubicacion)
):
    """Eliminar una ubicación física (CU-014)."""
    return LocationController.delete_location(db, current_user, idubicacion)
