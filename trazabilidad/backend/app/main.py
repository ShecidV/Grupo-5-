from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware


from app.core.config import settings
from app.controllers.cu004_autenticacion.auth_controller import router as auth_router
from app.controllers.cu001_tenants.tenant_controller import router as tenant_router
from app.controllers.cu002_usuarios.user_controller import router as user_router
from app.controllers.cu003_roles_permisos.role_controller import router as role_router
from app.controllers.cu005_bitacora.bitacora_controller import router as audit_router
from app.controllers.cu009_categorias.category_controller import router as category_router
from app.controllers.cu006_productos_variantes.product_controller import router as product_router
from app.controllers.cu007_certificaciones.certification_controller import router as certification_router
from app.controllers.cu008_catalogo_empresa.tenant_catalog_controller import router as tenant_catalog_router
from app.controllers.cu013_actores_cadena.actor_controller import router as actor_router
from app.controllers.cu014_ubicaciones.location_controller import router as location_router
from app.controllers.cu015_unidades_producto.unit_controller import router as unit_router
from app.controllers.cu010_ordenes_compra.purchase_controller import router as purchase_router
from app.controllers.cu011_compras.purchase_approval_controller import router as purchase_approval_router
from app.controllers.cu012_recepciones.reception_controller import router as reception_router
from app.controllers.cu016_codigos_qr.qr_controller import router as qr_router
from app.controllers.cu016_codigos_qr.public_trace_controller import router as trace_router
from app.controllers.cu019_envios_logisticos.shipment_controller import router as shipment_router
from app.controllers.cu020_asignacion_unidades_envio.shipment_unit_controller import router as shipment_unit_router
from app.controllers.cu021_eventos_transporte.transport_event_controller import router as transport_event_router
from app.controllers.cu022_ia.ai_report_controller import router as ai_report_router
from app.controllers.cu001_tenants.backup_controller import router as backup_router

app = FastAPI(
    title=settings.APP_NAME,
    description="API Enterprise Multi-Tenant de Trazabilidad en arquitectura MVC",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configuración de CORS
origins = settings.CORS_ORIGINS if isinstance(settings.CORS_ORIGINS, list) else [i.strip() for i in settings.CORS_ORIGINS.split(",")]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1|10\.0\.2\.2|192\.168\.\d+\.\d+)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclusión de rutas de los controladores
app.include_router(auth_router, prefix="/api/v1")
app.include_router(tenant_router, prefix="/api/v1")
app.include_router(user_router, prefix="/api/v1")
app.include_router(role_router, prefix="/api/v1")
app.include_router(audit_router, prefix="/api/v1")
app.include_router(category_router, prefix="/api/v1")
app.include_router(product_router, prefix="/api/v1")
app.include_router(certification_router, prefix="/api/v1")
app.include_router(tenant_catalog_router, prefix="/api/v1")
app.include_router(actor_router, prefix="/api/v1")
app.include_router(location_router, prefix="/api/v1")
app.include_router(unit_router, prefix="/api/v1")
app.include_router(purchase_router, prefix="/api/v1")
app.include_router(purchase_approval_router, prefix="/api/v1")
app.include_router(reception_router, prefix="/api/v1")
app.include_router(qr_router, prefix="/api/v1")
app.include_router(trace_router, prefix="/api/v1")
app.include_router(shipment_router, prefix="/api/v1")
app.include_router(transport_event_router, prefix="/api/v1")
# CU-020 comparte el prefijo /shipments con CU-019 y CU-021: sus subrutas
# /{idenvio}/units no colisionan con /{idenvio} ni /{idenvio}/events.
app.include_router(shipment_unit_router, prefix="/api/v1")
app.include_router(ai_report_router, prefix="/api/v1")
app.include_router(backup_router, prefix="/api/v1")


import jwt
from datetime import datetime, timezone, timedelta
from sqlalchemy import select
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.db.session import SessionLocal

# Middleware de auditoría automática: registra peticiones exitosas en la bitácora
@app.middleware("http")
async def audit_logger_middleware(request: Request, call_next):
    response = await call_next(request)
    
    path = request.url.path.rstrip("/")
    if (
        not path.startswith("/api/v1")
        or path in ("/api/v1/bitacora", "/api/v1/auth/login", "/api/v1/auth/refresh")
        or request.method == "OPTIONS"
    ):
        return response

    # Solo registrar operaciones exitosas (200-399) con token Bearer
    if 200 <= response.status_code < 400:
        auth_header = request.headers.get("authorization")
        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header.split(" ")[1]
            try:
                payload = jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
                sub = payload.get("sub") or payload.get("idusuario")
                tenant_id = payload.get("tenant_id") or payload.get("idtenant")
                if sub and tenant_id:
                    idusuario = int(sub)
                    idtenant = int(tenant_id)
                    client_ip = (
                        request.headers.get("x-forwarded-for", "").split(",")[0].strip()
                        or (request.client.host if request.client else "127.0.0.1")
                    )
                    # Deduce la entidad a partir del primer segmento de la URL
                    path_parts = [p for p in path.split("/") if p and p not in ("api", "v1")]
                    entidad = path_parts[0].capitalize() if path_parts else "General"
                    
                    db_audit = SessionLocal()
                    try:
                        ut_stmt = select(UsuarioTenant.idusuariotenant).where(
                            UsuarioTenant.idusuario == idusuario,
                            UsuarioTenant.idtenant == idtenant
                        )
                        idut = db_audit.execute(ut_stmt).scalar()
                        if not idut:
                            ut_stmt2 = select(UsuarioTenant.idusuariotenant).where(
                                UsuarioTenant.idusuario == idusuario
                            )
                            idut = db_audit.execute(ut_stmt2).scalar()
                        if idut:
                            # Hora oficial de Bolivia (BOT = UTC-4)
                            hora_bolivia = datetime.now(timezone(timedelta(hours=-4))).replace(tzinfo=None)
                            db_audit.add(Bitacora(
                                idusuariotenant=idut,
                                accion=request.method.upper(),
                                entidad=entidad,
                                ip=client_ip,
                                fechahora=hora_bolivia
                            ))
                            db_audit.commit()
                    except Exception as db_err:
                        print(f"[Audit DB Error]: {db_err}")
                        db_audit.rollback()
                    finally:
                        db_audit.close()
            except Exception as mid_err:
                print(f"[Audit Middleware Error]: {mid_err}")
                pass

    return response

from fastapi import Request, Depends
from fastapi.responses import JSONResponse
from sqlalchemy import text
from app.db.session import get_db
from sqlalchemy.orm import Session

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    import traceback
    return JSONResponse(
        status_code=500,
        content={"error_type": type(exc).__name__, "error_detail": str(exc), "trace": traceback.format_exc()}
    )

@app.get("/health", tags=["Health"])
def health_check(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1")).scalar()
        db_status = "connected"
    except Exception as e:
        db_status = f"error: {str(e)}"
    return {"status": "ok", "app": settings.APP_NAME, "db": db_status}
