from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status

from sqlalchemy.orm import Session

from sqlalchemy import select, func, or_



from app.db.session import get_db

from app.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant

from app.models.cu006_productos_variantes.variant import VarianteProducto

from app.models.cu002_usuarios.user import User

from app.controllers.cu004_autenticacion.auth_controller import get_current_user

from app.controllers.shared import get_user_tenant_id, resolve_tenant_id, require_roles

from app.views.cu008_catalogo_empresa.tenant_catalog_views import (

    TenantCatalogCreate,

    TenantCatalogUpdate,

    TenantCatalogResponse,

    TenantCatalogListResponse

)

from app.views.cu008_catalogo_empresa.recommendation_views import (

    PricingRecommendationRequest,

    PricingRecommendationsResponse,

)

from app.services.ai.pricing_recommender import build_pricing_recommendations



router = APIRouter(tags=["Gestionar Cat├ílogo por Empresa (CU-008)"])

# Roles autorizados a modificar el catálogo interno de la empresa
# (tenant_catalog:manage en la matriz rol-permisos).
ROLES_GESTION_CATALOGO_EMPRESA = ("SuperAdministrador", "AdministradorEmpresa")

requires_gestion_catalogo_empresa = require_roles(*ROLES_GESTION_CATALOGO_EMPRESA)





@router.post(
    "/tenant-catalog/recommendations",
    response_model=PricingRecommendationsResponse,
    status_code=status.HTTP_200_OK,
)
def generate_tenant_catalog_recommendations(
    data: PricingRecommendationRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Genera recomendaciones de pricing e inventario para el catalogo del tenant (CU-008 + IA)."""
    return TenantCatalogController.generate_recommendations(db, current_user, data)


class TenantCatalogController:



    @staticmethod

    def list_catalog(

        db: Session,

        user: User,

        search: Optional[str] = None,

        tenant_id: Optional[int] = None,

        skip: int = 0,

        limit: int = 50

    ) -> TenantCatalogListResponse:

        target_tenant_id = resolve_tenant_id(db, user, tenant_id)



        query = select(CatalogoTenant).where(CatalogoTenant.idtenant == target_tenant_id)



        if search and search.strip():

            term = f"%{search.strip().lower()}%"

            query = query.join(CatalogoTenant.variante).where(

                or_(

                    func.lower(CatalogoTenant.skuinterno).like(term),

                    func.lower(VarianteProducto.sku).like(term),

                    func.lower(VarianteProducto.color).like(term),

                    func.lower(VarianteProducto.capacidad).like(term)

                )

            )



        # Contar total

        count_stmt = select(func.count()).select_from(query.subquery())

        total = db.execute(count_stmt).scalar_one()



        query = query.order_by(CatalogoTenant.idcatalogotenant.asc()).offset(skip).limit(limit)

        items = db.execute(query).scalars().all()



        return TenantCatalogListResponse(

            total=total,

            items=[TenantCatalogResponse.model_validate(item) for item in items]

        )



    @staticmethod

    def add_to_catalog(db: Session, user: User, data: TenantCatalogCreate) -> TenantCatalogResponse:

        target_tenant_id = resolve_tenant_id(db, user, None)



        # Verificar que la variante exista

        stmt_v = select(VarianteProducto).where(VarianteProducto.idvariante == data.idvariante)

        var = db.execute(stmt_v).scalar_one_or_none()

        if not var:

            raise HTTPException(status_code=404, detail=f"Variante {data.idvariante} no encontrada.")



        # Verificar si ya existe en el cat├ílogo de la empresa

        stmt_e = select(CatalogoTenant).where(

            CatalogoTenant.idtenant == target_tenant_id,

            CatalogoTenant.idvariante == data.idvariante

        )

        if db.execute(stmt_e).scalar_one_or_none():

            raise HTTPException(status_code=400, detail="La variante ya se encuentra en el cat├ílogo de esta empresa.")



        cat_item = CatalogoTenant(

            idtenant=target_tenant_id,

            idvariante=data.idvariante,

            skuinterno=data.skuinterno or var.sku,

            precioventa=data.precioventa,

            costopromedio=data.costopromedio or 0.00,

            activo=data.activo if data.activo is not None else True

        )

        db.add(cat_item)

        db.commit()

        db.refresh(cat_item)

        return TenantCatalogResponse.model_validate(cat_item)



    @staticmethod

    def update_catalog_item(db: Session, user: User, idcatalogotenant: int, data: TenantCatalogUpdate) -> TenantCatalogResponse:

        stmt = select(CatalogoTenant).where(

            CatalogoTenant.idcatalogotenant == idcatalogotenant,

            CatalogoTenant.idtenant == resolve_tenant_id(db, user, None)

        )

        item = db.execute(stmt).scalar_one_or_none()

        if not item:

            raise HTTPException(status_code=404, detail=f"Item de cat├ílogo {idcatalogotenant} no encontrado.")



        if data.skuinterno is not None:

            item.skuinterno = data.skuinterno

        if data.precioventa is not None:

            item.precioventa = data.precioventa

        if data.costopromedio is not None:

            item.costopromedio = data.costopromedio

        if data.activo is not None:

            item.activo = data.activo



        db.commit()

        db.refresh(item)

        return TenantCatalogResponse.model_validate(item)



    @staticmethod

    def delete_catalog_item(db: Session, user: User, idcatalogotenant: int):

        stmt = select(CatalogoTenant).where(

            CatalogoTenant.idcatalogotenant == idcatalogotenant,

            CatalogoTenant.idtenant == resolve_tenant_id(db, user, None)

        )

        item = db.execute(stmt).scalar_one_or_none()

        if not item:

            raise HTTPException(status_code=404, detail=f"Item de cat├ílogo {idcatalogotenant} no encontrado.")



        db.delete(item)

        db.commit()

        return {"detail": f"Item {idcatalogotenant} removido del cat├ílogo."}






    @staticmethod
    def generate_recommendations(db, user, data) -> PricingRecommendationsResponse:
        target_tenant_id = resolve_tenant_id(db, user, getattr(data, "tenant_id", None))
        result = build_pricing_recommendations(db, tenant_id=target_tenant_id, top_n=data.top_n or 8)
        return PricingRecommendationsResponse.model_validate(result)


# Endpoints (Rutas HTTP)

@router.get("/tenant-catalog", response_model=TenantCatalogListResponse)

def get_tenant_catalog(

    search: Optional[str] = Query(None),

    tenant_id: Optional[int] = Query(None),

    skip: int = Query(0, ge=0),

    limit: int = Query(50, ge=1, le=100),

    db: Session = Depends(get_db),

    current_user: User = Depends(get_current_user)

):

    """Listar el cat├ílogo de productos de la empresa tenant (CU-008)."""

    return TenantCatalogController.list_catalog(db, current_user, search, tenant_id, skip, limit)





@router.post("/tenant-catalog", response_model=TenantCatalogResponse, status_code=status.HTTP_201_CREATED)

def add_to_tenant_catalog(

    data: TenantCatalogCreate,

    db: Session = Depends(get_db),

    current_user: User = Depends(requires_gestion_catalogo_empresa)

):

    """Agregar una variante de producto al cat├ílogo de la empresa (CU-008)."""

    return TenantCatalogController.add_to_catalog(db, current_user, data)





@router.put("/tenant-catalog/{idcatalogotenant}", response_model=TenantCatalogResponse)

def update_tenant_catalog_item(

    idcatalogotenant: int,

    data: TenantCatalogUpdate,

    db: Session = Depends(get_db),

    current_user: User = Depends(requires_gestion_catalogo_empresa)

):

    """Actualizar precio de venta, costo o SKU interno en el cat├ílogo (CU-008)."""

    return TenantCatalogController.update_catalog_item(db, current_user, idcatalogotenant, data)





@router.delete("/tenant-catalog/{idcatalogotenant}")

def delete_tenant_catalog_item(

    idcatalogotenant: int,

    db: Session = Depends(get_db),

    current_user: User = Depends(requires_gestion_catalogo_empresa)

):

    """Remover un ├¡tem del cat├ílogo de la empresa (CU-008)."""

    return TenantCatalogController.delete_catalog_item(db, current_user, idcatalogotenant)








