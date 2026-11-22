from fastapi import APIRouter

from app.packages.p1_seguridad.controllers.cu004_autenticacion.auth_controller import router as auth_router
from app.packages.p1_seguridad.controllers.cu001_tenants.tenant_controller import router as tenant_router
from app.packages.p1_seguridad.controllers.cu001_tenants.backup_controller import router as backup_router
from app.packages.p1_seguridad.controllers.cu002_usuarios.user_controller import router as user_router
from app.packages.p1_seguridad.controllers.cu003_roles_permisos.role_controller import router as role_router
from app.packages.p1_seguridad.controllers.cu005_bitacora.bitacora_controller import router as audit_router

router = APIRouter()

# Inclusión de los enrutadores de P1. CU-036 a CU-040 pertenecen a P8 (ADR-008).
router.include_router(auth_router)
router.include_router(tenant_router)
router.include_router(backup_router)
router.include_router(user_router)
router.include_router(role_router)
router.include_router(audit_router)
