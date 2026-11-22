from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware


from app.core.config import settings
from app.packages.p1_seguridad.router import router as p1_seguridad_router
from app.packages.p2_catalogo.router import router as p2_catalogo_router
from app.packages.p3_actores.router import router as p3_actores_router
from app.packages.p4_trazabilidad.router import router as p4_trazabilidad_router
from app.packages.p5_comercial.router import router as p5_comercial_router
from app.packages.p6_blockchain.router import router as p6_blockchain_router
from app.packages.p7_reportes.router import router as p7_reportes_router
from app.packages.p8_suscripciones.router import router as p8_suscripciones_router

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
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1|10\.0\.2\.2|192\.168\.\d+\.\d+|.*\.vercel\.app)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclusión de rutas de los controladores
app.include_router(p1_seguridad_router, prefix="/api/v1")
app.include_router(p2_catalogo_router, prefix="/api/v1")
app.include_router(p3_actores_router, prefix="/api/v1")
app.include_router(p4_trazabilidad_router, prefix="/api/v1")
app.include_router(p5_comercial_router, prefix="/api/v1")
app.include_router(p6_blockchain_router, prefix="/api/v1")
app.include_router(p7_reportes_router, prefix="/api/v1")
app.include_router(p8_suscripciones_router, prefix="/api/v1")


import jwt
from datetime import datetime, timezone, timedelta
from sqlalchemy import select
from app.packages.p1_seguridad.models.cu005_bitacora.bitacora import Bitacora
from app.packages.p1_seguridad.models.cu002_usuarios.usuario_tenant import UsuarioTenant
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

@app.on_event("startup")
async def ensure_scheduler_started():
    import asyncio
    try:
        from app.services.backup_scheduler import BackupSchedulerService
        asyncio.create_task(BackupSchedulerService.start_scheduler_loop())
    except Exception as e:
        print(f"[Main Startup Scheduler Warning]: {e}")
