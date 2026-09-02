# 🛡️ Backend - Sistema Multi-Tenant empresarial (FastAPI & PostgreSQL)

Este es el backend del Sistema Empresarial Multi-Tenant construido con **FastAPI**, **PostgreSQL**, **SQLAlchemy 2**, **Argon2** y **JWT**.

---

## 📦 Librerías y Dependencias Instaladas

A continuación se detallan las librerías principales instaladas en Python (`requirements.txt`):

### 1. Framework y Servidor Web
* **`fastapi`** (`0.141.1`): Framework web de alto rendimiento para construir APIs REST asíncronas con Python.
* **`uvicorn`** (`0.52.4`): Servidor web ASGI ultra rápido basado en `uvloop` y `httptools` para ejecutar FastAPI.
* **`starlette`** (`1.6.0`): Núcleo sobre el cual está construido FastAPI, manejando peticiones HTTP y cookies `HttpOnly`.

### 2. Base de Datos y ORM
* **`SQLAlchemy`** (`2.0.52`): ORM moderno (versión 2.0) para mapeo objeto-relacional y consultas asíncronas/síncronas.
* **`psycopg` / `psycopg-binary`** (`3.3.4`): Adaptador y driver oficial de PostgreSQL para Python 3.
* **`alembic`** (`1.19.1`): Herramienta oficial de migraciones de estructura de datos para SQLAlchemy.

### 3. Seguridad, Hashing y Autenticación
* **`pwdlib`** (`0.3.1`) & **`argon2-cffi`** (`25.1.0`): Algoritmo de hashing de contraseñas de alta seguridad recomendado por OWASP (**Argon2id**).
* **`PyJWT`** (`2.13.0`): Generación y verificación de Tokens JWT para autenticación sin estado (Stateless).

### 4. Configuración y Validación de Datos
* **`pydantic`** (`2.13.4`): Validación y parsing estricto de tipos de datos en esquemas de entrada y salida.
* **`pydantic-settings`** (`2.15.0`): Carga y validación automática de variables de entorno desde el archivo `.env`.
* **`python-dotenv`** (`1.2.3`): Lectura de archivos de configuración `.env`.
* **`email-validator`** (`2.3.0`): Validación estricta de formato de correos electrónicos.

### 5. Envíos de Correo SMTP y Plantillas
* **`aiosmtplib`** (`5.1.2`): Cliente SMTP asíncrono no bloqueante para el envío de correos electrónicos.
* **`Jinja2`** (`3.1.6`): Motor de plantillas HTML para renderizar el correo interactivo de restablecimiento de contraseña.

### 6. Testing y Pruebas Automatizadas
* **`pytest`** (`9.1.1`): Framework de ejecución de pruebas unitarias e integración.
* **`httpx`** (`0.28.1`): Cliente HTTP asíncrono para probar los endpoints de FastAPI en la suite de pruebas.

---

## 🧩 Extensiones Recomendadas para VSCode

Para un flujo de trabajo óptimo en VSCode, se recomienda instalar:
1. **Python** (`ms-python.python`): Soporte de lenguaje, formateo y depuración.
2. **Pylance** (`ms-python.vscode-pylance`): Autocompletado e intellisense rápido para Python.
3. **PostgreSQL** (`ckpoint.postgresql`): Explorador e interacción directa con la base de datos PostgreSQL.

---

## 🚀 Cómo Levantar el Backend Paso a Paso

### 1. Requisitos Previos
* Python 3.10 o superior (Verificado con Python 3.14).
* PostgreSQL activo en `localhost:5432` con la base de datos `trazabilidad` creada.

### 2. Pasos para Iniciar
1. Abre tu terminal en la carpeta del backend:
   ```bash
   cd trazabilidad/backend
   ```

2. Activa el entorno virtual:
   - **En Windows (PowerShell):**
     ```powershell
     .\.venv\Scripts\Activate.ps1
     ```
   - **En Linux / macOS:**
     ```bash
     source .venv/bin/activate
     ```

3. Verifica o configura el archivo `.env`:
   ```env
   APP_NAME=Sistema de Trazabilidad
   ENVIRONMENT=development
   DATABASE_URL=postgresql+psycopg://postgres:223051268@localhost:5432/trazabilidad
   JWT_SECRET=c948a31e8bf4b22c7104b2a8d5f3089408b07e7ef2a42a02d2bc27c62b9a71fd
   FRONTEND_URL=http://localhost:4200
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=diogomars2020@gmail.com
   SMTP_PASSWORD=ckllbyewhdfbinky
   SMTP_FROM=diogomars2020@gmail.com
   SMTP_STARTTLS=true
   ```

4. Ejecuta las migraciones de Alembic (creación de tablas):
   ```powershell
   python -m alembic upgrade head
   ```

5. Poblar los datos iniciales de prueba (Seed):
   ```powershell
   python seed.py
   ```

6. Iniciar el servidor web Uvicorn:
   ```powershell
   uvicorn app.main:app --reload
   ```

---

## 🔗 URLs Útiles
* **API Server:** [http://127.0.0.1:8000](http://127.0.0.1:8000)
* **Documentación Interactivas (Swagger UI):** [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
* **Documentación ReDoc:** [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)
