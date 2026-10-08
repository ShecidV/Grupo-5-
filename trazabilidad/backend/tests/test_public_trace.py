import time
import uuid as uuid_lib

import pytest
from sqlalchemy import select

from app.models.cu009_categorias.category import Categoria
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu021_eventos_transporte.transport_event import EventoTrazabilidad, EventoUnidad

TOKEN = "token-publico-test"


def login(client, tenant_slug, email, password):
    resp = client.post(
        "/api/v1/auth/login",
        json={"tenant_slug": tenant_slug, "email": email, "password": password},
    )
    assert resp.status_code == 200, resp.text
    return {"Authorization": f"Bearer {resp.json()['access_token']}"}


def _crear_unidad(db_session, setup_test_data, con_qr=True, con_evento=False):
    t1 = setup_test_data["tenant1"]
    u1 = setup_test_data["user1"]
    suffix = int(time.time() * 1000)

    cat = Categoria(nombrecategoria=f"Cat Trace {suffix}")
    db_session.add(cat)
    db_session.flush()

    prod = Producto(
        idcategoria=cat.idcategoria,
        nombre=f"Producto Trace {suffix}",
        modelo="MOD-TRACE",
        paisorigen="EEUU",
    )
    db_session.add(prod)
    db_session.flush()

    var = VarianteProducto(idproducto=prod.idproducto, sku=f"SKU-TRACE-{suffix}", color="Negro", capacidad="256GB")
    db_session.add(var)
    db_session.flush()

    uuid_publico = str(uuid_lib.uuid4())
    unidad = UnidadProducto(
        idtenant=t1.idtenant,
        idvariante=var.idvariante,
        numeroserie=f"SN-TRACE-{suffix}",
        uuidpublico=uuid_publico,
        estado="disponible",
    )
    db_session.add(unidad)
    db_session.flush()

    if con_qr:
        db_session.add(CodigoQR(
            idunidad=unidad.idunidad,
            tokenpublico=TOKEN,
            url=f"https://example.com/trace/{uuid_publico}",
            activo=True,
        ))

    if con_evento:
        ub = Ubicacion(idtenant=t1.idtenant, nombre="Almacén Origen", tipo="almacen", pais="Bolivia")
        db_session.add(ub)
        db_session.flush()

        ev = EventoTrazabilidad(
            idtenant=t1.idtenant,
            tipoevento="fabricacion",
            idubicacion=ub.idubicacion,
            idusuarioresponsable=u1.idusuario,
            descripcion="Unidad fabricada en planta",
            estadoverificacion="verificado",
        )
        db_session.add(ev)
        db_session.flush()
        db_session.add(EventoUnidad(idevento=ev.idevento, idunidad=unidad.idunidad))

    db_session.commit()
    return unidad


# ---------------------------------------------------------------------------
# GET /trace/{uuidpublico} — consulta publica sin autenticacion
# ---------------------------------------------------------------------------


def test_trace_publico_con_qr_activo(client, db_session, setup_test_data):
    unidad = _crear_unidad(db_session, setup_test_data, con_qr=True, con_evento=True)

    resp = client.get(f"/api/v1/trace/{unidad.uuidpublico}")
    assert resp.status_code == 200, resp.text
    data = resp.json()

    assert data["uuidpublico"] == unidad.uuidpublico
    assert data["numeroserie"] == unidad.numeroserie
    assert data["empresa"] == "Empresa Test 1"
    assert data["producto"]["paisorigen"] == "EEUU"
    assert data["variante"]["color"] == "Negro"
    assert len(data["eventos"]) == 1
    assert data["eventos"][0]["tipoevento"] == "fabricacion"
    assert data["eventos"][0]["estadoverificacion"] == "verificado"
    assert data["eventos"][0]["ubicacion"]["nombre"] == "Almacén Origen"

    # El payload publico no debe exponer datos sensibles
    assert "imei1" not in data
    assert "email" not in resp.text


def test_trace_uuid_inexistente_devuelve_404(client, setup_test_data):
    resp = client.get(f"/api/v1/trace/{uuid_lib.uuid4()}")
    assert resp.status_code == 404


def test_trace_unidad_sin_qr_activo_devuelve_404(client, db_session, setup_test_data):
    unidad = _crear_unidad(db_session, setup_test_data, con_qr=False)

    resp = client.get(f"/api/v1/trace/{unidad.uuidpublico}")
    assert resp.status_code == 404
    # Mismo mensaje que un UUID inexistente: no revela existencia de unidades sin QR
    assert resp.json()["detail"] == "Unidad no encontrada."


# ---------------------------------------------------------------------------
# GET /qr/{id}/image — requiere autenticacion y pertenencia al tenant
# ---------------------------------------------------------------------------


def test_qr_image_sin_token_devuelve_401(client, db_session, setup_test_data):
    unidad = _crear_unidad(db_session, setup_test_data, con_qr=True)

    resp = client.get(f"/api/v1/qr/{unidad.idunidad}/image")
    # HTTPBearer de la app responde 403 cuando no hay credenciales
    assert resp.status_code in (401, 403)


def test_qr_image_otro_tenant_devuelve_404(client, db_session, setup_test_data):
    unidad = _crear_unidad(db_session, setup_test_data, con_qr=True)
    headers = login(client, "empresa-test-2", "user2@test.com", "OtroPassword@456")

    resp = client.get(f"/api/v1/qr/{unidad.idunidad}/image", headers=headers)
    assert resp.status_code == 404


def test_qr_image_con_token_devuelve_png(client, db_session, setup_test_data):
    unidad = _crear_unidad(db_session, setup_test_data, con_qr=True)
    headers = login(client, "empresa-test-1", "user1@test.com", "MiClave@123")

    resp = client.get(f"/api/v1/qr/{unidad.idunidad}/image", headers=headers)
    assert resp.status_code == 200, resp.text
    assert resp.headers["content-type"] == "image/png"
    assert resp.content[:8] == b"\x89PNG\r\n\x1a\n"
