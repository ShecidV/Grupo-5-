"""Modelos de datos asociados a CU-017 (Escanear Código QR).

Reutiliza las entidades de Código QR (CodigoQR) y Unidad de Producto (UnidadProducto).
"""
from app.packages.p4_trazabilidad.models.cu016_codigos_qr.qr_code import CodigoQR
from app.packages.p4_trazabilidad.models.cu015_unidades_producto.unit import UnidadProducto

__all__ = ["CodigoQR", "UnidadProducto"]
