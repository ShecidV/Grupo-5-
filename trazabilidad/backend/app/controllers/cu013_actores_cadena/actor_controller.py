from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, or_

from app.db.session import get_db
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_user_tenant_id, require_roles
from app.views.cu013_actores_cadena.actor_views import (
    ActorCreate,
    ActorUpdate,
    ActorResponse,
    ActorListResponse
)

router = APIRouter(tags=["Gestionar Actores de la Cadena (CU-013)"])

# Roles autorizados a crear/editar/eliminar actores de la cadena (actors:manage).
ROLES_GESTION_ACTOR = ("SuperAdministrador", "AdministradorEmpresa")

requires_gestion_actor = require_roles(*ROLES_GESTION_ACTOR)


class ActorController:
    @staticmethod
    def list_actors(
        db: Session,
        user: User,
        search: Optional[str] = None,
        tipoactor: Optional[str] = None,
        skip: int = 0,
        limit: int = 50
    ) -> ActorListResponse:
        tenant_id = get_user_tenant_id(db, user)
        query = select(ActorCadena).where(ActorCadena.idtenant == tenant_id)

        if tipoactor and tipoactor.strip():
            query = query.where(ActorCadena.tipoactor == tipoactor.strip())

        if search and search.strip():
            term = f"%{search.strip().lower()}%"
            query = query.where(
                or_(
                    func.lower(ActorCadena.nombre).like(term),
                    func.lower(ActorCadena.razonsocial).like(term),
                    func.lower(ActorCadena.nit).like(term),
                    func.lower(ActorCadena.email).like(term)
                )
            )

        count_stmt = select(func.count()).select_from(query.subquery())
        total = db.execute(count_stmt).scalar_one()

        query = query.order_by(ActorCadena.idactor.asc()).offset(skip).limit(limit)
        items = db.execute(query).scalars().all()

        return ActorListResponse(
            total=total,
            items=[ActorResponse.model_validate(item) for item in items]
        )

    @staticmethod
    def create_actor(db: Session, user: User, data: ActorCreate) -> ActorResponse:
        tenant_id = get_user_tenant_id(db, user)
        actor = ActorCadena(
            idtenant=tenant_id,
            nombre=data.nombre,
            razonsocial=data.razonsocial,
            nit=data.nit,
            email=data.email,
            telefono=data.telefono,
            tipoactor=data.tipoactor
        )
        db.add(actor)
        db.commit()
        db.refresh(actor)
        return ActorResponse.model_validate(actor)

    @staticmethod
    def update_actor(db: Session, user: User, idactor: int, data: ActorUpdate) -> ActorResponse:
        tenant_id = get_user_tenant_id(db, user)
        stmt = select(ActorCadena).where(
            ActorCadena.idactor == idactor,
            ActorCadena.idtenant == tenant_id
        )
        actor = db.execute(stmt).scalar_one_or_none()
        if not actor:
            raise HTTPException(status_code=404, detail=f"Actor {idactor} no encontrado.")

        if data.nombre is not None:
            actor.nombre = data.nombre
        if data.razonsocial is not None:
            actor.razonsocial = data.razonsocial
        if data.nit is not None:
            actor.nit = data.nit
        if data.email is not None:
            actor.email = data.email
        if data.telefono is not None:
            actor.telefono = data.telefono
        if data.tipoactor is not None:
            actor.tipoactor = data.tipoactor

        db.commit()
        db.refresh(actor)
        return ActorResponse.model_validate(actor)

    @staticmethod
    def delete_actor(db: Session, user: User, idactor: int):
        tenant_id = get_user_tenant_id(db, user)
        stmt = select(ActorCadena).where(
            ActorCadena.idactor == idactor,
            ActorCadena.idtenant == tenant_id
        )
        actor = db.execute(stmt).scalar_one_or_none()
        if not actor:
            raise HTTPException(status_code=404, detail=f"Actor {idactor} no encontrado.")

        db.delete(actor)
        db.commit()
        return {"detail": f"Actor {idactor} eliminado."}


# Endpoints (Rutas HTTP)
@router.get("/actors", response_model=ActorListResponse)
def get_actors(
    search: Optional[str] = Query(None),
    tipoactor: Optional[str] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar actores de la cadena de suministro (CU-013)."""
    return ActorController.list_actors(db, current_user, search, tipoactor, skip, limit)


@router.post("/actors", response_model=ActorResponse, status_code=status.HTTP_201_CREATED)
def create_actor(
    data: ActorCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_actor)
):
    """Crear un actor de la cadena (CU-013)."""
    return ActorController.create_actor(db, current_user, data)


@router.put("/actors/{idactor}", response_model=ActorResponse)
def update_actor(
    idactor: int,
    data: ActorUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_actor)
):
    """Actualizar un actor (CU-013)."""
    return ActorController.update_actor(db, current_user, idactor, data)


@router.delete("/actors/{idactor}")
def delete_actor(
    idactor: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_actor)
):
    """Eliminar un actor (CU-013)."""
    return ActorController.delete_actor(db, current_user, idactor)
