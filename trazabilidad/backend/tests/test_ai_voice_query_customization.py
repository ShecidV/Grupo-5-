"""Personalización del Asistente de Informes Dinámicos por Voz.

Cubre el parser determinista (período, top N, métrica, estado), el ranking de
productos por tenant, el aislamiento multi-tenant (incluida la bitácora) y la
validación de tenant en la descarga PDF/Excel.
"""
from datetime import datetime, timedelta
from decimal import Decimal
import uuid

from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant
from app.models.cu009_categorias.category import Categoria
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta, VentaDetalle
from app.controllers.shared import get_bolivia_now
from app.services.ai.voice_query_parser import parse_query, parse_detail_period


AHORA = datetime(2026, 11, 20, 10, 30)


# ------------------------------------------------------------------ parser
def test_parser_entiende_top_10_y_ultimo_trimestre():
    parsed = parse_query(
        "¿Cuáles fueron los 10 productos más vendidos en el último trimestre o 3 meses?",
        now=AHORA,
    )
    assert parsed.intent == "ventas"
    assert parsed.limit == 10
    assert parsed.metric == "unidades"
    assert parsed.desde == datetime(2026, 9, 1)
    assert parsed.hasta == datetime(2026, 12, 1)
    assert "3 meses" in parsed.period_label
    assert "Top 10" in parsed.interpretation()


def test_parser_entiende_metrica_ingresos_y_filtro_estado():
    parsed = parse_query("top 5 por ingresos de ventas pagadas en los últimos 6 meses", now=AHORA)
    assert parsed.intent == "ventas"
    assert parsed.limit == 5
    assert parsed.metric == "ingresos"
    assert parsed.estado == "pagada"
    assert parsed.desde == datetime(2026, 6, 1)


def test_parser_top_excesivo_se_acota_y_consulta_sin_fecha_es_historica():
    ranking = parse_query("top 999 productos", now=AHORA)
    assert ranking.limit == 50
    stock = parse_query("¿cuánto stock de iPhones hay disponible?", now=AHORA)
    assert stock.intent == "inventario"
    assert stock.desde is None
    assert stock.hasta is None
    assert stock.period_label == "todo el historico"


# ------------------------------------------------------------------ helpers
def _crear_venta(db, tenant, nombre_producto, cantidad, precio, fecha):
    sufijo = uuid.uuid4().hex[:10]
    categoria = Categoria(nombrecategoria=f"Cat Voz-{sufijo}")
    db.add(categoria)
    db.flush()

    producto = Producto(
        idcategoria=categoria.idcategoria,
        nombre=f"{nombre_producto}-{sufijo[:5]}",
        modelo=nombre_producto,
        paisorigen="EEUU",
    )
    db.add(producto)
    db.flush()

    variante = VarianteProducto(
        idproducto=producto.idproducto,
        sku=f"SKUVOZ-{sufijo}",
        color="Titanio",
        capacidad="256GB",
    )
    cliente = ActorCadena(
        idtenant=tenant.idtenant,
        nombre=f"Cliente Voz {sufijo}",
        email=f"voz{sufijo}@test.com",
        tipoactor="CONSUMIDOR",
    )
    db.add_all([variante, cliente])
    db.flush()

    total = Decimal(str(precio)) * cantidad
    venta = Venta(
        idtenant=tenant.idtenant,
        idcliente=cliente.idactor,
        total=total,
        estado="pagada",
        fechaventa=fecha,
    )
    db.add(venta)
    db.flush()
    db.add(
        VentaDetalle(
            idventa=venta.idventa,
            idvariante=variante.idvariante,
            cantidad=cantidad,
            preciounitario=Decimal(str(precio)),
            subtotal=total,
        )
    )
    db.commit()
    return producto


def _publicar_en_catalogo(db, tenant, producto, precio=1200):
    from sqlalchemy import select
    variante = db.execute(
        select(VarianteProducto).where(VarianteProducto.idproducto == producto.idproducto)
    ).scalar_one()
    db.add(
        CatalogoTenant(
            idtenant=tenant.idtenant,
            idvariante=variante.idvariante,
            skuinterno=f"INT-{tenant.idtenant}-{producto.idproducto}",
            precioventa=Decimal(str(precio)),
            costopromedio=Decimal(str(precio)) / 2,
            activo=True,
        )
    )
    db.commit()
    return variante


def _crear_unidad(db, tenant, variante, fecha, estado="vendido"):
    db.add(
        UnidadProducto(
            idtenant=tenant.idtenant,
            idvariante=variante.idvariante,
            numeroserie=f"SER-{uuid.uuid4().hex[:12]}",
            estado=estado,
            fechaingreso=fecha,
            fechaventa=fecha if estado == "vendido" else None,
        )
    )
    db.commit()


# -------------------------------------------------------------- integración
def test_ranking_top_10_ultimo_trimestre(client, db_session, setup_test_data, auth_headers):
    t1 = setup_test_data["tenant1"]
    fecha = datetime.utcnow() - timedelta(days=10)
    producto = _crear_venta(db_session, t1, "iPhone Voz Ranking", 12, 1000, fecha)
    _crear_venta(db_session, t1, "iPad Voz Ranking", 3, 800, fecha)

    resp = client.post(
        "/api/v1/ai/voice-report",
        json={
            "query": "¿Cuáles fueron los 10 productos más vendidos en el último trimestre o 3 meses?"
        },
        headers=auth_headers,
    )
    assert resp.status_code == 200, resp.text
    data = resp.json()
    assert data["category"] == "ventas"
    assert data["filters_applied"]["limite"] == 10
    assert data["filters_applied"]["metrica"] == "unidades"
    assert "3 meses" in data["period_label"]
    assert "Empresa Test 1" in data["interpretation"]
    assert data["suggested_followups"]

    filas = data["table_rows"]
    assert len(filas) >= 2
    assert filas[0][1] == producto.nombre
    unidades = [fila[2] for fila in filas]
    assert unidades == sorted(unidades, reverse=True)


def test_ranking_por_ingresos_aisla_otro_tenant(client, db_session, setup_test_data, auth_headers):
    t1, t2 = setup_test_data["tenant1"], setup_test_data["tenant2"]
    fecha = datetime.utcnow() - timedelta(days=20)
    _crear_venta(db_session, t1, "iPhone Muchas Unidades", 10, 100, fecha)
    lider = _crear_venta(db_session, t1, "MacBook Mayor Ingreso", 2, 1000, fecha)
    ajeno = _crear_venta(db_session, t2, "Producto Ajeno Voz", 999, 1, fecha)

    resp = client.post(
        "/api/v1/ai/voice-report",
        json={"query": "top 1 por ingresos en los últimos 6 meses"},
        headers=auth_headers,
    )
    assert resp.status_code == 200, resp.text
    data = resp.json()
    assert data["filters_applied"]["metrica"] == "ingresos"
    assert data["filters_applied"]["limite"] == 1
    assert len(data["table_rows"]) == 1
    assert data["table_rows"][0][1] == lider.nombre
    assert ajeno.nombre not in [fila[1] for fila in data["table_rows"]]


def test_auditoria_por_voz_no_filtra_otro_tenant(client, db_session, setup_test_data, auth_headers):
    t1, t2 = setup_test_data["tenant1"], setup_test_data["tenant2"]
    ut1 = db_session.execute(
        select_usuario_tenant(db_session, setup_test_data["user1"], t1)
    ).scalar_one()
    ut2 = db_session.execute(
        select_usuario_tenant(db_session, setup_test_data["user2"], t2)
    ).scalar_one()
    fecha = datetime.utcnow() - timedelta(days=2)
    db_session.add_all([
        Bitacora(idusuariotenant=ut1.idusuariotenant, accion="GET", entidad="test", ip="10.0.0.1", fechahora=fecha),
        Bitacora(idusuariotenant=ut2.idusuariotenant, accion="GET", entidad="test", ip="10.0.0.2", fechahora=fecha),
    ])
    db_session.commit()

    resp = client.post(
        "/api/v1/ai/voice-report",
        json={"query": "resumen de bitácora y auditoría de los últimos 3 meses"},
        headers=auth_headers,
    )
    assert resp.status_code == 200, resp.text
    data = resp.json()
    assert data["category"] == "auditoria"
    ips = [fila[3] for fila in data["table_rows"]]
    assert "10.0.0.1" in ips
    assert "10.0.0.2" not in ips


def select_usuario_tenant(db, user, tenant):
    from sqlalchemy import select
    return select(UsuarioTenant).where(
        UsuarioTenant.idusuario == user.idusuario,
        UsuarioTenant.idtenant == tenant.idtenant,
    )


def test_parser_detecta_analisis_detallado_y_rango_fijo():
    parsed = parse_query(
        "analisis detallado de iPhone en el ultimo mes", now=AHORA
    )
    assert parsed.intent == "ventas"
    assert parsed.wants_detail is True
    desde, hasta, etiqueta = parse_detail_period(AHORA)
    assert desde == datetime(2023, 12, 1)
    assert etiqueta == "ultimos 36 meses (dic 2023 - nov 2026)"
    assert "analisis_detallado" in parsed.filters_applied()
    assert parsed.filters_applied()["analisis_detallado"] is True


def test_detalle_producto_metricas_reales_y_rango_36m(
    client, db_session, setup_test_data, auth_headers
):
    t1 = setup_test_data["tenant1"]
    fecha = datetime.utcnow() - timedelta(days=10)
    producto = _crear_venta(db_session, t1, "iPhone Detalle", 9, 1500, fecha)
    variante = _publicar_en_catalogo(db_session, t1, producto)
    _crear_unidad(db_session, t1, variante, fecha, estado="vendido")
    _crear_unidad(db_session, t1, variante, fecha, estado="disponible")

    resp = client.post(
        "/api/v1/ai/voice-report",
        json={"query": f"analisis detallado de {producto.nombre} en el ultimo mes"},
        headers=auth_headers,
    )
    assert resp.status_code == 200, resp.text
    data = resp.json()
    detalle = data["product_detail"]
    assert detalle is not None
    assert "36 meses" in detalle["period_label"]
    esperado_desde, _, _ = parse_detail_period(get_bolivia_now())
    assert detalle["desde"] == esperado_desde.date().isoformat()
    assert "ultimo mes" in data["period_label"]  # la consulta principal no cambia

    metricas = detalle["metrics"]
    assert metricas["unidades_vendidas"] >= 9
    assert metricas["ingresos_usd"] >= 13500
    assert metricas["num_ventas"] >= 1
    assert metricas["unidades_totales"] >= 2
    assert metricas["unidades_disponibles"] >= 1
    assert detalle["table_rows"]
    assert any("Ingresos USD" in fila[0] for fila in detalle["table_rows"])


def test_detalle_no_expone_producto_de_otro_tenant(
    client, db_session, setup_test_data, auth_headers
):
    t2 = setup_test_data["tenant2"]
    fecha = datetime.utcnow() - timedelta(days=10)
    ajeno = _crear_venta(db_session, t2, "Producto Detalle Ajeno", 4, 900, fecha)
    _publicar_en_catalogo(db_session, t2, ajeno)

    resp = client.post(
        "/api/v1/ai/voice-report",
        json={"query": f"analisis detallado de {ajeno.nombre}"},
        headers=auth_headers,
    )
    assert resp.status_code == 200, resp.text
    assert resp.json()["product_detail"] is None


def test_exportacion_incluye_ficha_detallada(
    client, db_session, setup_test_data, auth_headers
):
    import io
    import openpyxl

    t1 = setup_test_data["tenant1"]
    fecha = datetime.utcnow() - timedelta(days=10)
    producto = _crear_venta(db_session, t1, "iPad Detalle Export", 2, 700, fecha)
    variante = _publicar_en_catalogo(db_session, t1, producto)
    _crear_unidad(db_session, t1, variante, fecha)

    generado = client.post(
        "/api/v1/ai/voice-report",
        json={"query": f"analisis detallado de {producto.nombre}"},
        headers=auth_headers,
    )
    assert generado.status_code == 200, generado.text
    report_id = generado.json()["report_id"]

    excel = client.get(
        f"/api/v1/ai/reports/{report_id}/export?format=excel", headers=auth_headers
    )
    assert excel.status_code == 200
    wb = openpyxl.load_workbook(io.BytesIO(excel.content))
    assert "Detalle Producto" in wb.sheetnames

    pdf = client.get(
        f"/api/v1/ai/reports/{report_id}/export?format=pdf", headers=auth_headers
    )
    assert pdf.status_code == 200
    assert pdf.content.startswith(b"%PDF")


def test_exportacion_rechaza_reporte_de_otra_empresa(client, setup_test_data, auth_headers):
    t2 = setup_test_data["tenant2"]
    generado = client.post(
        "/api/v1/ai/voice-report",
        json={"query": "stock disponible"},
        headers=auth_headers,
    )
    assert generado.status_code == 200, generado.text
    report_id = generado.json()["report_id"]

    propio = client.get(f"/api/v1/ai/reports/{report_id}/export?format=pdf", headers=auth_headers)
    assert propio.status_code == 200
    assert propio.content.startswith(b"%PDF")

    cambiado = client.post(
        f"/api/v1/auth/switch-tenant/{t2.idtenant}", headers=auth_headers
    )
    assert cambiado.status_code == 200, cambiado.text
    headers_otra = {"Authorization": f"Bearer {cambiado.json()['access_token']}"}
    ajeno = client.get(
        f"/api/v1/ai/reports/{report_id}/export?format=pdf", headers=headers_otra
    )
    assert ajeno.status_code == 404
