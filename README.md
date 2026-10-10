# 🛡️ Sistema de Trazabilidad Multi-Tenant para Dispositivos Tecnológicos

Plataforma integral de trazabilidad y logística para dispositivos móviles con arquitectura multi-tenant, telemetría IoT, serialización física (IMEI/Serie), códigos QR criptográficos y control de acceso basado en roles y permisos (RBAC).

---

## 🏗️ Arquitectura del Proyecto

* **Backend:** FastAPI (Python 3.11+) + PostgreSQL 16 + SQLAlchemy 2.0 + Alembic.
* **Frontend Web:** Angular 19+ (Standalone Components, Signals, Vanilla SCSS).
* **App Móvil:** Flutter SDK (Android / iOS / Web).

---

## 🚀 Guía de Instalación y Ejecución Local

### Prerrequisitos
* **Python:** 3.11 o superior instalado.
* **Node.js:** v18 o superior y npm.
* **PostgreSQL:** 16 instalado y en ejecución en el puerto `5432`.
* **Flutter SDK:** (Opcional, solo si se ejecuta la app móvil).

---

### 1. ⚙️ Backend (FastAPI + PostgreSQL)

Abre una terminal PowerShell y sigue estos pasos:

```powershell
# 1. Navegar a la carpeta del backend
cd trazabilidad/backend

# 2. Activar el entorno virtual de Python
.\.venv\Scripts\Activate.ps1

# 3. Instalar dependencias (solo la primera vez)
pip install -r requirements.txt

# 4. Configurar variables de entorno en el archivo .env
# Asegúrate de que DATABASE_URL apunte a tu base de datos local en PostgreSQL:
# DATABASE_URL=postgresql+psycopg://postgres:TU_CLAVE@localhost:5432/BLACK

# 5. Aplicar migraciones de base de datos
python -m alembic upgrade head

# 6. Ejecutar el SEED maestro integral (puebla roles, permisos, catálogo Apple, 
#    nodos en Santa Cruz, 110 unidades serializadas con QR y telemetría)
python seed.py

# 7. Iniciar el servidor local de desarrollo
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

* **URL de la API:** [http://localhost:8000](http://localhost:8000)
* **Documentación interactiva (Swagger UI):** [http://localhost:8000/docs](http://localhost:8000/docs)
* **Documentación alternativa (Redoc):** [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

### 2. 💻 Frontend Web (Angular)

En una **segunda terminal**, ejecuta:

```powershell
# 1. Navegar a la carpeta del frontend
cd trazabilidad/frontend

# 2. Instalar dependencias npm (solo la primera vez)
npm install

# 3. Iniciar el servidor de desarrollo de Angular
npm start
```

* **Acceso Web:** [http://localhost:4200](http://localhost:4200)

---

### 3. 📱 App Móvil (Flutter)

En una **tercera terminal** (opcional):

```powershell
# 1. Navegar a la carpeta móvil
cd trazabilidad/mobile

# 2. Obtener paquetes y dependencias de Flutter
flutter pub get

# 3. Ejecutar en navegador Chrome (sin necesidad de emulador pesado)
flutter run -d chrome

# 4. O ejecutar en dispositivo físico / emulador Android conectado
flutter run
```

---

## 🔑 Credenciales de Acceso de Prueba

> **Contraseña unificada para todos los usuarios demo:** `Admin123!`

| Rol / Alcance | Correo Electrónico | Empresa Asignada | Tenant Slug |
| :--- | :--- | :--- | :---: |
| **SuperAdministrador Global** | `admin@trazabilidad.com` | *Acceso irrestricto a todas las empresas* | `1` |
| **Admin Empresa 1** | `admin@trazabilidad.com` | iStore Bolivia S.A. | `1` |
| **Admin Empresa 2** | `admin@techimport.com` | TechImport Santa Cruz S.R.L. | `2` |
| **Admin Empresa 3** | `admin@andinadigital.com` | Andina Digital Ltda. | `3` |
| **Admin Empresa 4** | `admin@electrosur.com` | ElectroSur Trading S.A. | `4` |
| **Admin Empresa 5** | `admin@cochawireless.com` | Cochabamba Wireless S.A. | `5` |

### Usuarios operativos por empresa (CU-002)

Un usuario por cada rol operativo en cada empresa (3 roles x 5 tenants = 15 cuentas).
El correo se deriva del dominio del administrador de la empresa.

| Rol | Empresa | Correo Electrónico | Tenant Slug |
| :--- | :--- | :--- | :---: |
| **Gestor de Operaciones** | iStore Bolivia S.A. | `operaciones@trazabilidad.com` | `1` |
| **Gestor de Ventas y Postventa** | iStore Bolivia S.A. | `ventas@trazabilidad.com` | `1` |
| **Auditor** | iStore Bolivia S.A. | `auditor@trazabilidad.com` | `1` |
| **Gestor de Operaciones** | TechImport Santa Cruz S.R.L. | `operaciones@techimport.com` | `2` |
| **Gestor de Ventas y Postventa** | TechImport Santa Cruz S.R.L. | `ventas@techimport.com` | `2` |
| **Auditor** | TechImport Santa Cruz S.R.L. | `auditor@techimport.com` | `2` |
| **Gestor de Operaciones** | Andina Digital Ltda. | `operaciones@andinadigital.com` | `3` |
| **Gestor de Ventas y Postventa** | Andina Digital Ltda. | `ventas@andinadigital.com` | `3` |
| **Auditor** | Andina Digital Ltda. | `auditor@andinadigital.com` | `3` |
| **Gestor de Operaciones** | ElectroSur Trading S.A. | `operaciones@electrosur.com` | `4` |
| **Gestor de Ventas y Postventa** | ElectroSur Trading S.A. | `ventas@electrosur.com` | `4` |
| **Auditor** | ElectroSur Trading S.A. | `auditor@electrosur.com` | `4` |
| **Gestor de Operaciones** | Cochabamba Wireless S.A. | `operaciones@cochawireless.com` | `5` |
| **Gestor de Ventas y Postventa** | Cochabamba Wireless S.A. | `ventas@cochawireless.com` | `5` |
| **Auditor** | Cochabamba Wireless S.A. | `auditor@cochawireless.com` | `5` |

---

## 📦 Datos Poblados por Defecto en el Sistema

Al ejecutar `python seed.py`, la base de datos queda configurada con:

1. **Seguridad RBAC:** 6 roles y 38 permisos granulares vinculados en `rolpermiso`. Incluye usuarios administradores y operativos (Gestor de Operaciones, Gestor de Ventas y Postventa y Auditor) por empresa.
2. **Catálogo Apple Oficial:** iPhone 16 Pro Max, 16 Pro, 16, 15 Pro Max, 15 Pro, 15, AirPods Pro USB-C, Cargador 20W (18 variantes de color y almacenamiento).
3. **Logística Santa Cruz de la Sierra:** Nodos GPS en Aeropuerto Viru Viru, Parque Industrial, Equipetrol, Ventura Mall y Las Brisas.
4. **Inventario Físico:** Mínimo 22 unidades físicas por tenant (110 unidades en total) con números de serie de fábrica Apple, doble IMEI TAC de 8 dígitos y códigos QR con token SHA-256.
5. **Telemetría IoT:** Mediciones de temperatura (°C), humedad (%) y vibración en ruta.
