"""Tests de las recomendaciones de pricing e inventario generados por IA (CU-008 + IA)."""

import time
from datetime import date, datetime, timedelta
from decimal import Decimal

import pytest

from app.models.cu009_categorias.category import Categoria
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant
from app.models.cu010_ordenes_compra.purchase import Compra, CompraDetalle
from app.models.cu012_recepciones.reception import RecepcionCompra, RecepcionDetalle
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.services.ai.pricing_recommender import build_pricing_recommendations


@pytest.fixture
def catalogo_ai(db_session, setup_test_data):
    """Crea productos, variantes y entradas de catálogo para el tenant 1.

    Devuelve un dict con los idvariante creados para poder afirmar sobre cada regla.
    """
    tenant = setup_test_data["tenant1"]
    cat = setup_test_data["tenant2"]

    categoria = db_session.query(Categoria).first()
    if categoria is None:
        pytest.skip("No hay categorias en la base de datos para crear productos de prueba")

    suffix = int(time.time() * 1000)

    def crear_variante(nombre: str, precio: float) -> VarianteProducto:
        producto = Producto(
            idcategoria=categoria.idcategoria,
            nombre=nombre,
            modelo=f"MOD-{suffix}",
            paisorigen="EEUU",
            activo=True,
        )
        db_session.add(producto)
        db_session.flush()

        variante = VarianteProducto(
            idproducto=producto.idproducto,
            capacidad="128GB",
            color="Negro",
            sku=f"AI-{suffix}-{producto.idproducto}",
            preciousd=Decimal(str(precio)),
        )
        db_session.add(variante)
        db_session.flush()
        return variante

    def agregar_catalogo(tenant_obj, variante: VarianteProducto, precio: float, costo: float):
        item = CatalogoTenant(
            idtenant=tenant_obj.idtenant,
            idvariante=variante.idvariante,
            skuinterno=f"INT-{suffix}-{variante.idvariante}",
            precioventa=Decimal(str(precio)),
            costopromedio=Decimal(str(costo)),
            activo=True,
        )
        db_session.add(item)
        db_session.flush()
        return item

    def agregar_unidades(tenant_obj, variante: VarianteProducto, estado: str, cantidad: int, dias_atras: int = 5):
        for i in range(cantidad):
            db_session.add(
                UnidadProducto(
                    idtenant=tenant_obj.idtenant,
                    idvariante=variante.idvariante,
                    numeroserie=f"SN-{estado}-{variante.idvariante}-{suffix}-{i}",
                    uuidpublico=f"uuid-{estado}-{variante.idvariante}-{suffix}-{i}",
                    estado=estado,
                    fechaingreso=datetime.utcnow() - timedelta(days=dias_atras + 10),
                    fechaventa=(
                        datetime.utcnow() - timedelta(days=dias_atras)
                        if estado == "vendido"
                        else None
                    ),
                )
            )

    ids = {}

    proveedor = ActorCadena(
        idtenant=tenant.idtenant,
        nombre=f"Proveedor IA {suffix}",
        nit=f"NIT-{suffix}",
        email=f"prov_{suffix}@test.com",
        tipoactor="PROVEEDOR_EEUU",
    )
    db_session.add(proveedor)
    db_session.flush()

    ubicacion = Ubicacion(
        idtenant=tenant.idtenant,
        nombre=f"Almacén IA {suffix}",
        ciudad="Santa Cruz",
        pais="Bolivia",
        tipo="almacen",
    )
    db_session.add(ubicacion)
    db_session.flush()

    # Regla 1: MARGEN_NEGATIVO (precio 800, costo 900)
    v = crear_variante("Producto Margen Negativo", 800)
    agregar_catalogo(tenant, v, 800, 900)
    ids["margen_negativo"] = v.idvariante

    # Regla 2: SUBIR_PRECIO (rotacion alta + margen < 15%)
    # 10 vendidas en 30 dias -> rotacion ~10 und/mes, margen (1000-920)/1000 = 8%
    v = crear_variante("Producto Rotacion Alta", 1000)
    agregar_catalogo(tenant, v, 1000, 920)
    agregar_unidades(tenant, v, "vendido", 10, dias_atras=30)
    ids["subir_precio"] = v.idvariante

    # Regla 3 + 4: BAJAR_PRECIO y SOBRESTOCK (margen 70%, 0 ventas, 6 disponibles)
    v = crear_variante("Producto Sobrestock", 1000)
    agregar_catalogo(tenant, v, 1000, 300)
    agregar_unidades(tenant, v, "disponible", 6)
    ids["sobrestock"] = v.idvariante

    # Regla 5: REPOSICION_URGENTE (rotacion alta, 1 disponible)
    v = crear_variante("Producto Reposicion Urgente", 1000)
    agregar_catalogo(tenant, v, 1000, 700)
    agregar_unidades(tenant, v, "vendido", 12, dias_atras=30)
    agregar_unidades(tenant, v, "disponible", 1)
    ids["reposicion"] = v.idvariante

    # Regla 6: RIESGO_DEVOLUCION (4 vendidas, 2 devueltas = 50%)
    v = crear_variante("Producto Alto Devolucion", 1000)
    agregar_catalogo(tenant, v, 1000, 700)
    agregar_unidades(tenant, v, "vendido", 4, dias_atras=60)
    agregar_unidades(tenant, v, "devuelto", 2)
    ids["devolucion"] = v.idvariante

    # Regla 7: BRECHA_DEMANDA (10 pedidas, 2 vendidas, rotacion baja)
    # 2 vendidas en 120 dias -> rotacion 0.50 und/mes (por debajo de 1.0 para no chocar con otras reglas)
    v = crear_variante("Producto Brecha Demanda", 1000)
    agregar_catalogo(tenant, v, 1000, 700)
    agregar_unidades(tenant, v, "vendido", 2, dias_atras=120)

    compra = Compra(
        idtenant=tenant.idtenant,
        idproveedor=proveedor.idactor,
        numeroorden=f"OC-{suffix}",
        fechacompra=date.today(),
        totalusd=Decimal("5000.00"),
        estado="recibida_parcial",
    )
    db_session.add(compra)
    db_session.flush()
    db_session.add(
        CompraDetalle(
            idcompra=compra.idcompra,
            idvariante=v.idvariante,
            cantidad=10,
            costounitariousd=Decimal("500.00"),
            subtotalusd=Decimal("5000.00"),
        )
    )

    recepcion = RecepcionCompra(
        idcompra=compra.idcompra,
        idubicacion=ubicacion.idubicacion,
        numerodocumento=f"REC-{suffix}",
        estado="parcial",
    )
    db_session.add(recepcion)
    db_session.flush()
    db_session.add(
        RecepcionDetalle(
            idrecepcion=recepcion.idrecepcion,
            idvariante=v.idvariante,
            cantidadesperada=10,
            cantidadrecibida=4,
        )
    )

    ids["brecha"] = v.idvariante

    # Variante del tenant 2 para verificar aislamiento multi-tenant
    v_otro = crear_variante("Producto Otro Tenant", 800)
    agregar_catalogo(cat, v_otro, 800, 900)
    agregar_unidades(cat, v_otro, "vendido", 3)
    ids["otro_tenant"] = v_otro.idvariante

    db_session.commit()

    return {"tenant1": tenant.idtenant, "tenant2": cat.idtenant, "ids": ids}


def _tipos_por_variante(resultado):
    mapa = {}
    for rec in resultado["recomendaciones"]:
        mapa.setdefault(rec["idvariante"], set()).add(rec["tipo"])
    return mapa


# ---------------------------------------------------------------------------
# Reglas de negocio
# ---------------------------------------------------------------------------


def test_detecta_margen_negativo(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=50)
    tipos = _tipos_por_variante(resultado)
    assert "MARGEN_NEGATIVO" in tipos[catalogo_ai["ids"]["margen_negativo"]]

    rec = next(
        r for r in resultado["recomendaciones"]
        if r["idvariante"] == catalogo_ai["ids"]["margen_negativo"]
        and r["tipo"] == "MARGEN_NEGATIVO"
    )
    assert rec["prioridad"] == "critica"
    assert rec["metricas"]["margen_pct"] < 0
    assert rec["accion_sugerida"]


def test_detecta_subir_precio_con_precio_sugerido(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=50)
    tipos = _tipos_por_variante(resultado)
    assert "SUBIR_PRECIO" in tipos[catalogo_ai["ids"]["subir_precio"]]

    rec = next(
        r for r in resultado["recomendaciones"]
        if r["idvariante"] == catalogo_ai["ids"]["subir_precio"]
        and r["tipo"] == "SUBIR_PRECIO"
    )
    assert rec["prioridad"] == "alta"
    # Precio original 1000, sugerencia +8% = 1080
    assert rec["metricas"]["precio_sugerido_usd"] == pytest.approx(1080.0, abs=0.01)


def test_detecta_bajar_precio_por_margen_alto_sin_ventas(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=50)
    tipos = _tipos_por_variante(resultado)
    assert "BAJAR_PRECIO" in tipos[catalogo_ai["ids"]["sobrestock"]]

    rec = next(
        r for r in resultado["recomendaciones"]
        if r["idvariante"] == catalogo_ai["ids"]["sobrestock"]
        and r["tipo"] == "BAJAR_PRECIO"
    )
    # Precio original 1000, sugerencia -10% = 900
    assert rec["metricas"]["precio_sugerido_usd"] == pytest.approx(900.0, abs=0.01)


def test_detecta_sobrestock(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=50)
    tipos = _tipos_por_variante(resultado)
    assert "SOBRESTOCK" in tipos[catalogo_ai["ids"]["sobrestock"]]


def test_detecta_reposicion_urgente(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=50)
    tipos = _tipos_por_variante(resultado)
    assert "REPOSICION_URGENTE" in tipos[catalogo_ai["ids"]["reposicion"]]

    rec = next(
        r for r in resultado["recomendaciones"]
        if r["idvariante"] == catalogo_ai["ids"]["reposicion"]
        and r["tipo"] == "REPOSICION_URGENTE"
    )
    assert rec["prioridad"] == "alta"
    assert rec["metricas"]["disponibles"] <= 2


def test_detecta_riesgo_de_devolucion(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=50)
    tipos = _tipos_por_variante(resultado)
    assert "RIESGO_DEVOLUCION" in tipos[catalogo_ai["ids"]["devolucion"]]

    rec = next(
        r for r in resultado["recomendaciones"]
        if r["idvariante"] == catalogo_ai["ids"]["devolucion"]
        and r["tipo"] == "RIESGO_DEVOLUCION"
    )
    assert rec["metricas"]["devolucion_pct"] >= 20.0


def test_detecta_brecha_de_demanda(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=50)
    tipos = _tipos_por_variante(resultado)
    assert "BRECHA_DEMANDA" in tipos[catalogo_ai["ids"]["brecha"]]

    rec = next(
        r for r in resultado["recomendaciones"]
        if r["idvariante"] == catalogo_ai["ids"]["brecha"]
        and r["tipo"] == "BRECHA_DEMANDA"
    )
    assert rec["metricas"]["pedidas"] == 10
    assert rec["metricas"]["brecha_demanda"] == 8


# ---------------------------------------------------------------------------
# Comportamiento general del motor
# ---------------------------------------------------------------------------


def test_aislamiento_por_tenant(db_session, catalogo_ai):
    """Las recomendaciones de un tenant no deben incluir variantes de otro."""
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=100)
    ids_devueltos = {r["idvariante"] for r in resultado["recomendaciones"]}
    assert catalogo_ai["ids"]["otro_tenant"] not in ids_devueltos

    resultado_otro = build_pricing_recommendations(db_session, catalogo_ai["tenant2"], top_n=100)
    ids_otro = {r["idvariante"] for r in resultado_otro["recomendaciones"]}
    assert ids_otro == {catalogo_ai["ids"]["otro_tenant"]}


def test_ordenado_por_prioridad(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=100)
    orden = {"critica": 0, "alta": 1, "media": 2, "baja": 3}
    prioridades = [orden[r["prioridad"]] for r in resultado["recomendaciones"]]
    assert prioridades == sorted(prioridades), "Las recomendaciones deben venir ordenadas por prioridad"


def test_top_n_limita_resultados(db_session, catalogo_ai):
    total = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=100)
    limitado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=2)
    assert len(limitado["recomendaciones"]) == 2
    assert limitado["total_recomendaciones"] == total["total_recomendaciones"]


def test_estructura_de_respuesta(db_session, catalogo_ai):
    resultado = build_pricing_recommendations(db_session, catalogo_ai["tenant1"], top_n=100)

    assert resultado["tenant_id"] == catalogo_ai["tenant1"]
    assert resultado["generated_at"]
    assert resultado["total_recomendaciones"] >= len(resultado["recomendaciones"])

    for rec in resultado["recomendaciones"]:
        assert rec["idvariante"]
        assert rec["tipo"] in {
            "MARGEN_NEGATIVO",
            "SUBIR_PRECIO",
            "BAJAR_PRECIO",
            "SOBRESTOCK",
            "REPOSICION_URGENTE",
            "RIESGO_DEVOLUCION",
            "BRECHA_DEMANDA",
        }
        assert rec["prioridad"] in {"critica", "alta", "media", "baja"}
        assert rec["titulo"] and rec["justificacion"] and rec["accion_sugerida"]
        assert isinstance(rec["evidencia"], list)
        assert isinstance(rec["metricas"], dict)


# ---------------------------------------------------------------------------
# Endpoint HTTP
# ---------------------------------------------------------------------------


def test_endpoint_requiere_autenticacion(client):
    resp = client.post("/api/v1/tenant-catalog/recommendations", json={"top_n": 5})
    assert resp.status_code in (401, 403)


def test_endpoint_devuelve_recomendaciones(client, auth_headers):
    resp = client.post("/api/v1/tenant-catalog/recommendations", json={"top_n": 5}, headers=auth_headers)
    assert resp.status_code == 200

    data = resp.json()
    assert data["tenant_id"]
    assert isinstance(data["recomendaciones"], list)
    assert len(data["recomendaciones"]) <= 5
    assert data["total_recomendaciones"] >= len(data["recomendaciones"])

    for rec in data["recomendaciones"]:
        assert "tipo" in rec and "prioridad" in rec
        assert "metricas" in rec and "evidencia" in rec


def test_endpoint_rechaza_campos_desconocidos(client, auth_headers):
    resp = client.post(
        "/api/v1/tenant-catalog/recommendations",
        json={"top_n": 5, "campo_inventado": "x"},
        headers=auth_headers,
    )
    assert resp.status_code == 422