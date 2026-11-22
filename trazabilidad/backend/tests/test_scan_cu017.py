import time
import uuid as uuid_lib
import pytest
from sqlalchemy import select

from app.models.cu009_categorias.category import Categoria
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.packages.p4_trazabilidad.controllers.cu017_escaneo_qr.scan_controller import ScanQRController
from app.packages.p4_trazabilidad.controllers.cu018_trazabilidad.public_trace_controller import PublicTraceController


def _crear_unidad_para_scan(db_session, setup_test_data, con_qr=True, qr_activo=True):
    t1 = setup_test_data["tenant1"]
    suffix = int(time.time() * 1000)

    cat = Categoria(nombrecategoria=f"Cat Scan {suffix}")
    db_session.add(cat)
    db_session.flush()

    prod = Producto(
        idcategoria=cat.idcategoria,
        nombre=f"iPhone 15 Pro Scan {suffix}",
        modelo="A2848",
        paisorigen="EEUU",
    )
    db_session.add(prod)
    db_session.flush()

    var = VarianteProducto(
        idproducto=prod.idproducto,
        sku=f"SKU-SCAN-{suffix}",
        color="Titanio Natural",
        capacidad="256GB",
    )
    db_session.add(var)
    db_session.flush()

    uuid_publico = str(uuid_lib.uuid4())
    unidad = UnidadProducto(
        idtenant=t1.idtenant,
        idvariante=var.idvariante,
        numeroserie=f"SN-SCAN-{suffix}",
        uuidpublico=uuid_publico,
        estado="disponible",
    )
    db_session.add(unidad)
    db_session.flush()

    qr = None
    if con_qr:
        qr = CodigoQR(
            idunidad=unidad.idunidad,
            tokenpublico=f"tok-{suffix}",
            url=f"https://blockchain-production-8de2.up.railway.app/trace/{uuid_publico}",
            activo=qr_activo,
        )
        db_session.add(qr)
        db_session.flush()

    db_session.commit()
    return unidad, qr


def test_scan_extract_uuid():
    # URL completa
    u = "d0c4d9aa-407a-4dd8-8095-2c8eb1a9d0a6"
    url = f"https://blockchain-production-8de2.up.railway.app/trace/{u}?ref=camera#scan"
    assert ScanQRController.extract_uuid(url) == u

    # UUID plano
    assert ScanQRController.extract_uuid(u) == u

    # Cadena vacía o no válida
    assert ScanQRController.extract_uuid("") is None
    assert ScanQRController.extract_uuid("invalid-content-without-uuid") is None


def test_scan_process_url_exitosa(client, db_session, setup_test_data):
    unidad, qr = _crear_unidad_para_scan(db_session, setup_test_data, con_qr=True, qr_activo=True)

    resp = client.post(
        "/api/v1/scan/process",
        json={"raw_content": qr.url, "formato": "QR_CODE"},
    )
    assert resp.status_code == 200, resp.text
    data = resp.json()
    assert data["es_valido"] is True
    assert data["uuidpublico"] == unidad.uuidpublico
    assert data["idunidad"] == unidad.idunidad
    assert data["numeroserie"] == unidad.numeroserie
    assert data["qr_activo"] is True
    assert data["modelo"] == "A2848"
    assert data["trace_url"] == f"/api/v1/trace/{unidad.uuidpublico}"


def test_scan_process_uuid_plano(client, db_session, setup_test_data):
    unidad, _ = _crear_unidad_para_scan(db_session, setup_test_data, con_qr=True, qr_activo=True)

    resp = client.post(
        "/api/v1/scan/process",
        json={"raw_content": unidad.uuidpublico},
    )
    assert resp.status_code == 200, resp.text
    data = resp.json()
    assert data["es_valido"] is True
    assert data["uuidpublico"] == unidad.uuidpublico
    assert data["qr_activo"] is True


def test_scan_process_formato_invalido(client):
    resp = client.post(
        "/api/v1/scan/process",
        json={"raw_content": "texto-aleatorio-sin-sentido"},
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["es_valido"] is False
    assert "no corresponde" in data["mensaje"]


def test_scan_process_unidad_sin_qr_activo(client, db_session, setup_test_data):
    unidad, _ = _crear_unidad_para_scan(db_session, setup_test_data, con_qr=True, qr_activo=False)

    resp = client.post(
        "/api/v1/scan/process",
        json={"raw_content": unidad.uuidpublico},
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["es_valido"] is False
    assert data["qr_activo"] is False
    assert "no cuenta con un código QR activo" in data["mensaje"]


def test_scan_verify_endpoint(client, db_session, setup_test_data):
    unidad, _ = _crear_unidad_para_scan(db_session, setup_test_data, con_qr=True, qr_activo=True)

    resp = client.get(f"/api/v1/scan/verify/{unidad.uuidpublico}")
    assert resp.status_code == 200
    data = resp.json()
    assert data["es_valido"] is True
    assert data["qr_activo"] is True
    assert data["idunidad"] == unidad.idunidad


def test_scan_verify_inexistente(client):
    fake_uuid = str(uuid_lib.uuid4())
    resp = client.get(f"/api/v1/scan/verify/{fake_uuid}")
    assert resp.status_code == 200
    data = resp.json()
    assert data["es_valido"] is False
    assert data["qr_activo"] is False
