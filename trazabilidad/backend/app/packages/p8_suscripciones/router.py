from fastapi import APIRouter

from app.packages.p8_suscripciones.controllers.cu036_planes.plan_controller import router as plan_router
from app.packages.p8_suscripciones.controllers.cu037_suscripciones.subscription_controller import router as subscription_router
from app.packages.p8_suscripciones.controllers.cu038_cuotas.quota_controller import router as quota_router
from app.packages.p8_suscripciones.controllers.cu039_facturacion.billing_controller import (
    history_router as billing_history_router, router as invoice_router,
)
from app.packages.p8_suscripciones.controllers.cu040_notificaciones.billing_notification_controller import (
    router as billing_notification_router,
)

router = APIRouter()

# Registro de routers de P8: Suscripción y Monetización SaaS (CU-036 a CU-040).
# Los contratos /planes y /suscripciones se conservan sin cambios (ADR-003 / ADR-008).
router.include_router(plan_router)
router.include_router(subscription_router)
router.include_router(quota_router)
router.include_router(invoice_router)
router.include_router(billing_history_router)
router.include_router(billing_notification_router)
