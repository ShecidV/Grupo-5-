import re
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.db.session import get_db
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.packages.p4_trazabilidad.views.cu017_escaneo_qr.scan_views import (
    ScanQRRequest,
    ScanQRResponse,
    ScanVerifyResponse,
)

router = APIRouter(prefix="/scan", tags=["Escanear Código QR (CU-017)"])

_UUID_REGEX = re.compile(
    r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", re.IGNORECASE
)


class ScanQRController:

    @staticmethod
    def extract_uuid(raw_input: str) -> Optional[str]:
        """Extrae el UUID público del código QR escaneado (URL completa o token)."""
        if not raw_input:
            return None
        raw = raw_input.strip()

        # 1. Búsqueda por patrón UUID regex
        match = _UUID_REGEX.search(raw)
        if match:
            return match.group(0).lower()

        # 2. Búsqueda por marcador de ruta /trace/
        marker = "/trace/"
        if marker in raw:
            candidate = raw.split(marker)[-1].split("?")[0].split("#")[0].strip("/")
            if candidate:
                return candidate.lower()

        return None

    @staticmethod
    def process_scan(db: Session, request: ScanQRRequest) -> ScanQRResponse:
        """Procesa y valida el contenido de un código QR escaneado (CU-017)."""
        uuid_publico = ScanQRController.extract_uuid(request.raw_content)

        if not uuid_publico:
            # Si no es un UUID estándar, buscar si coincide con tokenpublico de codigoqr
            qr_by_token = db.execute(
                select(CodigoQR).where(CodigoQR.tokenpublico == request.raw_content.strip())
            ).scalar_one_or_none()

            if qr_by_token:
                unit = db.execute(
                    select(UnidadProducto).where(UnidadProducto.idunidad == qr_by_token.idunidad)
                ).scalar_one_or_none()
                if unit:
                    uuid_publico = unit.uuidpublico

        if not uuid_publico:
            return ScanQRResponse(
                es_valido=False,
                qr_activo=False,
                mensaje="El formato o contenido del código QR no corresponde a una unidad registrada.",
            )

        # Buscar unidad por UUID público
        unit = db.execute(
            select(UnidadProducto).where(UnidadProducto.uuidpublico == uuid_publico)
        ).scalar_one_or_none()

        if not unit:
            return ScanQRResponse(
                es_valido=False,
                uuidpublico=uuid_publico,
                qr_activo=False,
                mensaje="Unidad no encontrada en el sistema.",
            )

        # Verificar si tiene código QR activo
        qr = db.execute(
            select(CodigoQR).where(CodigoQR.idunidad == unit.idunidad, CodigoQR.activo == True)
        ).scalar_one_or_none()

        if not qr:
            return ScanQRResponse(
                es_valido=False,
                uuidpublico=uuid_publico,
                idunidad=unit.idunidad,
                numeroserie=unit.numeroserie,
                qr_activo=False,
                mensaje="La unidad existe pero no cuenta con un código QR activo.",
            )

        # Obtener información complementaria de producto
        prod_nombre = None
        modelo = None
        if unit.idvariante:
            variante = db.execute(
                select(VarianteProducto).where(VarianteProducto.idvariante == unit.idvariante)
            ).scalar_one_or_none()
            if variante and variante.idproducto:
                prod = db.execute(
                    select(Producto).where(Producto.idproducto == variante.idproducto)
                ).scalar_one_or_none()
                if prod:
                    prod_nombre = prod.nombre
                    modelo = prod.modelo

        trace_url = f"/api/v1/trace/{unit.uuidpublico}"

        return ScanQRResponse(
            es_valido=True,
            uuidpublico=unit.uuidpublico,
            idunidad=unit.idunidad,
            numeroserie=unit.numeroserie,
            producto_nombre=prod_nombre,
            modelo=modelo,
            estado_unidad=str(unit.estado) if unit.estado else None,
            qr_activo=True,
            trace_url=trace_url,
            mensaje="Código QR escaneado y validado con éxito.",
        )

    @staticmethod
    def verify_qr(db: Session, identifier: str) -> ScanVerifyResponse:
        """Verificación rápida de vigencia y autenticidad del código QR (CU-017)."""
        uuid_publico = ScanQRController.extract_uuid(identifier) or identifier.strip()

        unit = db.execute(
            select(UnidadProducto).where(UnidadProducto.uuidpublico == uuid_publico)
        ).scalar_one_or_none()

        if not unit:
            # Buscar por tokenpublico
            qr_entry = db.execute(
                select(CodigoQR).where(CodigoQR.tokenpublico == identifier.strip())
            ).scalar_one_or_none()
            if qr_entry:
                unit = db.execute(
                    select(UnidadProducto).where(UnidadProducto.idunidad == qr_entry.idunidad)
                ).scalar_one_or_none()

        if not unit:
            return ScanVerifyResponse(
                es_valido=False,
                qr_activo=False,
                mensaje="El código QR verificado no existe en el registro del sistema.",
            )

        qr = db.execute(
            select(CodigoQR).where(CodigoQR.idunidad == unit.idunidad, CodigoQR.activo == True)
        ).scalar_one_or_none()

        if not qr:
            return ScanVerifyResponse(
                es_valido=False,
                uuidpublico=unit.uuidpublico,
                idunidad=unit.idunidad,
                qr_activo=False,
                mensaje="Código QR inactivo o revocado.",
            )

        return ScanVerifyResponse(
            es_valido=True,
            uuidpublico=unit.uuidpublico,
            idunidad=unit.idunidad,
            qr_activo=True,
            mensaje="Código QR verificado y activo.",
        )


@router.post("/process", response_model=ScanQRResponse)
def process_scan_endpoint(body: ScanQRRequest, db: Session = Depends(get_db)):
    """Procesar y validar el contenido extraído de un escaneo QR (CU-017 / sin autenticación)."""
    return ScanQRController.process_scan(db, body)


@router.get("/verify/{identifier}", response_model=ScanVerifyResponse)
def verify_qr_endpoint(identifier: str, db: Session = Depends(get_db)):
    """Verificación rápida de existencia y activación del código QR escaneado (CU-017)."""
    return ScanQRController.verify_qr(db, identifier)
