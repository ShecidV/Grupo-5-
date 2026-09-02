# 🛡️ Backend (FastAPI & PostgreSQL)

## 🛠️ Comando de Instalación Directa

```powershell
pip install -r requirements.txt
```

> **Librerías instaladas:** `fastapi`, `uvicorn`, `sqlalchemy`, `psycopg`, `alembic`, `argon2-cffi`, `pwdlib`, `pyjwt`, `pydantic-settings`, `aiosmtplib`, `jinja2`, `pytest`, `httpx`.

---

## 🚀 Comandos para Levantar el Backend

```powershell
# 1. Activar entorno virtual
.\.venv\Scripts\Activate.ps1

# 2. Aplicar migraciones de base de datos
python -m alembic upgrade head

# 3. Cargar datos iniciales
python seed.py

# 4. Iniciar servidor
uvicorn app.main:app --reload
```

* **URL API:** http://127.0.0.1:8000
* **Documentación (Swagger):** http://127.0.0.1:8000/docs
