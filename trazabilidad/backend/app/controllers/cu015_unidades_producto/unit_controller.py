import uuid
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, or_

from app.db.session import get_db
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_user_tenant_id, require_roles
from app.views.cu015_unidades_producto.unit_views import (
    UnitCreate,
    UnitUpdate,
    UnitResponse,
    UnitListResponse
)

router = APIRouter(tags=["Gestionar Unidades de Producto Serial/IMEI (CU-015)"])

# Roles autorizados a registrar y dar de baja unidades (units:create).
ROLES_GESTION_UNIDAD = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones")

# Además de los anteriores, GestorVentasPostventa puede actualizar estado/custodia
# (units:update: devoluciones, garantías y venta de unidades).
ROLES_EDICION_UNIDAD = ROLES_GESTION_UNIDAD + ("GestorVentasPostventa",)

requires_gestion_unidad = require_roles(*ROLES_GESTION_UNIDAD)
requires_edicion_unidad = require_roles(*ROLES_EDICION_UNIDAD)


class UnitController:

    @staticmethod
    def list_units(
        db: Session,
        user: User,
        search: Optional[str] = None,
        estado: Optional[str] = None,
        idvariante: Optional[int] = None,
        skip: int = 0,
        limit: int = 50
    ) -> UnitListResponse:
        tenant_id = get_user_tenant_id(db, user)
        query = select(UnidadProducto).where(UnidadProducto.idtenant == tenant_id)

        if estado and estado.strip():
            query = query.where(UnidadProducto.estado == estado.strip())

        if idvariante:
            query = query.where(UnidadProducto.idvariante == idvariante)

        if search and search.strip():
            term = f"%{search.strip().lower()}%"
            query = query.where(
                or_(
                    func.lower(UnidadProducto.numeroserie).like(term),
                    func.lower(UnidadProducto.imei1).like(term),
                    func.lower(UnidadProducto.imei2).like(term),
                    func.lower(UnidadProducto.eid).like(term),
                    func.lower(UnidadProducto.uuidpublico).like(term)
                )
            )

        count_stmt = select(func.count()).select_from(query.subquery())
        total = db.execute(count_stmt).scalar_one()

        query = query.order_by(UnidadProducto.idunidad.asc()).offset(skip).limit(limit)
        items = db.execute(query).scalars().all()

        return UnitListResponse(
            total=total,
            items=[UnitResponse.model_validate(item) for item in items]
        )

    @staticmethod
    def create_unit(db: Session, user: User, data: UnitCreate) -> UnitResponse:
        tenant_id = get_user_tenant_id(db, user)

        # Validar que la variante exista
        stmt_v = select(VarianteProducto).where(VarianteProducto.idvariante == data.idvariante)
        if not db.execute(stmt_v).scalar_one_or_none():
            raise HTTPException(status_code=404, detail=f"Variante {data.idvariante} no encontrada.")

        # Validar número de serie duplicado
        stmt_s = select(UnidadProducto).where(
            UnidadProducto.idtenant == tenant_id,
            UnidadProducto.numeroserie == data.numeroserie
        )
        if db.execute(stmt_s).scalar_one_or_none():
            raise HTTPException(status_code=400, detail=f"El número de serie '{data.numeroserie}' ya está registrado.")

        unit = UnidadProducto(
            idtenant=tenant_id,
            idvariante=data.idvariante,
            idrecepciondetalle=data.idrecepciondetalle or 1,
            numeroserie=data.numeroserie,
            imei1=data.imei1,
            imei2=data.imei2,
            eid=data.eid,
            uuidpublico=str(uuid.uuid4()),
            idcustodioactual=data.idcustodioactual,
            idubicacionactual=data.idubicacionactual,
            estado=data.estado or "disponible"
        )
        db.add(unit)
        db.commit()
        db.refresh(unit)
        return UnitResponse.model_validate(unit)

    @staticmethod
    def update_unit(db: Session, user: User, idunidad: int, data: UnitUpdate) -> UnitResponse:
        tenant_id = get_user_tenant_id(db, user)
        stmt = select(UnidadProducto).where(
            UnidadProducto.idunidad == idunidad,
            UnidadProducto.idtenant == tenant_id
        )
        unit = db.execute(stmt).scalar_one_or_none()
        if not unit:
            raise HTTPException(status_code=404, detail=f"Unidad {idunidad} no encontrada.")

        if data.numeroserie is not None:
            unit.numeroserie = data.numeroserie
        if data.imei1 is not None:
            unit.imei1 = data.imei1
        if data.imei2 is not None:
            unit.imei2 = data.imei2
        if data.eid is not None:
            unit.eid = data.eid
        if data.idcustodioactual is not None:
            unit.idcustodioactual = data.idcustodioactual
        if data.idubicacionactual is not None:
            unit.idubicacionactual = data.idubicacionactual
        if data.estado is not None:
            unit.estado = data.estado

        db.commit()
        db.refresh(unit)
        return UnitResponse.model_validate(unit)

    @staticmethod
    def delete_unit(db: Session, user: User, idunidad: int):
        tenant_id = get_user_tenant_id(db, user)
        stmt = select(UnidadProducto).where(
            UnidadProducto.idunidad == idunidad,
            UnidadProducto.idtenant == tenant_id
        )
        unit = db.execute(stmt).scalar_one_or_none()
        if not unit:
            raise HTTPException(status_code=404, detail=f"Unidad {idunidad} no encontrada.")

        db.delete(unit)
        db.commit()
        return {"detail": f"Unidad {idunidad} eliminada."}


# Endpoints (Rutas HTTP)
@router.get("/units", response_model=UnitListResponse)
def get_units(
    search: Optional[str] = Query(None),
    estado: Optional[str] = Query(None),
    idvariante: Optional[int] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar unidades físicas registradas (Serial/IMEI) (CU-015)."""
    return UnitController.list_units(db, current_user, search, estado, idvariante, skip, limit)


@router.post("/units", response_model=UnitResponse, status_code=status.HTTP_201_CREATED)
def create_unit(
    data: UnitCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_unidad)
):
    """Registrar una nueva unidad de producto con Serial/IMEI (CU-015)."""
    return UnitController.create_unit(db, current_user, data)


@router.put("/units/{idunidad}", response_model=UnitResponse)
def update_unit(
    idunidad: int,
    data: UnitUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_edicion_unidad)
):
    """Actualizar datos o custodia de una unidad (CU-015)."""
    return UnitController.update_unit(db, current_user, idunidad, data)


@router.delete("/units/{idunidad}")
def delete_unit(
    idunidad: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_unidad)
):
    """Eliminar una unidad física (CU-015)."""
    return UnitController.delete_unit(db, current_user, idunidad)
