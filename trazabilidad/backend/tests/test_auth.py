from datetime import datetime, timedelta, timezone
from app.models.password_reset_token import PasswordResetToken
from app.core.security import hash_token


def test_login_success(client, setup_test_data):
    response = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com",
            "password": "MiClave@123"
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["user"]["email"] == "user1@test.com"
    assert "refresh_token" in response.cookies


def test_login_invalid_password(client, setup_test_data):
    response = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com",
            "password": "WrongPassword@123"
        }
    )
    assert response.status_code == 401


def test_login_invalid_tenant(client, setup_test_data):
    response = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-inexistente",
            "email": "user1@test.com",
            "password": "MiClave@123"
        }
    )
    assert response.status_code == 401


def test_login_user_from_other_tenant(client, setup_test_data):
    # user1@test.com on tenant 2 has password "OtroPassword@456"
    response = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-2",
            "email": "user1@test.com",
            "password": "MiClave@123"  # Password of tenant 1 user!
        }
    )
    assert response.status_code == 401


def test_password_requirements_validation(client):
    # Test reset password with weak password
    response = client.post(
        "/api/v1/auth/reset-password",
        json={
            "token": "dummymatch",
            "new_password": "weak",
            "confirm_password": "weak"
        }
    )
    assert response.status_code == 400
    assert "8 caracteres" in response.json()["detail"]


def test_forgot_password_request(client, setup_test_data):
    response = client.post(
        "/api/v1/auth/forgot-password",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com"
        }
    )
    assert response.status_code == 200
    assert "Si la cuenta existe" in response.json()["message"]


def test_reset_password_valid_token(client, db_session, setup_test_data):
    user1 = setup_test_data["user1"]
    tenant1 = setup_test_data["tenant1"]

    raw_token = "valid-reset-token-123"
    token_hash_val = hash_token(raw_token)
    expires_at = datetime.now(timezone.utc) + timedelta(minutes=30)

    reset_token = PasswordResetToken(
        tenant_id=tenant1.id,
        user_id=user1.id,
        token_hash=token_hash_val,
        expires_at=expires_at
    )
    db_session.add(reset_token)
    db_session.commit()

    # Perform reset
    response = client.post(
        "/api/v1/auth/reset-password",
        json={
            "token": raw_token,
            "new_password": "NuevaClave@999",
            "confirm_password": "NuevaClave@999"
        }
    )
    assert response.status_code == 200
    assert "correctamente" in response.json()["message"]

    # Verify login with new password
    login_resp = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com",
            "password": "NuevaClave@999"
        }
    )
    assert login_resp.status_code == 200


def test_reset_password_expired_token(client, db_session, setup_test_data):
    user1 = setup_test_data["user1"]
    tenant1 = setup_test_data["tenant1"]

    raw_token = "expired-reset-token"
    token_hash_val = hash_token(raw_token)
    expires_at = datetime.now(timezone.utc) - timedelta(minutes=10)

    reset_token = PasswordResetToken(
        tenant_id=tenant1.id,
        user_id=user1.id,
        token_hash=token_hash_val,
        expires_at=expires_at
    )
    db_session.add(reset_token)
    db_session.commit()

    response = client.post(
        "/api/v1/auth/reset-password",
        json={
            "token": raw_token,
            "new_password": "NuevaClave@999",
            "confirm_password": "NuevaClave@999"
        }
    )
    assert response.status_code == 400
    assert "expirado" in response.json()["detail"]


def test_reset_password_already_used_token(client, db_session, setup_test_data):
    user1 = setup_test_data["user1"]
    tenant1 = setup_test_data["tenant1"]

    raw_token = "used-reset-token"
    token_hash_val = hash_token(raw_token)
    expires_at = datetime.now(timezone.utc) + timedelta(minutes=30)

    reset_token = PasswordResetToken(
        tenant_id=tenant1.id,
        user_id=user1.id,
        token_hash=token_hash_val,
        expires_at=expires_at,
        used_at=datetime.now(timezone.utc)
    )
    db_session.add(reset_token)
    db_session.commit()

    response = client.post(
        "/api/v1/auth/reset-password",
        json={
            "token": raw_token,
            "new_password": "NuevaClave@999",
            "confirm_password": "NuevaClave@999"
        }
    )
    assert response.status_code == 400
    assert "ya ha sido utilizado" in response.json()["detail"]


def test_get_me_unauthenticated(client):
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 403 or response.status_code == 401


def test_get_me_authenticated(client, setup_test_data):
    login_resp = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com",
            "password": "MiClave@123"
        }
    )
    token = login_resp.json()["access_token"]

    response = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {token}"}
    )
    assert response.status_code == 200
    assert response.json()["email"] == "user1@test.com"
    assert response.json()["tenant"]["slug"] == "empresa-test-1"
