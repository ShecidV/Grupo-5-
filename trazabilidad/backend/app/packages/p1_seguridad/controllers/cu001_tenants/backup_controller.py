import os
from typing import Optional, List
from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from fastapi.responses import FileResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from sqlalchemy import select

import asyncio
from app.db.session import get_db, engine
from app.packages.p1_seguridad.models.cu001_tenants.tenant import Tenant
from app.packages.p1_seguridad.models.cu001_tenants.tenant_backup import TenantBackup
from app.packages.p1_seguridad.models.cu001_tenants.tenant_backup_schedule import TenantBackupSchedule
from app.packages.p1_seguridad.models.cu002_usuarios.user import User
from app.packages.p1_seguridad.models.cu005_bitacora.bitacora import Bitacora
from app.packages.p1_seguridad.controllers.cu004_autenticacion.auth_controller import AuthController
from app.controllers.shared import (
    require_roles,
    get_bolivia_now,
    get_client_ip,
    get_idusuariotenant,
    _es_superadmin,
    resolve_tenant_id
)
from app.services.tenant_backup_service import TenantBackupService
from app.services.backup_scheduler import BackupSchedulerService
from app.core.config import settings
from app.packages.p1_seguridad.views.cu001_tenants.backup_views import (
    TenantBackupResponse,
    TenantBackupListResponse,
    CreateBackupResponse,
    DownloadBackupResponse,
    CreateBackupScheduleRequest,
    BackupScheduleResponse,
    BackupScheduleListResponse
)

router = APIRouter(prefix="/backups", tags=["Copias de Seguridad por Tenant (SuperAdministrador y Admin)"])

# Roles autorizados a gestionar copias de seguridad
roles_backup = require_roles("SuperAdministrador", "AdministradorEmpresa")
security = HTTPBearer(auto_error=False)


def _validar_permiso_tenant(db: Session, current_user: User, idtenant: int):
    if _es_superadmin(db, current_user):
        return
    tenant_id = resolve_tenant_id(db, current_user)
    if tenant_id != idtenant:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="No tiene permisos para operar sobre las copias de seguridad de otra empresa."
        )


@router.on_event("startup")
async def ensure_backup_tables_and_scheduler():
    """Asegura tablas de backups y arranca el scheduler de copias automáticas."""
    try:
        TenantBackup.__table__.create(bind=engine, checkfirst=True)
        TenantBackupSchedule.__table__.create(bind=engine, checkfirst=True)
    except Exception as e:
        print(f"[Backup Table Check Warning]: {e}")

    try:
        asyncio.create_task(BackupSchedulerService.start_scheduler_loop())
    except Exception as sched_err:
        print(f"[Scheduler Startup Warning]: {sched_err}")


@router.post("/tenants/{idtenant}", response_model=CreateBackupResponse, status_code=status.HTTP_201_CREATED)
def crear_copia_seguridad_tenant(
    idtenant: int,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(roles_backup)
):
    """
    Genera una copia de seguridad aislada y cifrada para un tenant específico.
    Almacena en localhost o en Supabase Storage según la configuración activa.
    """
    _validar_permiso_tenant(db, current_user, idtenant)

    # 1. Verificar existencia del tenant
    tenant = db.get(Tenant, idtenant)
    if not tenant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"La empresa con ID {idtenant} no existe."
        )

    # 2. Crear registro inicial
    backup_rec = TenantBackup(
        idtenant=idtenant,
        idusuario_creador=current_user.idusuario,
        nombre_archivo=f"backup_tenant_{idtenant}_generando.json.gz",
        cloud_storage="local",
        cloud_path="",
        estado="PENDIENTE",
        fechacreacion=get_bolivia_now()
    )
    db.add(backup_rec)
    db.commit()
    db.refresh(backup_rec)

    # 3. Registrar en Bitácora de Auditoría (CU-005)
    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(Bitacora(
            idusuariotenant=idut,
            accion="BACKUP_SOLICITADO",
            entidad="TenantBackup",
            identidad=backup_rec.idbackup,
            ip=get_client_ip(request),
            fechahora=get_bolivia_now()
        ))
        db.commit()
    except Exception as audit_err:
        print(f"[Audit Error]: {audit_err}")

    # 4. Procesar extracción, compresión y subida local o nube
    try:
        backup_procesado = TenantBackupService.procesar_backup(db, backup_rec.idbackup)
        return CreateBackupResponse(
            message=f"Copia de seguridad manual generada con éxito ({backup_procesado.total_registros} registros respaldados).",
            idbackup=backup_procesado.idbackup,
            estado=backup_procesado.estado,
            nombre_archivo=backup_procesado.nombre_archivo
        )
    except Exception as proc_err:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error al generar la copia de seguridad: {str(proc_err)}"
        )


@router.get("/tenants/{idtenant}", response_model=TenantBackupListResponse)
def listar_copias_seguridad_tenant(
    idtenant: int,
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(roles_backup)
):
    """Lista el historial cronológico de copias de seguridad de una empresa."""
    _validar_permiso_tenant(db, current_user, idtenant)

    tenant = db.get(Tenant, idtenant)
    if not tenant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"La empresa con ID {idtenant} no existe."
        )

    stmt = (
        select(TenantBackup)
        .where(TenantBackup.idtenant == idtenant)
        .order_by(TenantBackup.fechacreacion.desc())
        .offset(skip)
        .limit(limit)
    )
    items = db.execute(stmt).scalars().all()

    return TenantBackupListResponse(
        total=len(items),
        items=[TenantBackupResponse.model_validate(b) for b in items]
    )


@router.get("/tenants/{idtenant}/{idbackup}/download", response_model=DownloadBackupResponse)
def obtener_enlace_descarga(
    idtenant: int,
    idbackup: int,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(roles_backup)
):
    """Genera enlace de descarga para el archivo de copia de seguridad .json.gz."""
    _validar_permiso_tenant(db, current_user, idtenant)

    backup = db.get(TenantBackup, idbackup)
    if not backup or backup.idtenant != idtenant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Copia de seguridad no encontrada para esta empresa."
        )

    if backup.estado != "COMPLETADO":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"La copia de seguridad no está disponible (Estado: {backup.estado})."
        )

    # Registrar descarga en bitácora
    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(Bitacora(
            idusuariotenant=idut,
            accion="BACKUP_DESCARGADO",
            entidad="TenantBackup",
            identidad=backup.idbackup,
            ip=get_client_ip(request),
            fechahora=get_bolivia_now()
        ))
        db.commit()
    except Exception as audit_err:
        print(f"[Audit Download Error]: {audit_err}")

    # Si está en Supabase Storage, generar Signed URL
    if backup.cloud_storage == "supabase":
        signed_url = TenantBackupService.generar_signed_url_supabase(backup.cloud_path, expires_in_seconds=900)
        if signed_url:
            return DownloadBackupResponse(
                download_url=signed_url,
                nombre_archivo=backup.nombre_archivo,
                modo="signed_url",
                expires_in_minutes=15
            )

    # Almacenamiento local directo
    return DownloadBackupResponse(
        download_url=f"/api/v1/backups/download-local/{backup.idbackup}",
        nombre_archivo=backup.nombre_archivo,
        modo="direct",
        expires_in_minutes=None
    )


@router.get("/download-local/{idbackup}")
def descargar_archivo_local(
    idbackup: int,
    token: Optional[str] = Query(None),
    auth: Optional[HTTPAuthorizationCredentials] = Depends(security),
    db: Session = Depends(get_db)
):
    """Descarga directa del archivo comprimido cuando está almacenado localmente."""
    jwt_token = token or (auth.credentials if auth else None)
    if not jwt_token:
        raise HTTPException(status_code=401, detail="No autenticado.")

    current_user = AuthController.get_current_user_from_token(db, jwt_token)
    if not current_user:
        raise HTTPException(status_code=401, detail="Token inválido o expirado.")

    backup = db.get(TenantBackup, idbackup)
    if not backup:
        raise HTTPException(status_code=404, detail="Copia de seguridad no encontrada.")

    _validar_permiso_tenant(db, current_user, backup.idtenant)

    file_path = backup.cloud_path
    if not os.path.exists(file_path):
        fallback = os.path.abspath(os.path.join(settings.LOCAL_BACKUP_DIR, f"tenant_{backup.idtenant}", backup.nombre_archivo))
        if os.path.exists(fallback):
            file_path = fallback
            backup.cloud_path = fallback
            db.commit()
        else:
            raise HTTPException(status_code=404, detail="El archivo físico de la copia no se encuentra en el servidor local.")

    return FileResponse(
        path=file_path,
        filename=backup.nombre_archivo,
        media_type="application/gzip"
    )


# --- ENDPOINTS DE PROGRAMACIÓN AUTOMÁTICA DE COPIAS ---
@router.post("/tenants/{idtenant}/schedule", response_model=BackupScheduleResponse, status_code=status.HTTP_201_CREATED)
def programar_copia_seguridad(
    idtenant: int,
    data: CreateBackupScheduleRequest,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(roles_backup)
):
    """
    Programa una copia de seguridad automática para una fecha y hora determinada,
    con opción de frecuencia (UNA_VEZ, DIARIO, SEMANAL, MENSUAL).
    """
    _validar_permiso_tenant(db, current_user, idtenant)

    tenant = db.get(Tenant, idtenant)
    if not tenant:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"La empresa con ID {idtenant} no existe."
        )

    # Asegurar fecha en zona horaria boliviana sin tzinfo naive
    target_dt = data.fecha_hora_programada
    if target_dt.tzinfo is not None:
        from datetime import timezone, timedelta
        target_dt = target_dt.astimezone(timezone(timedelta(hours=-4))).replace(tzinfo=None)

    frecuencia_valida = data.frecuencia.upper() if data.frecuencia else "UNA_VEZ"
    if frecuencia_valida not in ("UNA_VEZ", "DIARIO", "SEMANAL", "MENSUAL"):
        frecuencia_valida = "UNA_VEZ"

    sched = TenantBackupSchedule(
        idtenant=idtenant,
        idusuario_creador=current_user.idusuario,
        fecha_hora_programada=target_dt,
        frecuencia=frecuencia_valida,
        activo=True,
        estado="PROGRAMADO",
        proxima_ejecucion=target_dt,
        fechacreacion=get_bolivia_now()
    )
    db.add(sched)
    db.commit()
    db.refresh(sched)

    # Registrar en bitácora
    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(Bitacora(
            idusuariotenant=idut,
            accion="BACKUP_PROGRAMADO",
            entidad="TenantBackupSchedule",
            identidad=sched.idschedule,
            ip=get_client_ip(request),
            fechahora=get_bolivia_now()
        ))
        db.commit()
    except Exception as audit_err:
        print(f"[Audit Schedule Error]: {audit_err}")

    return BackupScheduleResponse.model_validate(sched)


@router.get("/tenants/{idtenant}/schedule", response_model=BackupScheduleListResponse)
def listar_programaciones_tenant(
    idtenant: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(roles_backup)
):
    """Lista las programaciones de copias de seguridad de una empresa."""
    _validar_permiso_tenant(db, current_user, idtenant)

    stmt = (
        select(TenantBackupSchedule)
        .where(TenantBackupSchedule.idtenant == idtenant)
        .order_by(TenantBackupSchedule.fechacreacion.desc())
    )
    items = db.execute(stmt).scalars().all()
    return BackupScheduleListResponse(
        total=len(items),
        items=[BackupScheduleResponse.model_validate(s) for s in items]
    )


@router.delete("/tenants/{idtenant}/schedule/{idschedule}")
def cancelar_programacion_backup(
    idtenant: int,
    idschedule: int,
    request: Request,
    db: Session = Depends(get_db),
    current_user: User = Depends(roles_backup)
):
    """Cancela o desactiva una copia de seguridad programada."""
    _validar_permiso_tenant(db, current_user, idtenant)

    sched = db.get(TenantBackupSchedule, idschedule)
    if not sched or sched.idtenant != idtenant:
        raise HTTPException(status_code=404, detail="Programación no encontrada.")

    sched.activo = False
    sched.estado = "CANCELADO"
    db.commit()

    try:
        idut = get_idusuariotenant(db, current_user)
        db.add(Bitacora(
            idusuariotenant=idut,
            accion="BACKUP_PROGRAMACION_CANCELADA",
            entidad="TenantBackupSchedule",
            identidad=sched.idschedule,
            ip=get_client_ip(request),
            fechahora=get_bolivia_now()
        ))
        db.commit()
    except Exception as audit_err:
        print(f"[Audit Cancel Schedule Error]: {audit_err}")

    return {"message": f"Programación #{idschedule} cancelada exitosamente."}
