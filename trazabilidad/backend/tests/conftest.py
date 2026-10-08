import os
import sys

# Ensure backend root is in sys.path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, select
from sqlalchemy.orm import sessionmaker

from app.db.base import Base
from app.db.session import get_db
from app.main import app
from app.core.config import settings
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu002_usuarios.user import User
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu003_roles_permisos.role import Role
from app.models.cu003_roles_permisos.usuario_tenant_rol import UsuarioTenantRol
from app.core.security import hash_password

engine = create_engine(settings.DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="function")
def db_session():
    """Provides a fresh database session for each test and rolls back after test."""
    connection = engine.connect()
    transaction = connection.begin()
    session = TestingSessionLocal(bind=connection)

    yield session

    session.close()
    transaction.rollback()
    connection.close()


@pytest.fixture(scope="function")
def client(db_session):
    """FastAPI TestClient fixture with overridden DB dependency."""
    def _get_test_db():
        try:
            yield db_session
        finally:
            pass

    app.dependency_overrides[get_db] = _get_test_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()


@pytest.fixture(scope="function")
def setup_test_data(db_session):
    """Sets up Tenant 1, Tenant 2, User 1, and User 2 for testing."""
    t1 = Tenant(nombre="Empresa Test 1", razonsocial="Empresa Test 1 S.A.", nit="1111111", email="test1@empresa.com", activo=True)
    t2 = Tenant(nombre="Empresa Test 2", razonsocial="Empresa Test 2 S.A.", nit="2222222", email="test2@empresa.com", activo=True)
    db_session.add_all([t1, t2])
    db_session.flush()

    u1 = User(
        nombrecompleto="Usuario Uno",
        email="user1@test.com",
        contrasenahash=hash_password("MiClave@123"),
        activo=True
    )
    u2 = User(
        nombrecompleto="Usuario Dos",
        email="user2@test.com",
        contrasenahash=hash_password("OtroPassword@456"),
        activo=True
    )
    db_session.add_all([u1, u2])
    db_session.flush()

    ut1 = UsuarioTenant(idusuario=u1.idusuario, idtenant=t1.idtenant)
    ut2 = UsuarioTenant(idusuario=u2.idusuario, idtenant=t2.idtenant)
    db_session.add_all([ut1, ut2])
    db_session.commit()

    return {"tenant1": t1, "tenant2": t2, "user1": u1, "user2": u2}


@pytest.fixture
def auth_headers(client, db_session, setup_test_data):
    """user1@test.com con rol SuperAdministrador dentro de Empresa Test 1.

    Autocontenido: no depende del seed de la base de datos.
    """
    u1 = setup_test_data["user1"]
    t1 = setup_test_data["tenant1"]

    rol = db_session.execute(
        select(Role).where(Role.nombrerol == "SuperAdministrador")
    ).scalar_one_or_none()
    if not rol:
        rol = Role(nombrerol="SuperAdministrador", descripcion="Super administrador (test)")
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

    resp = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com",
            "password": "MiClave@123",
        },
    )
    assert resp.status_code == 200, resp.text
    return {"Authorization": f"Bearer {resp.json()['access_token']}"}
