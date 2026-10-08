"""Tests de cobertura de creación/edición de órdenes de compra (CU-010)
y de envíos logísticos con transiciones de estado (CU-019)."""

import time
from datetime import date, timedelta

import pytest

from app.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant
from app.models.cu009_categorias.category import Categoria
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu013_actores_cadena.actor import ActorCadena


@pytest.fixture
def base_data(db_session, setup_test_data):
    """Actores, producto y variante en catálogo para tenant 1 (autocontenido)."""
    t1 = setup_test_data["tenant1"]
    suffix = int(time.time() * 1000)

    proveedor = ActorCadena(
        idtenant=t1.idtenant,
        nombre=f"Proveedor COV {suffix}",
        razonsocial=f"Proveedor COV S.A. {suffix}",
        nit=f"PROV-{suffix}",
        tipoactor="PROVEEDOR_EEUU",
    )
    destino = ActorCadena(
        idtenant=t1.idtenant,
        nombre=f"Destino COV {suffix}",
        razonsocial=f"Destino COV S.A. {suffix}",
        nit=f"DEST-{suffix}",
        tipoactor="IMPORTADOR",
    )
    transportista = ActorCadena(
        idtenant=t1.idtenant,
        nombre=f"Transportista COV {suffix}",
        razonsocial=f"Transportista COV S.A. {suffix}",
        nit=f"TRANSP-{suffix}",
        tipoactor="TRANSPORTISTA_INTERNACIONAL",
    )
    db_session.add_all([proveedor, destino, transportista])
    db_session.flush()

    categoria = Categoria(nombrecategoria=f"CovCat {suffix}", descripcion="Categoría de cobertura")
    db_session.add(categoria)
    db_session.flush()

    producto = Producto(
        idcategoria=categoria.idcategoria,
        nombre=f"Producto COV {suffix}",
        modelo=f"MOD-COV-{suffix}",
        activo=True,
    )
    db_session.add(producto)
    db_session.flush()

    variante = VarianteProducto(
        idproducto=producto.idproducto,
        sku=f"COV-SKU-{suffix}",
        color="Negro",
        capacidad="128GB",
    )
    db_session.add(variante)
    db_session.flush()

    catalogo = CatalogoTenant(
        idtenant=t1.idtenant,
        idvariante=variante.idvariante,
        skuinterno=f"INT-COV-{suffix}",
        precioventa=150.00,
        costopromedio=90.00,
        activo=True,
    )
    db_session.add(catalogo)
    db_session.commit()

    return {
        "tenant": t1,
        "proveedor": proveedor,
        "destino": destino,
        "transportista": transportista,
        "variante": variante,
        "suffix": suffix,
    }


def _crear_compra(client, auth_headers, base_data, cantidad=3, costo="100.50", numeroorden=None):
    resp = client.post(
        "/api/v1/purchases",
        json={
            "idproveedor": base_data["proveedor"].idactor,
            "numeroorden": numeroorden or f"OC-COV-{base_data['suffix']}-{int(time.time() * 1000)}",
            "fechacompra": date.today().isoformat(),
            "detalles": [
                {
                    "idvariante": base_data["variante"].idvariante,
                    "cantidad": cantidad,
                    "costounitariousd": costo,
                }
            ],
        },
        headers=auth_headers,
    )
    return resp


def _crear_envio(client, auth_headers, base_data, codigoenvio=None):
    resp = client.post(
        "/api/v1/shipments",
        json={
            "idactororigen": base_data["proveedor"].idactor,
            "idactordestino": base_data["destino"].idactor,
            "idtransportista": base_data["transportista"].idactor,
            "codigoenvio": codigoenvio or f"ENV-COV-{base_data['suffix']}-{int(time.time() * 1000)}",
            "fechaestimada": "2026-10-20T00:00:00",
            "trackingexterno": "TRK-COV-123",
        },
        headers=auth_headers,
    )
    return resp


# ---------------------------------------------------------------------------
# CU-010 — Órdenes de compra
# ---------------------------------------------------------------------------


def test_create_purchase_success(client, auth_headers, base_data):
    resp = _crear_compra(client, auth_headers, base_data)
    assert resp.status_code == 201
    data = resp.json()
    assert data["estado"] == "pendiente"
    assert str(data["totalusd"]) == "301.50"
    assert data["total_items"] == 3
    assert len(data["detalles"]) == 1
    assert data["detalles"][0]["sku"] == base_data["variante"].sku
    assert data["detalles"][0]["producto_nombre"] == f"Producto COV {base_data['suffix']}"
    assert base_data["proveedor"].razonsocial in data["proveedor_nombre"]


def test_create_purchase_rejects_variant_outside_catalog(client, auth_headers, db_session, base_data):
    suf = int(time.time() * 1000)
    var_fuera = VarianteProducto(
        idproducto=base_data["variante"].idproducto,
        sku=f"COV-FUERA-{suf}",
        color="Rojo",
        capacidad="64GB",
    )
    db_session.add(var_fuera)
    db_session.commit()

    resp = client.post(
        "/api/v1/purchases",
        json={
            "idproveedor": base_data["proveedor"].idactor,
            "numeroorden": f"OC-FUERA-{suf}",
            "fechacompra": date.today().isoformat(),
            "detalles": [{"idvariante": var_fuera.idvariante, "cantidad": 1, "costounitariousd": "50.00"}],
        },
        headers=auth_headers,
    )
    assert resp.status_code == 400
    assert "catalogo" in resp.json()["detail"].lower()


def test_create_purchase_rejects_duplicate_numeroorden(client, auth_headers, base_data):
    numero = f"OC-DUP-{base_data['suffix']}-{int(time.time() * 1000)}"
    first = _crear_compra(client, auth_headers, base_data, numeroorden=numero)
    assert first.status_code == 201

    second = _crear_compra(client, auth_headers, base_data, numeroorden=numero)
    assert second.status_code == 409


def test_create_purchase_rejects_repeated_variants(client, auth_headers, base_data):
    suf = int(time.time() * 1000)
    resp = client.post(
        "/api/v1/purchases",
        json={
            "idproveedor": base_data["proveedor"].idactor,
            "numeroorden": f"OC-REP-{suf}",
            "fechacompra": date.today().isoformat(),
            "detalles": [
                {"idvariante": base_data["variante"].idvariante, "cantidad": 1, "costounitariousd": "10.00"},
                {"idvariante": base_data["variante"].idvariante, "cantidad": 2, "costounitariousd": "10.00"},
            ],
        },
        headers=auth_headers,
    )
    assert resp.status_code == 400
    assert "repetir" in resp.json()["detail"].lower()


def test_create_purchase_rejects_unknown_proveedor(client, auth_headers, base_data):
    suf = int(time.time() * 1000)
    resp = client.post(
        "/api/v1/purchases",
        json={
            "idproveedor": 999999,
            "numeroorden": f"OC-PROV-{suf}",
            "fechacompra": date.today().isoformat(),
            "detalles": [{"idvariante": base_data["variante"].idvariante, "cantidad": 1, "costounitariousd": "10.00"}],
        },
        headers=auth_headers,
    )
    assert resp.status_code == 400
    assert "proveedor" in resp.json()["detail"].lower() or "actor" in resp.json()["detail"].lower()


def test_update_purchase_success(client, auth_headers, base_data):
    created = _crear_compra(client, auth_headers, base_data)
    assert created.status_code == 201
    idcompra = created.json()["idcompra"]

    numero_nuevo = f"OC-EDIT-{base_data['suffix']}-{int(time.time() * 1000)}"
    resp = client.put(
        f"/api/v1/purchases/{idcompra}",
        json={
            "numeroorden": numero_nuevo,
            "detalles": [
                {"idvariante": base_data["variante"].idvariante, "cantidad": 5, "costounitariousd": "200.00"}
            ],
        },
        headers=auth_headers,
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["numeroorden"] == numero_nuevo
    assert str(data["totalusd"]) == "1000.00"
    assert data["total_items"] == 5


def test_update_purchase_rejected_when_not_pending(client, auth_headers, db_session, base_data):
    created = _crear_compra(client, auth_headers, base_data)
    assert created.status_code == 201
    idcompra = created.json()["idcompra"]

    from app.models.cu010_ordenes_compra.purchase import Compra

    compra = db_session.get(Compra, idcompra)
    compra.estado = "enviada"
    db_session.commit()

    resp = client.put(
        f"/api/v1/purchases/{idcompra}",
        json={"numeroorden": f"OC-BLOQ-{int(time.time() * 1000)}"},
        headers=auth_headers,
    )
    assert resp.status_code == 400
    assert "pendiente" in resp.json()["detail"].lower()


def test_update_purchase_unknown_id_returns_404(client, auth_headers):
    resp = client.put(
        "/api/v1/purchases/999999",
        json={"numeroorden": "OC-NADA"},
        headers=auth_headers,
    )
    assert resp.status_code == 404


def test_purchase_write_requires_role(client, setup_test_data):
    login = client.post(
        "/api/v1/auth/login",
        json={"tenant_slug": "empresa-test-2", "email": "user2@test.com", "password": "OtroPassword@456"},
    )
    headers = {"Authorization": f"Bearer {login.json()['access_token']}"}
    resp = client.post(
        "/api/v1/purchases",
        json={
            "idproveedor": 1,
            "numeroorden": "OC-SINROL",
            "fechacompra": date.today().isoformat(),
            "detalles": [{"idvariante": 1, "cantidad": 1, "costounitariousd": "1.00"}],
        },
        headers=headers,
    )
    assert resp.status_code == 403


# ---------------------------------------------------------------------------
# CU-019 — Envíos logísticos
# ---------------------------------------------------------------------------


def test_create_shipment_success(client, auth_headers, base_data):
    resp = _crear_envio(client, auth_headers, base_data)
    assert resp.status_code == 201
    data = resp.json()
    assert data["estado"] == "preparacion"
    assert data["total_unidades"] == 0
    assert data["trackingexterno"] == "TRK-COV-123"
    assert data["actor_origen_nombre"]
    assert data["actor_destino_nombre"]
    assert data["transportista_nombre"]
    assert data["fechasalida"] is None


def test_create_shipment_rejects_same_origin_destination(client, auth_headers, base_data):
    suf = int(time.time() * 1000)
    resp = client.post(
        "/api/v1/shipments",
        json={
            "idactororigen": base_data["proveedor"].idactor,
            "idactordestino": base_data["proveedor"].idactor,
            "codigoenvio": f"ENV-IGUAL-{suf}",
        },
        headers=auth_headers,
    )
    assert resp.status_code == 400


def test_create_shipment_rejects_duplicate_codigo(client, auth_headers, base_data):
    codigo = f"ENV-DUP-{base_data['suffix']}-{int(time.time() * 1000)}"
    first = _crear_envio(client, auth_headers, base_data, codigoenvio=codigo)
    assert first.status_code == 201

    second = _crear_envio(client, auth_headers, base_data, codigoenvio=codigo)
    assert second.status_code == 409


def test_create_shipment_rejects_unknown_actor(client, auth_headers, base_data):
    suf = int(time.time() * 1000)
    resp = client.post(
        "/api/v1/shipments",
        json={
            "idactororigen": base_data["proveedor"].idactor,
            "idactordestino": 999999,
            "codigoenvio": f"ENV-ACTOR-{suf}",
        },
        headers=auth_headers,
    )
    assert resp.status_code == 400


def test_update_shipment_success_while_preparacion(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    assert created.status_code == 201
    idenvio = created.json()["idenvio"]

    resp = client.put(
        f"/api/v1/shipments/{idenvio}",
        json={
            "trackingexterno": "TRK-EDITADO",
            "fechaestimada": "2026-11-01T00:00:00",
            "idtransportista": None,
        },
        headers=auth_headers,
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["trackingexterno"] == "TRK-EDITADO"
    assert data["transportista_nombre"] is None
    assert data["idtransportista"] is None


def test_update_shipment_rejected_when_not_preparacion(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    assert created.status_code == 201
    idenvio = created.json()["idenvio"]

    move = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "en_transito"},
        headers=auth_headers,
    )
    assert move.status_code == 200

    resp = client.put(
        f"/api/v1/shipments/{idenvio}",
        json={"trackingexterno": "DESPUES-SALIDA"},
        headers=auth_headers,
    )
    assert resp.status_code == 400
    assert "preparacion" in resp.json()["detail"].lower()


def test_update_shipment_unknown_id_returns_404(client, auth_headers):
    resp = client.put(
        "/api/v1/shipments/999999",
        json={"trackingexterno": "X"},
        headers=auth_headers,
    )
    assert resp.status_code == 404


def test_transition_preparacion_to_en_transito_sets_fechasalida(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    idenvio = created.json()["idenvio"]

    resp = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "en_transito"},
        headers=auth_headers,
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["estado"] == "en_transito"
    assert data["fechasalida"] is not None
    assert data["fechaentrega"] is None


def test_transition_en_transito_to_entregado_sets_fechaentrega(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    idenvio = created.json()["idenvio"]

    client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "en_transito"},
        headers=auth_headers,
    )
    resp = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "entregado"},
        headers=auth_headers,
    )
    assert resp.status_code == 200
    data = resp.json()
    assert data["estado"] == "entregado"
    assert data["fechasalida"] is not None
    assert data["fechaentrega"] is not None


def test_transition_skipping_state_is_rejected(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    idenvio = created.json()["idenvio"]

    resp = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "entregado"},
        headers=auth_headers,
    )
    assert resp.status_code == 400
    assert "preparacion" in resp.json()["detail"]


def test_transition_same_state_is_rejected(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    idenvio = created.json()["idenvio"]

    resp = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "preparacion"},
        headers=auth_headers,
    )
    assert resp.status_code == 400
    assert "ya se encuentra" in resp.json()["detail"].lower()


def test_transition_invalid_state_name_returns_422(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    idenvio = created.json()["idenvio"]

    resp = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "volando"},
        headers=auth_headers,
    )
    assert resp.status_code == 422


def test_transition_cancelado_is_terminal(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    idenvio = created.json()["idenvio"]

    cancel = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "cancelado"},
        headers=auth_headers,
    )
    assert cancel.status_code == 200
    assert cancel.json()["estado"] == "cancelado"

    resp = client.patch(
        f"/api/v1/shipments/{idenvio}/estado",
        json={"estado": "en_transito"},
        headers=auth_headers,
    )
    assert resp.status_code == 400


def test_transition_retrasado_can_return_and_deliver(client, auth_headers, base_data):
    created = _crear_envio(client, auth_headers, base_data)
    idenvio = created.json()["idenvio"]

    for estado in ("en_transito", "retrasado", "en_transito", "entregado"):
        resp = client.patch(
            f"/api/v1/shipments/{idenvio}/estado",
            json={"estado": estado},
            headers=auth_headers,
        )
        assert resp.status_code == 200, resp.text
        assert resp.json()["estado"] == estado

    assert resp.json()["fechaentrega"] is not None


def test_shipment_write_requires_role(client, setup_test_data):
    login = client.post(
        "/api/v1/auth/login",
        json={"tenant_slug": "empresa-test-2", "email": "user2@test.com", "password": "OtroPassword@456"},
    )
    headers = {"Authorization": f"Bearer {login.json()['access_token']}"}
    resp = client.post(
        "/api/v1/shipments",
        json={
            "idactororigen": 1,
            "idactordestino": 2,
            "codigoenvio": "ENV-SINROL",
        },
        headers=headers,
    )
    assert resp.status_code == 403
