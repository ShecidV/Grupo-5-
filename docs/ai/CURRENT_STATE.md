# Estado Actual del Sistema (Current State)

> **Documento:** Snapshot Técnico y Contexto Operativo para Agentes de IA  
> **Ubicación:** `docs/ai/CURRENT_STATE.md`  
> **Última Actualización:** 2026-11-21 (Panel Integral 36 meses + Asistente de Informes personalizable + Ficha Detallada de Producto: Backend + Web + Móvil)  
> **Branch Principal:** `main` (o rama de desarrollo activa)

---

## 1. Resumen Ejecutivo de la Base de Código

* **Estado de la Suite de Pruebas:** **202 PASSED | 0 FAILED | 0 ERRORS** (100% verde en PostgreSQL; 191 previos + 7 del asistente de informes + 4 de la ficha detallada de producto).
* **Base de Datos:** PostgreSQL local `Blockchain` (misma instancia que usan la app y los tests); migración Sprint 4 aplicada (`f1a2b3c4d5e6` → head). No existe una BD `blacktest` configurada en el código.
* **Empaquetado Modular (ADR-003 + ADR-008):**
  * **P1** `app/packages/p1_seguridad/` — CU-001 a CU-005 (incluye el push de CU-005 en `/notifications/push`).
  * **P2** `app/packages/p2_catalogo/` — CU-006 a CU-012.
  * **P3** `app/packages/p3_actores/` — CU-013, CU-014.
  * **P4** `app/packages/p4_trazabilidad/` — CU-015 a CU-024.
  * **P5** `app/packages/p5_comercial/` — CU-025 a CU-032.
  * **P6** `app/packages/p6_blockchain/` — CU-033, CU-034.
  * **P7** `app/packages/p7_reportes/` — CU-035 (reportes, dashboard y PDF).
  * **P8** `app/packages/p8_suscripciones/` — CU-036 a CU-040 (creado en Sprint 4; CU-036/037 migrados desde P1 con shims retrocompatibles).
* **Consolidación en `main.py`:** exactamente **8 inclusiones canónicas** de paquete con prefijo `/api/v1` (~174 rutas registradas).
* **Sprints Completados:** S0, S1, S2, S3 y S4 (backend + web + móvil de los CUs del sprint).
* **UI Web (Angular 21):** compila con `npm run build` (styles y plantillas sin errores).
* **UI Móvil (Flutter):** `flutter analyze` → **No issues found**.

---

## 2. Mapa de Cobertura de Casos de Uso (Backend)

| CU | Nombre del Caso de Uso | Paquete | Contrato principal | Estado |
| :--- | :--- | :---: | :--- | :---: |
| **CU-001 a CU-004** | Tenants, Usuarios, RBAC, Autenticación | P1 | `/tenants`, `/users`, `/roles`, `/auth` | Implementado / Probado |
| **CU-005** | Bitácora, notificaciones y push | P1 | `/bitacora`, `/notifications`, `/notifications/push` | Implementado / Probado |
| **CU-006 a CU-012** | Catálogo, compras y recepciones | P2 | `/products`, `/purchases`, `/receptions` | Implementado / Probado |
| **CU-013, CU-014** | Actores y ubicaciones | P3 | `/actors`, `/locations` | Implementado / Probado |
| **CU-015 a CU-024** | Unidades, QR (CU-016), Escaneo QR (CU-017), Trazabilidad Pública (CU-018), envíos, eventos, IA, sospechas y alertas (CU-022: ranking ventas/períodos/top N + ficha detallada de producto a 36 meses) | P4 | `/units`, `/qr`, `/scan`, `/trace`, `/shipments`, `/alerts`, `/ai/voice-report`, `/ai/reports/{id}/export` | Implementado / Probado |
| **CU-025, CU-026** | Ventas y asignación de unidades | P5 | `/sales`, `/sales/{id}/units` | Implementado / Probado |
| **CU-027** | Pagos de venta | P5 | `/payments` | Implementado / Probado |
| **CU-028** | Historial del consumidor | P5 | `/consumer/history` | Implementado / Probado (Web + Móvil) |
| **CU-029, CU-030** | Devoluciones y sus unidades | P5 | `/returns` | Implementado / Probado |
| **CU-031** | Garantías | P5 | `/warranties` | Implementado / Probado |
| **CU-032** | Documentos de unidad | P5 | `/documents` | Implementado |
| **CU-033, CU-034** | Blockchain y certificados | P6 | `/blockchain`, `/certificates` | Implementado |
| **CU-035** | Reportes, dashboard y Panel Integral 36 meses | P7 | `/reports/summary`, `/reports/traceability`, `/reports/pdf`, `/dashboard`, `/reports/analytics` | Implementado / Probado (Web + Móvil) |
| **CU-036, CU-037** | Planes y suscripciones | P8 | `/planes`, `/suscripciones` | Implementado / Probado |
| **CU-038** | Cuotas del plan | P8 | `/quotas`, `/quotas/consume` | Implementado / Probado |
| **CU-039** | Facturación y cobros | P8 | `/invoices`, `/billing/history` | Implementado / Probado |
| **CU-040** | Notificaciones de facturación | P8 | `/billing/notifications`, `/billing/notifications/process` | Implementado / Probado (Web + Móvil) |

---

## 3. Estado de la Infraestructura y Configuración

1. **Variables de Entorno Clave (`.env`):**
   * `DATABASE_URL`: PostgreSQL (ej. `postgresql+psycopg://postgres:rafa@localhost:5432/Blockchain`).
   * `JWT_SECRET` / `JWT_ALGORITHM`: firma HS256 para tokens de sesión.
   * `BLOCKCHAIN_PROVIDER_URL`, `SMART_CONTRACT_ADDRESS`: RPC y contrato de notarización.
2. **Seguridad y RBAC:**
   * Todo endpoint sensible usa `require_roles(...)`, con bypass de `SuperAdministrador` según ADR-005.
   * Todo endpoint de lectura/mutación aplica `resolve_tenant_id` (o filtra por unidad/venta del tenant en tablas hijas), incluido `POST /billing/notifications/process` (CU-040, corregido en el cierre de Sprint 4).
3. **Servicios transversales nuevos:**
   * `UnitAvailabilityService`: valida disponibilidad de unidades antes de asignarlas a ventas/devoluciones.
   * `SalesNotarizationService`: notarización best-effort de ventas (si falla Blockchain, la venta no se revierte).
   * `PushGateway`: notificaciones in-app con proveedores externos registrables (FCM/APNs).
4. **Servicio transversal del asistente (ADR-010, ADR-011):** `VoiceQueryParser` es determinista y no añade dependencias; calcula períodos en hora Bolivia y el fallback de Gemini funciona sin API key. `POST /ai/voice-report` es aditivo (`period_label`, `interpretation`, `filters_applied`, `suggested_followups`) y, cuando se detecta un producto o la frase «analisis detallado/ficha de…», añade `product_detail` con rango fijo de 36 meses y métricas filtradas por tenant. La exportación desde `REPORT_CACHE` exige JWT y valida el `tenant_id` activo (404 si no coincide), con nombre de archivo ASCII; PDF/Excel incluyen la sección de ficha.
5. **Mantenibilidad:**
   * `app/main.py` registra exclusivamente las 8 fachadas de paquete.
   * Los contratos REST históricos y los imports previos se preservan mediante shims.

---

## 4. Datos históricos de demostración (3 años / 36 meses)

* Script activo: `trazabilidad/backend/seed_historical_36m.py` (envoltorio de `seed_historical_6m.py`, `MESES=36`) con `--dry-run`, `--reset-history` y manifest `seed_historical_36m.manifest.json` (**20.401 IDs**; siembra los IDs del manifest 6m).
* Periodos generados: **`2023-12` a `2026-11`** (36 meses, relativos a `get_bolivia_now()`), para los tenants 1 a 5.
* Volumen total cargado: **20.401 filas** (17.335 del histórico previo + 2.340 de garantías/reportes por unidad + 726 de unidades en tránsito por variante). Por tenant: ~513 unidades base/QR/consultas, 148 eventos con condición/anclaje, 142 ventas/pagos, 30 facturas/cobros, 116 alertas, 12 devoluciones, 216 garantías, 144 reportes de sospecha con evidencia y unidades en tránsito por variante activa cada 6 meses, bitácora/notificaciones/usoplan proporcionales.
* Idempotencia demostrada: tras la carga, `--dry-run` y una segunda ejecución real insertan **0 filas**.
* `/api/v1/reports/analytics?meses=36` devuelve 11 series con 36 puntos cada una; 36/36 meses con datos reales. `/api/v1/reports/traceability` sigue devolviendo sus 6 puntos originales (contrato intacto).
* Los datos estan **solo en la BD local**; para la nube (Railway) hay que ejecutar `seed_historical_36m.py` alli (ver `HANDOFF_LATEST.md`, sección 5).
