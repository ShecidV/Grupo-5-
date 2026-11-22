"""Pobla 6 meses de datos historicos por empresa (tenant) en la BD local.

Diseno:
  * Fechas relativas a ``get_bolivia_now()`` (nunca fechas hardcodeadas).
  * Claves naturales deterministas por (tenant, periodo) -> re-ejecutar es no-op.
  * Un ``manifest`` con los IDs insertados permite ``--reset-history`` sin
    tocar datos operacionales del seed canonico.
  * ``--dry-run`` ejecuta toda la logica (incluye flush para resolver FKs)
    pero hace rollback al final: no escribe nada en la BD.

Uso:
    python seed_historical_6m.py --dry-run
    python seed_historical_6m.py
    python seed_historical_6m.py --reset-history
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
import traceback
from collections import Counter
from datetime import date, datetime, timedelta
from decimal import Decimal
from pathlib import Path
from typing import Any, Callable, Dict, List, Optional, Tuple

from sqlalchemy import bindparam, inspect as sa_inspect, select, text

from app.controllers.shared import get_bolivia_now
from app.db.session import SessionLocal

# P1 (shims historicos)
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu005_bitacora.bitacora import Bitacora
from app.models.cu005_bitacora.notification import Notificacion
# P2
from app.packages.p2_catalogo.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant
from app.packages.p2_catalogo.models.cu010_ordenes_compra.purchase import Compra, CompraDetalle
from app.packages.p2_catalogo.models.cu012_recepciones.reception import RecepcionCompra, RecepcionDetalle
# P3
from app.packages.p3_actores.models.cu013_actores_cadena.actor import ActorCadena
from app.packages.p3_actores.models.cu014_ubicaciones.location import Ubicacion
# P4
from app.packages.p4_trazabilidad.models.cu015_unidades_producto.unit import UnidadProducto
from app.packages.p4_trazabilidad.models.cu016_codigos_qr.qr_code import CodigoQR
from app.packages.p4_trazabilidad.models.cu018_trazabilidad.consulta_trazabilidad import ConsultaTrazabilidad
from app.packages.p4_trazabilidad.models.cu019_envios_logisticos.shipment import Envio
from app.packages.p4_trazabilidad.models.cu020_asignacion_unidades_envio.shipment_unit import EnvioUnidad
from app.packages.p4_trazabilidad.models.cu021_eventos_transporte.transport_event import (
    Alerta, CondicionTransporte, EventoUnidad, EventoTrazabilidad,
)
from app.packages.p4_trazabilidad.models.cu023_reporte_sospecha.suspicion_report import (
    ReporteSospecha, ReporteSospechaEvidencia,
)
# P5
from app.packages.p5_comercial.models.cu025_ventas.venta import Venta, VentaDetalle
from app.packages.p5_comercial.models.cu026_asignacion_unidades_venta.venta_unidad import VentaUnidad
from app.packages.p5_comercial.models.cu027_pagos.pago import Pago
from app.packages.p5_comercial.models.cu029_devoluciones.devolucion import Devolucion
from app.packages.p5_comercial.models.cu030_asignacion_devolucion.devolucion_unidad import DevolucionUnidad
from app.packages.p5_comercial.models.cu031_garantias.garantia import GarantiaUnidad
from app.packages.p5_comercial.models.cu032_documentos_unidad.documento_unidad import DocumentoUnidad
# P6
from app.packages.p6_blockchain.models.cu033_blockchain.registro_blockchain import RegistroBlockchain
# P8
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Plan, Suscripcion
from app.packages.p8_suscripciones.models.cu038_cuotas.uso_plan import UsoPlan
from app.packages.p8_suscripciones.models.cu039_facturacion.factura import Cobro, Factura, FacturaDetalle

MANIFEST = Path(__file__).with_name("seed_historical_6m.manifest.json")
PREFIJO = "HIST"
MESES = 6
UNIDADES_POR_MES = 12
VENTAS_POR_MES = 4
EVENTOS_POR_MES = 4
ALERTAS_POR_MES = 3
DOCUMENTOS_POR_MES = 3

TIPOS_EVENTO = [
    "fabricacion", "control_calidad_apple", "exportacion", "transporte_maritimo",
    "transporte_aereo", "llegada_puerto", "despacho_aduanero", "transporte_terrestre",
    "recepcion_almacen", "venta", "devolucion", "retiro",
]
TIPOS_ALERTA = [
    "temperatura", "humedad", "vibracion", "retraso_aduanero",
    "vencimiento_garantia", "fraude_autenticidad", "inconsistencia_cadena",
]
GRAVEDADES = ["baja", "media", "alta", "critica"]
TIPOS_DOCUMENTO = [
    "factura_compra", "certificado_importacion", "comprobante_garantia",
    "certificado_autenticidad", "informe_tecnico",
]
TIPOS_ANOMALIA = ["fraude_autenticidad", "empaque_vulnerado", "discrepancia_serial"]
ESTADOS_REPORTE = ["pendiente", "en_revision", "resuelta", "rechazada"]
METODOS_PAGO = ["transferencia", "tarjeta_credito", "efectivo"]

MODELOS: Dict[str, Any] = {
    "actorcadena": ActorCadena, "compra": Compra, "compradetalle": CompraDetalle,
    "recepcioncompra": RecepcionCompra, "recepciondetalle": RecepcionDetalle,
    "unidadproducto": UnidadProducto, "codigoqr": CodigoQR, "envio": Envio,
    "enviounidad": EnvioUnidad, "eventotrazabilidad": EventoTrazabilidad,
    "eventounidad": EventoUnidad, "condiciontransporte": CondicionTransporte,
    "registroblockchain": RegistroBlockchain, "venta": Venta,
    "ventadetalle": VentaDetalle, "ventaunidad": VentaUnidad, "pago": Pago,
    "devolucion": Devolucion, "devolucionunidad": DevolucionUnidad,
    "garantiaunidad": GarantiaUnidad, "documentounidad": DocumentoUnidad,
    "alerta": Alerta, "reportesospecha": ReporteSospecha,
    "reportesospechaevidencia": ReporteSospechaEvidencia,
    "bitacora": Bitacora, "notificacion": Notificacion,
    "consultatrazabilidad": ConsultaTrazabilidad, "usoplan": UsoPlan,
    "factura": Factura, "facturadetalle": FacturaDetalle, "cobro": Cobro,
}

# Orden de insercion; su reverso es el orden de borrado (hijos antes que padres).
ORDEN_INSERCION: List[str] = [
    "actorcadena",
    "compra", "compradetalle", "recepcioncompra", "recepciondetalle",
    "unidadproducto", "codigoqr", "envio", "enviounidad",
    "eventotrazabilidad", "eventounidad", "condiciontransporte", "registroblockchain",
    "venta", "ventadetalle", "ventaunidad", "pago",
    "devolucion", "devolucionunidad", "garantiaunidad", "documentounidad",
    "alerta", "reportesospecha", "reportesospechaevidencia",
    "bitacora", "notificacion", "consultatrazabilidad",
    "usoplan", "factura", "facturadetalle", "cobro",
]


def semilla(*partes: Any) -> int:
    """Entero determinista a partir de cualquier combinacion de valores."""
    crudo = "|".join(str(p) for p in partes).encode("utf-8")
    return int(hashlib.sha256(crudo).hexdigest()[:12], 16)


def anio_mes(dt: datetime, delta: int) -> Tuple[int, int]:
    total = dt.year * 12 + (dt.month - 1) + delta
    return total // 12, total % 12 + 1


def dia_en_mes(anio: int, mes: int, sem: int, *, min_dia: int = 1, max_dia: int = 26) -> datetime:
    dia = min_dia + sem % (max_dia - min_dia + 1)
    hora = 7 + (sem // 32) % 12
    return datetime(anio, mes, dia, hora, 0)


def sha(*partes: Any) -> str:
    return hashlib.sha256("|".join(str(p) for p in partes).encode("utf-8")).hexdigest()


class Cargador:
    """Inserta o reutiliza entidades por clave natural y registra sus IDs."""

    def __init__(self, db: Any, dry_run: bool):
        self.db = db
        self.dry_run = dry_run
        self.creados: Counter = Counter()
        self.omitidos: Counter = Counter()
        self.ids: Dict[str, List[int]] = {t: [] for t in ORDEN_INSERCION}

    def get(self, model: Any, **filtros: Any) -> Any:
        return self.db.execute(select(model).filter_by(**filtros)).scalars().first()

    def add(self, model: Any, filtros: Dict[str, Any], factory: Callable[[], Any]) -> Any:
        existente = self.get(model, **filtros)
        if existente is not None:
            self.omitidos[model.__tablename__] += 1
            return existente
        obj = factory()
        self.db.add(obj)
        self.db.flush()
        tabla = model.__tablename__
        pk = sa_inspect(model).primary_key[0].name
        self.ids.setdefault(tabla, []).append(getattr(obj, pk))
        self.creados[tabla] += 1
        return obj

    def resumen(self) -> str:
        lineas = [
            f"  {t}: +{self.creados.get(t, 0)} (ya existian {self.omitidos.get(t, 0)})"
            for t in ORDEN_INSERCION
            if self.creados.get(t, 0) or self.omitidos.get(t, 0)
        ]
        return f"Total nuevos: {sum(self.creados.values())}\n" + "\n".join(lineas)


def cargar_manifest() -> Dict[str, List[int]]:
    if not MANIFEST.exists():
        return {}
    try:
        datos = json.loads(MANIFEST.read_text(encoding="utf-8"))
        return {k: list(v) for k, v in datos.get("ids", {}).items()}
    except (OSError, ValueError) as exc:
        print(f"[AVISO] No se pudo leer {MANIFEST.name}: {exc}")
        return {}


def guardar_manifest(ids: Dict[str, List[int]]) -> None:
    previos = cargar_manifest()
    for tabla, valores in ids.items():
        previos.setdefault(tabla, [])
        for valor in valores:
            if valor not in previos[tabla]:
                previos[tabla].append(valor)
    MANIFEST.write_text(json.dumps({"ids": previos}, indent=2), encoding="utf-8")
    print(f"  Manifest actualizado: {MANIFEST.name}")


def reset_historial(db: Any) -> None:
    ids = cargar_manifest()
    if not ids:
        print("[AVISO] No hay manifest; nada que borrar.")
        return
    total = 0
    for tabla in reversed(ORDEN_INSERCION):
        valores = ids.get(tabla) or []
        if not valores:
            continue
        model = MODELOS[tabla]
        pk = sa_inspect(model).primary_key[0].name
        stmt = (
            text(f"DELETE FROM {tabla} WHERE {pk} IN :ids")
            .bindparams(bindparam("ids", expanding=True))
        )
        borrados = db.execute(stmt, {"ids": valores}).rowcount
        total += borrados
        if borrados:
            print(f"  - {tabla}: {borrados}")
    db.commit()
    MANIFEST.unlink(missing_ok=True)
    print(f"Historial eliminado: {total} filas.")


def sincronizar_secuencias(db: Any) -> None:
    for tabla in ORDEN_INSERCION:
        model = MODELOS[tabla]
        pk = sa_inspect(model).primary_key[0].name
        try:
            db.execute(text(
                f"SELECT setval(pg_get_serial_sequence('{tabla}', '{pk}'), "
                f"coalesce((SELECT max({pk}) FROM {tabla}), 1))"
            ))
        except Exception as exc:  # pragma: no cover - secuencia inexistente
            print(f"  [AVISO] secuencia {tabla}.{pk}: {exc}")


def poblar_tenant(db: Any, cargador: Cargador, tenant: Tenant, ahora: datetime) -> None:
    tt = tenant.idtenant
    usuarios_ut = db.execute(
        select(UsuarioTenant).where(UsuarioTenant.idtenant == tt)
    ).scalars().all()
    if not usuarios_ut:
        print(f"  [OMITIR] tenant {tt}: sin usuarios vinculados")
        return
    ut = usuarios_ut[0]
    idusuario = ut.idusuario

    actores = db.execute(
        select(ActorCadena).where(ActorCadena.idtenant == tt)
    ).scalars().all()
    por_tipo: Dict[str, List[ActorCadena]] = {}
    for actor in actores:
        por_tipo.setdefault(actor.tipoactor, []).append(actor)

    proveedores = (
        por_tipo.get("PROVEEDOR_EEUU") or por_tipo.get("DISTRIBUIDOR")
        or por_tipo.get("IMPORTADOR") or actores
    )
    tiendas = por_tipo.get("TIENDA") or por_tipo.get("DISTRIBUIDOR") or actores
    transportistas = por_tipo.get("TRANSPORTISTA_INTERNACIONAL") or proveedores
    if not (proveedores and tiendas and transportistas):
        print(f"  [OMITIR] tenant {tt}: faltan actores de cadena")
        return

    ubicaciones = db.execute(
        select(Ubicacion).where(Ubicacion.idtenant == tt)
    ).scalars().all()
    if not ubicaciones:
        print(f"  [OMITIR] tenant {tt}: sin ubicaciones")
        return
    ubicacion = ubicaciones[0]

    catalogo = db.execute(
        select(CatalogoTenant).where(
            CatalogoTenant.idtenant == tt, CatalogoTenant.activo.is_(True)
        )
    ).scalars().all()[:3]
    if not catalogo:
        print(f"  [OMITIR] tenant {tt}: sin catalogo activo")
        return
    variantes = [c.idvariante for c in catalogo]
    precio_base = max((c.precioventa for c in catalogo), default=Decimal("1200.00"))
    if not precio_base or precio_base <= 0:
        precio_base = Decimal("1200.00")

    suscripcion = db.execute(
        select(Suscripcion).where(
            Suscripcion.idtenant == tt, Suscripcion.estado.in_(["activa", "trial"])
        ).order_by(Suscripcion.idsuscripcion)
    ).scalars().first()
    fila_plan = None
    if suscripcion is not None:
        fila_plan = db.get(Plan, suscripcion.idplan)
    monto_factura = (
        fila_plan.preciomensual
        if fila_plan and fila_plan.preciomensual
        else Decimal("99.00")
    )

    consumidor = cargador.add(
        ActorCadena,
        {"idtenant": tt, "nombre": f"CONSUMIDOR HISTORICO {tenant.nombre}"},
        lambda: ActorCadena(
            idtenant=tt,
            nombre=f"CONSUMIDOR HISTORICO {tenant.nombre}",
            nit=f"HIST-{tt}",
            email=f"historico{tt}@demo.local",
            tipoactor="CONSUMIDOR",
        ),
    )

    for desplazamiento in range(-(MESES - 1), 1):
        anio, mes = anio_mes(ahora, desplazamiento)
        periodo = f"{anio:04d}-{mes:02d}"
        unidades: List[UnidadProducto] = []
        eventos: List[EventoTrazabilidad] = []
        alerta_id: Optional[int] = None
        fecha_ultima_venta = dia_en_mes(anio, mes, semilla(tt, periodo, "vta", 0), min_dia=13)
        ultima_venta: Optional[Venta] = None

        # --- 1. Compra y recepcion -------------------------------------
        s = semilla(tt, periodo, "compra")
        compra = cargador.add(
            Compra,
            {"numeroorden": f"OC-{PREFIJO}-{tt:02d}-{periodo}"},
            lambda: Compra(
                idtenant=tt,
                idproveedor=proveedores[0].idactor,
                numeroorden=f"OC-{PREFIJO}-{tt:02d}-{periodo}",
                fechacompra=dia_en_mes(anio, mes, s, max_dia=6).date(),
                totalusd=(precio_base * UNIDADES_POR_MES).quantize(Decimal("0.01")),
                estado="recibida_total",
            ),
        )
        cantidades = [4, 4, 4]
        for idvariante, cantidad in zip(variantes, cantidades):
            detalle = cargador.add(
                CompraDetalle,
                {"idcompra": compra.idcompra, "idvariante": idvariante},
                lambda v=idvariante, c=cantidad: CompraDetalle(
                    idcompra=compra.idcompra, idvariante=v, cantidad=c,
                    costounitariousd=(precio_base * Decimal("0.6")).quantize(Decimal("0.01")),
                    subtotalusd=(precio_base * Decimal("0.6") * c).quantize(Decimal("0.01")),
                ),
            )

        recepcion = cargador.add(
            RecepcionCompra,
            {"numerodocumento": f"REC-{PREFIJO}-{tt:02d}-{periodo}"},
            lambda: RecepcionCompra(
                idcompra=compra.idcompra,
                idubicacion=ubicacion.idubicacion,
                numerodocumento=f"REC-{PREFIJO}-{tt:02d}-{periodo}",
                fecharecepcion=dia_en_mes(
                    anio, mes, semilla(tt, periodo, "rec"), max_dia=10
                ),
                estado="completa",
            ),
        )
        for idvariante, cantidad in zip(variantes, cantidades):
            cargador.add(
                RecepcionDetalle,
                {"idrecepcion": recepcion.idrecepcion, "idvariante": idvariante},
                lambda r=recepcion, v=idvariante, n=cantidad: RecepcionDetalle(
                    idrecepcion=r.idrecepcion, idvariante=v,
                    cantidadesperada=n, cantidadrecibida=n,
                ),
            )

        # --- 2. Unidades y QR -------------------------------------------
        estado_extra = "devuelto" if mes % 3 == 0 else "disponible"
        estados = (
            ["vendido"] * 6 + ["disponible"] * 2 + ["en_transito"] * 2
            + [estado_extra, "disponible"]
        )
        for idx, estado in enumerate(estados):
            serie = f"{PREFIJO}-{tt:02d}-{periodo.replace('-', '')}-{idx:03d}"
            uuid_publico = sha("uuid", tt, periodo, idx)
            fecha_ingreso = dia_en_mes(
                anio, mes, semilla(tt, periodo, "ing", idx), max_dia=12
            )
            fecha_venta = (
                dia_en_mes(anio, mes, semilla(tt, periodo, "ven", idx), min_dia=13)
                if estado == "vendido" else None
            )
            unidad = cargador.add(
                UnidadProducto,
                {"numeroserie": serie},
                lambda sr=serie, u=uuid_publico, fi=fecha_ingreso, fv=fecha_venta, e=estado, i=idx: UnidadProducto(
                    idtenant=tt,
                    idvariante=variantes[i % len(variantes)],
                    numeroserie=sr,
                    imei1=str(semilla("imei", sr))[:15],
                    uuidpublico=u,
                    idcustodioactual=tiendas[0].idactor,
                    idubicacionactual=ubicacion.idubicacion,
                    estado=e,
                    fechaingreso=fi,
                    fechaventa=fv,
                ),
            )
            unidades.append(unidad)
            token = f"hist-{tt}-{periodo}-{idx}-{uuid_publico[:16]}"
            qr = cargador.add(
                CodigoQR,
                {"tokenpublico": token},
                lambda tkn=token, fi=fecha_ingreso: CodigoQR(
                    idunidad=unidad.idunidad,
                    tokenpublico=tkn,
                    url=f"https://blockchain-production-8de2.up.railway.app/trace/{unidad.uuidpublico}",
                    fechageneracion=fi,
                    activo=True,
                ),
            )
            fecha_consulta = fecha_ingreso + timedelta(days=2)
            cargador.add(
                ConsultaTrazabilidad,
                {"idcodigoqr": qr.idcodigoqr, "fechahora": fecha_consulta},
                lambda c=qr, f=fecha_consulta: ConsultaTrazabilidad(
                    idcodigoqr=c.idcodigoqr, fechahora=f,
                    ip="190.2.10.10", paisaproximado="BO",
                    useragent="DemoApp/1.0 (historico)",
                ),
            )

        # Unidades en tránsito por variante activa (cada 6 meses). Esto evita
        # que la ficha detallada de cualquier producto muestre 0 en logística.
        if mes % 6 == 0:
            variantes_detalle = [
                c.idvariante
                for c in db.execute(
                    select(CatalogoTenant).where(
                        CatalogoTenant.idtenant == tt,
                        CatalogoTenant.activo.is_(True),
                    )
                ).scalars().all()
            ]
            for idx_tr, id_variante in enumerate(variantes_detalle):
                serie_tr = f"{PREFIJO}-{tt:02d}-{periodo.replace('-', '')}-TR{idx_tr:03d}"
                fecha_tr = dia_en_mes(
                    anio, mes, semilla(tt, periodo, "trn", idx_tr), max_dia=12
                )
                cargador.add(
                    UnidadProducto,
                    {"numeroserie": serie_tr},
                    lambda s=serie_tr, v=id_variante, f=fecha_tr: UnidadProducto(
                        idtenant=tt, idvariante=v, numeroserie=s,
                        imei1=str(semilla("imei", s))[:15],
                        uuidpublico=sha("uuid", s),
                        idcustodioactual=tiendas[0].idactor,
                        idubicacionactual=ubicacion.idubicacion,
                        estado="en_transito", fechaingreso=f,
                    ),
                )

        # --- 3. Envio ----------------------------------------------------
        envio = cargador.add(
            Envio,
            {"codigoenvio": f"ENV-{PREFIJO}-{tt:02d}-{periodo}"},
            lambda: Envio(
                idtenant=tt,
                idactororigen=proveedores[0].idactor,
                idactordestino=tiendas[0].idactor,
                idtransportista=transportistas[0].idactor,
                codigoenvio=f"ENV-{PREFIJO}-{tt:02d}-{periodo}",
                fechasalida=dia_en_mes(anio, mes, semilla(tt, periodo, "env"), max_dia=14),
                fechaestimada=dia_en_mes(anio, mes, semilla(tt, periodo, "est"), min_dia=15),
                fechaentrega=dia_en_mes(anio, mes, semilla(tt, periodo, "ent"), min_dia=20),
                estado="entregado",
                trackingexterno=f"TRK-{PREFIJO}-{tt}-{periodo}",
            ),
        )
        for unidad in unidades[:3]:
            cargador.add(
                EnvioUnidad,
                {"idenvio": envio.idenvio, "idunidad": unidad.idunidad},
                lambda e=envio, u=unidad: EnvioUnidad(idenvio=e.idenvio, idunidad=u.idunidad),
            )

        # --- 4. Eventos, condiciones y anclaje blockchain -----------------
        for idx in range(EVENTOS_POR_MES):
            tipo = TIPOS_EVENTO[((mes - 1) * EVENTOS_POR_MES + idx) % len(TIPOS_EVENTO)]
            descripcion = f"{PREFIJO} {tenant.nombre} · {periodo} · {tipo}"
            fecha_evento = dia_en_mes(
                anio, mes, semilla(tt, periodo, "evt", idx), min_dia=8
            )
            evento = cargador.add(
                EventoTrazabilidad,
                {"descripcion": descripcion},
                lambda d=descripcion, f=fecha_evento, t=tipo: EventoTrazabilidad(
                    idtenant=tt, tipoevento=t, fechahora=f,
                    idactororigen=proveedores[0].idactor,
                    idactordestino=tiendas[0].idactor,
                    idubicacion=ubicacion.idubicacion,
                    idusuarioresponsable=idusuario,
                    descripcion=d,
                    payloadhash=sha("evento", d)[:64],
                    estadoverificacion="verificado",
                ),
            )
            eventos.append(evento)
            unidad_evento = unidades[idx % len(unidades)]
            cargador.add(
                EventoUnidad,
                {"idevento": evento.idevento, "idunidad": unidad_evento.idunidad},
                lambda e=evento, u=unidad_evento: EventoUnidad(
                    idevento=e.idevento, idunidad=u.idunidad
                ),
            )
            cargador.add(
                CondicionTransporte,
                {"idevento": evento.idevento},
                lambda e=evento, f=fecha_evento: CondicionTransporte(
                    idevento=e.idevento, temperatura=Decimal("18.50"),
                    humedad=Decimal("55.00"), presion=Decimal("1013.25"),
                    nivelvibracion=Decimal("0.30"), timestampregistro=f,
                    fuentedatos=f"SENSOR-{PREFIJO}",
                ),
            )
            payload = sha("blockchain", tt, periodo, idx)
            cargador.add(
                RegistroBlockchain,
                {"payloadhash": payload},
                lambda e=evento, p=payload, f=fecha_evento: RegistroBlockchain(
                    idevento=e.idevento, payloadhash=p, txhash="0x" + sha("tx", p),
                    blocknumber=1000000 + semilla(p) % 100000,
                    network="sepolia", chainid="11155111",
                    contractaddress="0x" + sha("contract", p)[:40],
                    fechaenvio=f, fechaconfirmacion=f + timedelta(minutes=2),
                    estado="confirmado", numeroconfirmaciones=12,
                ),
            )

        # --- 5. Alertas ---------------------------------------------------
        for idx in range(ALERTAS_POR_MES):
            descripcion = f"{PREFIJO} alerta {tenant.nombre} {periodo} #{idx}"
            fecha_alerta = dia_en_mes(
                anio, mes, semilla(tt, periodo, "ala", idx), min_dia=10
            )
            resuelta = idx == 0
            alerta = cargador.add(
                Alerta,
                {"descripcion": descripcion},
                lambda d=descripcion, f=fecha_alerta, r=resuelta, i=idx: Alerta(
                    idtenant=tt,
                    idunidad=unidades[i % len(unidades)].idunidad,
                    idevento=eventos[i % len(eventos)].idevento,
                    tipoalerta=TIPOS_ALERTA[(i + mes) % len(TIPOS_ALERTA)],
                    descripcion=d, gravedad=GRAVEDADES[i % len(GRAVEDADES)],
                    fechadeteccion=f,
                    fecharesolucion=f + timedelta(hours=3) if r else None,
                    estado="resuelta" if r else "en_proceso",
                    idusuarioresolutor=idusuario if r else None,
                ),
            )
            if alerta_id is None:
                alerta_id = alerta.idalerta

        # --- 6. Ventas, pagos, garantias y devoluciones -------------------
        unidades_vendidas = [u for u in unidades if u.estado == "vendido"]
        cursor = 0
        for idx in range(VENTAS_POR_MES):
            cantidad = 2 if idx < 2 else 1
            asignadas = unidades_vendidas[cursor:cursor + cantidad]
            cursor += cantidad
            if not asignadas:
                break
            total = (precio_base * cantidad).quantize(Decimal("0.01"))
            fecha_venta = dia_en_mes(
                anio, mes, semilla(tt, periodo, "vta", idx), min_dia=13
            )
            fecha_ultima_venta = fecha_venta
            venta = cargador.add(
                Venta,
                {"idcliente": consumidor.idactor, "fechaventa": fecha_venta},
                lambda f=fecha_venta, t=total: Venta(
                    idtenant=tt, idcliente=consumidor.idactor,
                    fechaventa=f, total=t, estado="entregada",
                ),
            )
            ultima_venta = venta
            detalle = cargador.add(
                VentaDetalle,
                {"idventa": venta.idventa, "idvariante": asignadas[0].idvariante},
                lambda v=venta, u=asignadas[0], c=cantidad, t=total: VentaDetalle(
                    idventa=v.idventa, idvariante=u.idvariante,
                    cantidad=c, preciounitario=precio_base, subtotal=t,
                ),
            )
            for unidad in asignadas:
                cargador.add(
                    VentaUnidad,
                    {"idunidad": unidad.idunidad},
                    lambda d=detalle, u=unidad: VentaUnidad(
                        idventadetalle=d.idventadetalle, idunidad=u.idunidad
                    ),
                )
            fecha_pago = fecha_venta + timedelta(
                days=1 + semilla(tt, periodo, "pgo", idx) % 3
            )
            cargador.add(
                Pago,
                {"idventa": venta.idventa, "fechapago": fecha_pago},
                lambda v=venta, t=total, f=fecha_pago, i=idx: Pago(
                    idventa=v.idventa, metodopago=METODOS_PAGO[i % len(METODOS_PAGO)],
                    monto=t, fechapago=f, estado="completado",
                ),
            )

        # Una garantía por unidad vendida: así cada producto del catálogo
        # conserva métricas reales en la ficha detallada de 36 meses.
        for idx_gar, u_garantia in enumerate(unidades_vendidas):
            ini = dia_en_mes(
                anio, mes, semilla(tt, periodo, "gar", idx_gar), min_dia=14
            ).date()
            cargador.add(
                GarantiaUnidad,
                {"idunidad": u_garantia.idunidad},
                lambda u=u_garantia, f=ini: GarantiaUnidad(
                    idunidad=u.idunidad, fechainicio=f, fechafin=f + timedelta(days=365),
                    proveedor="Apple Inc.",
                    condiciones=f"Garantia historica {PREFIJO} {periodo}",
                ),
            )

        if estado_extra == "devuelto" and ultima_venta is not None:
            u_devuelta = next((u for u in unidades if u.estado == "devuelto"), None)
            if u_devuelta is not None:
                fecha_dev = fecha_ultima_venta + timedelta(days=6)
                dev = cargador.add(
                    Devolucion,
                    {"idventa": ultima_venta.idventa, "fechadevolucion": fecha_dev},
                    lambda v=ultima_venta, f=fecha_dev: Devolucion(
                        idventa=v.idventa, fechadevolucion=f,
                        motivo="daño_transporte",
                        descripcion=f"{PREFIJO} devolucion {periodo}",
                        estado="procesada",
                    ),
                )
                cargador.add(
                    DevolucionUnidad,
                    {"idunidad": u_devuelta.idunidad},
                    lambda d=dev, u=u_devuelta: DevolucionUnidad(
                        iddevolucion=d.iddevolucion, idunidad=u.idunidad
                    ),
                )

        # --- 7. Documentos, bitacora y notificaciones ---------------------
        for idx in range(DOCUMENTOS_POR_MES):
            nombre = f"{PREFIJO}-DOC-{tt}-{periodo}-{idx}"
            fecha_emision = dia_en_mes(
                anio, mes, semilla(tt, periodo, "doc", idx), min_dia=9
            ).date()
            unidad_doc = unidades[idx % len(unidades)]
            cargador.add(
                DocumentoUnidad,
                {"idunidad": unidad_doc.idunidad, "nombre": nombre},
                lambda u=unidad_doc, n=nombre, f=fecha_emision, i=idx: DocumentoUnidad(
                    idunidad=u.idunidad, nombre=n,
                    urlarchivo=f"https://docs.demo.local/{PREFIJO}/{n}.pdf",
                    hasharchivo=sha("doc", n), fechaemision=f,
                    fechavencimiento=f + timedelta(days=365),
                    tipodocumento=TIPOS_DOCUMENTO[i % len(TIPOS_DOCUMENTO)],
                ),
            )

        fecha_aud = dia_en_mes(anio, mes, semilla(tt, periodo, "bit"), min_dia=11)
        id_venta_aud = ultima_venta.idventa if ultima_venta is not None else None
        cargador.add(
            Bitacora,
            {"idusuariotenant": ut.idusuariotenant, "accion": "POST",
             "entidad": f"{PREFIJO}-VENTA", "fechahora": fecha_aud},
            lambda u=ut, f=fecha_aud, iv=id_venta_aud: Bitacora(
                idusuariotenant=u.idusuariotenant, accion="POST",
                entidad=f"{PREFIJO}-VENTA", identidad=iv,
                ip="127.0.0.1", fechahora=f,
            ),
        )
        fecha_not = fecha_aud + timedelta(hours=1)
        titulo_not = f"{PREFIJO} Resumen mensual {periodo}"
        cargador.add(
            Notificacion,
            {"idusuariotenant": ut.idusuariotenant, "titulo": titulo_not,
             "fechaenvio": fecha_not},
            lambda u=ut, t=titulo_not, f=fecha_not: Notificacion(
                idusuariotenant=u.idusuariotenant, titulo=t,
                contenido=(
                    f"Se registraron {VENTAS_POR_MES} ventas y "
                    f"{UNIDADES_POR_MES} unidades en {periodo}."
                ),
                leida=True, fechaenvio=f, fechalectura=f + timedelta(hours=2),
                enlaceaccion="/reports",
            ),
        )

        # --- 8. Sospechas (cada 3 meses) ----------------------------------
        # Se genera un reporte por unidad para que cada producto tenga
        # incidentes reales en su ficha detallada, sin romper el ticket
        # histórico ya sembrado en corridas anteriores.
        if mes % 3 == 0:
            ticket_base = f"{PREFIJO}-{tt}-{periodo}"
            for idx_rep, unidad_rep in enumerate(unidades):
                ticket = f"{ticket_base}-U{idx_rep:02d}"
                fecha_rep = dia_en_mes(
                    anio, mes, semilla(tt, periodo, "rep", idx_rep), min_dia=16
                )
                reporte = cargador.add(
                    ReporteSospecha,
                    {"codigoticket": ticket},
                    lambda tk=ticket, f=fecha_rep, u=unidad_rep: ReporteSospecha(
                        codigoticket=tk, idtenant=tt,
                        idunidad=u.idunidad, idusuario=idusuario,
                        tipoanomalia=TIPOS_ANOMALIA[(mes + idx_rep) % len(TIPOS_ANOMALIA)],
                        descripcion=f"{PREFIJO} reporte de sospecha {periodo} u{idx_rep}",
                        latitud=Decimal("-16.489700"), longitud=Decimal("-68.119300"),
                        estado=ESTADOS_REPORTE[(mes + idx_rep) % len(ESTADOS_REPORTE)],
                        gravedad=GRAVEDADES[(mes + idx_rep) % len(GRAVEDADES)],
                        idalerta=alerta_id, score_ml=Decimal("0.7500"),
                        sugerencia_ml="verificar", creadoen=f, actualizadoen=f,
                    ),
                )
                hash_ev = sha("evidencia", ticket)
                cargador.add(
                    ReporteSospechaEvidencia,
                    {"hashsha256": hash_ev},
                    lambda r=reporte, h=hash_ev, f=fecha_rep: ReporteSospechaEvidencia(
                        idreporte=r.idreporte,
                        nombrearchivo=f"{PREFIJO}-{ticket}.jpg",
                        tipomime="image/jpeg", tamanobytes=102400,
                        urlalmacenamiento=f"https://storage.demo.local/{PREFIJO}/{ticket}.jpg",
                        hashsha256=h, creadoen=f,
                    ),
                )

        # --- 9. Cuotas y facturacion --------------------------------------
        cargador.add(
            UsoPlan,
            {"idtenant": tt, "periodo": periodo},
            lambda t_=tt, p=periodo, f=fecha_aud: UsoPlan(
                idtenant=t_, periodo=p, reportesgenerados=4,
                unidadesregistradas=UNIDADES_POR_MES, usuariosactivos=len(usuarios_ut),
                actualizadoen=f,
            ),
        )
        numero_factura = f"FAC-{PREFIJO}-{tt:02d}-{periodo.replace('-', '')}"
        emision = dia_en_mes(anio, mes, semilla(tt, periodo, "fac"), min_dia=15)
        factura = cargador.add(
            Factura,
            {"idtenant": tt, "numero": numero_factura},
            lambda n=numero_factura, e=emision, m=monto_factura: Factura(
                idtenant=tt,
                idsuscripcion=suscripcion.idsuscripcion if suscripcion else None,
                numero=n, fechaemision=e, fechavencimiento=e + timedelta(days=30),
                monto=m, moneda="USD", estado="pagada",
            ),
        )
        cargador.add(
            FacturaDetalle,
            {"idfactura": factura.idfactura, "concepto": "Suscripcion mensual"},
            lambda f_=factura, m=monto_factura: FacturaDetalle(
                idfactura=f_.idfactura, concepto="Suscripcion mensual",
                cantidad=1, preciounitario=m, subtotal=m,
            ),
        )
        cargador.add(
            Cobro,
            {"idfactura": factura.idfactura, "fechacobro": emision + timedelta(days=5)},
            lambda f_=factura, e=emision, m=monto_factura: Cobro(
                idfactura=f_.idfactura, fechacobro=e + timedelta(days=5),
                monto=m, metodopago="transferencia",
                referencia=f"TRX-{PREFIJO}-{tt}-{periodo}",
                estado="completado",
            ),
        )


def main(argv=None, *, meses: Optional[int] = None, manifest: Optional[str] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="Simula sin escribir en la BD")
    parser.add_argument(
        "--reset-history", action="store_true",
        help="Borra solo el historial generado por este script",
    )
    parser.add_argument("--meses", type=int, default=None, help="Cantidad de meses a poblar")
    parser.add_argument("--manifest", default=None, help="Ruta del manifest a utilizar")
    args = parser.parse_args(argv)

    global MESES, MANIFEST
    if args.meses is not None:
        MESES = args.meses
    elif meses is not None:
        MESES = meses
    if args.manifest:
        MANIFEST = Path(args.manifest)
    elif manifest:
        MANIFEST = Path(manifest)

    db = SessionLocal()
    try:
        if args.reset_history:
            print("== RESET HISTORICO ==")
            reset_historial(db)
            return 0

        print(f"== POBLADO HISTORICO {MESES} MESES ==")
        print(f"Modo: {'DRY-RUN (sin escritura)' if args.dry_run else 'ESCRITURA'}")
        ahora = get_bolivia_now()
        periodos = [anio_mes(ahora, d) for d in range(-(MESES - 1), 1)]
        print("Periodos: " + ", ".join(f"{a:04d}-{m:02d}" for a, m in periodos))

        tenants = db.execute(
            select(Tenant).where(Tenant.idtenant <= 5).order_by(Tenant.idtenant)
        ).scalars().all()
        cargador = Cargador(db, args.dry_run)
        for tenant in tenants:
            print(f"\n-> tenant {tenant.idtenant}: {tenant.nombre}")
            poblar_tenant(db, cargador, tenant, ahora)

        print("\n== RESUMEN ==")
        print(cargador.resumen())

        if args.dry_run:
            db.rollback()
            print("\nDRY-RUN finalizado: rollback ejecutado, la BD no cambio.")
            return 0

        sincronizar_secuencias(db)
        db.commit()
        guardar_manifest(cargador.ids)
        print("\nPoblado historico completado y confirmado.")
        return 0
    except Exception as exc:
        db.rollback()
        print(f"\n[ERROR] {exc}", file=sys.stderr)
        traceback.print_exc()
        return 1
    finally:
        db.close()


if __name__ == "__main__":
    raise SystemExit(main())
