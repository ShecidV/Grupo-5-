import os
import json
import gzip
import hashlib
from datetime import datetime, date, timezone, timedelta
from decimal import Decimal
from typing import Dict, Any, List, Optional, Tuple

import httpx
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.core.config import settings
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu001_tenants.tenant_backup import TenantBackup
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu003_roles_permisos.usuario_tenant_rol import UsuarioTenantRol
from app.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu010_ordenes_compra.purchase import Compra, CompraDetalle
from app.models.cu012_recepciones.reception import RecepcionCompra, RecepcionDetalle
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu019_envios_logisticos.shipment import Envio
from app.models.cu020_asignacion_unidades_envio.shipment_unit import EnvioUnidad
from app.models.cu021_eventos_transporte.transport_event import (
    EventoTrazabilidad,
    EventoUnidad,
    CondicionTransporte,
    Alerta
)
from app.models.cu005_bitacora.bitacora import Bitacora


def get_bolivia_now() -> datetime:
    return datetime.now(timezone(timedelta(hours=-4))).replace(tzinfo=None)


def serialize_value(val: Any) -> Any:
    """Serializa tipos no nativos de JSON como datetime, date o Decimal."""
    if isinstance(val, (datetime, date)):
        return val.isoformat()
    if isinstance(val, Decimal):
        return float(val)
    if isinstance(val, bytes):
        return val.hex()
    return val


def model_to_dict(obj: Any) -> Dict[str, Any]:
    """Convierte un objeto modelo de SQLAlchemy a diccionario serializable."""
    if obj is None:
        return {}
    res = {}
    for col in obj.__table__.columns:
        val = getattr(obj, col.name, None)
        res[col.name] = serialize_value(val)
    return res


class TenantBackupService:
    @classmethod
    def extraer_datos_tenant(cls, db: Session, idtenant: int) -> Tuple[Dict[str, Any], int]:
        """Extrae todas las tablas relacionales vinculadas a un tenant específico."""
        tenant = db.get(Tenant, idtenant)
        if not tenant:
            raise ValueError(f"No existe la empresa con ID {idtenant}")

        # 1. Tenant info
        tenant_dict = model_to_dict(tenant)

        # 2. Usuarios asignados a este tenant y sus roles
        uts = db.execute(
            select(UsuarioTenant).where(UsuarioTenant.idtenant == idtenant)
        ).scalars().all()
        iduts = [ut.idusuariotenant for ut in uts]
        ut_dicts = [model_to_dict(ut) for ut in uts]

        ut_roles_dicts = []
        if iduts:
            ut_roles = db.execute(
                select(UsuarioTenantRol).where(UsuarioTenantRol.idusuariotenant.in_(iduts))
            ).scalars().all()
            ut_roles_dicts = [model_to_dict(r) for r in ut_roles]

        # 3. Catálogo por empresa
        catalogo = db.execute(
            select(CatalogoTenant).where(CatalogoTenant.idtenant == idtenant)
        ).scalars().all()
        catalogo_dicts = [model_to_dict(c) for c in catalogo]

        # 4. Actores de la cadena
        actores = db.execute(
            select(ActorCadena).where(ActorCadena.idtenant == idtenant)
        ).scalars().all()
        actores_dicts = [model_to_dict(a) for a in actores]

        # 5. Ubicaciones (nodos logísticos)
        ubicaciones = db.execute(
            select(Ubicacion).where(Ubicacion.idtenant == idtenant)
        ).scalars().all()
        ubicaciones_dicts = [model_to_dict(u) for u in ubicaciones]

        # 6. Órdenes de compra y detalles
        compras = db.execute(
            select(Compra).where(Compra.idtenant == idtenant)
        ).scalars().all()
        idcompras = [c.idcompra for c in compras]
        compras_dicts = [model_to_dict(c) for c in compras]

        compras_detalles_dicts = []
        if idcompras:
            compras_detalles = db.execute(
                select(CompraDetalle).where(CompraDetalle.idcompra.in_(idcompras))
            ).scalars().all()
            compras_detalles_dicts = [model_to_dict(cd) for cd in compras_detalles]

        # 7. Recepciones y detalles
        recepciones_dicts = []
        recepciones_detalles_dicts = []
        if idcompras:
            recepciones = db.execute(
                select(RecepcionCompra).where(RecepcionCompra.idcompra.in_(idcompras))
            ).scalars().all()
            idrecepciones = [r.idrecepcion for r in recepciones]
            recepciones_dicts = [model_to_dict(r) for r in recepciones]

            if idrecepciones:
                recepciones_detalles = db.execute(
                    select(RecepcionDetalle).where(RecepcionDetalle.idrecepcion.in_(idrecepciones))
                ).scalars().all()
                recepciones_detalles_dicts = [model_to_dict(rd) for rd in recepciones_detalles]

        # 8. Unidades serializadas
        unidades = db.execute(
            select(UnidadProducto).where(UnidadProducto.idtenant == idtenant)
        ).scalars().all()
        idunidades = [u.idunidad for u in unidades]
        unidades_dicts = [model_to_dict(u) for u in unidades]

        # 9. Códigos QR
        qr_dicts = []
        if idunidades:
            qrs = db.execute(
                select(CodigoQR).where(CodigoQR.idunidad.in_(idunidades))
            ).scalars().all()
            qr_dicts = [model_to_dict(q) for q in qrs]

        # 10. Envíos y asignaciones
        envios = db.execute(
            select(Envio).where(Envio.idtenant == idtenant)
        ).scalars().all()
        idenvios = [e.idenvio for e in envios]
        envios_dicts = [model_to_dict(e) for e in envios]

        envios_unidades_dicts = []
        if idenvios:
            envios_unidades = db.execute(
                select(EnvioUnidad).where(EnvioUnidad.idenvio.in_(idenvios))
            ).scalars().all()
            envios_unidades_dicts = [model_to_dict(eu) for eu in envios_unidades]

        # 11. Eventos de transporte y telemetría
        eventos = db.execute(
            select(EventoTrazabilidad).where(EventoTrazabilidad.idtenant == idtenant)
        ).scalars().all()
        ideventos = [ev.idevento for ev in eventos]
        eventos_dicts = [model_to_dict(ev) for ev in eventos]

        eventos_unidades_dicts = []
        alertas_dicts = []
        condiciones_dicts = []
        if ideventos:
            eventos_unidades = db.execute(
                select(EventoUnidad).where(EventoUnidad.idevento.in_(ideventos))
            ).scalars().all()
            eventos_unidades_dicts = [model_to_dict(eu) for eu in eventos_unidades]

            alertas = db.execute(
                select(Alerta).where(Alerta.idevento.in_(ideventos))
            ).scalars().all()
            alertas_dicts = [model_to_dict(al) for al in alertas]

            condiciones = db.execute(
                select(CondicionTransporte).where(CondicionTransporte.idevento.in_(ideventos))
            ).scalars().all()
            condiciones_dicts = [model_to_dict(c) for c in condiciones]

        # 12. Bitácora de auditoría asociada al tenant
        bitacora_dicts = []
        if iduts:
            bitacora_records = db.execute(
                select(Bitacora).where(Bitacora.idusuariotenant.in_(iduts))
            ).scalars().all()
            bitacora_dicts = [model_to_dict(b) for b in bitacora_records]

        total_registros = (
            1
            + len(ut_dicts)
            + len(ut_roles_dicts)
            + len(catalogo_dicts)
            + len(actores_dicts)
            + len(ubicaciones_dicts)
            + len(compras_dicts)
            + len(compras_detalles_dicts)
            + len(recepciones_dicts)
            + len(recepciones_detalles_dicts)
            + len(unidades_dicts)
            + len(qr_dicts)
            + len(envios_dicts)
            + len(envios_unidades_dicts)
            + len(eventos_dicts)
            + len(eventos_unidades_dicts)
            + len(condiciones_dicts)
            + len(alertas_dicts)
            + len(bitacora_dicts)
        )

        backup_payload = {
            "version": "1.0",
            "metadata": {
                "idtenant": tenant.idtenant,
                "nombre_comercial": tenant.nombre,
                "razon_social": tenant.razonsocial,
                "nit": tenant.nit,
                "email": tenant.email,
                "fecha_generacion": get_bolivia_now().isoformat(),
                "total_registros": total_registros,
                "sistema": "Sistema Enterprise de Trazabilidad Multi-Tenant"
            },
            "data": {
                "tenant": [tenant_dict],
                "usuario_tenant": ut_dicts,
                "usuario_tenant_rol": ut_roles_dicts,
                "catalogo_tenant": catalogo_dicts,
                "actor_cadena": actores_dicts,
                "ubicacion": ubicaciones_dicts,
                "compra": compras_dicts,
                "compra_detalle": compras_detalles_dicts,
                "recepcion_compra": recepciones_dicts,
                "recepcion_detalle": recepciones_detalles_dicts,
                "unidad_producto": unidades_dicts,
                "codigo_qr": qr_dicts,
                "envio": envios_dicts,
                "envio_unidad": envios_unidades_dicts,
                "evento_trazabilidad": eventos_dicts,
                "evento_unidad": eventos_unidades_dicts,
                "condicion_transporte": condiciones_dicts,
                "alerta": alertas_dicts,
                "bitacora": bitacora_dicts
            }
        }

        return backup_payload, total_registros

    @classmethod
    def subir_a_supabase_storage(cls, cloud_path: str, compressed_bytes: bytes) -> bool:
        """Sube el archivo al bucket de Supabase Storage mediante su API REST oficial."""
        if not settings.SUPABASE_URL or not settings.SUPABASE_SERVICE_ROLE_KEY:
            return False

        base_url = settings.SUPABASE_URL.rstrip("/")
        bucket = settings.SUPABASE_BACKUP_BUCKET
        upload_url = f"{base_url}/storage/v1/object/{bucket}/{cloud_path}"

        headers = {
            "Authorization": f"Bearer {settings.SUPABASE_SERVICE_ROLE_KEY}",
            "apikey": settings.SUPABASE_SERVICE_ROLE_KEY,
            "Content-Type": "application/gzip",
            "x-upsert": "true"
        }

        try:
            with httpx.Client(timeout=30.0) as client:
                res = client.post(upload_url, headers=headers, content=compressed_bytes)
                if res.status_code in (200, 201):
                    return True
                
                # Si el bucket no existe, intentar crearlo automáticamente
                if res.status_code in (400, 404) or "not found" in res.text.lower():
                    create_bucket_url = f"{base_url}/storage/v1/bucket"
                    bucket_payload = {"id": bucket, "name": bucket, "public": False}
                    client.post(create_bucket_url, headers=headers, json=bucket_payload)
                    # Reintentar subida
                    res2 = client.post(upload_url, headers=headers, content=compressed_bytes)
                    return res2.status_code in (200, 201)

                print(f"[Supabase Storage Error]: {res.status_code} - {res.text}")
                return False
        except Exception as e:
            print(f"[Supabase Storage Upload Exception]: {e}")
            return False

    @classmethod
    def generar_signed_url_supabase(cls, cloud_path: str, expires_in_seconds: int = 900) -> Optional[str]:
        """Genera una URL firmada de descarga temporal en Supabase Storage."""
        if not settings.SUPABASE_URL or not settings.SUPABASE_SERVICE_ROLE_KEY:
            return None

        base_url = settings.SUPABASE_URL.rstrip("/")
        bucket = settings.SUPABASE_BACKUP_BUCKET
        sign_url = f"{base_url}/storage/v1/object/sign/{bucket}/{cloud_path}"

        headers = {
            "Authorization": f"Bearer {settings.SUPABASE_SERVICE_ROLE_KEY}",
            "apikey": settings.SUPABASE_SERVICE_ROLE_KEY,
            "Content-Type": "application/json"
        }

        try:
            with httpx.Client(timeout=10.0) as client:
                res = client.post(sign_url, headers=headers, json={"expiresIn": expires_in_seconds})
                if res.status_code == 200:
                    data = res.json()
                    signed_url_path = data.get("signedURL")
                    if signed_url_path:
                        # Concatenar URL completa si viene relativa
                        if signed_url_path.startswith("http"):
                            return signed_url_path
                        return f"{base_url}/storage/v1{signed_url_path}"
        except Exception as e:
            print(f"[Supabase Signed URL Exception]: {e}")
        return None

    @classmethod
    def procesar_backup(cls, db: Session, idbackup: int) -> TenantBackup:
        """Flujo orquestador: extrae, comprime, calcula hash y almacena en la nube o local."""
        backup_record = db.get(TenantBackup, idbackup)
        if not backup_record:
            raise ValueError(f"Registro de backup #{idbackup} no encontrado")

        try:
            backup_record.estado = "PROCESANDO"
            db.commit()

            # 1. Extraer datos del tenant
            payload, total_regs = cls.extraer_datos_tenant(db, backup_record.idtenant)

            # 2. Serializar a JSON y comprimir en memoria
            json_text = json.dumps(payload, ensure_ascii=False, indent=2)
            compressed_bytes = gzip.compress(json_text.encode("utf-8"), compresslevel=9)

            # 3. Checksum criptográfico SHA-256
            checksum = hashlib.sha256(compressed_bytes).hexdigest()
            peso_bytes = len(compressed_bytes)

            # 4. Nombre y ruta en la nube
            timestamp_str = get_bolivia_now().strftime("%Y%m%d_%H%M%S")
            nombre_archivo = f"backup_tenant_{backup_record.idtenant}_{timestamp_str}.json.gz"
            cloud_path = f"tenants/tenant_{backup_record.idtenant}/{nombre_archivo}"

            # 5. Intentar almacenamiento en Supabase Storage
            subido_supabase = False
            if (
                settings.SUPABASE_URL
                and settings.SUPABASE_SERVICE_ROLE_KEY
                and "[PROJECT-REF]" not in settings.SUPABASE_URL
                and "supabase.co" in settings.SUPABASE_URL
            ):
                subido_supabase = cls.subir_a_supabase_storage(cloud_path, compressed_bytes)

            if subido_supabase:
                backup_record.cloud_storage = "supabase"
                backup_record.cloud_path = cloud_path
            else:
                # Almacenamiento local seguro (fallback para desarrollo u offline)
                local_dir = os.path.abspath(os.path.join(settings.LOCAL_BACKUP_DIR, f"tenant_{backup_record.idtenant}"))
                os.makedirs(local_dir, exist_ok=True)
                local_file_path = os.path.join(local_dir, nombre_archivo)
                with open(local_file_path, "wb") as f:
                    f.write(compressed_bytes)
                backup_record.cloud_storage = "local"
                backup_record.cloud_path = local_file_path

            backup_record.nombre_archivo = nombre_archivo
            backup_record.peso_bytes = peso_bytes
            backup_record.checksum_sha256 = checksum
            backup_record.total_registros = total_regs
            backup_record.estado = "COMPLETADO"
            backup_record.mensaje_error = None
            db.commit()
            db.refresh(backup_record)
            return backup_record

        except Exception as err:
            db.rollback()
            backup_record.estado = "FALLIDO"
            backup_record.mensaje_error = str(err)
            db.commit()
            raise err
