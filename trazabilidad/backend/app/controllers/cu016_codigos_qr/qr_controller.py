import io
import secrets
from typing import Optional, List
from datetime import datetime, timezone, timedelta
import qrcode
import qrcode.constants
from fastapi import APIRouter, Depends, HTTPException, Query, Request, Response, status
from sqlalchemy.orm import Session
from sqlalchemy import select, func, or_

from app.db.session import get_db
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu002_usuarios.user import User
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.controllers.shared import get_user_tenant_id, require_roles
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.views.cu016_codigos_qr.qr_views import (
    UnitQrInfoResponse,
    GenerateQRResponse,
    BulkQRRequest,
    BulkQRResponse
)

router = APIRouter(prefix="/qr", tags=["Generación y Descarga de Código QR (CU-016)"])

# Roles autorizados a generar tokens QR (qr:generate en la matriz rol-permisos).
ROLES_GENERACION_QR = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones")

requires_generacion_qr = require_roles(*ROLES_GENERACION_QR)


def _get_bolivia_now() -> datetime:
    return datetime.now(timezone(timedelta(hours=-4))).replace(tzinfo=None)


def _get_client_ip(request: Request) -> str:
    return (
        request.headers.get("x-forwarded-for", "").split(",")[0].strip()
        or (request.client.host if request.client else "127.0.0.1")
    )


def _get_tenant_id(db: Session, user: User) -> int:
    try:
        return get_user_tenant_id(db, user)
    except Exception:
        tenant = getattr(user, "tenant", None)
        return getattr(tenant, "idtenant", 1) if tenant else 1


def _build_trace_url(uuidpublico: str) -> str:
    return f"https://blockchain-production-8de2.up.railway.app/trace/{uuidpublico}"


class QRController:

    @staticmethod
    def list_units(
        db: Session,
        current_user: User,
        tiene_qr: Optional[bool] = None,
        search: Optional[str] = None,
        skip: int = 0,
        limit: int = 50
    ) -> List[UnitQrInfoResponse]:
        tenant_id = _get_tenant_id(db, current_user)

        query = (
            select(
                UnidadProducto,
                VarianteProducto.sku.label("variante_sku"),
                VarianteProducto.color,
                VarianteProducto.capacidad.label("almacenamiento"),
                Producto.nombre.label("producto_nombre"),
                CodigoQR.idcodigoqr,
                CodigoQR.tokenpublico,
                CodigoQR.url,
                CodigoQR.fechageneracion,
                CodigoQR.activo.label("qr_activo")
            )
            .join(VarianteProducto, UnidadProducto.idvariante == VarianteProducto.idvariante)
            .join(Producto, VarianteProducto.idproducto == Producto.idproducto)
            .outerjoin(CodigoQR, UnidadProducto.idunidad == CodigoQR.idunidad)
            .where(UnidadProducto.idtenant == tenant_id)
        )

        if tiene_qr is True:
            query = query.where(CodigoQR.idcodigoqr.is_not(None), CodigoQR.activo == True)
        elif tiene_qr is False:
            query = query.where(or_(CodigoQR.idcodigoqr.is_(None), CodigoQR.activo == False))

        if search and search.strip():
            clean_search = f"%{search.strip().lower()}%"
            query = query.where(
                or_(
                    func.lower(UnidadProducto.numeroserie).like(clean_search),
                    func.lower(UnidadProducto.imei1).like(clean_search),
                    func.lower(UnidadProducto.uuidpublico).like(clean_search),
                    func.lower(Producto.nombre).like(clean_search)
                )
            )

        query = query.order_by(UnidadProducto.idunidad.desc()).offset(skip).limit(limit)
        rows = db.execute(query).all()

        results = []
        for (
            u, sku, color, almacenamiento, prod_nombre,
            idqr, token, qr_url, fecha_gen, qr_activo
        ) in rows:
            has_valid_qr = bool(idqr and qr_activo)
            results.append(
                UnitQrInfoResponse(
                    idunidad=u.idunidad,
                    numeroserie=u.numeroserie,
                    imei1=u.imei1,
                    imei2=u.imei2,
                    uuidpublico=u.uuidpublico,
                    estado=str(u.estado),
                    producto_nombre=prod_nombre or "Dispositivo",
                    variante_sku=sku or f"VAR-{u.idvariante}",
                    color=color,
                    almacenamiento=almacenamiento,
                    tiene_qr=has_valid_qr,
                    idcodigoqr=idqr if has_valid_qr else None,
                    tokenpublico=token if has_valid_qr else None,
                    url=qr_url if has_valid_qr else None,
                    fechageneracion=fecha_gen if has_valid_qr else None
                )
            )

        return results

    @staticmethod
    def generate_qr(
        db: Session,
        current_user: User,
        request: Request,
        idunidad: int
    ) -> GenerateQRResponse:
        tenant_id = _get_tenant_id(db, current_user)
        stmt = select(UnidadProducto).where(
            UnidadProducto.idunidad == idunidad,
            UnidadProducto.idtenant == tenant_id
        )
        unit = db.execute(stmt).scalar_one_or_none()

        if not unit:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Unidad de producto con ID {idunidad} no encontrada o no pertenece a la empresa."
            )

        hora_bolivia = _get_bolivia_now()
        client_ip = _get_client_ip(request)

        # Buscar si ya existe un registro en codigoqr
        stmt_qr = select(CodigoQR).where(CodigoQR.idunidad == unit.idunidad)
        qr_obj = db.execute(stmt_qr).scalar_one_or_none()

        token_publico = secrets.token_urlsafe(32)
        url_trazabilidad = _build_trace_url(unit.uuidpublico)

        if qr_obj:
            qr_obj.tokenpublico = token_publico
            qr_obj.url = url_trazabilidad
            qr_obj.fechageneracion = hora_bolivia
            qr_obj.activo = True
        else:
            qr_obj = CodigoQR(
                idunidad=unit.idunidad,
                tokenpublico=token_publico,
                url=url_trazabilidad,
                fechageneracion=hora_bolivia,
                activo=True
            )
            db.add(qr_obj)

        db.flush()

        # Registrar auditoría en bitácora
        stmt_ut = select(UsuarioTenant.idusuariotenant).where(
            UsuarioTenant.idusuario == current_user.idusuario,
            UsuarioTenant.idtenant == tenant_id
        )
        idut = db.execute(stmt_ut).scalar()
        if idut:
            db.add(Bitacora(
                idusuariotenant=idut,
                accion="GENERAR_QR",
                entidad="CodigoQR",
                identidad=qr_obj.idcodigoqr,
                ip=client_ip,
                fechahora=hora_bolivia
            ))

        db.commit()
        db.refresh(qr_obj)

        return GenerateQRResponse(
            idcodigoqr=qr_obj.idcodigoqr,
            idunidad=unit.idunidad,
            numeroserie=unit.numeroserie,
            uuidpublico=unit.uuidpublico,
            tokenpublico=qr_obj.tokenpublico,
            url=qr_obj.url or url_trazabilidad,
            fechageneracion=qr_obj.fechageneracion or hora_bolivia,
            qr_image_url=f"/api/v1/qr/{unit.idunidad}/image",
            message="Código QR generado exitosamente."
        )

    @staticmethod
    def render_qr_image(
        db: Session,
        idunidad: int,
        download: bool = False,
        current_user: Optional[User] = None
    ) -> Response:
        if current_user:
            tenant_id = _get_tenant_id(db, current_user)
            stmt = select(UnidadProducto).where(
                UnidadProducto.idunidad == idunidad,
                UnidadProducto.idtenant == tenant_id
            )
        else:
            stmt = select(UnidadProducto).where(UnidadProducto.idunidad == idunidad)
        unit = db.execute(stmt).scalar_one_or_none()

        if not unit:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Unidad de producto con ID {idunidad} no encontrada."
            )

        stmt_qr = select(CodigoQR).where(CodigoQR.idunidad == unit.idunidad, CodigoQR.activo == True)
        qr_obj = db.execute(stmt_qr).scalar_one_or_none()

        # Si no existe, generarlo automáticamente para responder con la imagen
        if not qr_obj:
            url_trazabilidad = _build_trace_url(unit.uuidpublico)
            token_publico = secrets.token_urlsafe(32)
            qr_obj = CodigoQR(
                idunidad=unit.idunidad,
                tokenpublico=token_publico,
                url=url_trazabilidad,
                fechageneracion=_get_bolivia_now(),
                activo=True
            )
            db.add(qr_obj)
            db.commit()
            db.refresh(qr_obj)

        # Generar imagen QR con Pillow
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_M,
            box_size=10,
            border=4,
        )
        qr.add_data(qr_obj.url or _build_trace_url(unit.uuidpublico))
        qr.make(fit=True)

        img = qr.make_image(fill_color="black", back_color="white")
        buffer = io.BytesIO()
        img.save(buffer, "PNG")
        img_bytes = buffer.getvalue()

        headers = {
            "Content-Type": "image/png",
            "Cache-Control": "public, max-age=3600"
        }
        if download:
            headers["Content-Disposition"] = f'attachment; filename="qr_{unit.numeroserie}.png"'
        else:
            headers["Content-Disposition"] = f'inline; filename="qr_{unit.numeroserie}.png"'

        return Response(content=img_bytes, media_type="image/png", headers=headers)

    @staticmethod
    def generate_bulk(
        db: Session,
        current_user: User,
        request: Request,
        body: BulkQRRequest
    ) -> BulkQRResponse:
        results = []
        for uid in body.idunidades:
            try:
                res = QRController.generate_qr(db, current_user, request, uid)
                results.append(res)
            except Exception:
                continue

        return BulkQRResponse(total_generados=len(results), items=results)


# Rutas FastAPI
@router.get("/units", response_model=List[UnitQrInfoResponse])
def list_units_route(
    tiene_qr: Optional[bool] = Query(None, description="Filtrar por si tiene QR (true/false)"),
    search: Optional[str] = Query(None, description="Buscar por número de serie, IMEI, modelo"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar unidades físicas para generación o consulta de Código QR (CU-016)."""
    return QRController.list_units(db, current_user, tiene_qr, search, skip, limit)


@router.post("/generate/{idunidad}", response_model=GenerateQRResponse)
def generate_qr_route(
    idunidad: int,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_generacion_qr)
):
    """Generar token criptográfico y código QR para una unidad física (CU-016)."""
    return QRController.generate_qr(db, current_user, request, idunidad)


@router.get("/{idunidad}/image")
def get_qr_image_route(
    idunidad: int,
    download: bool = Query(False, description="Si es true, fuerza la descarga del archivo PNG"),
    db: Session = Depends(get_db)
):
    """Obtener imagen PNG del código QR de la unidad para visualización o descarga (CU-016)."""
    return QRController.render_qr_image(db, idunidad, download)


@router.post("/generate-bulk", response_model=BulkQRResponse)
def generate_bulk_route(
    body: BulkQRRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_generacion_qr)
):
    """Generar códigos QR en lote para múltiples unidades seleccionadas (CU-016)."""
    return QRController.generate_bulk(db, current_user, request, body)
