import os
import sys

# Ensure backend root is in sys.path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.db.base import Base
from app.db.session import get_db
from app.main import app
from app.core.config import settings
from app.models.tenant import Tenant
from app.models.user import User
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
    t1 = Tenant(name="Empresa Test 1", slug="empresa-test-1", is_active=True)
    t2 = Tenant(name="Empresa Test 2", slug="empresa-test-2", is_active=True)
    db_session.add_all([t1, t2])
    db_session.flush()

    u1 = User(
        tenant_id=t1.id,
        email="user1@test.com",
        password_hash=hash_password("MiClave@123"),
        first_name="Usuario",
        last_name="Uno",
        is_active=True
    )
    u2 = User(
        tenant_id=t2.id,
        email="user1@test.com",
        password_hash=hash_password("OtroPassword@456"),
        first_name="Usuario",
        last_name="Dos",
        is_active=True
    )
    db_session.add_all([u1, u2])
    db_session.commit()

    return {"tenant1": t1, "tenant2": t2, "user1": u1, "user2": u2}
