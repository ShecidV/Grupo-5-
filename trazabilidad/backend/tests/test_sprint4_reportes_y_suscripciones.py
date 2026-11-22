"""Sprint 4 - P7/P8: CU-035, CU-038, CU-039, CU-040 y push CU-005."""
from datetime import datetime, timedelta
from decimal import Decimal
import uuid

from app.models.cu001_tenants.tenant import Tenant
from app.models.cu005_bitacora.notification import Notificacion
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Plan, Suscripcion


def _plan_y_suscripcion(db_session, tenant, *, limite_reportes=1, dias_vencimiento=30):
    suf = uuid.uuid4().hex[:8]
    plan = Plan(
        codigo=f"plan-s4-{suf}",
        nombre=f"Plan Sprint 4 {suf}",
        preciomensual=Decimal("99.00"),
        precioanual=Decimal("990.00"),
        moneda="USD",
        limiteusuarios=10,
        limiteunidades=100,
        limitereportesmes=limite_reportes,
        diastrial=0,
        activo=True,
    )
    db_session.add(plan)
    db_session.flush()
    ahora = datetime.utcnow()
    sus = Suscripcion(
        idtenant=tenant.idtenant,
        idplan=plan.idplan,
        estado="activa",
        fechainicio=ahora - timedelta(days=1),
        fechafin=ahora + timedelta(days=dias_vencimiento),
        renovacionautomatica=True,
    )
    db_session.add(sus)
    db_session.commit()
    return plan, sus


def test_reportes_resumen_trazabilidad_dashboard_y_pdf(client, auth_headers):
    res = client.get("/api/v1/reports/summary", headers=auth_headers)
    assert res.status_code == 200, res.text
    data = res.json()
    assert data["totalunidades"] >= 0
    assert "unidades_por_estado" in data
    assert "ingresos" in data

    trace = client.get("/api/v1/reports/traceability", headers=auth_headers)
    assert trace.status_code == 200, trace.text
    assert "eventosportipo" in trace.json()

    dash = client.get("/api/v1/dashboard", headers=auth_headers)
    assert dash.status_code == 200, dash.text
    assert dash.json()["resumen"]["idtenant"] == data["idtenant"]

    pdf = client.get("/api/v1/reports/pdf", headers=auth_headers)
    assert pdf.status_code == 200, pdf.text[:200] if pdf.headers["content-type"].startswith("text") else ""
    assert pdf.content.startswith(b"%PDF")
    assert "application/pdf" in pdf.headers["content-type"]


def test_reportes_requieren_rol(client, setup_test_data):
    resp = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-2",
            "email": "user2@test.com",
            "password": "OtroPassword@456",
        },
    )
    headers = {"Authorization": f"Bearer {resp.json()['access_token']}"}
    assert client.get("/api/v1/reports/summary", headers=headers).status_code == 403
    assert client.get("/api/v1/dashboard", headers=headers).status_code == 403


def test_cuotas_consumo_y_limite(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    _plan_y_suscripcion(db_session, t1, limite_reportes=2)

    actual = client.get("/api/v1/quotas", headers=auth_headers)
    assert actual.status_code == 200, actual.text
    limite = actual.json()["limites"]["reportesgenerados"]
    assert limite["permitido"] == 2
    assert limite["usado"] == 0

    for _ in range(2):
        ok = client.post(
            "/api/v1/quotas/consume",
            json={"concepto": "reportesgenerados", "cantidad": 1},
            headers=auth_headers,
        )
        assert ok.status_code == 200, ok.text

    excedido = client.post(
        "/api/v1/quotas/consume",
        json={"concepto": "reportesgenerados", "cantidad": 1},
        headers=auth_headers,
    )
    assert excedido.status_code == 429, excedido.text

    invalido = client.post(
        "/api/v1/quotas/consume",
        json={"concepto": "no_existe", "cantidad": 1},
        headers=auth_headers,
    )
    assert invalido.status_code == 400


def test_facturacion_cobros_e_historial(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    plan, sus = _plan_y_suscripcion(db_session, t1)

    vencimiento = (datetime.utcnow() + timedelta(days=15)).isoformat()
    creada = client.post("/api/v1/invoices", json={
        "idsuscripcion": sus.idsuscripcion,
        "numero": f"FAC-S4-{uuid.uuid4().hex[:8]}",
        "fechavencimiento": vencimiento,
        "items": [{"concepto": "Suscripción mensual", "cantidad": 1, "preciounitario": "99.00"}],
    }, headers=auth_headers)
    assert creada.status_code == 201, creada.text
    factura = creada.json()
    assert factura["monto"] == "99.00"
    assert factura["saldo"] == "99.00"
    idfactura = factura["idfactura"]

    mal = client.post(
        f"/api/v1/invoices/{idfactura}/charges",
        json={"monto": "200.00", "metodopago": "transferencia"},
        headers=auth_headers,
    )
    assert mal.status_code == 400

    cobro = client.post(
        f"/api/v1/invoices/{idfactura}/charges",
        json={"monto": "99.00", "metodopago": "transferencia", "referencia": "TX-S4-1"},
        headers=auth_headers,
    )
    assert cobro.status_code == 200, cobro.text
    assert cobro.json()["saldo"] == "0.00"
    assert cobro.json()["estado"] == "pagada"

    historial = client.get("/api/v1/billing/history", headers=auth_headers)
    assert historial.status_code == 200, historial.text
    assert historial.json()["cobros"] >= 1
    assert Decimal(historial.json()["saldopendiente"]) >= 0

    listado = client.get("/api/v1/invoices", headers=auth_headers)
    assert listado.status_code == 200
    assert idfactura in [f["idfactura"] for f in listado.json()["items"]]


def test_factura_de_otro_tenant_404(client, db_session, setup_test_data, auth_headers):
    t2 = setup_test_data["tenant2"]
    from app.packages.p8_suscripciones.models.cu039_facturacion.factura import Factura
    ajena = Factura(
        idtenant=t2.idtenant,
        numero=f"AJENA-{uuid.uuid4().hex[:8]}",
        fechaemision=datetime.utcnow(),
        fechavencimiento=datetime.utcnow() + timedelta(days=10),
        monto=Decimal("50.00"),
        moneda="USD",
        estado="pendiente",
    )
    db_session.add(ajena)
    db_session.commit()
    assert client.get(f"/api/v1/invoices/{ajena.idfactura}", headers=auth_headers).status_code == 404


def test_notificaciones_facturacion_y_push_cu005(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    plan, sus = _plan_y_suscripcion(db_session, t1, dias_vencimiento=3)
    sus.fechafin = datetime.utcnow() + timedelta(days=2)
    db_session.commit()

    procesar = client.post(
        "/api/v1/billing/notifications/process",
        json={"diasanticipacion": 7, "incluirvencidas": True},
        headers=auth_headers,
    )
    assert procesar.status_code == 200, procesar.text
    assert procesar.json()["enviadas"] >= 1

    historial = client.get("/api/v1/billing/notifications", headers=auth_headers)
    assert historial.status_code == 200, historial.text
    assert historial.json()["enviadas"] >= 1

    antes = db_session.query(Notificacion).count()
    push = client.post("/api/v1/notifications/push", json={
        "titulo": "Prueba CU-005",
        "contenido": "Notificación push de prueba",
        "enlaceaccion": "/dashboard",
    }, headers=auth_headers)
    assert push.status_code == 200, push.text
    assert push.json()["destinatarios"] >= 1
    assert db_session.query(Notificacion).count() > antes


def test_procesar_notificaciones_aisla_tenant(client, db_session, setup_test_data, auth_headers):
    """CU-040: procesar vencimientos solo afecta al tenant activo (ADR-001)."""
    t1 = setup_test_data["tenant1"]
    t2 = setup_test_data["tenant2"]

    _, sus_t1 = _plan_y_suscripcion(db_session, t1, dias_vencimiento=3)
    sus_t1.fechafin = datetime.utcnow() + timedelta(days=2)
    _, sus_t2 = _plan_y_suscripcion(db_session, t2, dias_vencimiento=3)
    sus_t2.fechafin = datetime.utcnow() + timedelta(days=2)
    db_session.commit()

    procesar = client.post(
        "/api/v1/billing/notifications/process",
        json={"diasanticipacion": 7, "incluirvencidas": True},
        headers=auth_headers,
    )
    assert procesar.status_code == 200, procesar.text
    ids = [item["id"] for item in procesar.json()["items"]]

    assert f"suscripcion-{sus_t1.idsuscripcion}" in ids
    assert f"suscripcion-{sus_t2.idsuscripcion}" not in ids
