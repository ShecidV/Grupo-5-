"""
=============================================================================
SCRIPT MAESTRO DE POBLADO DE BASE DE DATOS (SEED DEFINITIVO)
=============================================================================
Puebla y sincroniza de forma integral e idempotente toda la plataforma:
  1. Roles del Sistema (CU-003: 6 roles oficiales).
  2. Catálogo Granular de Permisos (38 permisos organizados por módulo).
  3. Matriz de Vinculación Rol-Permiso (118 relaciones relacionales en rolpermiso).
  4. Empresas Demo (CU-001: 5 tenants con NIT y datos en Bolivia).
  5. Usuarios Administradores (CU-002: SuperAdmin global y admins de tenant) y
     usuarios operativos por rol (Gestor de Operaciones, Gestor de Ventas y
     Postventa, Auditor), uno por cada empresa (3 roles x 5 tenants).
  6. Certificaciones Legales (CU-007: Homologación ATT Bolivia, RoHS).
  7. Catálogo Oficial Apple iPhone (CU-006: 8 productos, 18 variantes).
  8. Catálogo por Empresa (CU-008: CatalogoTenant con precios y márgenes).
  9. Cadena de Suministro (CU-013: Proveedor LatAm, Importador, TransOriente, iStore).
  10. Nodos Logísticos (CU-014: 5 ubicaciones GPS reales en Santa Cruz de la Sierra).
  11. Abastecimiento y Recepción (CU-010 / CU-012: Órdenes de compra y actas).
  12. Unidades Serializadas y Códigos QR (CU-015 / CU-016: 22 unidades por tenant,
      110 en total con seriales de fábrica Apple, doble IMEI TAC y QR criptográfico).
  13. Envíos y Telemetría IoT (CU-019 / CU-020 / CU-021: Despachos con sensores GPS).
  14. Resincronización automática de secuencias seriales de PostgreSQL.
=============================================================================
"""

import sys
import os
import uuid
import hashlib
import random
from datetime import date, datetime, timedelta, timezone
from decimal import Decimal

# Asegurar backend en el path de Python
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
if sys.platform.startswith("win"):
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

from sqlalchemy.orm import Session
from sqlalchemy import select, text

from app.db.session import SessionLocal
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu002_usuarios.user import User
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu003_roles_permisos.role import Role
from app.models.cu003_roles_permisos.permission import Permiso
from app.models.cu003_roles_permisos.role_permission import RolPermiso
from app.models.cu003_roles_permisos.usuario_tenant_rol import UsuarioTenantRol
from app.models.cu009_categorias.category import Categoria
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu007_certificaciones.certification import Certificacion, ProductoCertificacion
from app.models.cu008_catalogo_empresa.tenant_catalog import CatalogoTenant
from app.models.cu013_actores_cadena.actor import ActorCadena
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu010_ordenes_compra.purchase import Compra, CompraDetalle
from app.models.cu012_recepciones.reception import RecepcionCompra, RecepcionDetalle
from app.models.cu019_envios_logisticos.shipment import Envio
from app.models.cu020_asignacion_unidades_envio.shipment_unit import EnvioUnidad
from app.models.cu021_eventos_transporte.transport_event import (
    EventoTrazabilidad,
    EventoUnidad,
    CondicionTransporte
)
from app.core.security import hash_password

DEMO_PASSWORD = os.getenv("SEED_PASSWORD", "Admin123!")

def get_now_bolivia() -> datetime:
    return datetime.now(timezone(timedelta(hours=-4))).replace(tzinfo=None)


# -------------------------------------------------------------------------
# 1. ROLES DEL SISTEMA
# -------------------------------------------------------------------------
ROLES_DATA = [
    ("SuperAdministrador", "Control total sobre la plataforma, gestión de tenants y configuración global"),
    ("AdministradorEmpresa", "Gestión completa de una empresa (tenant): catálogo, usuarios, reportes"),
    ("GestorOperaciones", "Gestión de abastecimiento, inventario (seriales/IMEI), logística y trazabilidad"),
    ("GestorVentasPostventa", "Gestión de ventas, devoluciones, garantías y documentos adjuntos"),
    ("Consumidor", "Consulta de trazabilidad, favoritos y notificaciones (solo sus productos)"),
    ("Auditor", "Acceso de solo lectura a trazabilidad, blockchain y reportes"),
]

# -------------------------------------------------------------------------
# 2. CATÁLOGO DE PERMISOS GRANULARES
# -------------------------------------------------------------------------
PERMISOS_CATALOGO = [
    {"nombre": "tenants:read", "modulo": "Empresas", "desc": "Consultar y listar empresas registradas en la plataforma"},
    {"nombre": "tenants:create", "modulo": "Empresas", "desc": "Crear y dar de alta nuevas empresas (tenants)"},
    {"nombre": "tenants:update", "modulo": "Empresas", "desc": "Modificar datos y configuración corporativa de empresas"},
    {"nombre": "tenants:delete", "modulo": "Empresas", "desc": "Desactivar o suspender empresas de la plataforma"},
    {"nombre": "tenants:switch", "modulo": "Empresas", "desc": "Cambiar libremente de contexto entre empresas del sistema"},

    {"nombre": "users:read", "modulo": "Usuarios", "desc": "Consultar y listar usuarios registrados en el tenant"},
    {"nombre": "users:create", "modulo": "Usuarios", "desc": "Registrar nuevos usuarios y enviar credenciales de acceso"},
    {"nombre": "users:update", "modulo": "Usuarios", "desc": "Modificar perfiles, datos y estado activo de usuarios"},
    {"nombre": "users:delete", "modulo": "Usuarios", "desc": "Desactivar o suspender usuarios del sistema"},

    {"nombre": "roles:read", "modulo": "Roles y Permisos", "desc": "Ver catálogo de roles del sistema y sus permisos"},
    {"nombre": "roles:assign", "modulo": "Roles y Permisos", "desc": "Asignar, modificar y revocar roles a usuarios"},

    {"nombre": "categories:read", "modulo": "Categorías", "desc": "Visualizar categorías de productos tecnológicos"},
    {"nombre": "categories:manage", "modulo": "Categorías", "desc": "Crear, editar y eliminar categorías de productos"},

    {"nombre": "certifications:read", "modulo": "Certificaciones", "desc": "Consultar certificaciones legales (ATT Bolivia, RoHS, etc.)"},
    {"nombre": "certifications:manage", "modulo": "Certificaciones", "desc": "Crear y homologar certificaciones oficiales para productos"},

    {"nombre": "products:read", "modulo": "Productos", "desc": "Consultar especificaciones, variantes y modelos oficiales"},
    {"nombre": "products:manage", "modulo": "Productos", "desc": "Crear, actualizar y dar de baja productos y variantes globales"},

    {"nombre": "tenant_catalog:read", "modulo": "Catálogo Empresa", "desc": "Ver catálogo interno, costos promedio y precios al público"},
    {"nombre": "tenant_catalog:manage", "modulo": "Catálogo Empresa", "desc": "Ajustar precios de venta, márgenes de ganancia y SKU interno"},

    {"nombre": "actors:read", "modulo": "Cadena de Suministro", "desc": "Consultar proveedores, importadores, transportistas y tiendas"},
    {"nombre": "actors:manage", "modulo": "Cadena de Suministro", "desc": "Dar de alta y gestionar actores de la cadena de suministro"},

    {"nombre": "locations:read", "modulo": "Ubicaciones", "desc": "Visualizar almacenes, aduanas, hubs logísticos y sucursales"},
    {"nombre": "locations:manage", "modulo": "Ubicaciones", "desc": "Registrar y actualizar ubicaciones con coordenadas GPS en Bolivia"},

    {"nombre": "purchases:read", "modulo": "Compras", "desc": "Ver órdenes de compra internacionales y de importación"},
    {"nombre": "purchases:create", "modulo": "Compras", "desc": "Generar nuevas órdenes de compra de lotes de dispositivos"},
    {"nombre": "purchases:approve", "modulo": "Compras", "desc": "Aprobar o cancelar órdenes de compra pendientes"},

    {"nombre": "receptions:read", "modulo": "Recepciones", "desc": "Consultar actas de recepción y control de aduana"},
    {"nombre": "receptions:manage", "modulo": "Recepciones", "desc": "Registrar ingreso físico y cotejo de cantidades de mercancía"},

    {"nombre": "units:read", "modulo": "Unidades Físicas", "desc": "Consultar números de serie, IMEIs, estado y custodio de unidades"},
    {"nombre": "units:create", "modulo": "Unidades Físicas", "desc": "Registrar e individualizar unidades físicas con serial y doble IMEI"},
    {"nombre": "units:update", "modulo": "Unidades Físicas", "desc": "Actualizar estado operativo, custodia o venta de unidades"},

    {"nombre": "qr:read", "modulo": "Códigos QR", "desc": "Visualizar, escanear y descargar códigos QR de trazabilidad"},
    {"nombre": "qr:generate", "modulo": "Códigos QR", "desc": "Generar tokens hash criptográficos y enlaces públicos de verificación"},

    {"nombre": "shipments:read", "modulo": "Transporte y Envíos", "desc": "Monitorear despachos en curso, rutas y estados de entrega"},
    {"nombre": "shipments:create", "modulo": "Transporte y Envíos", "desc": "Programar y despachar envíos entre nodos de la cadena"},
    {"nombre": "shipments:assign_units", "modulo": "Transporte y Envíos", "desc": "Asignar unidades físicas serializadas a un manifiesto de carga"},
    {"nombre": "shipments:telemetry", "modulo": "Transporte y Envíos", "desc": "Registrar eventos de trazabilidad y telemetría de sensores IoT"},

    {"nombre": "audit:read", "modulo": "Auditoría", "desc": "Consultar bitácora inmutable de eventos, cambios y accesos de seguridad"},
]

MATRIZ_ROL_PERMISOS = {
    "SuperAdministrador": [p["nombre"] for p in PERMISOS_CATALOGO],
    "AdministradorEmpresa": [
        "tenants:read", "tenants:update",
        "users:read", "users:create", "users:update", "users:delete",
        "roles:read", "roles:assign",
        "categories:read", "categories:manage",
        "certifications:read", "certifications:manage",
        "products:read",
        "tenant_catalog:read", "tenant_catalog:manage",
        "actors:read", "actors:manage",
        "locations:read", "locations:manage",
        "purchases:read", "purchases:create", "purchases:approve",
        "receptions:read", "receptions:manage",
        "units:read", "units:create", "units:update",
        "qr:read", "qr:generate",
        "shipments:read", "shipments:create", "shipments:assign_units", "shipments:telemetry",
        "audit:read",
    ],
    "GestorOperaciones": [
        "categories:read",
        "certifications:read",
        "products:read",
        "tenant_catalog:read",
        "actors:read",
        "locations:read", "locations:manage",
        "purchases:read", "purchases:create", "purchases:approve",
        "receptions:read", "receptions:manage",
        "units:read", "units:create", "units:update",
        "qr:read", "qr:generate",
        "shipments:read", "shipments:create", "shipments:assign_units", "shipments:telemetry",
    ],
    "GestorVentasPostventa": [
        "products:read",
        "tenant_catalog:read",
        "purchases:read",
        "units:read", "units:update",
        "qr:read",
        "shipments:read",
    ],
    "Auditor": [
        "tenants:read", "users:read", "roles:read", "categories:read", "certifications:read",
        "products:read", "tenant_catalog:read", "actors:read", "locations:read",
        "purchases:read", "receptions:read", "units:read", "qr:read", "shipments:read", "audit:read",
    ],
    "Consumidor": [
        "products:read", "units:read", "qr:read",
    ],
}

# -------------------------------------------------------------------------
# 3. EMPRESAS (TENANTS) DEMO
# -------------------------------------------------------------------------
TENANTS_DATA = [
    {
        "idtenant": 1, "nombre": "iStore Bolivia S.A.",
        "razonsocial": "iStore Importaciones y Distribucion S.A.",
        "nit": "123456789", "email": "importadora@bolivia.com", "telefono": "70000000",
        "admin_email": "admin@trazabilidad.com",
    },
    {
        "idtenant": 2, "nombre": "TechImport Santa Cruz S.R.L.",
        "razonsocial": "TechImport Santa Cruz Sociedad de Responsabilidad Limitada",
        "nit": "987654321", "email": "contacto@techimport.com", "telefono": "70111111",
        "admin_email": "admin@techimport.com",
    },
    {
        "idtenant": 3, "nombre": "Andina Digital Ltda.",
        "razonsocial": "Andina Digital Limitada",
        "nit": "456789123", "email": "contacto@andinadigital.com", "telefono": "70222222",
        "admin_email": "admin@andinadigital.com",
    },
    {
        "idtenant": 4, "nombre": "ElectroSur Trading S.A.",
        "razonsocial": "ElectroSur Trading Sociedad Anónima",
        "nit": "321654987", "email": "contacto@electrosur.com", "telefono": "70333333",
        "admin_email": "admin@electrosur.com",
    },
    {
        "idtenant": 5, "nombre": "Cochabamba Wireless S.A.",
        "razonsocial": "Cochabamba Wireless Sociedad Anónima",
        "nit": "654987321", "email": "contacto@cochawireless.com", "telefono": "70444444",
        "admin_email": "admin@cochawireless.com",
    },
]

# -------------------------------------------------------------------------
# 3.1 USUARIOS OPERATIVOS DEMO (CU-002)
# Un usuario por cada rol operativo en cada empresa (3 roles x 5 tenants).
# El correo se deriva del dominio del administrador de la empresa.
# -------------------------------------------------------------------------
ROLES_USUARIOS_DEMO = [
    ("GestorOperaciones", "operaciones", "Gestor de Operaciones"),
    ("GestorVentasPostventa", "ventas", "Gestor de Ventas y Postventa"),
    ("Auditor", "auditor", "Auditor Interno"),
]

# -------------------------------------------------------------------------
# 4. CATÁLOGO APPLE IPHONE
# -------------------------------------------------------------------------
IPHONE_CATALOG = [
    {
        "nombre": "iPhone 16 Pro Max",
        "modelo": "A3296",
        "categoria": "Smartphones",
        "paisorigen": "China",
        "descripcion": "Pantalla Super Retina XDR de 6.9'', chip A18 Pro, botón Control de Cámara y titanio grado 5.",
        "variantes": [
            {"capacidad": "256GB", "color": "Titanio Desierto", "sku": "IP16PM-256-DES", "preciousd": Decimal("1299.00")},
            {"capacidad": "512GB", "color": "Titanio Natural", "sku": "IP16PM-512-NAT", "preciousd": Decimal("1499.00")},
            {"capacidad": "256GB", "color": "Titanio Negro", "sku": "IP16PM-256-NEG", "preciousd": Decimal("1299.00")},
        ]
    },
    {
        "nombre": "iPhone 16 Pro",
        "modelo": "A3293",
        "categoria": "Smartphones",
        "paisorigen": "China",
        "descripcion": "Pantalla de 6.3'', chip A18 Pro, sistema de cámaras Pro de 48 MP y acabado de titanio.",
        "variantes": [
            {"capacidad": "128GB", "color": "Titanio Blanco", "sku": "IP16P-128-BLA", "preciousd": Decimal("1099.00")},
            {"capacidad": "256GB", "color": "Titanio Natural", "sku": "IP16P-256-NAT", "preciousd": Decimal("1199.00")},
            {"capacidad": "128GB", "color": "Titanio Negro", "sku": "IP16P-128-NEG", "preciousd": Decimal("1099.00")},
        ]
    },
    {
        "nombre": "iPhone 16",
        "modelo": "A3287",
        "categoria": "Smartphones",
        "paisorigen": "China",
        "descripcion": "Pantalla de 6.1'' con Dynamic Island, chip A18 y nuevo botón de acción háptico.",
        "variantes": [
            {"capacidad": "128GB", "color": "Azul Ultramar", "sku": "IP16-128-AZU", "preciousd": Decimal("899.00")},
            {"capacidad": "256GB", "color": "Verde Azulado", "sku": "IP16-256-VRD", "preciousd": Decimal("999.00")},
            {"capacidad": "128GB", "color": "Negro", "sku": "IP16-128-NEG", "preciousd": Decimal("899.00")},
        ]
    },
    {
        "nombre": "iPhone 15 Pro Max",
        "modelo": "A3106",
        "categoria": "Smartphones",
        "paisorigen": "Corea del Sur",
        "descripcion": "Pantalla de 6.7'', chip A17 Pro con GPU de 6 núcleos, teleobjetivo 5x óptico.",
        "variantes": [
            {"capacidad": "256GB", "color": "Titanio Azul", "sku": "IP15PM-256-AZU", "preciousd": Decimal("1149.00")},
            {"capacidad": "512GB", "color": "Titanio Natural", "sku": "IP15PM-512-NAT", "preciousd": Decimal("1349.00")},
        ]
    },
    {
        "nombre": "iPhone 15 Pro",
        "modelo": "A3102",
        "categoria": "Smartphones",
        "paisorigen": "China",
        "descripcion": "Pantalla de 6.1'', conector USB-C compatible con USB 3 y diseño ultraligero de titanio.",
        "variantes": [
            {"capacidad": "128GB", "color": "Titanio Negro", "sku": "IP15P-128-NEG", "preciousd": Decimal("999.00")},
            {"capacidad": "256GB", "color": "Titanio Blanco", "sku": "IP15P-256-BLA", "preciousd": Decimal("1099.00")},
        ]
    },
    {
        "nombre": "iPhone 15",
        "modelo": "A3090",
        "categoria": "Smartphones",
        "paisorigen": "China",
        "descripcion": "Cámara de 48 MP con resolución ultraalta, Dynamic Island y puerto USB-C.",
        "variantes": [
            {"capacidad": "128GB", "color": "Azul", "sku": "IP15-128-AZU", "preciousd": Decimal("799.00")},
            {"capacidad": "256GB", "color": "Rosa", "sku": "IP15-256-ROS", "preciousd": Decimal("899.00")},
            {"capacidad": "128GB", "color": "Negro", "sku": "IP15-128-NEG", "preciousd": Decimal("799.00")},
        ]
    },
    {
        "nombre": "AirPods Pro (2.ª gen USB-C)",
        "modelo": "A3048",
        "categoria": "Audio y Wearables",
        "paisorigen": "Vietnam",
        "descripcion": "Cancelación activa de ruido 2x, audio adaptativo y estuche MagSafe USB-C.",
        "variantes": [
            {"capacidad": "-", "color": "Blanco", "sku": "APP2-USBC-BLA", "preciousd": Decimal("249.00")},
        ]
    },
    {
        "nombre": "Cargador Apple 20W USB-C",
        "modelo": "A2305",
        "categoria": "Accesorios Oficiales",
        "paisorigen": "China",
        "descripcion": "Adaptador de corriente rápido USB-C de 20W oficial de Apple para Bolivia.",
        "variantes": [
            {"capacidad": "20W", "color": "Blanco", "sku": "AP20W-USB-BLA", "preciousd": Decimal("29.00")},
        ]
    },
]


def run_master_seed():
    db: Session = SessionLocal()
    print("=" * 75)
    print("EJECUTANDO SEED MAESTRO DEL SISTEMA DE TRAZABILIDAD (BOLIVIA)")
    print("=" * 75)

    try:
        # -------------------------------------------------------------
        # 1. ROLES
        # -------------------------------------------------------------
        print("\n[1/10] Sincronizando Roles del Sistema...")
        roles_db_map = {}
        for nombre, desc in ROLES_DATA:
            r = db.execute(select(Role).where(Role.nombrerol == nombre)).scalars().first()
            if not r:
                r = Role(nombrerol=nombre, descripcion=desc)
                db.add(r)
                db.flush()
            roles_db_map[nombre] = r
        db.commit()
        print(f"  ✓ {len(roles_db_map)} roles verificados.")

        # -------------------------------------------------------------
        # 2. PERMISOS Y VINCULACIÓN ROL-PERMISO
        # -------------------------------------------------------------
        print("\n[2/10] Sincronizando Catálogo de Permisos y Matriz Rol-Permiso...")
        permisos_db_map = {}
        for p in PERMISOS_CATALOGO:
            perm = db.execute(select(Permiso).where(Permiso.nombrepermiso == p["nombre"])).scalars().first()
            if not perm:
                perm = Permiso(nombrepermiso=p["nombre"], modulo=p["modulo"], descripcion=p["desc"])
                db.add(perm)
                db.flush()
            permisos_db_map[p["nombre"]] = perm

        for rol_nombre, perm_list in MATRIZ_ROL_PERMISOS.items():
            rol = roles_db_map.get(rol_nombre)
            if not rol:
                continue
            for p_nombre in perm_list:
                perm = permisos_db_map.get(p_nombre)
                if not perm:
                    continue
                rp = db.execute(
                    select(RolPermiso).where(RolPermiso.idrol == rol.idrol, RolPermiso.idpermiso == perm.idpermiso)
                ).scalars().first()
                if not rp:
                    db.add(RolPermiso(idrol=rol.idrol, idpermiso=perm.idpermiso))
        db.commit()
        print(f"  ✓ {len(permisos_db_map)} permisos granulares vinculados con éxito.")

        # -------------------------------------------------------------
        # 3. EMPRESAS (TENANTS) Y USUARIOS ADMINISTRADORES
        # -------------------------------------------------------------
        print("\n[3/10] Sincronizando Empresas Demo y Credenciales...")
        tenants_db = []
        super_admin_user = None

        for t_data in TENANTS_DATA:
            t = db.execute(select(Tenant).where(Tenant.idtenant == t_data["idtenant"])).scalars().first()
            if not t:
                t = Tenant(
                    idtenant=t_data["idtenant"],
                    nombre=t_data["nombre"],
                    razonsocial=t_data["razonsocial"],
                    nit=t_data["nit"],
                    email=t_data["email"],
                    telefono=t_data["telefono"],
                    activo=True
                )
                db.add(t)
                db.flush()
            tenants_db.append(t)

            # Usuario Administrador
            admin = db.execute(select(User).where(User.email == t_data["admin_email"])).scalars().first()
            if not admin:
                admin = User(
                    nombrecompleto="Administrador General",
                    email=t_data["admin_email"],
                    contrasenahash=hash_password(DEMO_PASSWORD),
                    activo=True
                )
                db.add(admin)
                db.flush()

            # Guardar referencia del SuperAdministrador
            if t_data["admin_email"] == "admin@trazabilidad.com":
                super_admin_user = admin

            # Vínculo UsuarioTenant
            ut = db.execute(
                select(UsuarioTenant).where(UsuarioTenant.idusuario == admin.idusuario, UsuarioTenant.idtenant == t.idtenant)
            ).scalars().first()
            if not ut:
                ut = UsuarioTenant(idusuario=admin.idusuario, idtenant=t.idtenant)
                db.add(ut)
                db.flush()

            # Asignar rol
            rol_a_asignar = roles_db_map["SuperAdministrador"] if t_data["admin_email"] == "admin@trazabilidad.com" else roles_db_map["AdministradorEmpresa"]
            has_rol = db.execute(
                select(UsuarioTenantRol).where(UsuarioTenantRol.idusuariotenant == ut.idusuariotenant, UsuarioTenantRol.idrol == rol_a_asignar.idrol)
            ).scalars().first()
            if not has_rol:
                db.add(UsuarioTenantRol(idusuariotenant=ut.idusuariotenant, idrol=rol_a_asignar.idrol))

            # Usuarios operativos demo por empresa (CU-002): Gestor de Operaciones,
            # Gestor de Ventas y Postventa, y Auditor.
            domain = t_data["admin_email"].split("@")[-1]
            for rol_nombre, localpart, nombre_completo in ROLES_USUARIOS_DEMO:
                rol_email = f"{localpart}@{domain}"
                rol_user = db.execute(select(User).where(User.email == rol_email)).scalars().first()
                if not rol_user:
                    rol_user = User(
                        nombrecompleto=nombre_completo,
                        email=rol_email,
                        contrasenahash=hash_password(DEMO_PASSWORD),
                        activo=True
                    )
                    db.add(rol_user)
                    db.flush()

                # Vínculo UsuarioTenant del usuario operativo
                rol_ut = db.execute(
                    select(UsuarioTenant).where(
                        UsuarioTenant.idusuario == rol_user.idusuario,
                        UsuarioTenant.idtenant == t.idtenant
                    )
                ).scalars().first()
                if not rol_ut:
                    rol_ut = UsuarioTenant(idusuario=rol_user.idusuario, idtenant=t.idtenant)
                    db.add(rol_ut)
                    db.flush()

                # Asignar el rol operativo correspondiente
                has_rol_operativo = db.execute(
                    select(UsuarioTenantRol).where(
                        UsuarioTenantRol.idusuariotenant == rol_ut.idusuariotenant,
                        UsuarioTenantRol.idrol == roles_db_map[rol_nombre].idrol
                    )
                ).scalars().first()
                if not has_rol_operativo:
                    db.add(UsuarioTenantRol(idusuariotenant=rol_ut.idusuariotenant, idrol=roles_db_map[rol_nombre].idrol))

        # Garantizar que el SuperAdmin pertenezca a todos los tenants con rol SuperAdministrador
        if super_admin_user:
            super_role = roles_db_map["SuperAdministrador"]
            for t in tenants_db:
                ut = db.execute(
                    select(UsuarioTenant).where(UsuarioTenant.idusuario == super_admin_user.idusuario, UsuarioTenant.idtenant == t.idtenant)
                ).scalars().first()
                if not ut:
                    ut = UsuarioTenant(idusuario=super_admin_user.idusuario, idtenant=t.idtenant)
                    db.add(ut)
                    db.flush()
                has_super = db.execute(
                    select(UsuarioTenantRol).where(UsuarioTenantRol.idusuariotenant == ut.idusuariotenant, UsuarioTenantRol.idrol == super_role.idrol)
                ).scalars().first()
                if not has_super:
                    db.add(UsuarioTenantRol(idusuariotenant=ut.idusuariotenant, idrol=super_role.idrol))

        db.commit()
        total_operativos = len(tenants_db) * len(ROLES_USUARIOS_DEMO)
        print(f"  ✓ {len(tenants_db)} empresas y usuarios con acceso multi-tenant listos.")
        print(f"  ✓ {total_operativos} usuarios operativos (Gestor de Operaciones, Ventas y Auditor) verificados.")

        # -------------------------------------------------------------
        # 4. CATEGORÍAS Y CERTIFICACIONES
        # -------------------------------------------------------------
        print("\n[4/10] Sincronizando Categorías y Certificaciones...")
        cat_map = {}
        for c_nombre, c_desc in [
            ("Smartphones", "Teléfonos inteligentes de alta gama"),
            ("Audio y Wearables", "Auriculares y relojes inteligentes"),
            ("Accesorios Oficiales", "Cargadores, cables y fundas originales"),
        ]:
            cat = db.execute(select(Categoria).where(Categoria.nombrecategoria == c_nombre)).scalars().first()
            if not cat:
                cat = Categoria(nombrecategoria=c_nombre, descripcion=c_desc)
                db.add(cat)
                db.flush()
            cat_map[c_nombre] = cat

        cert_att = db.execute(select(Certificacion).where(Certificacion.nombre == "Homologación ATT Bolivia")).scalars().first()
        if not cert_att:
            cert_att = Certificacion(
                nombre="Homologación ATT Bolivia",
                entidademisora="Autoridad de Regulación y Fiscalización de Telecomunicaciones",
                descripcion="Certificado oficial de uso de frecuencias radioeléctricas y compatibilidad celular en Bolivia."
            )
            db.add(cert_att)
            db.flush()
        db.commit()
        print("  ✓ Categorías y Certificaciones oficiales ATT configuradas.")

        # -------------------------------------------------------------
        # 5. CATÁLOGO APPLE IPHONE Y VARIANTES
        # -------------------------------------------------------------
        print("\n[5/10] Sincronizando Catálogo Apple iPhone y Variantes...")
        todas_variantes = []
        for pdata in IPHONE_CATALOG:
            prod = db.execute(select(Producto).where(Producto.nombre == pdata["nombre"])).scalars().first()
            if not prod:
                prod = Producto(
                    nombre=pdata["nombre"],
                    modelo=pdata["modelo"],
                    idcategoria=cat_map[pdata["categoria"]].idcategoria,
                    paisorigen=pdata["paisorigen"],
                    descripcion=pdata["descripcion"],
                    activo=True
                )
                db.add(prod)
                db.flush()

                # Vincular certificación ATT si es smartphone
                if pdata["categoria"] == "Smartphones":
                    db.add(ProductoCertificacion(
                        idproducto=prod.idproducto,
                        idcertificacion=cert_att.idcertificacion,
                        fechaobtencion=date.today() - timedelta(days=60)
                    ))

            for vdata in pdata["variantes"]:
                var = db.execute(select(VarianteProducto).where(VarianteProducto.sku == vdata["sku"])).scalars().first()
                if not var:
                    var = VarianteProducto(
                        idproducto=prod.idproducto,
                        capacidad=vdata["capacidad"],
                        color=vdata["color"],
                        sku=vdata["sku"],
                        preciousd=vdata["preciousd"]
                    )
                    db.add(var)
                    db.flush()
                todas_variantes.append(var)

        db.commit()
        print(f"  ✓ {len(IPHONE_CATALOG)} productos Apple y {len(todas_variantes)} variantes verificados.")

        # -------------------------------------------------------------
        # 6. LOGÍSTICA SANTA CRUZ, UNIDADES SERIALIZADAS Y ENVÍOS
        # -------------------------------------------------------------
        print("\n[6/10] Sincronizando Cadena de Suministro, Unidades (22 por empresa) y QR...")
        random.seed(42)
        FACTORY_PREFIXES = ["F17", "DNP", "G6T", "C39", "F2L", "DX3", "H02", "J8K", "M03", "K4L"]
        APPLE_TACS = ["35294111", "35849210", "35981208", "35401923", "35182944"]
        estados_distribucion = ["vendido"] * 11 + ["disponible"] * 6 + ["en_transito"] * 4 + ["devuelto"] * 1

        for t in tenants_db:
            # 6.1 Catálogo Empresa
            # Diversificar márgenes para que las recomendaciones sean más realistas
            for idx, v in enumerate(todas_variantes):
                cat_t = db.execute(
                    select(CatalogoTenant).where(CatalogoTenant.idtenant == t.idtenant, CatalogoTenant.idvariante == v.idvariante)
                ).scalars().first()
                if not cat_t:
                    margen = Decimal("1.20") if idx % 2 == 0 else Decimal("1.28")
                    db.add(CatalogoTenant(
                        idtenant=t.idtenant,
                        idvariante=v.idvariante,
                        skuinterno=f"{t.nit[:4]}-{v.sku}",
                        costopromedio=v.preciousd,
                        precioventa=(v.preciousd * margen).quantize(Decimal("0.01")),
                        activo=True
                    ))
            db.flush()

            # 6.2 Actores de la Cadena
            proveedor = db.execute(
                select(ActorCadena).where(ActorCadena.idtenant == t.idtenant, ActorCadena.tipoactor == "PROVEEDOR_EEUU")
            ).scalars().first()
            if not proveedor:
                proveedor = ActorCadena(
                    idtenant=t.idtenant,
                    nombre="Apple Latin America Distribution Hub",
                    razonsocial="Apple Operations International Ltd.",
                    nit="900881920",
                    email=f"supplies-scz{t.idtenant}@apple-latam.com",
                    telefono="+1-800-692-7753",
                    tipoactor="PROVEEDOR_EEUU"
                )
                db.add(proveedor)
                db.flush()

            importador = db.execute(
                select(ActorCadena).where(ActorCadena.idtenant == t.idtenant, ActorCadena.tipoactor == "IMPORTADOR")
            ).scalars().first()
            if not importador:
                importador = ActorCadena(
                    idtenant=t.idtenant,
                    nombre=f"Importadora {t.nombre}",
                    razonsocial=t.razonsocial,
                    nit=t.nit,
                    email=t.email,
                    telefono=t.telefono or "70000000",
                    tipoactor="IMPORTADOR"
                )
                db.add(importador)
                db.flush()

            transportista = db.execute(
                select(ActorCadena).where(ActorCadena.idtenant == t.idtenant, ActorCadena.tipoactor == "TRANSPORTISTA_INTERNACIONAL")
            ).scalars().first()
            if not transportista:
                transportista = ActorCadena(
                    idtenant=t.idtenant,
                    nombre="TransOriente Logística Express S.R.L.",
                    razonsocial="Transportes y Carga del Oriente Boliviano S.R.L.",
                    nit="482910291",
                    email=f"operaciones-scz{t.idtenant}@transoriente.bo",
                    telefono="77382910",
                    tipoactor="TRANSPORTISTA_INTERNACIONAL"
                )
                db.add(transportista)
                db.flush()

            tienda_retail = db.execute(
                select(ActorCadena).where(ActorCadena.idtenant == t.idtenant, ActorCadena.tipoactor == "TIENDA")
            ).scalars().first()
            if not tienda_retail:
                tienda_retail = ActorCadena(
                    idtenant=t.idtenant,
                    nombre=f"iStore Santa Cruz - Ventura Mall ({t.idtenant})",
                    razonsocial=f"Retail {t.razonsocial}",
                    nit=t.nit,
                    email=f"ventas-ventura{t.idtenant}@istore.bo",
                    telefono="78901234",
                    tipoactor="TIENDA"
                )
                db.add(tienda_retail)
                db.flush()

            # 6.3 Ubicaciones en Santa Cruz
            UBICACIONES_SCZ = [
                {
                    "nombre": f"Aduana Interior Santa Cruz (Viru Viru) - {t.idtenant}",
                    "tipo": "aduana", "idactor": proveedor.idactor,
                    "direccion": "Aeropuerto Internacional Viru Viru, Terminal de Carga",
                    "latitud": Decimal("-17.64482000"), "longitud": Decimal("-63.13541000"),
                },
                {
                    "nombre": f"Centro de Distribución Parque Industrial - {t.idtenant}",
                    "tipo": "centro_distribucion", "idactor": importador.idactor,
                    "direccion": "Parque Industrial PI-27, Calle 5 Este",
                    "latitud": Decimal("-17.76541000"), "longitud": Decimal("-63.14125000"),
                },
                {
                    "nombre": f"Almacén Central Equipetrol - {t.idtenant}",
                    "tipo": "almacen", "idactor": importador.idactor,
                    "direccion": "Av. San Martín esq. Calle 8 Este, Equipetrol Norte",
                    "latitud": Decimal("-17.76312000"), "longitud": Decimal("-63.19584000"),
                },
                {
                    "nombre": f"iStore Ventura Mall - {t.idtenant}",
                    "tipo": "punto_venta", "idactor": tienda_retail.idactor,
                    "direccion": "Ventura Mall, 4to Anillo, Nivel 1 Local 142",
                    "latitud": Decimal("-17.75470000"), "longitud": Decimal("-63.20163000"),
                },
                {
                    "nombre": f"Sucursal Las Brisas Mall - {t.idtenant}",
                    "tipo": "punto_venta", "idactor": tienda_retail.idactor,
                    "direccion": "Las Brisas Centro Comercial, 4to Anillo y Av. Cristo Redentor",
                    "latitud": Decimal("-17.74721000"), "longitud": Decimal("-63.17892000"),
                },
            ]

            ubicaciones_map = {}
            for udata in UBICACIONES_SCZ:
                u = db.execute(
                    select(Ubicacion).where(Ubicacion.idtenant == t.idtenant, Ubicacion.nombre == udata["nombre"])
                ).scalars().first()
                if not u:
                    u = Ubicacion(
                        idtenant=t.idtenant, idactor=udata["idactor"], nombre=udata["nombre"],
                        direccion=udata["direccion"], latitud=udata["latitud"], longitud=udata["longitud"],
                        ciudad="Santa Cruz de la Sierra", pais="Bolivia", tipo=udata["tipo"]
                    )
                    db.add(u)
                    db.flush()
                ubicaciones_map[udata["tipo"]] = u

            almacen_scz = ubicaciones_map.get("centro_distribucion") or ubicaciones_map.get("almacen")
            tienda_scz = ubicaciones_map.get("punto_venta")

            # 6.4 Compras y Recepciones
            num_orden = f"OC-2026-SCZ-{t.idtenant:02d}"
            compra = db.execute(select(Compra).where(Compra.numeroorden == num_orden)).scalars().first()
            if not compra:
                compra = Compra(
                    idtenant=t.idtenant, idproveedor=proveedor.idactor, numeroorden=num_orden,
                    fechacompra=date.today() - timedelta(days=15), totalusd=Decimal("26850.00"), estado="recibida_total"
                )
                db.add(compra)
                db.flush()
                for idx, v in enumerate(todas_variantes[:6]):
                    db.add(CompraDetalle(
                        idcompra=compra.idcompra, idvariante=v.idvariante, cantidad=4 if idx < 3 else 3,
                        costounitariousd=v.preciousd, subtotalusd=Decimal(str(float(v.preciousd) * (4 if idx < 3 else 3)))
                    ))
                db.flush()

            num_rec = f"REC-2026-SCZ-{t.idtenant:02d}"
            recepcion = db.execute(select(RecepcionCompra).where(RecepcionCompra.numerodocumento == num_rec)).scalars().first()
            if not recepcion:
                recepcion = RecepcionCompra(
                    idcompra=compra.idcompra, idubicacion=almacen_scz.idubicacion,
                    fecharecepcion=get_now_bolivia() - timedelta(days=10), numerodocumento=num_rec, estado="completa"
                )
                db.add(recepcion)
                db.flush()

            # 6.5 Unidades físicas serializadas (Garantizar mínimo 22 por tenant)
            unidades_existentes = db.execute(select(UnidadProducto).where(UnidadProducto.idtenant == t.idtenant)).scalars().all()
            unidades_necesarias = max(22 - len(unidades_existentes), 0)

            for i in range(unidades_necesarias):
                variante_sel = todas_variantes[i % len(todas_variantes)]
                prefix = random.choice(FACTORY_PREFIXES)
                rand_alnum = "".join(random.choices("0123456789ABCDEFGHJKLMNPQRSTUVWXYZ", k=7))
                serie = f"{prefix}{t.idtenant}{rand_alnum}"

                tac = random.choice(APPLE_TACS)
                rand_num = "".join(random.choices("0123456789", k=6))
                imei1 = f"{tac}{rand_num}{i % 10}"
                imei2 = f"35{tac[2:]}{rand_num}{(i + 1) % 10}"
                eid = f"89049032{t.idtenant:02d}" + "".join(random.choices("0123456789ABCDEF", k=22))
                estado_u = estados_distribucion[i % len(estados_distribucion)]

                if estado_u == "disponible":
                    custodio_u = importador.idactor
                    ubicacion_u = almacen_scz.idubicacion if i % 2 == 0 else tienda_scz.idubicacion
                    fecha_v = None
                elif estado_u == "en_transito":
                    custodio_u = transportista.idactor
                    ubicacion_u = almacen_scz.idubicacion
                    fecha_v = None
                elif estado_u == "devuelto":
                    custodio_u = tienda_retail.idactor
                    ubicacion_u = tienda_scz.idubicacion
                    fecha_v = get_now_bolivia() - timedelta(days=random.randint(30, 60))
                else:  # vendido
                    custodio_u = tienda_retail.idactor
                    ubicacion_u = tienda_scz.idubicacion
                    fecha_v = get_now_bolivia() - timedelta(days=random.randint(1, 90))

                fecha_ingreso = get_now_bolivia() - timedelta(days=random.randint(10, 25))
                unit = UnidadProducto(
                    idtenant=t.idtenant, idvariante=variante_sel.idvariante, idrecepciondetalle=None,
                    numeroserie=serie, imei1=imei1, imei2=imei2, eid=eid, uuidpublico=str(uuid.uuid4()),
                    idcustodioactual=custodio_u, idubicacionactual=ubicacion_u, estado=estado_u,
                    fechaingreso=fecha_ingreso, fechaventa=fecha_v
                )
                db.add(unit)
                db.flush()

                token_qr = hashlib.sha256(f"{unit.numeroserie}-{unit.uuidpublico}".encode()).hexdigest()[:32]
                url_qr = f"https://blockchain-production-8de2.up.railway.app/trace/{unit.uuidpublico}"
                db.add(CodigoQR(
                    idunidad=unit.idunidad, tokenpublico=token_qr, url=url_qr,
                    fechageneracion=fecha_ingreso, activo=True
                ))

            db.flush()

            # 6.6 Envíos y Telemetría IoT en Santa Cruz
            codigo_envio = f"ENV-SCZ-{t.idtenant:02d}-001"
            envio = db.execute(select(Envio).where(Envio.codigoenvio == codigo_envio)).scalars().first()
            if not envio:
                envio = Envio(
                    idtenant=t.idtenant, idactororigen=importador.idactor, idactordestino=tienda_retail.idactor,
                    idtransportista=transportista.idactor, codigoenvio=codigo_envio,
                    fechasalida=get_now_bolivia() - timedelta(hours=6),
                    fechaestimada=get_now_bolivia() + timedelta(hours=2),
                    estado="en_transito", trackingexterno=f"BOL-SCZ-{random.randint(100000, 999999)}"
                )
                db.add(envio)
                db.flush()

                unidades_tenant = db.execute(select(UnidadProducto).where(UnidadProducto.idtenant == t.idtenant)).scalars().all()
                unidades_transito = [u for u in unidades_tenant if u.estado == "en_transito"][:4]
                for u in unidades_transito:
                    db.add(EnvioUnidad(idenvio=envio.idenvio, idunidad=u.idunidad))

                evento1 = EventoTrazabilidad(
                    idtenant=t.idtenant, tipoevento="transporte_terrestre", fechahora=get_now_bolivia() - timedelta(hours=5),
                    idactororigen=importador.idactor, idactordestino=tienda_retail.idactor, idubicacion=almacen_scz.idubicacion,
                    idusuarioresponsable=super_admin_user.idusuario if super_admin_user else 1,
                    descripcion="Despacho de iPhones desde Centro de Distribución Parque Industrial hacia Ventura Mall.",
                    estadoverificacion="verificado"
                )
                db.add(evento1)
                db.flush()

                db.add(CondicionTransporte(
                    idevento=evento1.idevento, temperatura=Decimal("21.50"), humedad=Decimal("54.00"),
                    presion=Decimal("965.20"), nivelvibracion=Decimal("0.15"), fuentedatos="Sensor IoT GPS Teltonika FMC130"
                ))

                for u in unidades_transito:
                    db.add(EventoUnidad(idevento=evento1.idevento, idunidad=u.idunidad))

        db.commit()
        print("  ✓ Unidades serializadas, códigos QR y telemetría de transporte creados con éxito.")

        # -------------------------------------------------------------
        # 6.7 RECOMENDACIONES DE PRICING E INVENTARIO CON IA (CU-008 + IA)
        # -------------------------------------------------------------
        print("\n[6.7/10] Sincronizando escenarios y datos de prueba para Recomendaciones IA...")
        from populate_recommendation_data import populate_ai_recommendations
        populate_ai_recommendations(db, [t.idtenant for t in tenants_db])

        # -------------------------------------------------------------
        # 7. SINCRONIZACIÓN DE SECUENCIAS EN POSTGRESQL
        # -------------------------------------------------------------
        print("\n[7/10] Sincronizando Secuencias en PostgreSQL...")
        TABLAS_SECUENCIAS = [
            ("rol", "idrol"), ("permiso", "idpermiso"), ("rolpermiso", "idrolpermiso"),
            ("tenant", "idtenant"), ("usuario", "idusuario"), ("usuariotenant", "idusuariotenant"),
            ("usuariotenantrol", "idusuariotenantrol"), ("categoria", "idcategoria"),
            ("producto", "idproducto"), ("varianteproducto", "idvariante"),
            ("certificacion", "idcertificacion"), ("productocertificacion", "idproductocertificacion"),
            ("catalogotenant", "idcatalogotenant"), ("actorcadena", "idactor"),
            ("ubicacion", "idubicacion"), ("compra", "idcompra"), ("compradetalle", "idcompradetalle"),
            ("recepcioncompra", "idrecepcion"), ("unidadproducto", "idunidad"),
            ("codigoqr", "idcodigoqr"), ("envio", "idenvio"), ("enviounidad", "idenviounidad"),
            ("eventotrazabilidad", "idevento"), ("eventounidad", "ideventounidad"),
            ("condiciontransporte", "idcondicion"),
        ]

        for tabla, col_pk in TABLAS_SECUENCIAS:
            try:
                db.execute(text(f"""
                    SELECT setval(
                        pg_get_serial_sequence('{tabla}', '{col_pk}'),
                        coalesce((SELECT MAX({col_pk}) FROM {tabla}), 1)
                    );
                """))
            except Exception:
                pass
        db.commit()
        print("  ✓ Secuencias de PostgreSQL sincronizadas.")

        print("\n" + "=" * 75)
        print("SEED MAESTRO FINALIZADO CON ÉXITO")
        print("  - Contraseña de todos los usuarios demo: Admin123!")
        print("  - SuperAdministrador: admin@trazabilidad.com")
        print("  - Usuarios operativos (3 por empresa): operaciones@, ventas@, auditor@<dominio>")
        print("=" * 75)

    except Exception as e:
        db.rollback()
        print(f"\n[ERROR EN SEED MAESTRO]: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()


if __name__ == "__main__":
    run_master_seed()
