import os
import hashlib
import uuid
from decimal import Decimal
from typing import Optional, List
from datetime import datetime

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Query,
    Request,
    UploadFile,
    File,
    Form,
    status,
)
from sqlalchemy.orm import Session
from sqlalchemy import select, func, desc

from app.db.session import get_db
from app.models.cu021_eventos_transporte.transport_event import Alerta
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu005_bitacora.notification import Notificacion
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu003_roles_permisos.role import Role
from app.models.cu003_roles_permisos.usuario_tenant_rol import UsuarioTenantRol
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user

def get_current_user_optional(request: Request, db: Session = Depends(get_db)) -> Optional[User]:
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return None
    token = auth_header.split(" ")[1]
    try:
        from app.packages.p1_seguridad.controllers.cu004_autenticacion.auth_controller import AuthController
        return AuthController.get_current_user_from_token(db, token)
    except Exception:
        return None
from app.controllers.shared import (
    get_bolivia_now,
    get_client_ip,
    get_idusuariotenant,
    require_roles,
    resolve_tenant_id,
)
from app.packages.p4_trazabilidad.models.cu023_reporte_sospecha.suspicion_report import (
    ReporteSospecha,
    ReporteSospechaEvidencia,
)
from app.views.cu023_reporte_sospecha.suspicion_views import (
    ReporteSospechaResponse,
    ReporteSospechaListResponse,
    EvidenciaResponse,
    UpdateReporteEstadoRequest,
    ReportarSospechaRequest,
    ReporteSospechaLegacyResponse,
)
from app.services.ai.suspicion_ml import SuspicionMLService

router = APIRouter(prefix="", tags=["Reportes de Sospecha (CU-023)"])

_ROLES_NOTIFICABLES = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones")
_ROLES_GESTION_REPORTES = ("SuperAdministrador", "AdministradorEmpresa", "GestorOperaciones", "Auditor")
_requires_gestion_reportes = require_roles(*_ROLES_GESTION_REPORTES)

# Formatos de imagen permitidos y límite de tamaño
_ALLOWED_MIME_TYPES = {"image/jpeg", "image/png", "image/webp"}
_MAX_FILE_SIZE = 5 * 1024 * 1024  # 5 MB por imagen
_UPLOAD_DIR = os.path.join("app", "uploads", "evidencias_sospecha")
os.makedirs(_UPLOAD_DIR, exist_ok=True)


class SuspicionController:

    @staticmethod
    def _to_response(db: Session, rep: ReporteSospecha, mensaje: Optional[str] = None) -> ReporteSospechaResponse:
        numeroserie = None
        uuidpublico = None
        if rep.unidad:
            numeroserie = rep.unidad.numeroserie
            uuidpublico = rep.unidad.uuidpublico
        else:
            u = db.execute(
                select(UnidadProducto.numeroserie, UnidadProducto.uuidpublico).where(
                    UnidadProducto.idunidad == rep.idunidad
                )
            ).first()
            if u:
                numeroserie, uuidpublico = u

        evidencias_dto = [
            EvidenciaResponse(
                idevidencia=ev.idevidencia,
                nombrearchivo=ev.nombrearchivo,
                tipomime=ev.tipomime,
                tamanobytes=ev.tamanobytes,
                urlalmacenamiento=ev.urlalmacenamiento,
                hashsha256=ev.hashsha256,
                creadoen=ev.creadoen,
            )
            for ev in rep.evidencias
        ]

        return ReporteSospechaResponse(
            idreporte=rep.idreporte,
            codigoticket=rep.codigoticket,
            idtenant=rep.idtenant,
            idunidad=rep.idunidad,
            numeroserie=numeroserie,
            uuidpublico=uuidpublico,
            idusuario=rep.idusuario,
            tipoanomalia=rep.tipoanomalia,
            descripcion=rep.descripcion,
            latitud=rep.latitud,
            longitud=rep.longitud,
            estado=rep.estado,
            gravedad=rep.gravedad,
            observacionresolucion=rep.observacionresolucion,
            idalerta=rep.idalerta,
            score_ml=rep.score_ml,
            sugerencia_ml=rep.sugerencia_ml,
            creadoen=rep.creadoen,
            actualizadoen=rep.actualizadoen,
            evidencias=evidencias_dto,
            mensaje=mensaje,
        )

    @staticmethod
    def _resolver_unidad_por_identificador(
        db: Session,
        unidad_id: Optional[int] = None,
        identificador: Optional[str] = None,
    ) -> UnidadProducto:
        if unidad_id:
            unidad = db.execute(
                select(UnidadProducto).where(UnidadProducto.idunidad == unidad_id)
            ).scalar_one_or_none()
            if unidad:
                return unidad

        if identificador:
            cleaned = identificador.strip()
            # Buscar por UUID público
            unidad = db.execute(
                select(UnidadProducto).where(UnidadProducto.uuidpublico == cleaned)
            ).scalar_one_or_none()
            if unidad:
                return unidad

            # Buscar por Número de Serie
            unidad = db.execute(
                select(UnidadProducto).where(UnidadProducto.numeroserie == cleaned)
            ).scalar_one_or_none()
            if unidad:
                return unidad

            # Buscar por token / URL de CodigoQR
            qr = db.execute(
                select(CodigoQR).where(
                    (CodigoQR.tokenpublico == cleaned) | (CodigoQR.url.like(f"%{cleaned}%")),
                    CodigoQR.activo == True,
                )
            ).scalars().first()
            if qr:
                unidad = db.execute(
                    select(UnidadProducto).where(UnidadProducto.idunidad == qr.idunidad)
                ).scalar_one_or_none()
                if unidad:
                    return unidad

        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No se encontró la unidad especificada por ID, número de serie o UUID de QR.",
        )

    @staticmethod
    def _generar_ticket() -> str:
        random_suffix = uuid.uuid4().hex[:8].upper()
        year = datetime.utcnow().year
        return f"REP-{year}-{random_suffix}"

    @staticmethod
    def _notificar_incidencia(db: Session, idtenant: int, ticket: str, idalerta: Optional[int]) -> None:
        try:
            stmt = (
                select(UsuarioTenant.idusuariotenant)
                .join(
                    UsuarioTenantRol,
                    UsuarioTenantRol.idusuariotenant == UsuarioTenant.idusuariotenant,
                )
                .join(Role, Role.idrol == UsuarioTenantRol.idrol)
                .where(
                    UsuarioTenant.idtenant == idtenant,
                    Role.nombrerol.in_(_ROLES_NOTIFICABLES),
                )
                .distinct()
            )
            iduts = db.execute(stmt).scalars().all()
            for idut in iduts:
                db.add(
                    Notificacion(
                        idusuariotenant=idut,
                        titulo="Reporte de sospecha de falsificación",
                        contenido=f"Se registró el ticket {ticket} de presunta anomalía/falsificación.",
                        enlaceaccion=f"/alerts/{idalerta}" if idalerta else "/alerts",
                    )
                )
            db.flush()
        except Exception:
            pass


# -----------------------------------------------------------------------------
# 1. POST /api/v1/reportes-sospecha (Multipart, hasta 3 fotos, ML y Alerta)
# -----------------------------------------------------------------------------
@router.post(
    "/reportes-sospecha",
    response_model=ReporteSospechaResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Registrar reporte de sospecha con evidencias fotográficas y geolocalización (CU-023)",
)
async def create_reporte_sospecha(
    request: Request,
    tipo_anomalia: str = Form(..., description="fraude_autenticidad, empaque_vulnerado, discrepancia_serial"),
    descripcion: str = Form(..., min_length=5, description="Detalle de la anomalía o sospecha"),
    unidad_id: Optional[int] = Form(None),
    identificador: Optional[str] = Form(None, description="Número de serie o UUID público del QR"),
    latitud: Optional[float] = Form(None),
    longitud: Optional[float] = Form(None),
    evidencias: List[UploadFile] = File([], description="Hasta 3 fotografías de respaldo"),
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_current_user_optional),
):
    tipos_validos = {"fraude_autenticidad", "empaque_vulnerado", "discrepancia_serial"}
    if tipo_anomalia not in tipos_validos:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Tipo de anomalía inválido '{tipo_anomalia}'. Permitidos: {', '.join(sorted(tipos_validos))}",
        )

    if not (unidad_id or identificador):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Debe proporcionar 'unidad_id' o 'identificador' (serial o UUID).",
        )

    # Validar límite de 3 fotografías
    if len(evidencias) > 3:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Se permite un máximo de 3 fotografías como evidencia.",
        )

    unidad = SuspicionController._resolver_unidad_por_identificador(db, unidad_id, identificador)

    # Procesar archivos de evidencia y calcular hash SHA-256
    evidencias_procesadas = []
    for ev in evidencias:
        if not ev.filename:
            continue
        if ev.content_type not in _ALLOWED_MIME_TYPES:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Tipo de archivo no permitido: {ev.content_type}. Solo se admiten JPG, PNG y WEBP.",
            )

        content = await ev.read()
        if len(content) == 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"El archivo '{ev.filename}' está vacío.",
            )
        if len(content) > _MAX_FILE_SIZE:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"El archivo '{ev.filename}' supera el tamaño máximo permitido (5 MB).",
            )

        sha256_hash = hashlib.sha256(content).hexdigest()
        ext = os.path.splitext(ev.filename)[1].lower() or ".jpg"
        unique_filename = f"{uuid.uuid4().hex}{ext}"
        file_path = os.path.join(_UPLOAD_DIR, unique_filename)

        with open(file_path, "wb") as f:
            f.write(content)

        evidencias_procesadas.append(
            {
                "nombrearchivo": ev.filename,
                "tipomime": ev.content_type or "image/jpeg",
                "tamanobytes": len(content),
                "urlalmacenamiento": f"/uploads/evidencias_sospecha/{unique_filename}",
                "hashsha256": sha256_hash,
            }
        )

    # Generar ticket único
    codigo_ticket = SuspicionController._generar_ticket()

    # Análisis opcional de Machine Learning (apoyo no bloqueante)
    ml_result = SuspicionMLService.analyze_report(
        descripcion=descripcion,
        tipo_declarado=tipo_anomalia,
        tiene_coordenadas=(latitud is not None and longitud is not None),
        num_fotos=len(evidencias_procesadas),
    )

    # Crear Alerta asociada con estado pendiente y gravedad alta
    desc_alerta = (
        f"Ticket {codigo_ticket} - Sospecha de anomalía ({tipo_anomalia}): {descripcion.strip()}.\n"
        f"Unidad: {unidad.numeroserie} (ID: {unidad.idunidad})."
    )
    if ml_result.get("score_riesgo"):
        desc_alerta += f" [ML Risk Score: {ml_result['score_riesgo']} | Sugerencia: {ml_result.get('tipo_sugerido')}]"

    alerta = Alerta(
        idtenant=unidad.idtenant,
        idunidad=unidad.idunidad,
        tipoalerta="fraude_autenticidad",
        descripcion=desc_alerta,
        gravedad="alta",
        fechadeteccion=get_bolivia_now(),
        estado="pendiente",
    )
    db.add(alerta)
    db.flush()

    # Crear ReporteSospecha
    reporte = ReporteSospecha(
        codigoticket=codigo_ticket,
        idtenant=unidad.idtenant,
        idunidad=unidad.idunidad,
        idusuario=current_user.idusuario if current_user else None,
        tipoanomalia=tipo_anomalia,
        descripcion=descripcion.strip(),
        latitud=Decimal(str(round(latitud, 6))) if latitud is not None else None,
        longitud=Decimal(str(round(longitud, 6))) if longitud is not None else None,
        estado="pendiente",
        gravedad="alta",
        idalerta=alerta.idalerta,
        score_ml=Decimal(str(ml_result["score_riesgo"])),
        sugerencia_ml=ml_result.get("tipo_sugerido"),
        creadoen=get_bolivia_now(),
        actualizadoen=get_bolivia_now(),
    )
    db.add(reporte)
    db.flush()

    # Insertar evidencias
    for ev_data in evidencias_procesadas:
        ev_obj = ReporteSospechaEvidencia(
            idreporte=reporte.idreporte,
            nombrearchivo=ev_data["nombrearchivo"],
            tipomime=ev_data["tipomime"],
            tamanobytes=ev_data["tamanobytes"],
            urlalmacenamiento=ev_data["urlalmacenamiento"],
            hashsha256=ev_data["hashsha256"],
            creadoen=get_bolivia_now(),
        )
        db.add(ev_obj)

    # Registrar en bitácora de auditoría
    try:
        idut = get_idusuariotenant(current_user, unidad.idtenant) if current_user else None
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion="crear_reporte_sospecha",
                entidad="reportesospecha",
                identidad=reporte.idreporte,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    # Notificar a los responsables
    SuspicionController._notificar_incidencia(db, unidad.idtenant, codigo_ticket, alerta.idalerta)

    db.commit()
    db.refresh(reporte)

    return SuspicionController._to_response(
        db, reporte, mensaje=f"Reporte registrado exitosamente con ticket {codigo_ticket}."
    )


# -----------------------------------------------------------------------------
# 2. GET /api/v1/reportes-sospecha/ticket/{codigo_ticket} (Consulta Pública)
# -----------------------------------------------------------------------------
@router.get(
    "/reportes-sospecha/ticket/{codigo_ticket}",
    response_model=ReporteSospechaResponse,
    summary="Consultar seguimiento de reporte por código de ticket único",
)
def get_reporte_by_ticket(
    codigo_ticket: str,
    db: Session = Depends(get_db),
):
    rep = db.execute(
        select(ReporteSospecha).where(ReporteSospecha.codigoticket == codigo_ticket.strip().upper())
    ).scalar_one_or_none()

    if not rep:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"No se encontró ningún reporte con el ticket '{codigo_ticket}'.",
        )

    return SuspicionController._to_response(db, rep)


# -----------------------------------------------------------------------------
# 3. GET /api/v1/reportes-sospecha/{id} (Detalle por ID con permisos y tenant)
# -----------------------------------------------------------------------------
@router.get(
    "/reportes-sospecha/{idreporte}",
    response_model=ReporteSospechaResponse,
    summary="Consultar detalle de un reporte por ID",
)
def get_reporte_by_id(
    idreporte: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_reportes),
):
    tenant_id = resolve_tenant_id(db, current_user)
    rep = db.execute(
        select(ReporteSospecha).where(ReporteSospecha.idreporte == idreporte)
    ).scalar_one_or_none()

    if not rep:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Reporte no encontrado.")

    # Aislamiento multi-tenant
    if tenant_id != 0 and rep.idtenant != tenant_id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Reporte no encontrado.")

    return SuspicionController._to_response(db, rep)


# -----------------------------------------------------------------------------
# 4. GET /api/v1/reportes-sospecha (Listado administrativo filtrado)
# -----------------------------------------------------------------------------
@router.get(
    "/reportes-sospecha",
    response_model=ReporteSospechaListResponse,
    summary="Listado administrativo de reportes de sospecha con filtros",
)
def list_reportes_sospecha(
    estado: Optional[str] = Query(None),
    tipo_anomalia: Optional[str] = Query(None),
    gravedad: Optional[str] = Query(None),
    idunidad: Optional[int] = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_reportes),
):
    tenant_id = resolve_tenant_id(db, current_user)
    stmt = select(ReporteSospecha)
    if tenant_id != 0:
        stmt = stmt.where(ReporteSospecha.idtenant == tenant_id)

    if estado:
        stmt = stmt.where(ReporteSospecha.estado == estado.strip().lower())
    if tipo_anomalia:
        stmt = stmt.where(ReporteSospecha.tipoanomalia == tipo_anomalia.strip())
    if gravedad:
        stmt = stmt.where(ReporteSospecha.gravedad == gravedad.strip().lower())
    if idunidad:
        stmt = stmt.where(ReporteSospecha.idunidad == idunidad)

    total = db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
    stmt = stmt.order_by(desc(ReporteSospecha.creadoen)).offset(skip).limit(limit)
    rows = db.execute(stmt).scalars().all()

    items = [SuspicionController._to_response(db, r) for r in rows]
    return ReporteSospechaListResponse(total=total, skip=skip, limit=limit, items=items)


# -----------------------------------------------------------------------------
# 5. PATCH /api/v1/reportes-sospecha/{id}/estado (Resolución / Gestión)
# -----------------------------------------------------------------------------
@router.patch(
    "/reportes-sospecha/{idreporte}/estado",
    response_model=ReporteSospechaResponse,
    summary="Actualizar estado y resolución de un reporte de sospecha",
)
def update_reporte_estado(
    idreporte: int,
    body: UpdateReporteEstadoRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(_requires_gestion_reportes),
):
    tenant_id = resolve_tenant_id(db, current_user)
    estados_validos = {"pendiente", "en_revision", "resuelta", "rechazada"}
    nuevo_estado = body.estado.strip().lower()
    if nuevo_estado not in estados_validos:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Estado inválido '{body.estado}'. Permitidos: {', '.join(sorted(estados_validos))}",
        )

    rep = db.execute(
        select(ReporteSospecha).where(ReporteSospecha.idreporte == idreporte)
    ).scalar_one_or_none()

    if not rep:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Reporte no encontrado.")

    if tenant_id != 0 and rep.idtenant != tenant_id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Reporte no encontrado.")

    rep.estado = nuevo_estado
    rep.actualizadoen = get_bolivia_now()
    if body.observacion:
        rep.observacionresolucion = body.observacion.strip()

    # Si tiene alerta asociada y se marca resuelta/rechazada, sincronizar alerta
    if rep.idalerta and nuevo_estado in ("resuelta", "rechazada"):
        alerta = db.execute(select(Alerta).where(Alerta.idalerta == rep.idalerta)).scalar_one_or_none()
        if alerta:
            alerta.estado = "resuelta" if nuevo_estado == "resuelta" else "en_proceso"
            alerta.fecharesolucion = get_bolivia_now()
            alerta.idusuarioresolutor = current_user.idusuario

    # Registrar en bitácora
    try:
        idut = get_idusuariotenant(current_user, rep.idtenant)
        db.add(
            Bitacora(
                idusuariotenant=idut,
                accion=f"actualizar_estado_reporte_{nuevo_estado}",
                entidad="reportesospecha",
                identidad=rep.idreporte,
                ip=get_client_ip(request),
                fechahora=get_bolivia_now(),
            )
        )
    except Exception:
        pass

    db.commit()
    db.refresh(rep)

    return SuspicionController._to_response(
        db, rep, mensaje=f"Estado actualizado a '{nuevo_estado}' exitosamente."
    )


# -----------------------------------------------------------------------------
# Shim Legacy para mantener compatibilidad con POST /api/v1/reports/suspicion
# -----------------------------------------------------------------------------
@router.post("/reports/suspicion", response_model=ReporteSospechaLegacyResponse, status_code=status.HTTP_201_CREATED)
def report_suspicion_legacy(
    body: ReportarSospechaRequest,
    db: Session = Depends(get_db),
):
    """Shim retrocompatible para llamadas JSON existentes sin archivo."""
    if not (body.uuidpublico or body.numeroserie):
        raise HTTPException(
            status_code=400,
            detail="Debe indicar el UUID público o el número de serie de la unidad.",
        )

    ident = body.uuidpublico or body.numeroserie
    unidad = SuspicionController._resolver_unidad_por_identificador(db, identificador=ident)

    tipo_mapping = {
        "producto_falso": "fraude_autenticidad",
        "empaque_alterado": "empaque_vulnerado",
        "serial_duplicado": "discrepancia_serial",
        "origen_dudoso": "fraude_autenticidad",
        "otro": "fraude_autenticidad",
    }
    tipo_anomalia = tipo_mapping.get(body.motivo, "fraude_autenticidad")
    ticket = SuspicionController._generar_ticket()

    desc_completa = f"Reporte de sospecha ({body.motivo}): {body.descripcion or 'Sin detalle adicional'}."
    if body.evidencia:
        desc_completa += f" Evidencia: {body.evidencia}."
    if body.nombrereportante:
        desc_completa += f" Reportante: {body.nombrereportante} ({body.contactoreportante or 'sin contacto'})."

    ml_result = SuspicionMLService.analyze_report(
        descripcion=desc_completa,
        tipo_declarado=tipo_anomalia,
    )

    alerta = Alerta(
        idtenant=unidad.idtenant,
        idunidad=unidad.idunidad,
        tipoalerta="fraude_autenticidad",
        descripcion=f"Ticket {ticket} - {desc_completa} [ML Risk: {ml_result['score_riesgo']}]",
        gravedad="alta",
        fechadeteccion=get_bolivia_now(),
        estado="pendiente",
    )
    db.add(alerta)
    db.flush()

    reporte = ReporteSospecha(
        codigoticket=ticket,
        idtenant=unidad.idtenant,
        idunidad=unidad.idunidad,
        tipoanomalia=tipo_anomalia,
        descripcion=desc_completa,
        estado="pendiente",
        gravedad="alta",
        idalerta=alerta.idalerta,
        score_ml=Decimal(str(ml_result["score_riesgo"])),
        sugerencia_ml=ml_result.get("tipo_sugerido"),
        creadoen=get_bolivia_now(),
        actualizadoen=get_bolivia_now(),
    )
    db.add(reporte)
    db.flush()

    SuspicionController._notificar_incidencia(db, unidad.idtenant, ticket, alerta.idalerta)
    db.commit()
    db.refresh(alerta)

    return ReporteSospechaLegacyResponse(
        idalerta=alerta.idalerta,
        referencia=ticket,
        tipoalerta=str(alerta.tipoalerta),
        estado=str(alerta.estado),
        mensaje="Reporte registrado. El equipo de operaciones revisará la incidencia.",
    )
