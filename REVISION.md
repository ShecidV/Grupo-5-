# Revisión del Análisis — Sprint 1 y Sprint 2

> Nota de continuación: si estás retomando este trabajo al día siguiente, leé primero
> la sección [Resumen ejecutivo](#resumen-ejecutivo) y [Próximos pasos](#próximos-pasos-sugeridos).
> Este archivo resume toda la auditoría de casos de uso (Sprint 1 y Sprint 2) y la corrida
> de pruebas realizada, para saber exactamente en qué punto quedó cada cosa.

---

## 1. Contexto

**Objetivo de la sesión:** determinar si están implementados todos los casos de uso de los
Sprints 1 y 2 del proyecto (documento de ingeniería de software en `extracted_doc_text.txt` /
`Sprint#2.pdf`) y verificar el estado real de las pruebas con pytest.

**Stack del proyecto:**
- Backend: FastAPI + PostgreSQL + SQLAlchemy 2.0 + Alembic (`trazabilidad/backend`).
- Frontend web: Angular (`trazabilidad/frontend`).
- App móvil: Flutter (`trazabilidad/mobile`).

**Caso de uso por sprint (según el documento):**

| Sprint | CUs |
| :--- | :--- |
| **Sprint 1** — Autenticación y gestión de productos | CU-004, CU-006, CU-007, CU-008, CU-009, CU-013, CU-014 |
| **Sprint 2** — Compras, unidades y logística | CU-010, CU-011, CU-012, CU-015, CU-016, CU-019, CU-020, CU-021 |

---

## 2. Resumen ejecutivo

- **Los 15 casos de uso de Sprint 1 y Sprint 2 están implementados** en backend (controller +
  router registrado en `main.py`) y en el frontend web (componente + vista + ruta + servicio).
- **Sprint 2 tiene cobertura de tests 25/25 PASSED** (`tests/test_sprint2_cu.py`).
- **Sprint 1 tiene cobertura parcial de tests**, con varios que fallan por *fragilidad del
  harness* (IDs hardcodeados + filtraciones de estado entre tests), NO por falta de implementación.
- **RBAC por roles completado en los 15 CUs** de Sprint 1 y 2 (ver sección 5.1): toda
  endpoint de escritura exige `require_roles(...)`; las lecturas siguen siendo solo
  autenticadas (consistente con el resto de la API).
- **Garantía SuperAdministrador: acceso total** (ver 5.1): bypass verificado en JWT/DB de
  `require_roles`, en el `roleGuard` de Angular y ahora también en `resolve_tenant_id`
  (podía operar cualquier empresa sin exigir vínculo). Además `switch-tenant` valida
  membresía (403 para no miembros) y el SuperAdmin queda vinculado con su rol al cambiar
  a una empresa nueva (pendiente 3 cerrado).
- Hay **baches de calidad** detectados en la auditoría de código (ver sección 6): RBAC débil en
  varios endpoints, endpoint público `/trace/{uuid}` inexistente, imagen QR sin autenticar, entre
  otros.
- La corrida pytest se hizo contra una DB local scratch llamada **`blacktest`** (PostgreSQL 18
  local). Quedó creada y con datos de prueba; no se tocó la base de Supabase del `.env`.

---

## 3. Auditoría por capa

### 3.1 Backend (FastAPI)

**Todo implementado y con router en `app/main.py`:**

| CU | Router / Controller | Estado |
| :--- | :--- | :--- |
| CU-004 | `views/cu004_autenticacion/auth_controller.py` | Implementado |
| CU-006 | `controllers/cu006_productos_variantes/product_controller.py` | Implementado |
| CU-007 | `controllers/cu007_certificaciones/certification_controller.py` | Implementado |
| CU-008 | `controllers/cu008_catalogo_empresa/tenant_catalog_controller.py` | Implementado |
| CU-009 | `controllers/cu009_categorias/category_controller.py` | Implementado |
| CU-013 | `controllers/cu013_actores_cadena/actor_controller.py` | Implementado |
| CU-014 | `controllers/cu014_ubicaciones/location_controller.py` | Implementado |
| CU-010 | `controllers/cu010_ordenes_compra/purchase_controller.py` | Implementado |
| CU-011 | `controllers/cu011_compras/purchase_approval_controller.py` | Implementado |
| CU-012 | `controllers/cu012_recepciones/reception_controller.py` | Implementado |
| CU-015 | `controllers/cu015_unidades_producto/unit_controller.py` | Implementado |
| CU-016 | `controllers/cu016_codigos_qr/qr_controller.py` | Implementado |
| CU-019 | `controllers/cu019_envios_logisticos/shipment_controller.py` | Implementado |
| CU-020 | `controllers/cu020_asignacion_unidades_envio/shipment_unit_controller.py` | Implementado |
| CU-021 | `controllers/cu021_eventos_transporte/transport_event_controller.py` | Implementado |

### 3.2 Frontend web (Angular)

Todo implementado: cada CU tiene componente, vista, ruta protegida con `authGuard` + `roleGuard`
y servicio consumiendo la API:

| CU | Ruta |
| :--- | :--- |
| CU-004 | `/login`, `/forgot-password`, `/reset-password` |
| CU-006 | `/products` |
| CU-007 | `/certifications` |
| CU-008 | `/tenant-catalog` |
| CU-009 | `/categories` |
| CU-013 | `/actors` |
| CU-014 | `/locations` |
| CU-010 / CU-011 | `/purchases` (alta/edición + aprobación/rechazo) |
| CU-012 | `/receptions` |
| CU-015 | `/units` |
| CU-016 | `/qr-codes` (individual + bulk + descarga PNG) |
| CU-019 / CU-020 / CU-021 | `/shipments` (envíos + asignación de unidades + timeline/eventos) |

### 3.3 App móvil (Flutter)

| CU | Estado móvil |
| :--- | :--- |
| CU-004 | Implementado (login / forgot / reset) |
| CU-021 | Implementado (registro de eventos + telemetría, timeline) |
| CU-010 / CU-011 / CU-016 | Implementados (compras, aprobación/rechazo, QR) |
| CU-012, CU-015, CU-020 | Sin pantalla móvil (la tabla del doc los marca web-only, pero la narrativa del doc los llama "casos de uso móviles" — ver sección 6) |

---

## 4. Corrida de pytest

### 4.1 Cómo se ejecutó

1. PostgreSQL 18 local con servicio `postgresql-x64-18` corriendo en `localhost:5432`.
2. DB scratch: `CREATE DATABASE blacktest;`
3. Migraciones: `DATABASE_URL=postgresql+psycopg://postgres:***@localhost:5432/blacktest`
   → `.venv\Scripts\python.exe -m alembic upgrade head`
4. Seed maestro: `.venv\Scripts\python.exe seed.py` (necesario: varios tests asumen los datos
   de `admin@trazabilidad.com` / `Admin123!` y del catálogo Apple).
5. Pruebas:
   `$env:PYTHONDONTWRITEBYTECODE='1'; python -m pytest -p no:cacheprovider -v`

> La password del postgres local se usó solo en la URL de la corrida, no quedó guardada en archivos.
> La DB `blacktest` sigue creada con datos de prueba (se puede borrar cuando se quiera).

### 4.2 Resultado final (con seed aplicado)

> Corrida de verificación post-RBAC + garantía SuperAdmin (2026-10-08, contra `blacktest` con seed):
> **68 passed | 6 failed | 11 errors** = baseline (59 passed) + los 9 tests de
> `tests/test_rbac.py` (4 iniciales de roles + 5 nuevos: bypass SuperAdmin cross-tenant,
> aislamiento cross-tenant 403, switch-tenant miembro 200 / no-miembro 403, SuperAdmin
> crea vínculo con rol). Ningún fallo nuevo ni 403 inesperado en los endpoints protegidos.

```
76 tests recolectados
59 passed | 6 failed | 11 errors | (11 skipped — de CU-022/IA, fuera de sprint)
```

**Resumen por archivo:**

| Archivo | CUs | Resultado |
| :--- | :--- | :--- |
| `test_auth.py` | CU-004 | 8/8 PASSED |
| `test_sprint2_cu.py` | Sprint 2 (010, 011, 012, 015, 016, 019, 020, 021) | 25/25 PASSED |
| `test_supply_chain.py` | CU-013, CU-014 | actors/locations PASSED; units_crud FAILED (FK) |
| `test_catalog.py` | CU-009, CU-006 | categorías PASSED; productos FAILED (FK idcategoria=3) |
| `test_cert_catalog.py` | CU-007, CU-008 | FAILED (404 vs 201 / FK) |
| `test_roles.py` | CU-003 (Sprint 0) | list_roles PASSED; permisos/asignación FAILED (idrol=1) |
| `test_tenants.py`, `test_users.py`, `test_audit.py` | Sprint 0 | PASSED |
| `test_recommendations.py` | CU-022 (IA, fuera de sprint) | 11 ERRORES SQLAlchemy |

### 4.3 Causa raíz de los fallos (fragilidad de la suite, NO código faltante)

- **IDs hardcodeados**: los tests usan `idrol=1` y `idcategoria=3`, pero el seed genera los
  registros con otros IDs (los roles quedaron en 24-29, las categorías en 25-27).
- **Filtración de estado entre tests**: el fixture de `conftest.py` envuelve cada test en una
  transacción con rollback, pero los endpoints hacen `commit()` propios y el rollback falla con
  `SAWarning: transaction already deassociated`. Evidencia: la DB quedó con **395 unidades**
  (el seed crea 110), una "Categoría Test …" persistida y roles en 24-29.
- El test `test_create_reception_completa_genera_unidades` dio `3 != 2` en la primera corrida
  (sin seed) y **pasó** en la segunda (con seed): confirma dependencia del estado de la DB.

**Conclusión:** los CUs de Sprint 1 y 2 están implementados; los fracasos son del harness de
pruebas (tests no auto-contenidos), no de los casos de uso.

---

## 5. Baches detectados en la auditoría de código (pendientes)

### 5.1 RBAC por roles — ✅ COMPLETADO

Se decidió el nivel **roles** (no permisos granulares) y se aplicó `require_roles(...)` a
todas las endpoints de escritura que estaban sin protección, siguiendo el patrón de
CU-010/011/012/019/020. Mapeo derivado de `MATRIZ_ROL_PERMISOS` en `seed.py`:

| CU | Constante | Roles en escritura |
| :--- | :--- | :--- |
| CU-006 productos/variantes | `ROLES_GESTION_PRODUCTO` | SuperAdministrador, AdministradorEmpresa |
| CU-007 certificaciones (+vinculación a producto) | `ROLES_GESTION_CERTIFICACION` | SuperAdministrador, AdministradorEmpresa |
| CU-008 catálogo empresa (POST/PUT/DELETE) | `ROLES_GESTION_CATALOGO_EMPRESA` | SuperAdministrador, AdministradorEmpresa |
| CU-009 categorías | `ROLES_GESTION_CATEGORIA` | SuperAdministrador, AdministradorEmpresa |
| CU-013 actores | `ROLES_GESTION_ACTOR` | SuperAdministrador, AdministradorEmpresa |
| CU-014 ubicaciones | `ROLES_GESTION_UBICACION` | + GestorOperaciones |
| CU-015 unidades: alta/baja | `ROLES_GESTION_UNIDAD` | + GestorOperaciones |
| CU-015 unidades: edición | `ROLES_EDICION_UNIDAD` | + GestorVentasPostventa (`units:update`) |
| CU-016 QR (`generate`, `generate-bulk`) | `ROLES_GENERACION_QR` | + GestorOperaciones (`qr:generate`) |
| CU-021 eventos de transporte (POST events) | `ROLES_EVENTOS_TRANSPORTE` | + GestorOperaciones (`shipments:telemetry`) |

Notas:
- **Desviación documentada:** la matriz da `products:manage` solo a SuperAdministrador,
  pero el documento de sprint dice que el catálogo se gestiona "por empresa"; se habilitó
  también a `AdministradorEmpresa`. Si se quiere estricto, quitarlo de
  `ROLES_GESTION_PRODUCTO` en `product_controller.py`.
- `GET /shipments/{id}/timeline` y el resto de lecturas quedaron solo con
  `get_current_user` (consistente con toda la API).
- `POST /tenant-catalog/recommendations` (IA, computacional) quedó autenticado sin rol.
- **Sprint 0 sigue sin RBAC:** `/tenants`, `/users`, `/users/{id}/roles` (pruebas
  `test_tenants`/`test_users` dependen de eso). `switch-tenant` ya valida membresía
  (ver 5.2.3).
- **Garantía SuperAdministrador (acceso total):**
  - `require_roles` (shared.py): bypass si el rol está en el JWT (que lo incluye vía
    cualquier vínculo) o en DB (fallback).
  - `roleGuard` de Angular: bypass en todas las rutas.
  - `resolve_tenant_id` (shared.py): **nuevo bypass** — opera cualquier empresa sin exigir
    vínculo `UsuarioTenant` (validando solo que el tenant exista). Sin esto un SuperAdmin
    sin vínculo en un tenant creado después del seed recibía 403.
  - `switch-tenant`: el SuperAdmin puede cambiar a cualquier empresa; si no estaba
    vinculado se crea el vínculo **con rol SuperAdministrador asignado**.
  - Mobile no tiene gating por roles → sin excepciones.

### 5.2 Otros pendientes

1. **Modelo de 38 permisos sin evaluar.** `Permiso` / `rolpermiso` existen y el seed los crea,
   pero ningún endpoint verifica permisos, solo roles (decisión: se implementó solo roles,
   ver 5.1). Requiere un helper `require_permission(...)` si se quiere granularidad.
2. **CU-016 — endpoint público `/trace/{uuid}` inexistente.** `qr_controller.py:50` construye la
   URL de verificación pública, pero esa ruta no existe en el backend (correspondería a CU-018/022
   de Sprint 3). Además `GET /qr/{id}/image` (descarga del QR) no exige autenticación.
3. ~~**CU-004 — `switch-tenant` sin validar membresía** (`auth_controller.py:583`)~~
   **COMPLETADO:** ahora exige vínculo `UsuarioTenant` (403 para no miembros); el
   SuperAdministrador puede cambiar a cualquier empresa y queda vinculado con el rol
   SuperAdministrador. Tests: `test_switch_tenant_*` en `tests/test_rbac.py`.
4. **Tests faltantes** (cobertura que no existe):
   - CU-010: creación/edición de órdenes de compra.
   - CU-019: creación/edición/transiciones de estado de envíos.
   - CU-004: ~~`switch-tenant`~~ **HECHO** (`test_switch_tenant_*` en `tests/test_rbac.py`);
     faltan `refresh`, `logout`.
   - RBAC: ~~tests de 403~~ **HECHO** en `tests/test_rbac.py` (falta cubrir el resto de CUs).
5. **Mobile pendiente** (a decidir): CU-012 (recepción), CU-015 (unidades) y CU-020 (asignación a
   envío) no tienen pantalla Flutter. La tabla del documento los marca **web-only**, pero el texto
   narrativo los llama "casos de uso móviles"; el documento se contradice.
6. **Inconsistencias del documento:**
   - La tabla general lista **CU-015 como Sprint 1** (el backlog de S1 no lo incluye; S2 sí).
   - La tabla general lista **CU-032 "Adjuntar Documentos a Unidades" como Sprint 2**: no está en
     el backlog de S2 (SP3 sí lo lista) y **no está implementado** (no existe `cu032` en backend).
   - Dominios de Railway distintos entre QR (`blockchain-production-8de2...`) y la API
     (`grupo5si2-production-380b...`).

---

## 6. Próximos pasos sugeridos

1. ~~Decidir el nivel de RBAC y aplicarlo en los CUs sin protección~~ **HECHO** (sección 5.1):
   nivel roles, aplicado a CU-021, CU-015, Sprint 1 completo y QR de CU-016; verificado con
   la suite (68 passed incl. `tests/test_rbac.py`, mismos 6 fallos preexistentes del harness).
2. Implementar (o delegar a Sprint 3) el endpoint público `/trace/{uuid}` y autenticar la
   descarga de imagen QR.
3. ~~Validar membresía en `switch-tenant` (CU-004)~~ **HECHO** (ver 5.2.3): 403 para no
   miembros; SuperAdmin puede cambiar a cualquier empresa y queda vinculado con su rol.
   Garantía SuperAdmin ("acceso a todo") verificada también en `resolve_tenant_id`.
4. Corregir la fragilidad de la suite (`test_catalog`, `test_cert_catalog`, `test_roles`,
   `test_supply_chain`): reemplazar IDs hardcodeados por la creación de dependencias dentro del
   propio test y/o aislar el estado (commit/rollback).
5. Agregar los tests faltantes del punto 5.
6. Decidir si CU-012 / CU-015 / CU-020 deben tener app móvil (alinear con la narrativa del documento).
7. Limpieza: borrar la DB `blacktest` local al finalizar.

---

## 7. Enlaces útiles

- Backend y rutas: `trazabilidad/backend/app/controllers/*/...` y `trazabilidad/backend/app/main.py`
- Tests: `trazabilidad/backend/tests/`
- Documento extraído: `extracted_doc_text.txt` (tabla de CUs en líneas ~2187-2403)
- Ocurrencias de CUs en el documento: `cu_occurrences.txt`
- Documento Sprint 2 en texto: `sprint2_full_text.txt`
- README del proyecto (ejecución local): `README.md`