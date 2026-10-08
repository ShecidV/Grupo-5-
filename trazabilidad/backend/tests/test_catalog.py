import time


def test_list_and_create_categories(client, auth_headers):
    resp = client.get("/api/v1/categories", headers=auth_headers)
    assert resp.status_code == 200
    initial_count = len(resp.json())

    unique_suffix = int(time.time() * 1000)
    new_cat = {
        "nombrecategoria": f"Categoría Test {unique_suffix}",
        "descripcion": "Categoría de prueba para test"
    }
    create_resp = client.post("/api/v1/categories", json=new_cat, headers=auth_headers)
    assert create_resp.status_code == 201
    cat_data = create_resp.json()
    assert cat_data["nombrecategoria"] == f"Categoría Test {unique_suffix}"

    resp_after = client.get("/api/v1/categories", headers=auth_headers)
    assert len(resp_after.json()) == initial_count + 1


def test_list_create_and_update_products(client, auth_headers):
    resp = client.get("/api/v1/products", headers=auth_headers)
    assert resp.status_code == 200

    unique_suffix = int(time.time() * 1000)

    cat_resp = client.post(
        "/api/v1/categories",
        json={
            "nombrecategoria": f"Categoría Prod {unique_suffix}",
            "descripcion": "Categoría para producto de prueba",
        },
        headers=auth_headers,
    )
    assert cat_resp.status_code == 201
    idcategoria = cat_resp.json()["idcategoria"]

    new_prod = {
        "nombre": f"iPad Air {unique_suffix}",
        "modelo": "A2902",
        "paisorigen": "EEUU",
        "descripcion": "iPad Air de prueba",
        "idcategoria": idcategoria
    }
    create_resp = client.post("/api/v1/products", json=new_prod, headers=auth_headers)
    assert create_resp.status_code == 201
    prod_data = create_resp.json()
    idprod = prod_data["idproducto"]

    # Add variant with unique SKU
    new_var = {
        "capacidad": "128GB",
        "color": "Azul Estelar",
        "sku": f"SKU-{unique_suffix}",
        "preciousd": 599.00
    }
    var_resp = client.post(f"/api/v1/products/{idprod}/variants", json=new_var, headers=auth_headers)
    assert var_resp.status_code == 201
    var_data = var_resp.json()
    assert var_data["sku"] == f"SKU-{unique_suffix}"

    # Get product detail
    detail_resp = client.get(f"/api/v1/products/{idprod}", headers=auth_headers)
    assert detail_resp.status_code == 200
    assert len(detail_resp.json()["variantes"]) >= 1
