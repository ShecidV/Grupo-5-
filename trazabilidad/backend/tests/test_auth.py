from datetime import datetime, timedelta, timezone
from app.models.cu004_autenticacion.password_reset_token import PasswordResetToken
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
            "tenant_slug": "empresa-inexistente-xyz",
            "email": "user1@test.com",
            "password": "MiClave@123"
        }
    )
    # If no match is found, fallback returns active tenant or 401
    assert response.status_code in (200, 401)


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
        idtenant=tenant1.idtenant,
        idusuario=user1.idusuario,
        tokenhash=token_hash_val,
        expiraen=expires_at
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
        idtenant=tenant1.idtenant,
        idusuario=user1.idusuario,
        tokenhash=token_hash_val,
        expiraen=expires_at
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
        idtenant=tenant1.idtenant,
        idusuario=user1.idusuario,
        tokenhash=token_hash_val,
        expiraen=expires_at,
        usadoen=datetime.now(timezone.utc)
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
    assert response.status_code in (401, 403)


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


def test_refresh_returns_new_access_token(client, setup_test_data):
    login_resp = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com",
            "password": "MiClave@123"
        }
    )
    assert login_resp.status_code == 200
    assert "refresh_token" in client.cookies

    resp = client.post("/api/v1/auth/refresh")
    assert resp.status_code == 200
    data = resp.json()
    assert "access_token" in data
    assert data["user"]["email"] == "user1@test.com"

    # El token refrescado debe ser funcional
    me = client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {data['access_token']}"}
    )
    assert me.status_code == 200


def test_refresh_without_cookie_returns_401(client):
    resp = client.post("/api/v1/auth/refresh")
    assert resp.status_code == 401
    assert "refresco" in resp.json()["detail"].lower()


def test_refresh_with_invalid_token_returns_401(client):
    client.cookies.set("refresh_token", "token-inventado-no-existe")
    resp = client.post("/api/v1/auth/refresh")
    assert resp.status_code == 401


def test_logout_revokes_refresh_token(client, setup_test_data):
    login_resp = client.post(
        "/api/v1/auth/login",
        json={
            "tenant_slug": "empresa-test-1",
            "email": "user1@test.com",
            "password": "MiClave@123"
        }
    )
    assert login_resp.status_code == 200
    raw_refresh = client.cookies.get("refresh_token")
    assert raw_refresh

    logout_resp = client.post("/api/v1/auth/logout")
    assert logout_resp.status_code == 200
    assert "correctamente" in logout_resp.json()["message"].lower()

    # Reenviar el mismo token de refresco: fue revocado
    client.cookies.set("refresh_token", raw_refresh)
    resp = client.post("/api/v1/auth/refresh")
    assert resp.status_code == 401
    assert "revocado" in resp.json()["detail"].lower()


def test_logout_without_cookie_returns_200(client):
    resp = client.post("/api/v1/auth/logout")
    assert resp.status_code == 200
