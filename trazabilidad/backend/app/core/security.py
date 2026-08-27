import re
import hashlib
import secrets
from datetime import datetime, timedelta, timezone
from typing import Optional, Tuple
import jwt
from pwdlib import PasswordHash

from app.core.config import settings

# Initialize Argon2 password hasher
password_hash_context = PasswordHash.recommended()


def hash_password(password: str) -> str:
    """Hash password using Argon2id."""
    return password_hash_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify plain password against hashed password."""
    try:
        return password_hash_context.verify(plain_password, hashed_password)
    except Exception:
        return False


def validate_password_strength(password: str) -> Tuple[bool, str]:
    """
    Validate password strength according to requirements:
    - Min 8 chars
    - At least 1 uppercase
    - At least 1 lowercase
    - At least 1 number
    - At least 1 special char (!@#$%^&*()_-+=.,)
    """
    if len(password) < 8:
        return False, "La contraseña debe tener al menos 8 caracteres."
    if not re.search(r"[A-Z]", password):
        return False, "La contraseña debe contener al menos una letra mayúscula."
    if not re.search(r"[a-z]", password):
        return False, "La contraseña debe contener al menos una letra minúscula."
    if not re.search(r"[0-9]", password):
        return False, "La contraseña debe contener al menos un número."
    if not re.search(r"[!@#$%^&*()_\-+=\.,]", password):
        return False, "La contraseña debe contener al menos un carácter especial (!@#$%^&*()_-+=.,)."
    return True, ""


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """Create JWT Access Token."""
    to_encode = data.copy()
    now = datetime.now(timezone.utc)
    if expires_delta:
        expire = now + expires_delta
    else:
        expire = now + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"iat": now, "exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)
    return encoded_jwt


def decode_access_token(token: str) -> Optional[dict]:
    """Decode and validate JWT Access Token."""
    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
        return payload
    except jwt.PyJWTError:
        return None


def generate_secure_raw_token() -> str:
    """Generate a cryptographically secure random token string."""
    return secrets.token_urlsafe(32)


def hash_token(token: str) -> str:
    """Generate SHA-256 hash of a raw token for safe database storage."""
    return hashlib.sha256(token.encode("utf-8")).hexdigest()
