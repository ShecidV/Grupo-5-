"""Sprint 4 - P5: CU-025 a CU-031 (ventas, unidades, pagos, devoluciones, garantías)."""
from datetime import date, timedelta
from decimal import Decimal
import time
import uuid as uuid_lib

from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu009_categorias.category import Categoria
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta
from app.packages.p5_comercial.models.cu027_pagos.pago import Pago


def _contexto(db_session, tenant, *, email=None, cantidad_unidades=2):
    suffix = int(time.time() * 1000) + uuid_lib.uuid4().int % 1000
    cat = Categoria(nombrecategoria=f"Cat S4-{suffix}")
    db_session.add(cat)
    db_session.flush()
    prod = Producto(
        idcategoria=cat.idcategoria, nombre=f"iPhone S4-{suffix}",
        modelo="iPhone 15 Pro", paisorigen="EEUU",
    )
    db_session.add(prod)
    db_session.flush()
    var = VarianteProducto(
        idproducto=prod.idproducto, sku=f"SKU-S4-{suffix}", color="Titanio", capacidad="256GB"
    )
    db_session.add(var)
    db_session.flush()
    cliente = ActorCadena(
        idtenant=tenant.idtenant,
        nombre=f"Consumidor {suffix}",
        email=email or f"consumidor{suffix}@test.com",
        tipoactor="CONSUMIDOR",
    )
    db_session.add(cliente)
    db_session.flush()
    unidades = []
    for i in range(cantidad_unidades):
        u = UnidadProducto(
            idtenant=tenant.idtenant,
            idvariante=var.idvariante,
            numeroserie=f"SN-S4-{suffix}-{i}",
            uuidpublico=str(uuid_lib.uuid4()),
            estado="disponible",
        )
        db_session.add(u)
        unidades.append(u)
    db_session.commit()
    return var, cliente, unidades


def _venta_payload(var, cliente, unidades):
    return {
        "idcliente": cliente.idactor,
        "detalles": [{
            "idvariante": var.idvariante,
            "cantidad": len(unidades),
            "preciounitario": "1000.00",
            "idunidades": [u.idunidad for u in unidades],
        }],
    }


def test_crear_venta_asigna_unidades_y_calcula_total(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    var, cliente, unidades = _contexto(db_session, t1)

    resp = client.post("/api/v1/sales", json=_venta_payload(var, cliente, unidades), headers=auth_headers)
    assert resp.status_code == 201, resp.text
    data = resp.json()
    assert data["total"] == "2000.00"
    assert data["estado"] == "pendiente"
    assert len(data["detalles"][0]["unidades"]) == 2

    db_session.expire_all()
    for u in unidades:
        db_session.refresh(u)
        assert str(u.estado) == "vendido"
        assert u.fechaventa is not None


def test_crear_venta_cliente_de_otro_tenant_404(client, db_session, setup_test_data, auth_headers):
    t2 = setup_test_data["tenant2"]
    var, cliente, unidades = _contexto(db_session, t2)
    resp = client.post("/api/v1/sales", json=_venta_payload(var, cliente, unidades), headers=auth_headers)
    assert resp.status_code == 404


def test_listar_ventas_no_filtra_otro_tenant(client, db_session, setup_test_data, auth_headers):
    t1, t2 = setup_test_data["tenant1"], setup_test_data["tenant2"]
    var1, c1, u1 = _contexto(db_session, t1)
    var2, c2, u2 = _contexto(db_session, t2)
    client.post("/api/v1/sales", json=_venta_payload(var1, c1, u1), headers=auth_headers)

    ajena = Venta(idtenant=t2.idtenant, idcliente=c2.idactor, total=Decimal("999.00"), estado="pendiente")
    db_session.add(ajena)
    db_session.commit()

    resp = client.get("/api/v1/sales", headers=auth_headers)
    assert resp.status_code == 200, resp.text
    ids = [v["idventa"] for v in resp.json()["items"]]
    assert ajena.idventa not in ids


def test_asignar_unidad_ya_vendida_conflicto(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    var, cliente, unidades = _contexto(db_session, t1)
    creada = client.post(
        "/api/v1/sales", json=_venta_payload(var, cliente, [unidades[0]]), headers=auth_headers
    ).json()
    detalle = creada["detalles"][0]

    # Se intenta vender la misma unidad en otra venta.
    resp = client.post(
        "/api/v1/sales", json=_venta_payload(var, cliente, [unidades[0]]), headers=auth_headers
    )
    assert resp.status_code == 409, resp.text

    # Y también por el endpoint explícito de asignación (CU-026).
    db_session.add(Venta(
        idtenant=t1.idtenant, idcliente=cliente.idactor,
        total=Decimal("1000.00"), estado="pendiente",
    ))
    db_session.flush()
    resp2 = client.post(
        f"/api/v1/sales/{creada['idventa']}/units",
        json={"idventadetalle": detalle["idventadetalle"], "idunidades": [unidades[1].idunidad]},
        headers=auth_headers,
    )
    assert resp2.status_code == 409  # excede la cantidad del detalle


def test_desasignar_unidad_devuelve_estado_disponible(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    var, cliente, unidades = _contexto(db_session, t1)
    creada = client.post(
        "/api/v1/sales", json=_venta_payload(var, cliente, [unidades[0]]), headers=auth_headers
    ).json()

    resp = client.delete(
        f"/api/v1/sales/{creada['idventa']}/units/{unidades[0].idunidad}", headers=auth_headers
    )
    assert resp.status_code == 200, resp.text
    db_session.expire_all()
    db_session.refresh(unidades[0])
    assert str(unidades[0].estado) == "disponible"


def test_pago_completado_marca_venta_pagada(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    var, cliente, unidades = _contexto(db_session, t1)
    creada = client.post(
        "/api/v1/sales", json=_venta_payload(var, cliente, [unidades[0]]), headers=auth_headers
    ).json()

    resp = client.post("/api/v1/payments", json={
        "idventa": creada["idventa"], "metodopago": "transferencia",
        "monto": "1000.00", "estado": "completado",
    }, headers=auth_headers)
    assert resp.status_code == 201, resp.text
    assert resp.json()["venta_estado"] == "pagada"

    detalle = client.get(f"/api/v1/sales/{creada['idventa']}", headers=auth_headers).json()
    assert detalle["monto_pagado"] == "1000.00"
    assert detalle["saldo"] == "0.00"


def test_pago_venta_ajena_404(client, db_session, setup_test_data, auth_headers):
    t2 = setup_test_data["tenant2"]
    var, cliente, unidades = _contexto(db_session, t2)
    ajena = Venta(idtenant=t2.idtenant, idcliente=cliente.idactor, total=Decimal("100.00"))
    db_session.add(ajena)
    db_session.commit()

    resp = client.post("/api/v1/payments", json={
        "idventa": ajena.idventa, "metodopago": "efectivo", "monto": "100.00",
    }, headers=auth_headers)
    assert resp.status_code == 404


def test_devolucion_valida_unidades_y_aprueba(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    var, cliente, unidades = _contexto(db_session, t1, cantidad_unidades=3)
    creada = client.post(
        "/api/v1/sales", json=_venta_payload(var, cliente, unidades[:2]), headers=auth_headers
    ).json()

    resp_mala = client.post("/api/v1/returns", json={
        "idventa": creada["idventa"], "motivo": "defecto_fabrica",
        "idunidades": [unidades[2].idunidad],
    }, headers=auth_headers)
    assert resp_mala.status_code == 400

    resp = client.post("/api/v1/returns", json={
        "idventa": creada["idventa"], "motivo": "defecto_fabrica",
        "descripcion": "No enciende", "idunidades": [unidades[0].idunidad],
    }, headers=auth_headers)
    assert resp.status_code == 201, resp.text
    iddev = resp.json()["iddevolucion"]

    aprobada = client.patch(
        f"/api/v1/returns/{iddev}/estado", json={"estado": "aprobada"}, headers=auth_headers
    )
    assert aprobada.status_code == 200, aprobada.text
    db_session.expire_all()
    db_session.refresh(unidades[0])
    assert str(unidades[0].estado) == "devuelto"


def test_garantia_por_unidad(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    var, cliente, unidades = _contexto(db_session, t1, cantidad_unidades=1)
    hoy = date.today()
    resp = client.post("/api/v1/warranties", json={
        "idunidad": unidades[0].idunidad,
        "fechainicio": hoy.isoformat(),
        "fechafin": (hoy + timedelta(days=365)).isoformat(),
        "proveedor": "Apple Bolivia",
    }, headers=auth_headers)
    assert resp.status_code == 201, resp.text
    assert resp.json()["vigente"] is True
    assert resp.json()["numeroserie"] == unidades[0].numeroserie

    consulta = client.get(
        f"/api/v1/warranties/units/{unidades[0].idunidad}/current", headers=auth_headers
    )
    assert consulta.status_code == 200


def test_historial_consumidor_aislado_por_tenant(client, db_session, setup_test_data, auth_headers):
    t1, t2 = setup_test_data["tenant1"], setup_test_data["tenant2"]
    var1, c1, u1 = _contexto(db_session, t1, email="user1@test.com", cantidad_unidades=1)
    var2, c2, u2 = _contexto(db_session, t2, cantidad_unidades=1)
    client.post("/api/v1/sales", json=_venta_payload(var1, c1, u1), headers=auth_headers)

    resp = client.get("/api/v1/consumer/history", headers=auth_headers)
    assert resp.status_code == 200, resp.text
    data = resp.json()
    assert data["idcliente"] == c1.idactor
    assert data["totalcompras"] == 1

    ajena = client.get(
        f"/api/v1/consumer/history?idcliente={c2.idactor}", headers=auth_headers
    )
    assert ajena.status_code == 404


def test_ventas_requieren_rol(client, db_session, setup_test_data):
    resp = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-2",
            "email": "user2@test.com",
            "password": "OtroPassword@456",
        },
    )
    assert resp.status_code == 200, resp.text
    headers = {"Authorization": f"Bearer {resp.json()['access_token']}"}
    sin_rol = client.get("/api/v1/sales", headers=headers)
    assert sin_rol.status_code == 403
