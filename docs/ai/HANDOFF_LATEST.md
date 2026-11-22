# Relevo Operativo de Agentes (Handoff Latest)

> **Documento:** Pase de Posta Inmediato entre Sesiones de Agentes de IA  
> **Ubicación:** `docs/ai/HANDOFF_LATEST.md`  
> **Fecha / Sesión:** 2026-11-21  
> **Sprint Activo:** Sprint 4 (Comercialización, Reportes y Monetización SaaS)  
> **Estado Técnico:** Panel Integral 36 meses + Asistente de Informes + Ficha Detallada de Producto (36m) + Desacoplamiento canónico CU-017/CU-018 | **Tests verdes (0 fallos)** | Angular build OK | Flutter analyze OK

---

## 0-a. Reorganización Canónica de CU-017 y CU-018 (P4 - Trazabilidad CORE)

1. **Arqueología y Separación Modular de CU-017 y CU-018 (P4 - Trazabilidad CORE):**
   * **Diagnóstico Inicial:** El código de CU-018 (`public_trace_controller.py` y `public_trace_views.py`) se encontraba mezclado físicamente dentro de `app/packages/p4_trazabilidad/controllers/cu016_codigos_qr/` y `views/cu016_codigos_qr/`. A su vez, CU-017 (Escanear Código QR) carecía de paquete MVC dedicado en backend.
   * **Reorganización Canónica de CU-018 (Registrar Consulta de Trazabilidad):**
     * Controlador canónico ubicado en `app/packages/p4_trazabilidad/controllers/cu018_trazabilidad/public_trace_controller.py`.
     * Vistas y esquemas canónicos en `app/packages/p4_trazabilidad/views/cu018_trazabilidad/public_trace_views.py`.
     * Modelo SQLAlchemy `ConsultaTrazabilidad` consolidado en `app/packages/p4_trazabilidad/models/cu018_trazabilidad/consulta_trazabilidad.py`.
     * Shims de retrocompatibilidad creados en `app/controllers/cu018_trazabilidad/` y `app/views/cu018_trazabilidad/`, y shims en `cu016_codigos_qr` para preservar importaciones previas.
   * **Implementación Canónica de CU-017 (Escanear Código QR):**
     * Controlador canónico creado en `app/packages/p4_trazabilidad/controllers/cu017_escaneo_qr/scan_controller.py` con endpoints `/api/v1/scan/process` y `/api/v1/scan/verify/{identifier}`.
     * Vistas y esquemas en `app/packages/p4_trazabilidad/views/cu017_escaneo_qr/scan_views.py` (`ScanQRRequest`, `ScanQRResponse`, `ScanVerifyResponse`).
     * Shims de compatibilidad en `app/controllers/cu017_escaneo_qr/` y `app/views/cu017_escaneo_qr/`.
     * Vinculación en app móvil Flutter (`trazabilidad/mobile/lib/views/qr_scanner_view.dart`) con el flujo de extracción y verificación.
   * **Fachada de Paquete 4 (`router.py`):**
     * Actualizado `app/packages/p4_trazabilidad/router.py` para montar limpiamente `scan_router` (CU-017) y `trace_router` (CU-018) desde sus ubicaciones canónicas.

2. **Suite de Pruebas Automatizadas:**
   * Creado `tests/test_scan_cu017.py` con 7 pruebas exhaustivas (procesamiento de URLs completas de escaneo, UUIDs planos, validación de estado activo, detección de formatos inválidos y verificación).
   * Ejecutados tests de CU-017 y CU-018 (`test_scan_cu017.py` y `test_public_trace.py`): **13 passed**.
   * Cero roturas de contratos REST.

---

## 0. Sesión actual (2026-11-21): Análisis detallado por producto dentro del asistente
**Petición:** que el asistente muestre un análisis detallado por producto (unidades, ingresos, N° ventas y más métricas que salían a 0), con datos reales, siempre sobre un rango amplio de 36 meses, para los 5 tenants demo. Alcance aprobado: detalle dentro del asistente, seed idempotente re-ejecutable y cero regresiones.

### Backend (P4/CU-022, respuesta aditiva)
* `ParsedQuery.wants_detail` y `_DETALLE` en `voice_query_parser.py` reconocen «analisis detallado / detalle de / ficha de / desglose de / perfil de…». `parse_detail_period(now)` fija **36 meses** (`2023-12 → 2026-11`) con hora Bolivia, aunque la consulta pida otro período. El productor se resuelve con `_resolver_filtros_catalogo()` contra `CatalogoTenant`, sin duplicar lógica.
* `build_product_detail()` en `voice_query_engine.py` consulta por tenant y variantes del producto: unidades, ingresos, N° ventas, cobrado, ticket y precio promedio, stock/disponibles/en tránsito, devoluciones y tasa, garantías, consultas QR, eventos, alertas, reportes de sospecha y tendencia mensual. Todas las tablas hijas se filtran desde un padre con `idtenant` (`Venta`, `UnidadProducto`, `EventoTrazabilidad`, `Alerta`, `ReporteSospecha`).
* `POST /api/v1/ai/voice-report` devuelve **`product_detail`** (opcional) con insignia `Detalle · 36 meses · <empresa>`; `filters_applied` añade `analisis_detallado`, `detalle_producto`, `detalle_desde` y `detalle_hasta`. La consulta principal conserva su período original y los followups pasan a incluir «Análisis detallado de …».
* `REPORT_CACHE` incluye el detalle; `GET /api/v1/ai/reports/{id}/export` lo pasa a `report_generator.py`, que añade la hoja **«Detalle Producto»** en Excel y una sección de ficha en PDF.

### Seed histórico (idempotente y re-ejecutable)
* `seed_historical_6m.py` (reutilizado por el envoltorio 36m) ahora genera: una **garantía por unidad vendida**, un **reporte de sospecha por unidad** en meses `mes % 3 == 0` (tickets `-Uxx`, sin chocar con el ticket histórico) y una **unidad en tránsito por variante activa** cada 6 meses. Las claves naturales siguen siendo deterministas (`numeroserie`, `codigoticket`, `idunidad`), por lo que re-ejecutar es no-op.
* `--dry-run` validado (+2.340 y luego +726 filas, rollback limpio). Ejecución real completada: **20.401 IDs** en `seed_historical_36m.manifest.json`; la segunda ejecución reporta **0 filas nuevas**.
* Verificado en tenant 1, producto «iPhone 15»: 80 unidades vendidas, $34.164 ingresos, 36 ventas, 72 garantías, 48 reportes, 146 consultas QR, 37 alertas y 48 unidades en tránsito. **Ninguna métrica de la ficha queda en 0.**

### Web Angular y Móvil Flutter
* Modelos aditivos `product_detail` en `ai-report.model.ts` y `ProductDetailModel` en `ai_report_model.dart`.
* Dashboard web: tarjeta «DETALLE · 36 MESES» con KPIs, rango y chips de tendencia mensual, además de chips de seguimiento dentro del resultado. Asistente móvil: `_buildProductDetailCard()` con el mismo contenido y chips reutilizando los followups existentes.

### Verificación
* `tests/test_ai_voice_query_customization.py` ampliado a **11 pruebas** (añade parser de detalle, métricas reales, rango 36m aunque la consulta pida 1 mes, invisibilidad de producto ajeno y exportación con ficha).
* **Suite completa: 202 passed, 0 failed, 0 errors**. `npm run build` OK (solo warnings de presupuesto CSS preexistentes). `flutter analyze` → **No issues found**. ADR-011 registrado.

### Archivos nuevos / modificados
`app/services/ai/{voice_query_parser.py,voice_query_engine.py,report_generator.py}`, `app/packages/p4_trazabilidad/{views/cu022_ia/ai_schemas.py,controllers/cu022_ia/ai_report_controller.py}`, `tests/test_ai_voice_query_customization.py`, `seed_historical_6m.py`, `seed_historical_36m.manifest.json`, `frontend/src/app/{models/ai-report.model.ts,views/pages/dashboard.view.html}`, `mobile/lib/{models/ai_report_model.dart,views/widgets/voice_assistant_sheet.dart}`, `docs/{DECISION_LOG.md,ai/*.md}`.

---

## 0-bis. Sesión anterior (2026-11-20): Asistente de Informes Dinámicos por Voz personalizable

**Petición:** mejorar el asistente para entender consultas ricas por empresa, p. ej. «¿Cuáles fueron los 10 productos más vendidos en el último trimestre o 3 meses?», con chips sugeridos y una insignia visible de la interpretación aplicada en web y móvil. Alcance aprobado: motor + chips + badge, endurecimiento multi-tenant y ventas/fechas en todos los intentos.

### Backend (P4/CU-022, extensiones aditivas)
* **Nuevo parser determinista** `app/services/ai/voice_query_parser.py`: `ParsedQuery` extrae `intent` (`ventas`, `compras`, `logistica`, `auditoria`, `inventario`), rango temporal, `limit`, `metric`, `estado`, `producto` y `proveedor`. Normaliza acentos, calcula fechas con `get_bolivia_now()` (BOT) y **no añade dependencias**. Períodos: hoy/ayer, 7 días, mes, trimestre (3 meses), semestre (6 meses), año, «últimos N meses/días» y año explícito; sin período = todo el historial (comportamiento previo intacto).
* `top N` acepta `top 10`, `los 10 productos`, `primeros 5` y números en palabras; **`top 999` se acota a 50**. Métrica `unidades` por defecto; `ingresos` con `ingresos/facturación/monto/rentables`.
* **Nuevo ranking P5** `query_sales_ranking_data()`: `Venta → VentaDetalle → VarianteProducto → Producto`, filtrado por `Venta.idtenant`, rango de fechas, estado y producto; orden por unidades o ingresos y límite `top N` (default 10). KPIs, gráfico de barras y tabla con `#`, producto, unidades, ingresos USD y número de ventas.
* **Fechas en todos los intentos**: compras (`fechacompra`), logística (`fechasalida`), inventario (`fechaingreso`) y auditoría (`fechahora`). El intérprete resuelve productos/proveedores mencionados contra el **catálogo del tenant**.
* **Corrección de aislamiento (ADR-001/005):** `query_audit_data()` ahora hace join con `UsuarioTenant` y filtra por tenant (antes filtraba globalmente); `/ai/voice-report` usa `resolve_tenant_id(db, current_user)` en lugar del fallback `idtenant=1`.
* **Exportación endurecida:** `REPORT_CACHE` guarda `tenant_id`; `GET /api/v1/ai/reports/{id}/export` exige JWT y devuelve **404** si la empresa activa no coincide con la del snapshot (incluso SuperAdmin debe cambiar de empresa con `/auth/switch-tenant`). Se corrigió además un bug preexistente: nombre de archivo PDF con acentos rompía la cabecera HTTP; ahora se normaliza a ASCII.
* **Respuesta aditiva** (sin romper clientes): `period_label`, `interpretation` («Empresa · Top N por métrica · período · filtros»), `filters_applied` y `suggested_followups`. El prompt de Gemini recibe la interpretación literal; el fallback determinista para `ventas` nombra el producto líder, unidades e ingresos. La interpretación también aparece en el PDF/Excel mediante `period_label`/`interpretation` opcionales en `report_generator.py`.

### Web Angular y Móvil Flutter
* `quickPrompts` / `_quickPrompts` con 6 chips (top 10, top 5 por ingresos, compras, envíos, stock, auditoría). Badge «Consulta interpretada» con la interpretación y chips de seguimiento; en móvil, `ActionChip` llama al `submitQuery` existente.
* Modelos actualizados de forma opcional/retrocompatible: `ai-report.model.ts` y `ai_report_model.dart` (`periodLabel`, `interpretation`, `filtersApplied`, `suggestedFollowups`).

### Verificación
* `tests/test_ai_voice_query_customization.py` (7 pruebas): parser trimestre/top 10, ingresos + estado + 6 meses, tope 999→50 e historial, ranking ordenado, aislamiento de ranking por ingresos, bitácora por tenant y descarga ajena 404.
* **Suite completa: 198 passed, 0 failed, 0 errors** (191 + 7). `npm run build` OK (solo warnings de presupuesto CSS preexistentes). `flutter analyze` → **No issues found**. ADR-010 registrado.

### Archivos nuevos / modificados
`app/services/ai/voice_query_parser.py` (nuevo), `app/services/ai/voice_query_engine.py`, `app/services/ai/report_generator.py`, `app/packages/p4_trazabilidad/controllers/cu022_ia/ai_report_controller.py`, `app/packages/p4_trazabilidad/views/cu022_ia/ai_schemas.py`, `tests/test_ai_voice_query_customization.py` (nuevo), `frontend/src/app/{models/ai-report.model.ts,controllers/pages/dashboard.controller.ts,views/pages/dashboard.view.html}`, `mobile/lib/{models/ai_report_model.dart,views/widgets/voice_assistant_sheet.dart}`, `docs/{DECISION_LOG.md,ai/*.md}`.

---

## 0-bis. Sesión inmediatamente anterior (2026-11-20): Panel Integral por tenant con 36 meses

**Petición:** «en el dashboard de cada tenant me pide lo siguiente: tiene que dar todos los reportes consultas totalmente. Debe tener datos estadisticos de 3 años. Diseña esto para hacerlo bien por favor.»

### Backend (P7 / CU-035, extensión sin romper contratos)
* **Nuevo endpoint** `GET /api/v1/reports/analytics?meses=36&idtenant=2` — agregado analítico por tenant, `1 ≤ meses ≤ 36` (default 36), RBAC `requires_reportes` (5 roles), `Depends(resolve_analytics_tenant)` con bypass SuperAdmin (ADR-001/005) y Bitácora del middleware.
* **11 series mensuales** con los 36 puntos siempre presentes (`0` en meses sin datos, nunca omitidos): unidades, ventas, ingresos, pagos, eventos, eventos anclados, alertas, consultas QR, facturado, cobrado y reportes generados.
* **10 KPIs** con variación vs. 12 meses anteriores y base textual; 10 distribuciones, ranking de productos/eventos y bloques comercial, alertas, logística, facturación, actividad y suscripción.
* Archivos nuevos: `app/packages/p7_reportes/controllers/cu035_reportes/report_analytics_service.py`, `app/packages/p7_reportes/views/cu035_reportes/report_analytics_views.py`; endpoint en `report_controller.py`. **No se modificaron** `/reports/summary`, `/reports/traceability`, `/reports/pdf` ni `/dashboard`.
* Tests nuevos: `tests/test_dashboard_integral_36m.py` (3 pruebas: 36 puntos/secciones, rango+rol+400, aislamiento+bypass 404). Suite: **191 passed**.

### Histórico real de 36 meses (BD local `Blockchain`)
* `seed_historical_36m.py` (envoltorio de `seed_historical_6m.py` con `MESES=36` y manifest propio, sin duplicar 800 líneas).
* El manifest 36m se siembra desde el 6m, por lo que `--reset-history` cubre **17.335 IDs** (2.894 + 14.441 nuevas filas).
* Rango generado: **`2023-12` → `2026-11`** (36 meses). Verificado tenant 2: 513 unidades, 142 ventas, 202.137,00 USD, 36/36 meses con datos.
* `--dry-run` tras la carga → **0 filas nuevas** (idempotente).

### Web Angular
* `models/analytics.model.ts`, `controllers/services/analytics.service.ts`, `controllers/pages/analytics-panel.controller.ts`, `views/pages/analytics-panel.view.{html,css}`.
* Panel único de **8 pestañas** (Resumen, Tendencias 36 meses, Trazabilidad, Comercial, Alertas, Logística, Facturación, Actividad) integrado en `/dashboard` y reutilizado en `/reports`.
* Gráfico SVG inline sin librería nueva; franja de cadencia de 36 celdas; superficies planas, `tabular-nums`, tabs con scroll horizontal en móvil.
* Correcciones de QA visual: `formatoFecha` respeta `YYYY-MM` sin desplazamiento de zona horaria; `.dashboard-nav` apilado ≤768 px para eliminar overflow horizontal a 390 px (verificado 390=390).

### Móvil Flutter
* `models/analytics_model.dart`, `controllers/analytics_service.dart`, `controllers/analytics_controller.dart`, `views/analytics_view.dart`, getter `reportsAnalytics` en `api_config.dart`.
* Tarjeta «Panel Integral (CU-035)» en `dashboard_view.dart` con 3 KPIs y acceso a la pantalla, oculta para `Consumidor`; `user_model.dart` acepta `roles`.
* `flutter analyze` → **No issues found**.

### ADR
* **ADR-009**: agregado analítico P7 + manifest 36 meses (ver `docs/DECISION_LOG.md`).

---

## 1. ¿Qué se completó en la sesión anterior (2026-11-19)?

1. **Paquete P8 (ADR-008):**
   * Creado físicamente `app/packages/p8_suscripciones/` y registrado como **8º router** en `app/main.py`.
   * CU-036 y CU-037 migrados desde P1, conservando shims retrocompatibles (incluido el import usado por `tests/test_subscriptions_cu036_cu037.py`).
   * ADR-006 parcialmente supersedido y corregido: el control de límites duros corresponde a **CU-038**, no a CU-040.
   * Migración Alembic aplicada: tablas `usoplan`, `factura`, `facturadetalle`, `cobro` y unicidades en `ventaunidad`, `devolucionunidad`, `garantiaunidad` (`f1a2b3c4d5e6`).

2. **Backend Sprint 4 (P5, P7, P8 y CU-005):**
   * **CU-025/026/027/028/029/030/031:** ventas, asignación de unidades, pagos, historial del consumidor, devoluciones y garantías under `/api/v1/sales`, `/payments`, `/consumer`, `/returns`, `/warranties`.
   * **CU-035:** `/reports/summary`, `/reports/traceability`, `/reports/pdf` y `/dashboard`.
   * **CU-038:** `/quotas` y `/quotas/consume` con límite duro y respuesta `429`.
   * **CU-039:** `/invoices`, `/invoices/{id}/charges` y `/billing/history`.
   * **CU-040:** `/billing/notifications` y `/billing/notifications/process`.
   * **CU-005:** cerrada la brecha de push con `POST /api/v1/notifications/push` y `PushGateway` (in-app + proveedores FCM/APNs registrables).
   * **Aislamiento CU-040 reforzado:** `POST /billing/notifications/process` ahora inyecta `resolve_tenant_id` y filtra suscripciones/facturas por empresa (ADR-001); el modo global queda reservado al scheduler que invoca `BillingNotifier.procesar_programadas` sin `idtenant`. Nuevo test `test_procesar_notificaciones_aisla_tenant`.
   * Seams creados: `UnitAvailabilityService`, `SalesNotarizationService` (best-effort), `PushGateway`.
   * Correcciones: `to_char` para la serie temporal de reportes (psycopg 3) y normalización `Decimal` a 2 decimales en el saldo de facturación.

3. **Pruebas:**
   * `tests/test_sprint4_comercial_cu025_a_cu031.py` → 11 pruebas (200/201, 403, aislamiento multi-tenant).
   * `tests/test_sprint4_reportes_y_suscripciones.py` → 7 pruebas (reportes/PDF/dashboard, cuotas 429, facturación y cobros, factura ajena 404, notificaciones y push, aislamiento de notificaciones por tenant).
   * Suite completa: **188 passed, 0 failed, 0 errors**.

4. **Frontend Web (Angular 21):**
   * Servicios: `sales.service.ts`, `after-sales.service.ts`, `reporting.service.ts`, `quotas.service.ts`, `billing.service.ts`.
   * Modelos: `models/sprint4.model.ts`.
   * Pantallas: `/sales` (CU-025/026/027/028), `/post-sales` (CU-029/030/031), `/reports` (CU-035), `/quotas` (CU-038), `/billing` (CU-039/040 + push CU-005), todas con `authGuard` + `roleGuard` y enlaces en el dashboard.
   * `npm run build` exitoso; se amplió el presupuesto inicial de 1 MB a 2 MB en `angular.json` por el crecimiento del bundle.

5. **Aplicación Móvil (Flutter):**
   * CU-028: modelo, servicio, controlador y vista `consumer_history_view.dart` con acceso a trazabilidad y certificado por unidad.
   * CU-040: modelo, servicio, controlador y vista `billing_notifications_view.dart`.
   * Getters `consumerHistory` y `billingNotifications` en `api_config.dart`; dos tarjetas nuevas en `dashboard_view.dart`.
   * `flutter analyze` → **No issues found**.

6. **Poblado histórico de 6 meses (BD local `Blockchain`):**
   * Creado `trazabilidad/backend/seed_historical_6m.py`: **2.894 filas nuevas** para los 5 tenants en `2026-06` → `2026-11`.
   * Distribución: 360 unidades con QR y consulta, 120 eventos con condición/anclaje blockchain simulado, 120 ventas/pagos, 30 facturas/cobros, 90 alertas, 10 reportes de sospecha, 30 bitácoras y 30 notificaciones.
   * Re-ejecución verificada: `--dry-run` posterior reportó **0 filas nuevas** (idempotente por clave natural).
   * Manifest `seed_historical_6m.manifest.json` permite `--reset-history` sin afectar datos del seed canónico.
   * Suite completa tras la carga: **188 passed, 0 failed, 0 errors**.

---

## 2. Archivos Afectados / Creados (resumen)

* `trazabilidad/backend/app/main.py`
* `trazabilidad/backend/app/packages/p5_comercial/**` (CU-025 a CU-031)
* `trazabilidad/backend/app/packages/p7_reportes/**` (CU-035)
* `trazabilidad/backend/app/packages/p8_suscripciones/**` (CU-036 a CU-040)
* `trazabilidad/backend/app/packages/p1_seguridad/controllers/cu005_bitacora/bitacora_controller.py`
* `trazabilidad/backend/app/services/{unit_availability,sales_notarization,push_gateway}.py`
* `trazabilidad/backend/alembic/versions/f1a2b3c4d5e6_tablas_sprint4_facturacion_cuotas.py`
* `trazabilidad/backend/tests/test_sprint4_comercial_cu025_a_cu031.py`
* `trazabilidad/backend/tests/test_sprint4_reportes_y_suscripciones.py`
* `trazabilidad/backend/seed_historical_6m.py` (nuevo)
* `trazabilidad/backend/seed_historical_6m.manifest.json` (generado)
* `trazabilidad/frontend/src/app/app.routes.ts`
* `trazabilidad/frontend/src/app/models/sprint4.model.ts`
* `trazabilidad/frontend/src/app/controllers/services/{sales,after-sales,reporting,quotas,billing}.service.ts`
* `trazabilidad/frontend/src/app/controllers/pages/{sales,after-sales,reporting,quotas,billing}-*.controller.ts`
* `trazabilidad/frontend/src/app/views/pages/{sales,after-sales,reporting,quotas,billing}-*.view.html`
* `trazabilidad/frontend/src/app/views/pages/sales-management.view.css` (estilo compartido Sprint 4)
* `trazabilidad/frontend/angular.json`
* `trazabilidad/mobile/lib/core/api_config.dart`
* `trazabilidad/mobile/lib/controllers/{consumer_history,billing_notification}_{service,controller}.dart`
* `trazabilidad/mobile/lib/models/{consumer_history,billing_notification}_model.dart`
* `trazabilidad/mobile/lib/views/{consumer_history,billing_notifications}_view.dart`
* `trazabilidad/mobile/lib/views/dashboard_view.dart`
* `docs/DECISION_LOG.md` (ADR-006 corregido + ADR-008)
* `docs/ARCHITECTURE.md`, `docs/IMPLEMENTATION_PHASES.md`
* `docs/ai/{CURRENT_STATE,HANDOFF_LATEST,NEXT_STEPS}.md`

---

## 3. Verificación y Credenciales de Prueba

* Backend: `cd trazabilidad/backend && python -m pytest tests/ -q` → **191 passed, 0 failed, 0 errors**.
* Web: `cd trazabilidad/frontend && npm run build` → OK (1,04 MB / 195,64 kB transfer; solo warnings de presupuesto CSS preexistentes).
* Móvil: `cd trazabilidad/mobile && flutter analyze` → No issues found.
* QA visual (browser-automation, 1440 y 390): 8 pestañas, 2 paths SVG y 36 celdas de cadencia en Tendencias, sin overflow horizontal (390=390).

### Smoke test real (servidor local + credenciales entregadas)
* Login `empresa-demo / admin@trazabilidad.com / Admin123!` → OK, roles `SuperAdministrador, AdministradorEmpresa`.
* 200 OK: `/sales`, `/payments`, `/returns`, `/warranties`, `/reports/summary`, `/reports/traceability`, `/dashboard`, `/quotas`, `/invoices`, `/billing/history`, `/billing/notifications`.
* `/reports/pdf` → 200, `application/pdf`, 2039 bytes (contenido `%PDF-1.3`).
* `/consumer/history` → 200 con datos demo creados (venta `idventa=45`, `idcliente=1839`, `total=1200.00`, 1 unidad). Sin `?idcliente` devuelve 404 si el correo del administrador no tiene perfil de consumidor; usar el cliente demo indicado.

### Verificación del historico (BD local)
* `python seed_historical_6m.py --dry-run` → 2.894 filas nuevas; segunda ejecución → 0 nuevas.
* Series `/api/v1/reports/traceability` → 6 puntos (`2026-06` … `2026-11`) para el tenant demo.
* `/api/v1/reports/summary` → 158 unidades, ingresos 35.364,00 USD; `/reports/pdf` → 200 `application/pdf`.
* Conteos por tenant: 72 unidades y 24 eventos vinculados en cada empresa (1…5).

### Credenciales demo (verificadas contra la BD actual)
| Uso | `tenant_slug` | Email | Password | Rol |
| :--- | :--- | :--- | :--- | :--- |
| Revisar **todos** los CUs (recomendado) | `empresa-demo` (o `1`) | `admin@trazabilidad.com` | `Admin123!` | SuperAdministrador |
| Admin de empresa (otro tenant) | `2` | `admin@techimport.com` | `Admin123!` | AdministradorEmpresa |
| Otros tenants | `3`, `4`, `5` | `admin@andinadigital.com`, `admin@electrosur.com`, `admin@cochawireless.com` | `Admin123!` | AdministradorEmpresa |

> El `tenant_slug` también acepta el ID numérico, el NIT o el slug del nombre de la empresa.  
> Los usuarios operativos del seed (`operaciones@…`, `ventas@…`, `auditor@…`) **no están presentes en la BD actual**; si se requieren para probar RBAC específico, ejecutar `python seed.py`. Las cuentas admin anteriores tienen acceso a todos los endpoints Sprint 4 (SuperAdmin por bypass ADR-005; AdminEmpresa por roles explícitos).

---

## 4. Servidores

* Backend FastAPI: `http://localhost:8000` (`/docs`).
* Frontend Angular: `http://localhost:4200` (`npm start`).
* Móvil Flutter: `flutter run` (configurar URL del servidor en la pantalla de login; hosts soportados en `ApiConfig`).

---

## 5. Despliegue y datos en la nube (pendiente)

El historico se cargo **solo en la BD local `Blockchain`**. Subir el codigo a Git/Railway **no traslada los datos**: la BD de Railway es otra instancia y el `Dockerfile` no ejecuta seeds en el arranque.

Cuando se tenga acceso al entorno remoto, ejecutar en Railway Shell (con `DATABASE_URL` de produccion inyectado):

```bash
python seed.py                     # solo si la BD remota no tiene tenants/catalogo base
python seed_historical_36m.py --dry-run
python seed_historical_36m.py
```

El script es determinista, por lo que genera los mismos 36 meses (`2023-12` → `2026-11`) en cualquier BD que tenga el seed base. El frontend en Vercel consume la API desplegada y no requiere cambios. No usar `--reset-history` en la primera ejecucion remota.

> Nota: persiste un 403 preexistente en `GET /api/v1/planes?solo_activos=true` que el dashboard llama al iniciar (controlador P8 no modificado en esta sesión). No afecta al Panel Integral ni a la navegación.
