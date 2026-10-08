import time


def test_actors_crud(client, auth_headers):
    # List
    resp = client.get("/api/v1/actors", headers=auth_headers)
    assert resp.status_code == 200
    assert "items" in resp.json()

    # Create
    unique_suffix = int(time.time() * 1000)
    actor_data = {
        "nombre": f"Apple Supplier {unique_suffix}",
        "razonsocial": "Apple Inc USA",
        "nit": f"US-{unique_suffix}",
        "email": f"supplier_{unique_suffix}@apple.com",
        "telefono": "+1-800-123-456",
        "tipoactor": "PROVEEDOR_EEUU"
    }
    create_resp = client.post("/api/v1/actors", json=actor_data, headers=auth_headers)
    assert create_resp.status_code == 201
    created = create_resp.json()
    assert created["nombre"] == f"Apple Supplier {unique_suffix}"


def test_locations_crud(client, auth_headers):
    # List
    resp = client.get("/api/v1/locations", headers=auth_headers)
    assert resp.status_code == 200
    assert "items" in resp.json()

    # Create
    unique_suffix = int(time.time() * 1000)
    loc_data = {
        "nombre": f"Almacén Central {unique_suffix}",
        "direccion": "Av. Banzer Km 8",
        "ciudad": "Santa Cruz",
        "pais": "Bolivia",
        "tipo": "almacen"
    }
    create_resp = client.post("/api/v1/locations", json=loc_data, headers=auth_headers)
    assert create_resp.status_code == 201
    created = create_resp.json()
    assert created["nombre"] == f"Almacén Central {unique_suffix}"


def test_units_crud(client, auth_headers):
    # List
    resp = client.get("/api/v1/units", headers=auth_headers)
    assert resp.status_code == 200
    assert "items" in resp.json()

    # Create product & variant first
    unique_suffix = int(time.time() * 1000)

    cat_resp = client.post(
        "/api/v1/categories",
        json={"nombrecategoria": f"Categoría Unidades {unique_suffix}"},
        headers=auth_headers,
    )
    assert cat_resp.status_code == 201
    idcategoria = cat_resp.json()["idcategoria"]

    prod_resp = client.post(
        "/api/v1/products",
        json={"nombre": f"iPhone 16 Pro {unique_suffix}", "modelo": "A3089", "idcategoria": idcategoria},
        headers=auth_headers
    )
    assert prod_resp.status_code == 201
    idprod = prod_resp.json()["idproducto"]

    var_resp = client.post(
        f"/api/v1/products/{idprod}/variants",
        json={"capacidad": "256GB", "color": "Titán Natural", "sku": f"SKU-IPH16-{unique_suffix}", "preciousd": 999.00},
        headers=auth_headers
    )
    assert var_resp.status_code == 201
    idvar = var_resp.json()["idvariante"]

    # Register unit
    unit_data = {
        "idvariante": idvar,
        "numeroserie": f"SN-{unique_suffix}",
        "imei1": f"359{unique_suffix}",
        "imei2": f"358{unique_suffix}",
        "eid": f"EID{unique_suffix}",
        "estado": "disponible"
    }
    create_unit_resp = client.post("/api/v1/units", json=unit_data, headers=auth_headers)
    assert create_unit_resp.status_code == 201
    created_unit = create_unit_resp.json()
    assert created_unit["numeroserie"] == f"SN-{unique_suffix}"
