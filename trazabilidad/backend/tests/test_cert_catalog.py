import time


def test_certifications_crud(client, auth_headers):
    # List
    resp = client.get("/api/v1/certifications", headers=auth_headers)
    assert resp.status_code == 200

    unique_suffix = int(time.time() * 1000)

    # Own category + product (no hardcoded IDs)
    cat_resp = client.post(
        "/api/v1/categories",
        json={"nombrecategoria": f"Categoría Cert {unique_suffix}"},
        headers=auth_headers,
    )
    assert cat_resp.status_code == 201
    idcategoria = cat_resp.json()["idcategoria"]

    prod_resp = client.post(
        "/api/v1/products",
        json={"nombre": f"Producto Cert {unique_suffix}", "modelo": "MOD-CERT", "idcategoria": idcategoria},
        headers=auth_headers,
    )
    assert prod_resp.status_code == 201
    idprod = prod_resp.json()["idproducto"]

    # Create
    new_cert = {
        "nombre": f"ISO-{unique_suffix}",
        "entidademisora": "International Organization for Standardization",
        "descripcion": "Certificación ISO de calidad"
    }
    create_resp = client.post("/api/v1/certifications", json=new_cert, headers=auth_headers)
    assert create_resp.status_code == 201
    cert_data = create_resp.json()
    assert cert_data["nombre"] == f"ISO-{unique_suffix}"
    idcert = cert_data["idcertificacion"]

    # Assign to own product
    assign_resp = client.post(
        f"/api/v1/products/{idprod}/certifications",
        json={"idcertificacion": idcert, "fechaobtencion": "2026-01-15"},
        headers=auth_headers
    )
    assert assign_resp.status_code == 201

    # List product certs
    list_p_certs = client.get(f"/api/v1/products/{idprod}/certifications", headers=auth_headers)
    assert list_p_certs.status_code == 200
    assert len(list_p_certs.json()) >= 1


def test_tenant_catalog_operations(client, auth_headers):
    # List catalog
    resp = client.get("/api/v1/tenant-catalog", headers=auth_headers)
    assert resp.status_code == 200
    assert "items" in resp.json()

    # Add variant to tenant catalog
    unique_suffix = int(time.time() * 1000)

    cat_resp = client.post(
        "/api/v1/categories",
        json={"nombrecategoria": f"Categoría Catálogo {unique_suffix}"},
        headers=auth_headers,
    )
    assert cat_resp.status_code == 201
    idcategoria = cat_resp.json()["idcategoria"]

    # First create a product with valid idcategoria and modelo
    prod_resp = client.post(
        "/api/v1/products",
        json={"nombre": f"Producto Tenant {unique_suffix}", "modelo": "MOD-TEST", "idcategoria": idcategoria},
        headers=auth_headers
    )
    assert prod_resp.status_code == 201
    idprod = prod_resp.json()["idproducto"]

    var_resp = client.post(
        f"/api/v1/products/{idprod}/variants",
        json={"sku": f"SKU-T-{unique_suffix}", "preciousd": 100.00},
        headers=auth_headers
    )
    assert var_resp.status_code == 201
    idvar = var_resp.json()["idvariante"]

    # Add to catalog
    cat_item = {
        "idvariante": idvar,
        "skuinterno": f"INT-SKU-{unique_suffix}",
        "precioventa": 150.00,
        "costopromedio": 90.00
    }
    add_resp = client.post("/api/v1/tenant-catalog", json=cat_item, headers=auth_headers)
    assert add_resp.status_code == 201
    added_data = add_resp.json()
    assert str(added_data["precioventa"]) == "150.00"
