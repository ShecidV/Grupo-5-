from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, or_

from app.db.session import get_db
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import require_roles
from app.views.cu006_productos_variantes.product_views import (
    ProductCreate,
    ProductUpdate,
    ProductResponse,
    ProductListResponse,
    VariantCreate,
    VariantUpdate,
    VariantResponse
)

router = APIRouter(tags=["Gestionar Productos y Variantes (CU-006)"])

# Roles autorizados a crear/editar/bajar productos y variantes del catálogo global.
# (products:manage en la matriz rol-permisos.)
ROLES_GESTION_PRODUCTO = ("SuperAdministrador", "AdministradorEmpresa")

requires_gestion_producto = require_roles(*ROLES_GESTION_PRODUCTO)


class ProductController:
    @staticmethod
    def list_products(
        db: Session,
        search: Optional[str] = None,
        idcategoria: Optional[int] = None,
        skip: int = 0,
        limit: int = 50
    ) -> ProductListResponse:
        query = select(Producto)

        if search and search.strip():
            term = f"%{search.strip().lower()}%"
            query = query.where(
                or_(
                    func.lower(Producto.nombre).like(term),
                    func.lower(Producto.modelo).like(term),
                    func.lower(Producto.descripcion).like(term)
                )
            )

        if idcategoria is not None:
            query = query.where(Producto.idcategoria == idcategoria)

        # Contar total
        count_stmt = select(func.count()).select_from(query.subquery())
        total = db.execute(count_stmt).scalar_one()

        query = query.order_by(Producto.idproducto.asc()).offset(skip).limit(limit)
        items = db.execute(query).scalars().all()

        return ProductListResponse(
            total=total,
            items=[ProductResponse.model_validate(p) for p in items]
        )

    @staticmethod
    def get_product(db: Session, idproducto: int) -> ProductResponse:
        stmt = select(Producto).where(Producto.idproducto == idproducto)
        prod = db.execute(stmt).scalar_one_or_none()
        if not prod:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Producto con ID {idproducto} no encontrado."
            )
        return ProductResponse.model_validate(prod)

    @staticmethod
    def create_product(db: Session, data: ProductCreate) -> ProductResponse:
        prod = Producto(
            nombre=data.nombre,
            idcategoria=data.idcategoria or 1,
            modelo=data.modelo or "",
            paisorigen=data.paisorigen,
            descripcion=data.descripcion,
            imagenurl=data.imagenurl,
            activo=data.activo if data.activo is not None else True
        )
        db.add(prod)
        db.commit()
        db.refresh(prod)
        return ProductResponse.model_validate(prod)

    @staticmethod
    def update_product(db: Session, idproducto: int, data: ProductUpdate) -> ProductResponse:
        stmt = select(Producto).where(Producto.idproducto == idproducto)
        prod = db.execute(stmt).scalar_one_or_none()
        if not prod:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Producto con ID {idproducto} no encontrado."
            )

        if data.nombre is not None:
            prod.nombre = data.nombre
        if data.idcategoria is not None:
            prod.idcategoria = data.idcategoria
        if data.modelo is not None:
            prod.modelo = data.modelo
        if data.paisorigen is not None:
            prod.paisorigen = data.paisorigen
        if data.descripcion is not None:
            prod.descripcion = data.descripcion
        if data.imagenurl is not None:
            prod.imagenurl = data.imagenurl
        if data.activo is not None:
            prod.activo = data.activo

        db.commit()
        db.refresh(prod)
        return ProductResponse.model_validate(prod)

    @staticmethod
    def delete_product(db: Session, idproducto: int) -> ProductResponse:
        stmt = select(Producto).where(Producto.idproducto == idproducto)
        prod = db.execute(stmt).scalar_one_or_none()
        if not prod:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Producto con ID {idproducto} no encontrado."
            )

        prod.activo = False
        db.commit()
        db.refresh(prod)
        return ProductResponse.model_validate(prod)

    # Operaciones de variantes
    @staticmethod
    def add_variant(db: Session, idproducto: int, data: VariantCreate) -> VariantResponse:
        stmt_p = select(Producto).where(Producto.idproducto == idproducto)
        prod = db.execute(stmt_p).scalar_one_or_none()
        if not prod:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Producto con ID {idproducto} no encontrado."
            )

        # Validar SKU único
        stmt_sku = select(VarianteProducto).where(VarianteProducto.sku == data.sku)
        if db.execute(stmt_sku).scalar_one_or_none():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"El SKU '{data.sku}' ya está registrado."
            )

        var = VarianteProducto(
            idproducto=idproducto,
            capacidad=data.capacidad or "",
            color=data.color or "",
            sku=data.sku,
            preciousd=data.preciousd
        )
        db.add(var)
        db.commit()
        db.refresh(var)
        return VariantResponse.model_validate(var)

    @staticmethod
    def update_variant(db: Session, idvariante: int, data: VariantUpdate) -> VariantResponse:
        stmt = select(VarianteProducto).where(VarianteProducto.idvariante == idvariante)
        var = db.execute(stmt).scalar_one_or_none()
        if not var:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Variante con ID {idvariante} no encontrada."
            )

        if data.sku is not None and data.sku != var.sku:
            stmt_sku = select(VarianteProducto).where(VarianteProducto.sku == data.sku)
            if db.execute(stmt_sku).scalar_one_or_none():
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"El SKU '{data.sku}' ya está registrado por otra variante."
                )
            var.sku = data.sku

        if data.capacidad is not None:
            var.capacidad = data.capacidad
        if data.color is not None:
            var.color = data.color
        if data.preciousd is not None:
            var.preciousd = data.preciousd

        db.commit()
        db.refresh(var)
        return VariantResponse.model_validate(var)

    @staticmethod
    def delete_variant(db: Session, idvariante: int):
        stmt = select(VarianteProducto).where(VarianteProducto.idvariante == idvariante)
        var = db.execute(stmt).scalar_one_or_none()
        if not var:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Variante con ID {idvariante} no encontrada."
            )

        db.delete(var)
        db.commit()
        return {"detail": f"Variante {idvariante} eliminada exitosamente."}


# Endpoints (Rutas HTTP)
@router.get("/products", response_model=ProductListResponse)
def get_products(
    search: Optional[str] = Query(None),
    idcategoria: Optional[int] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar productos con filtrado por búsqueda y categoría (CU-006)."""
    return ProductController.list_products(db, search, idcategoria, skip, limit)


@router.get("/products/{idproducto}", response_model=ProductResponse)
def get_product(
    idproducto: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener detalle de producto con sus variantes (CU-006)."""
    return ProductController.get_product(db, idproducto)


@router.post("/products", response_model=ProductResponse, status_code=status.HTTP_201_CREATED)
def create_product(
    data: ProductCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_producto)
):
    """Crear un nuevo producto (CU-006)."""
    return ProductController.create_product(db, data)


@router.put("/products/{idproducto}", response_model=ProductResponse)
def update_product(
    idproducto: int,
    data: ProductUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_producto)
):
    """Editar información de un producto (CU-006)."""
    return ProductController.update_product(db, idproducto, data)


@router.delete("/products/{idproducto}", response_model=ProductResponse)
def delete_product(
    idproducto: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_producto)
):
    """Desactivar un producto (CU-006)."""
    return ProductController.delete_product(db, idproducto)


# Endpoints de Variantes
@router.post("/products/{idproducto}/variants", response_model=VariantResponse, status_code=status.HTTP_201_CREATED)
def add_variant(
    idproducto: int,
    data: VariantCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_producto)
):
    """Agregar una variante a un producto (CU-006)."""
    return ProductController.add_variant(db, idproducto, data)


@router.put("/variants/{idvariante}", response_model=VariantResponse)
def update_variant(
    idvariante: int,
    data: VariantUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_producto)
):
    """Editar una variante existente (CU-006)."""
    return ProductController.update_variant(db, idvariante, data)


@router.delete("/variants/{idvariante}")
def delete_variant(
    idvariante: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_producto)
):
    """Eliminar una variante (CU-006)."""
    return ProductController.delete_variant(db, idvariante)
