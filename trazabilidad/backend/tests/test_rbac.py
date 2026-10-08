import time
import pytest
from sqlalchemy import select

from app.models.cu002_usuarios.user import User
from app.models.cu003_roles_permisos.role import Role
from app.models.cu003_roles_permisos.usuario_tenant_rol import UsuarioTenantRol
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant

ROL_ADMIN_EMPRESA = "AdministradorEmpresa"
ROL_SUPER = "SuperAdministrador"
ADMIN_EMAIL = "admin@trazabilidad.com"
ADMIN_PASSWORD = "Admin123!"
ADMIN_TENANT_SLUG = "123456789"


def login(client, tenant_slug, email, password):
    resp = client.post(
        "/api/v1/auth/login",
        json={"tenant_slug": tenant_slug, "email": email, "password": password},
    )
    assert resp.status_code == 200, resp.text
    return {"Authorization": f"Bearer {resp.json()['access_token']}"}


@pytest.fixture
def headers_admin_empresa(client, db_session, setup_test_data):
    """user1@test.com con el rol AdministradorEmpresa dentro de Empresa Test 1."""
    u1 = setup_test_data["user1"]
    t1 = setup_test_data["tenant1"]

    rol = db_session.execute(
        select(Role).where(Role.nombrerol == ROL_ADMIN_EMPRESA)
    ).scalar_one_or_none()
    if not rol:
        rol = Role(nombrerol=ROL_ADMIN_EMPRESA, descripcion="Administrador de empresa (test)")
        db_session.add(rol)
        db_session.flush()

    ut1 = db_session.execute(
        select(UsuarioTenant).where(
            UsuarioTenant.idusuario == u1.idusuario,
            UsuarioTenant.idtenant == t1.idtenant,
        )
    ).scalar_one()
    ya_asignado = db_session.execute(
        select(UsuarioTenantRol).where(
            UsuarioTenantRol.idusuariotenant == ut1.idusuariotenant,
            UsuarioTenantRol.idrol == rol.idrol,
        )
    ).scalar_one_or_none()
    if not ya_asignado:
        db_session.add(UsuarioTenantRol(idusuariotenant=ut1.idusuariotenant, idrol=rol.idrol))
        db_session.commit()

    return login(client, "empresa-test-1", "user1@test.com", "MiClave@123")


def test_escritura_sin_roles_devuelve_403(client, setup_test_data):
    headers = login(client, "empresa-test-2", "user2@test.com", "OtroPassword@456")

    resp = client.post(
        "/api/v1/categories",
        json={"nombrecategoria": f"SinRol {int(time.time() * 1000)}"},
        headers=headers,
    )
    assert resp.status_code == 403
    assert "roles" in resp.json()["detail"].lower()


def test_generar_qr_sin_roles_devuelve_403_antes_del_handler(client, setup_test_data):
    headers = login(client, "empresa-test-2", "user2@test.com", "OtroPassword@456")

    resp = client.post("/api/v1/qr/generate/999999", headers=headers)
    assert resp.status_code == 403


def test_escritura_con_rol_admin_empresa_permitida(client, headers_admin_empresa):
    unique_suffix = int(time.time() * 1000)
    resp = client.post(
        "/api/v1/categories",
        json={
            "nombrecategoria": f"Cat RBAC {unique_suffix}",
            "descripcion": "Categoría creada en test de RBAC",
        },
        headers=headers_admin_empresa,
    )
    assert resp.status_code == 201, resp.text
    assert resp.json()["nombrecategoria"] == f"Cat RBAC {unique_suffix}"


def test_lectura_permitida_para_rol_sin_gestion(client, setup_test_data):
    headers = login(client, "empresa-test-2", "user2@test.com", "OtroPassword@456")

    resp = client.get("/api/v1/categories", headers=headers)
    assert resp.status_code == 200


# ---------------------------------------------------------------------------
# Garantia SuperAdministrador: acceso total sin exigir vinculo
# ---------------------------------------------------------------------------


def _crear_tenant_uniq(client, headers):
    suffix = int(time.time() * 1000)
    resp = client.post(
        "/api/v1/tenants",
        json={
            "nombre": f"Tenant Super {suffix}",
            "razonsocial": f"Tenant Super {suffix} S.A.",
            "nit": f"999{suffix}",
            "email": f"super{suffix}@test.com",
        },
        headers=headers,
    )
    assert resp.status_code == 201, resp.text
    return resp.json()


def test_superadmin_opera_sobre_tenant_sin_vinculo(client, setup_test_data):
    headers = login(client, ADMIN_TENANT_SLUG, ADMIN_EMAIL, ADMIN_PASSWORD)
    nuevo = _crear_tenant_uniq(client, headers)

    resp = client.get(
        f"/api/v1/tenant-catalog?tenant_id={nuevo['idtenant']}",
        headers=headers,
    )
    assert resp.status_code == 200, resp.text
    assert resp.json()["total"] == 0


def test_cross_tenant_sin_vinculo_devuelve_403(client, setup_test_data):
    headers = login(client, "empresa-test-2", "user2@test.com", "OtroPassword@456")
    t1_id = setup_test_data["tenant1"].idtenant

    resp = client.get(
        f"/api/v1/tenant-catalog?tenant_id={t1_id}",
        headers=headers,
    )
    assert resp.status_code == 403


def test_switch_tenant_miembro_propio_devuelve_200(client, setup_test_data):
    headers = login(client, "empresa-test-1", "user1@test.com", "MiClave@123")
    t1_id = setup_test_data["tenant1"].idtenant

    resp = client.post(f"/api/v1/auth/switch-tenant/{t1_id}", headers=headers)
    assert resp.status_code == 200, resp.text
    assert resp.json()["user"]["tenant"]["idtenant"] == t1_id


def test_switch_tenant_sin_membresia_devuelve_403(client, setup_test_data):
    headers = login(client, "empresa-test-2", "user2@test.com", "OtroPassword@456")
    t1_id = setup_test_data["tenant1"].idtenant

    resp = client.post(f"/api/v1/auth/switch-tenant/{t1_id}", headers=headers)
    assert resp.status_code == 403


def test_switch_tenant_superadmin_crea_vinculo_con_rol(client, db_session, setup_test_data):
    headers = login(client, ADMIN_TENANT_SLUG, ADMIN_EMAIL, ADMIN_PASSWORD)
    nuevo = _crear_tenant_uniq(client, headers)

    resp = client.post(f"/api/v1/auth/switch-tenant/{nuevo['idtenant']}", headers=headers)
    assert resp.status_code == 200, resp.text

    me = client.get("/api/v1/auth/me", headers={
        "Authorization": f"Bearer {resp.json()['access_token']}"
    })
    assert me.status_code == 200
    assert ROL_SUPER in me.json()["roles"]

    admin = db_session.execute(
        select(User).where(User.email == ADMIN_EMAIL)
    ).scalar_one()
    ut = db_session.execute(
        select(UsuarioTenant).where(
            UsuarioTenant.idusuario == admin.idusuario,
            UsuarioTenant.idtenant == nuevo["idtenant"],
        )
    ).scalar_one_or_none()
    assert ut is not None

    rol_super = db_session.execute(
        select(Role).where(Role.nombrerol == ROL_SUPER)
    ).scalars().first()
    assert rol_super is not None
    utr = db_session.execute(
        select(UsuarioTenantRol).where(
            UsuarioTenantRol.idusuariotenant == ut.idusuariotenant,
            UsuarioTenantRol.idrol == rol_super.idrol,
        )
    ).scalar_one_or_none()
    assert utr is not None
