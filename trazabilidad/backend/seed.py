import sys
import os
from sqlalchemy.orm import Session
from sqlalchemy import select

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.db.session import SessionLocal
from app.models.tenant import Tenant
from app.models.user import User
from app.core.security import hash_password, validate_password_strength


def run_seed():
    db: Session = SessionLocal()
    try:
        # 1. Ensure Tenant 'Empresa Demo' exists
        stmt_tenant = select(Tenant).where(Tenant.slug == "empresa-demo")
        tenant = db.execute(stmt_tenant).scalar_one_or_none()
        if not tenant:
            tenant = Tenant(
                name="Empresa Demo",
                slug="empresa-demo",
                is_active=True
            )
            db.add(tenant)
            db.flush()
            print("Tenant 'Empresa Demo' creado exitosamente.")
        else:
            print("Tenant 'Empresa Demo' ya existe.")

        # 2. Ensure User 'diogomars2026@gmail.com' exists
        email = "diogomars2026@gmail.com"
        stmt_user = select(User).where(
            User.tenant_id == tenant.id,
            User.email == email
        )
        user = db.execute(stmt_user).scalar_one_or_none()

        password = os.getenv("SEED_PASSWORD", "Admin123.")
        is_valid, msg = validate_password_strength(password)
        if not is_valid:
            print(f"Error: La contraseña no cumple los requisitos: {msg}")
            sys.exit(1)

        if not user:
            user = User(
                tenant_id=tenant.id,
                email=email,
                password_hash=hash_password(password),
                first_name="Diogo",
                last_name="Mars",
                is_active=True
            )
            db.add(user)
            print(f"Usuario '{email}' creado exitosamente para 'Empresa Demo'.")
        else:
            user.password_hash = hash_password(password)
            user.is_active = True
            print(f"Usuario '{email}' actualizado exitosamente con nueva contraseña.")

        db.commit()

    except Exception as e:
        db.rollback()
        print(f"Error al ejecutar el seed: {e}")
    finally:
        db.close()


if __name__ == "__main__":
    run_seed()
