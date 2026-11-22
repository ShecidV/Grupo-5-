from fastapi import APIRouter
from app.packages.p4_trazabilidad.controllers.cu015_unidades_producto.unit_controller import router as unit_router
from app.packages.p4_trazabilidad.controllers.cu016_codigos_qr.qr_controller import router as qr_router
from app.packages.p4_trazabilidad.controllers.cu017_escaneo_qr.scan_controller import router as scan_router
from app.packages.p4_trazabilidad.controllers.cu018_trazabilidad.public_trace_controller import router as trace_router
from app.packages.p4_trazabilidad.controllers.cu019_envios_logisticos.shipment_controller import router as shipment_router
from app.packages.p4_trazabilidad.controllers.cu020_asignacion_unidades_envio.shipment_unit_controller import router as shipment_unit_router
from app.packages.p4_trazabilidad.controllers.cu021_eventos_transporte.transport_event_controller import router as transport_event_router
from app.packages.p4_trazabilidad.controllers.cu022_ia.ai_report_controller import router as ai_report_router
from app.packages.p4_trazabilidad.controllers.cu023_reporte_sospecha.suspicion_controller import router as suspicion_router
from app.packages.p4_trazabilidad.controllers.cu024_alertas.alert_controller import router as alert_router

router = APIRouter()

# Registro de routers de P4: Inventario y Trazabilidad CORE
router.include_router(unit_router)
router.include_router(qr_router)
router.include_router(scan_router)
router.include_router(trace_router)
router.include_router(shipment_router)
# CU-020 comparte el prefijo /shipments con CU-019 y CU-021: sus subrutas
# /{idenvio}/units no colisionan con /{idenvio} ni /{idenvio}/events.
router.include_router(shipment_unit_router)
router.include_router(transport_event_router)
router.include_router(suspicion_router)
router.include_router(alert_router)
router.include_router(ai_report_router)
