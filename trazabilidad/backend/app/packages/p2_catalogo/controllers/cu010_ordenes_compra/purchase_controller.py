import os
from typing import Optional, List
from decimal import Decimal
from fastapi import APIRouter, Depends, HTTPException, Query, status, Request, BackgroundTasks

from app.core.config import settings
from app.core.mail_service import MailService
from sqlalchemy.orm import Session
from sqlalchemy import select, func, cast, String

from app.db.session import get_db
from app.models.cu010_ordenes_compra.purchase import Compra, CompraDetalle
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import require_roles
from app.views.cu010_ordenes_compra.purchase_views import (
    CompraResponse,
    CompraListResponse,
    CompraDetalleResponse,
    CompraCreate,
    CompraUpdate,
    CompraDetalleCreate
)

router = APIRouter(prefix="/purchases", tags=["Gestión de Órdenes de Compra (CU-010)"])



# Destinatario exclusivo para notificaciones en entorno localhost (CU-010)

LOCAL_NOTIFICATION_EMAIL_CU010 = "rafaelmontanoroca@gmail.com"





def is_localhost_request(request: Optional[Request] = None) -> bool:

    """Verifica si la solicitud o el entorno de ejecución actual es localhost."""

    if os.environ.get("RAILWAY_ENVIRONMENT") or os.environ.get("RAILWAY_STATIC_URL"):

        return False



    if request is not None:

        host = (request.headers.get("host") or request.url.hostname or "").lower()

        origin = (request.headers.get("origin") or "").lower()

        referer = (request.headers.get("referer") or "").lower()



        # Excluir dominios de producción remota

        if any(prod in host or prod in origin or prod in referer for prod in ("railway.app", "vercel.app")):

            return False



        if any(h in host for h in ("localhost", "127.0.0.1")) or            any(h in origin for h in ("localhost", "127.0.0.1")) or            any(h in referer for h in ("localhost", "127.0.0.1")):

            return True



    frontend_url = (settings.FRONTEND_URL or "").lower()

    if any(prod in frontend_url for prod in ("railway.app", "vercel.app")):

        return False



    return "localhost" in frontend_url or "127.0.0.1" in frontend_url


# Roles autorizados a crear y editar ordenes de compra.
ROLES_GESTION_COMPRA = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones")

requires_compra_management = require_roles(*ROLES_GESTION_COMPRA)


def format_compra_response(compra: Compra, db: Session) -> CompraResponse:
    """Convierte un modelo Compra en un CompraResponse enriquecido con detalles y proveedor."""
    proveedor_nombre = None
    if compra.idproveedor:
        stmt_prov = select(ActorCadena.razonsocial).where(ActorCadena.idactor == compra.idproveedor)
        proveedor_nombre = db.execute(stmt_prov).scalar_one_or_none()

    # Cargar detalles con nombres de producto y variante
    stmt_det = (
        select(
            CompraDetalle,
            VarianteProducto.sku,
            VarianteProducto.color,
            VarianteProducto.capacidad.label("almacenamiento"),
            Producto.nombre.label("producto_nombre")
        )
        .outerjoin(VarianteProducto, CompraDetalle.idvariante == VarianteProducto.idvariante)
        .outerjoin(Producto, VarianteProducto.idproducto == Producto.idproducto)
        .where(CompraDetalle.idcompra == compra.idcompra)
    )
    detalles_rows = db.execute(stmt_det).all()

    detalles_resp = []
    for det, sku, color, almacenamiento, producto_nombre in detalles_rows:
        detalles_resp.append(
            CompraDetalleResponse(
                idcompradetalle=det.idcompradetalle,
                idcompra=det.idcompra,
                idvariante=det.idvariante,
                sku=sku or f"VAR-{det.idvariante}",
                producto_nombre=producto_nombre or "Producto",
                color=color,
                almacenamiento=almacenamiento,
                cantidad=det.cantidad,
                costounitariousd=det.costounitariousd,
                subtotalusd=det.subtotalusd
            )
        )

    return CompraResponse(
        idcompra=compra.idcompra,
        idtenant=compra.idtenant,
        idproveedor=compra.idproveedor,
        proveedor_nombre=proveedor_nombre or f"Proveedor #{compra.idproveedor}",
        numeroorden=compra.numeroorden,
        fechacompra=compra.fechacompra,
        totalusd=compra.totalusd,
        estado=str(compra.estado),
        total_items=sum(d.cantidad for d in detalles_resp),
        detalles=detalles_resp
    )


class PurchaseController:

    @staticmethod
    def list_purchases(
        db: Session,
        current_user: User,
        estado: Optional[str] = None,
        skip: int = 0,
        limit: int = 50
    ) -> CompraListResponse:
        tenant_id = current_user.tenant.idtenant if current_user.tenant else 1

        query = select(Compra).where(Compra.idtenant == tenant_id)
        if estado and estado.strip():
            # estado es un enum de Postgres: hay que castear a texto para usar lower()
            query = query.where(
                func.lower(cast(Compra.estado, String)) == estado.strip().lower()
            )

        # Total
        count_stmt = select(func.count()).select_from(query.subquery())
        total = db.execute(count_stmt).scalar_one()

        query = query.order_by(Compra.idcompra.desc()).offset(skip).limit(limit)
        compras = db.execute(query).scalars().all()

        items = [format_compra_response(c, db) for c in compras]
        return CompraListResponse(total=total, items=items)

    @staticmethod
    def get_purchase(
        db: Session,
        current_user: User,
        idcompra: int
    ) -> CompraResponse:
        tenant_id = current_user.tenant.idtenant if current_user.tenant else 1
        stmt = select(Compra).where(Compra.idcompra == idcompra, Compra.idtenant == tenant_id)
        compra = db.execute(stmt).scalar_one_or_none()

        if not compra:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Orden de compra con ID {idcompra} no encontrada o no pertenece a la empresa."
            )

        return format_compra_response(compra, db)

    @staticmethod
    def _get_compra_or_404(db: Session, current_user: User, idcompra: int) -> Compra:
        tenant_id = current_user.tenant.idtenant if current_user.tenant else 1
        compra = db.execute(
            select(Compra).where(Compra.idcompra == idcompra, Compra.idtenant == tenant_id)
        ).scalar_one_or_none()
        if not compra:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Orden de compra con ID {idcompra} no encontrada o no pertenece a la empresa."
            )
        return compra

    @staticmethod
    def _validar_proveedor(db: Session, tenant_id: int, idproveedor: int) -> None:
        existe = db.execute(
            select(ActorCadena.idactor).where(
                ActorCadena.idactor == idproveedor,
                ActorCadena.idtenant == tenant_id
            )
        ).scalar_one_or_none()
        if not existe:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"El actor con ID {idproveedor} no existe o no pertenece a la empresa."
            )

    @staticmethod
    def _validar_numeroorden(db: Session, numeroorden: str, excluir_id: Optional[int] = None) -> str:
        # compra_numeroorden_key es UNIQUE global, no por empresa
        limpio = numeroorden.strip()
        stmt = select(Compra.idcompra).where(Compra.numeroorden == limpio)
        if excluir_id is not None:
            stmt = stmt.where(Compra.idcompra != excluir_id)
        if db.execute(stmt).scalar_one_or_none() is not None:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail=f"El numero de orden '{limpio}' ya existe en el sistema."
            )
        return limpio

    @staticmethod
    def _resolver_detalles(db: Session, tenant_id: int, detalles: List[CompraDetalleCreate]):
        ids = [d.idvariante for d in detalles]
        if len(ids) != len(set(ids)):
            repetidos = sorted({i for i in ids if ids.count(i) > 1})
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"La orden no puede repetir variantes. Repetidas: {repetidos}."
            )

        stmt = select(CatalogoTenant.idvariante).where(
            CatalogoTenant.idtenant == tenant_id,
            CatalogoTenant.idvariante.in_(ids),
            CatalogoTenant.activo != False
        )
        validas = set(db.execute(stmt).scalars().all())
        invalidas = [i for i in ids if i not in validas]
        if invalidas:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Las variantes {invalidas} no pertenecen al catalogo activo de la empresa."
            )

        filas = []
        total = Decimal("0.00")
        for d in detalles:
            unitario = Decimal(d.costounitariousd)
            subtotal = (Decimal(d.cantidad) * unitario).quantize(Decimal("0.01"))
            filas.append({
                "idvariante": d.idvariante,
                "cantidad": d.cantidad,
                "costounitariousd": unitario,
                "subtotalusd": subtotal,
            })
            total += subtotal
        return filas, total

    @staticmethod
    def create_purchase(db: Session, current_user: User, body: CompraCreate) -> CompraResponse:
        tenant_id = current_user.tenant.idtenant if current_user.tenant else 1
        PurchaseController._validar_proveedor(db, tenant_id, body.idproveedor)
        numeroorden = PurchaseController._validar_numeroorden(db, body.numeroorden)
        filas, total = PurchaseController._resolver_detalles(db, tenant_id, body.detalles)

        compra = Compra(
            idtenant=tenant_id,
            idproveedor=body.idproveedor,
            numeroorden=numeroorden,
            fechacompra=body.fechacompra,
            totalusd=total,
            estado="pendiente"
        )
        compra.detalles = [CompraDetalle(**f) for f in filas]

        db.add(compra)
        db.commit()
        db.refresh(compra)

        return format_compra_response(compra, db)

    @staticmethod
    def update_purchase(
        db: Session,
        current_user: User,
        idcompra: int,
        body: CompraUpdate
    ) -> CompraResponse:
        compra = PurchaseController._get_compra_or_404(db, current_user, idcompra)

        if str(compra.estado).lower() != "pendiente":
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Solo se pueden editar ordenes en estado 'pendiente'. El estado actual es '{compra.estado}'."
            )

        tenant_id = compra.idtenant

        if body.idproveedor is not None:
            PurchaseController._validar_proveedor(db, tenant_id, body.idproveedor)
            compra.idproveedor = body.idproveedor

        if body.numeroorden is not None:
            compra.numeroorden = PurchaseController._validar_numeroorden(
                db, body.numeroorden, excluir_id=compra.idcompra
            )

        if body.fechacompra is not None:
            compra.fechacompra = body.fechacompra

        if body.detalles is not None:
            filas, total = PurchaseController._resolver_detalles(db, tenant_id, body.detalles)
            compra.detalles = [CompraDetalle(**f) for f in filas]
            compra.totalusd = total

        db.commit()
        db.refresh(compra)

        return format_compra_response(compra, db)


# Rutas FastAPI
@router.get("", response_model=CompraListResponse)
def list_purchases_route(
    estado: Optional[str] = Query(None, description="Filtrar por estado (pendiente, enviada, recibida_total, cancelada)"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar órdenes de compra de la empresa autenticada (CU-010)."""
    return PurchaseController.list_purchases(db, current_user, estado, skip, limit)


@router.get("/{idcompra}", response_model=CompraResponse)
def get_purchase_route(
    idcompra: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Obtener detalle completo de una orden de compra (CU-010)."""
    return PurchaseController.get_purchase(db, current_user, idcompra)


@router.post("", response_model=CompraResponse, status_code=status.HTTP_201_CREATED)
def create_purchase_route(
    body: CompraCreate,
    request: Request,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_compra_management)
):
    """Registrar una nueva orden de compra con sus lineas de detalle (CU-010)."""
    compra_resp = PurchaseController.create_purchase(db, current_user, body)

    # Notificación por correo exclusiva para entorno localhost (CU-010)
    if is_localhost_request(request):
        tenant_name = current_user.tenant.nombre if current_user.tenant else "Empresa Demo"
        background_tasks.add_task(
            MailService.send_purchase_order_email,
            to_email=LOCAL_NOTIFICATION_EMAIL_CU010,
            compra=compra_resp,
            tenant_name=tenant_name,
            environment_label="localhost"
        )

    return compra_resp


@router.put("/{idcompra}", response_model=CompraResponse)
def update_purchase_route(
    idcompra: int,
    body: CompraUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_compra_management)
):
    """Editar una orden de compra que sigue en estado pendiente (CU-010)."""
    return PurchaseController.update_purchase(db, current_user, idcompra, body)
