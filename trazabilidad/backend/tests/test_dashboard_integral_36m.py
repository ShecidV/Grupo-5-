"""Panel integral por tenant con estadisticas de 36 meses (extension CU-035)."""
from app.controllers.shared import get_bolivia_now


SECCIONES = {
    "kpis", "series", "distribuciones", "ranking", "comercial", "alertas",
    "logistica", "facturacion", "actividad", "suscripcion", "periodo", "comparacion",
}


def _periodos_entre(desde: str, hasta: str) -> int:
    anio_d, mes_d = (int(p) for p in desde.split("-"))
    anio_h, mes_h = (int(p) for p in hasta.split("-"))
    return (anio_h - anio_d) * 12 + (mes_h - mes_d) + 1


def test_panel_integral_36_meses_y_secciones(client, auth_headers):
    resp = client.get("/api/v1/reports/analytics?meses=36", headers=auth_headers)
    assert resp.status_code == 200, resp.text[:500]
    data = resp.json()

    assert SECCIONES.issubset(data.keys())
    assert data["periodo"]["meses"] == 36
    assert _periodos_entre(data["periodo"]["desde"], data["periodo"]["hasta"]) == 36
    assert data["periodo"]["hasta"] == get_bolivia_now().strftime("%Y-%m")

    assert len(data["series"]) == 11
    assert all(len(serie["puntos"]) == 36 for serie in data["series"])
    assert all(
        punto["periodo"] == data["periodo"]["desde"] if idx == 0 else True
        for serie in data["series"]
        for idx, punto in enumerate(serie["puntos"])
    )
    assert len(data["kpis"]) == 10
    assert data["kpis"][0]["etiqueta"] == "Unidades registradas"
    assert data["comparacion"]["etiqueta"] == "vs 12 meses anteriores"
    assert len(data["distribuciones"]["unidades_por_estado"]) >= 0

    resumen = client.get("/api/v1/reports/summary", headers=auth_headers)
    assert resumen.status_code == 200
    assert data["idtenant"] == resumen.json()["idtenant"]


def test_panel_integral_respeta_rango_y_rol(client, auth_headers):
    resp = client.get("/api/v1/reports/analytics?meses=12", headers=auth_headers)
    assert resp.status_code == 200, resp.text[:500]
    assert resp.json()["periodo"]["meses"] == 12
    assert len(resp.json()["series"][0]["puntos"]) == 12

    assert client.get("/api/v1/reports/analytics?meses=0", headers=auth_headers).status_code == 422
    assert client.get("/api/v1/reports/analytics?meses=37", headers=auth_headers).status_code == 422

    login = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-2",
            "email": "user2@test.com",
            "password": "OtroPassword@456",
        },
    )
    sin_rol = {"Authorization": f"Bearer {login.json()['access_token']}"}
    assert client.get("/api/v1/reports/analytics", headers=sin_rol).status_code == 403


def test_panel_integral_aislamiento_y_bypass_superadmin(client, auth_headers, setup_test_data):
    tenant2 = setup_test_data["tenant2"].idtenant

    propio = client.get("/api/v1/reports/analytics", headers=auth_headers)
    assert propio.status_code == 200
    assert propio.json()["idtenant"] == setup_test_data["tenant1"].idtenant

    ajeno = client.get(f"/api/v1/reports/analytics?idtenant={tenant2}", headers=auth_headers)
    assert ajeno.status_code == 200, ajeno.text[:500]
    assert ajeno.json()["idtenant"] == tenant2
    assert ajeno.json()["tenantnombre"] == "Empresa Test 2"

    inexistente = client.get("/api/v1/reports/analytics?idtenant=999999", headers=auth_headers)
    assert inexistente.status_code == 404
