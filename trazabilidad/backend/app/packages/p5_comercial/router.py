from fastapi import APIRouter
from app.packages.p5_comercial.controllers.cu032_documentos_unidad.document_controller import router as document_router
from app.packages.p5_comercial.controllers.cu025_ventas.sale_controller import router as sale_router
from app.packages.p5_comercial.controllers.cu027_pagos.payment_controller import router as payment_router
from app.packages.p5_comercial.controllers.cu028_historial_consumidor.consumer_history_controller import router as consumer_history_router
from app.packages.p5_comercial.controllers.cu029_devoluciones.return_controller import router as return_router
from app.packages.p5_comercial.controllers.cu030_asignacion_devolucion.return_unit_controller import router as return_unit_router
from app.packages.p5_comercial.controllers.cu031_garantias.warranty_controller import router as warranty_router

router = APIRouter()

# Registro de routers de P5: Comercialización y Post-Venta
router.include_router(document_router)
router.include_router(sale_router)
router.include_router(payment_router)
router.include_router(consumer_history_router)
router.include_router(return_router)
router.include_router(return_unit_router)
router.include_router(warranty_router)
