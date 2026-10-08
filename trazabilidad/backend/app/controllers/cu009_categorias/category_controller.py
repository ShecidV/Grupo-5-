from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.db.session import get_db
from app.models.cu009_categorias.category import Categoria
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import require_roles
from app.views.cu009_categorias.category_views import (
    CategoryCreate,
    CategoryUpdate,
    CategoryResponse
)

router = APIRouter(tags=["Gestionar Categorías de Productos (CU-009)"])

# Roles autorizados a crear/editar/eliminar categorías (categories:manage).
ROLES_GESTION_CATEGORIA = ("SuperAdministrador", "AdministradorEmpresa")

requires_gestion_categoria = require_roles(*ROLES_GESTION_CATEGORIA)


class CategoryController:
    @staticmethod
    def list_categories(db: Session) -> List[CategoryResponse]:
        stmt = select(Categoria).order_by(Categoria.idcategoria.asc())
        cats = db.execute(stmt).scalars().all()
        return [CategoryResponse.model_validate(c) for c in cats]

    @staticmethod
    def create_category(db: Session, data: CategoryCreate) -> CategoryResponse:
        cat = Categoria(
            nombrecategoria=data.nombrecategoria,
            descripcion=data.descripcion
        )
        db.add(cat)
        db.commit()
        db.refresh(cat)
        return CategoryResponse.model_validate(cat)

    @staticmethod
    def update_category(db: Session, idcategoria: int, data: CategoryUpdate) -> CategoryResponse:
        stmt = select(Categoria).where(Categoria.idcategoria == idcategoria)
        cat = db.execute(stmt).scalar_one_or_none()
        if not cat:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Categoría con ID {idcategoria} no encontrada."
            )

        if data.nombrecategoria is not None:
            cat.nombrecategoria = data.nombrecategoria
        if data.descripcion is not None:
            cat.descripcion = data.descripcion

        db.commit()
        db.refresh(cat)
        return CategoryResponse.model_validate(cat)

    @staticmethod
    def delete_category(db: Session, idcategoria: int):
        stmt = select(Categoria).where(Categoria.idcategoria == idcategoria)
        cat = db.execute(stmt).scalar_one_or_none()
        if not cat:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Categoría con ID {idcategoria} no encontrada."
            )

        db.delete(cat)
        db.commit()
        return {"detail": f"Categoría {idcategoria} eliminada exitosamente."}


# Endpoints (Rutas HTTP)
@router.get("/categories", response_model=List[CategoryResponse])
def get_categories(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar todas las categorías (CU-009)."""
    return CategoryController.list_categories(db)


@router.post("/categories", response_model=CategoryResponse, status_code=status.HTTP_201_CREATED)
def create_category(
    data: CategoryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_categoria)
):
    """Crear una nueva categoría (CU-009)."""
    return CategoryController.create_category(db, data)


@router.put("/categories/{idcategoria}", response_model=CategoryResponse)
def update_category(
    idcategoria: int,
    data: CategoryUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_categoria)
):
    """Editar una categoría existente (CU-009)."""
    return CategoryController.update_category(db, idcategoria, data)


@router.delete("/categories/{idcategoria}")
def delete_category(
    idcategoria: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_categoria)
):
    """Eliminar una categoría (CU-009)."""
    return CategoryController.delete_category(db, idcategoria)
