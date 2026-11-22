from fastapi import APIRouter

from app.packages.p7_reportes.controllers.cu035_reportes.report_controller import (
    dashboard_router, router as report_router,
)

router = APIRouter()

# Registro de routers de P7: Reportes e Inteligencia de Negocio (CU-035).
router.include_router(report_router)
router.include_router(dashboard_router)
