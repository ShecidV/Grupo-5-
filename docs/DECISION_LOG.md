# Registro de Decisiones de Arquitectura (Architecture Decision Log)

> **Documento:** Registro Canónico de Decisiones Técnicas (ADR / Diátaxis Explicación)  
> **Ubicación:** `docs/DECISION_LOG.md`  
> **Audiencia:** Equipo de Ingeniería, Scrum Master, Arquitectos y Auditores  

Este documento registra cronológicamente las decisiones arquitectónicas fundamentales tomadas para la plataforma de trazabilidad de dispositivos Apple, detallando contexto, alternativas evaluadas y consecuencias.

---

## Índice de Decisiones (ADRs)

* [ADR-001: Estrategia de Aislamiento Multi-Tenant por Columna Discriminadora](#adr-001-estrategia-de-aislamiento-multi-tenant-por-columna-discriminadora)
* [ADR-002: Modelo Híbrido de Trazabilidad: Notarización On-Chain vs. Persistencia Off-Chain](#adr-002-modelo-híbrido-de-trazabilidad-notarización-on-chain-vs-persistencia-off-chain)
* [ADR-003: Organización en 7 Paquetes mediante Fachadas de Enrutamiento sin Rotura de APIs](#adr-003-organización-en-7-paquetes-mediante-fachadas-de-enrutamiento-sin-rotura-de-apis)
* [ADR-004: Aislamiento de Suite de Pruebas Automatizadas con Base de Datos Local Dedicada](#adr-004-aislamiento-de-suite-de-pruebas-automatizadas-con-base-de-datos-local-dedicada)
* [ADR-005: Bypass de Gobernanza y Auditoría para SuperAdministrador](#adr-005-bypass-de-gobernanza-y-auditoría-para-superadministrador)
* [ADR-006: Inclusión del Módulo SaaS (Planes y Suscripciones) en Paquete P1 durante Sprint 3](#adr-006-inclusión-del-módulo-saas-planes-y-suscripciones-en-paquete-p1-durante-sprint-3)
* [ADR-007: Motor Heurístico de Machine Learning Ligero Off-Chain para Sospecha de Fraude (CU-023)](#adr-007-motor-heurístico-de-machine-learning-ligero-off-chain-para-sospecha-de-fraude-cu-023)
* [ADR-008: Creación del Paquete P8 de Suscripción y Monetización SaaS](#adr-008-creación-del-paquete-p8-de-suscripción-y-monetización-saas)
* [ADR-009: Agregado analítico P7 y manifest histórico de 36 meses](#adr-009-agregado-analítico-p7-y-manifest-histórico-de-36-meses)
* [ADR-010: Intérprete determinista y ranking por tenant para el asistente de informes por voz](#adr-010-intérprete-determinista-y-ranking-por-tenant-para-el-asistente-de-informes-por-voz)
* [ADR-011: Ficha detallada de producto a 36 meses y seed suplementario por tenant](#adr-011-ficha-detallada-de-producto-a-36-meses-y-seed-suplementario-por-tenant)

---

### ADR-001: Estrategia de Aislamiento Multi-Tenant por Columna Discriminadora

* **Estado:** Aceptado
* **Fecha:** Sprint 0
* **Contexto:** La plataforma debe alojar múltiples empresas importadoras y distribuidoras en Bolivia de forma aislada. Se evaluaron tres enfoques: base de datos por tenant, esquema por tenant (PostgreSQL schemas) y base de datos compartida con discriminador `tenant_id`.
* **Decisión:** Implementar base de datos compartida con columna discriminadora `idtenant` / `tenant_id` en todas las tablas transaccionales, inyectada y validada obligatoriamente en cada endpoint de FastAPI mediante la dependencia `resolve_tenant_id`.
* **Consecuencias:**
  * *Positivas:* Menor costo de infraestructura, migraciones simples con Alembic y facilidad para consultas analíticas globales del SuperAdmin.
  * *Riesgos:* Toda consulta debe incluir `WHERE idtenant = :tenant_id`. Se mitiga forzando el filtrado a través de servicios y dependencias base.

---

### ADR-002: Modelo Híbrido de Trazabilidad: Notarización On-Chain vs. Persistencia Off-Chain

* **Estado:** Aceptado
* **Fecha:** Sprint 1 / Sprint 2
* **Contexto:** Registrar la totalidad de los datos (documentos, fotos, datos JSON de sensores) directamente en la red Ethereum generaría costos insostenibles de gas fees y problemas severos de escalabilidad y latencia.
* **Decisión:** Adoptar un modelo híbrido:
  1. **Off-Chain (PostgreSQL + Cloud Storage):** Almacena los registros operativos completos, archivos binarios (PDFs, facturas aduaneras) y metadatos de sensores.
  2. **On-Chain (Smart Contracts en Sepolia/Amoy):** Almacena únicamente el hash criptográfico SHA-256 de los datos, el identificador único del equipo (`unitId`), timestamp y la firma del operador.
* **Consecuencias:**
  * *Positivas:* Consumo mínimo de gas, transacciones instantáneas off-chain y garantía matemática de no alteración mediante verificación de hash.
  * *Trade-off:* Se requiere una tarea de sincronización/reconciliación entre la base relacional y la confirmación final de la transacción en la blockchain (estado "pendiente").

---

### ADR-003: Organización en 7 Paquetes mediante Fachadas de Enrutamiento sin Rotura de APIs

* **Estado:** Aceptado
* **Fecha:** Sprint 2 / Sprint 3
* **Contexto:** El backend creció con 26 carpetas individuales por Caso de Uso (`cu001` a `cu034`), generando más de 25 inclusiones de routers en `main.py`. Mover físicamente los archivos de inmediato rompería los tests unitarios y las rutas consumidas por Angular y Flutter.
* **Decisión:** Implementar un patrón de Módulos Profundos mediante empaquetado físico en `app/packages/` (P1 a P7; extendido a **P1 a P8** por [ADR-008](#adr-008-creación-del-paquete-p8-de-suscripción-y-monetización-saas)) y fachadas `router.py`, manteniendo shims retrocompatibles en las rutas históricas de `app/controllers/`, `app/models/` y `app/views/`.
* **Consecuencias:**
  * *Positivas:* Rutas HTTP (`/api/v1/...`) 100% preservadas, cero roturas en los clientes frontend/móvil y preservación de la suite de pruebas.

---

### ADR-004: Aislamiento de Suite de Pruebas Automatizadas con Base de Datos Local Dedicada

* **Estado:** Aceptado
* **Fecha:** Sprint 2
* **Contexto:** Las pruebas de integración en pytest presentaban fallos aleatorios por colisión de IDs y mutación de estado compartido al ejecutarse sobre bases de datos en desarrollo.
* **Decisión:** Configurar un arnés de pruebas con una base de datos local dedicada PostgreSQL (`blacktest`), aislando los fixtures de sesión y ejecutando limpieza controlada tras cada suite.
* **Consecuencias:**
  * *Positivas:* 100% de reproducibilidad (167 tests pasando consecutivamente). Pruebas seguras sin riesgo de corromper datos de desarrollo.

---

### ADR-005: Bypass de Gobernanza y Auditoría para SuperAdministrador

* **Estado:** Aceptado
* **Fecha:** Sprint 2
* **Contexto:** El Super Administrador necesita supervisar, auditar e intervenir cualquier empresa sin requerir asignaciones manuales previas ni bloqueos por membresía rígida.
* **Decisión:** Otorgar bypass total de tenant en `require_roles` y `resolve_tenant_id` para el rol SuperAdministrador, registrando en `Bitacora` (CU-005) cada una de sus acciones de supervisión transversal.
* **Consecuencias:**
  * *Positivas:* Flexibilidad operativa total para el administrador global de la plataforma.
  * *Contramedida:* Trazabilidad obligatoria de auditoría en cada petición mediante el middleware HTTP.

---

### ADR-006: Inclusión del Módulo SaaS (Planes y Suscripciones) en Paquete P1 durante Sprint 3

* **Estado:** **Supersedido por ADR-008** (parcialmente: la ubicación física en P1 se revierte; el hook de plan `trial` en `TenantController.create_tenant` se conserva)
* **Fecha:** Sprint 3 (2026-11-01)
* **Contexto:** La plataforma requiere monetización multi-tenant y control de cuotas para las empresas clientes (límite de dispositivos trazados, almacenamiento, usuarios y días de prueba gratuita) según la guía rectora de CU-036 y CU-037.
* **Decisión:** Implementar `CU-036` (Planes de Suscripción) y `CU-037` (Suscripción de Empresa) dentro del Paquete P1 (Seguridad y Multi-Tenant) durante el Sprint 3, estableciendo un hook automático en `TenantController.create_tenant` que asigna inmediatamente un plan `trial` a toda empresa nueva. El control activo de límites duros se delega a Sprint 4 (`CU-038`, corregido según `USE_CASES_MAP.md`; el borrador original decía incorrectamente CU-040).
* **Consecuencias:**
  * *Positivas:* Permite a las empresas clientes ver claramente sus cuotas de servicio y al SuperAdmin gestionar el catálogo SaaS sin alterar el alcance de ventas de Sprint 4.

---

### ADR-007: Motor Heurístico de Machine Learning Ligero Off-Chain para Sospecha de Fraude (CU-023)

* **Estado:** Aceptado
* **Fecha:** Sprint 3 (2026-11-01)
* **Contexto:** Las denuncias públicas de falsificación de dispositivos Apple requieren una evaluación objetiva preliminar para priorizar alertas y despachar verificaciones aduaneras o técnicas sin incurrir en costos de servicios externos de LLM ni latencia excesiva.
* **Decisión:** Implementar un servicio heurístico nativo de Machine Learning (`SuspicionMLService`) en Python, basado en TF-IDF simplificado, scoring ponderado de términos de fraude (`falso`, `clon`, `sellos rotos`, `caja china`) y normalización léxica en una escala de 0.0 a 1.0.
* **Consecuencias:**
  * *Positivas:* Sin dependencias pesadas de GPU ni llamadas a APIs de pago; tiempo de respuesta inferior a 5ms y persistencia del score en la tabla `reportesospecha`.

---

### ADR-008: Creación del Paquete P8 de Suscripción y Monetización SaaS

* **Estado:** Aceptado
* **Fecha:** Sprint 4 (2026-11-19)
* **Contexto:** `USE_CASES_MAP.md` asigna CU-036 a CU-040 al Paquete 8 (Suscripción y Monetización SaaS), pero ADR-006 los había ubicado físicamente en `p1_seguridad` durante Sprint 3. Sprint 4 incorpora CU-038 (cuotas), CU-039 (facturación) y CU-040 (notificaciones de facturación), lo que hace insostenible seguir agregando routers SaaS en P1 y contradice el mapa canónico de paquetes.
* **Decisión:**
  1. Crear el paquete físico `app/packages/p8_suscripciones/` con estructura MVC por CU (CU-036 a CU-040) y fachada `router.py`.
  2. Migrar CU-036 y CU-037 desde `p1_seguridad` a P8, conservando **shims** retrocompatibles en las rutas Python históricas (incluido `app.packages.p1_seguridad.models.cu036_planes.subscription_models`, importado por `tests/test_subscriptions_cu036_cu037.py`).
  3. Registrar `p8_suscripciones_router` como **octava** inclusión en `app.main` con prefijo `/api/v1`, preservando los contratos `/planes` y `/suscripciones` sin cambios.
  4. Mantener el hook de creación de suscripción `trial` en `TenantController.create_tenant` (ADR-006), actualizando únicamente su import hacia P8.
  5. Corregir ADR-006: el control de límites duros corresponde a **CU-038**, no a CU-040.
* **Consecuencias:**
  * *Positivas:* Arquitectura física alineada con `USE_CASES_MAP.md`; P1 vuelve a contener solo CU-001 a CU-005; cero rotura de rutas HTTP ni de imports históricos.
  * *Negativas:* `main.py` pasa de 7 a 8 routers canónicos y la documentación de "7 paquetes" debe actualizarse a "8 paquetes".
  * *Contramedida:* Los shims de P1 quedan explícitamente marcados con `ADR-008` y se eliminarán solo cuando no existan imports externos que los requieran.

---

### ADR-009: Agregado analítico P7 y manifest histórico de 36 meses

* **Estado:** Aceptado
* **Fecha:** 2026-11-20
* **Contexto:** El dashboard anterior solo mostraba un resumen de 6 meses en `/reports` y ninguna métrica operativa en `/dashboard`; el asistente IA era la única fuente de KPIs. El usuario pidió «todos los reportes y consultas» con «datos estadísticos de 3 años» para **cada tenant**, en web y móvil, como panel único con pestañas. Los contratos `/api/v1` y el aislamiento multi-tenant son inmutables (ADR-001/003/005).
* **Decisión:**
  1. Agregar **un endpoint nuevo** `GET /api/v1/reports/analytics` en P7/CU-035 en lugar de modificar `/reports/summary`, `/reports/traceability`, `/reports/pdf` ni `/dashboard`.
  2. `meses` acotado a `1..36` (default 36) y series con **36 puntos siempre presentes**: mes sin datos se emite como `0`, nunca se omite. Las variaciones llevan su base textual («vs 12 meses anteriores»); base 0 se marca `(base 0)` y sin base se imprime `—`.
  3. `Depends(resolve_analytics_tenant)` con `resolve_tenant_id` (ADR-001/005) y `requires_reportes`; SuperAdmin puede pasar `?idtenant=` y la acción queda en Bitácora por el middleware. Usuario normal que pida otro tenant recibe 403; tenant inexistente, 404.
  4. El servicio `ReportAnalyticsService` es de solo lectura: filtra por `idtenant` o join a tabla padre (nunca columnas hijas sin tenant) y **no incrementa** `UsoPlan.reportesgenerados` (coherente con los endpoints P7 actuales).
  5. Histórico: `seed_historical_36m.py` envuelve `seed_historical_6m.py` con `MESES=36` y manifest propio; el manifest 36m se siembra desde el 6m para que `--reset-history` cubra las 17.335 filas. Rango **`2023-12 → 2026-11`** (36 meses; `2024-01 → 2026-11` son 35).
  6. UI: un componente reutilizable de 8 pestañas en Angular y Flutter consume el mismo endpoint; gráfico SVG propio en web (sin librería nueva) y `fl_chart` ya instalado en móvil.
* **Consecuencias:**
   * *Positivas:* cero rotura de contratos; suite 191 verde; datos reales verificados (36/36 meses con datos); panel único y consistente entre web y móvil.
   * *Negativas:* ~30 consultas por request; se acepta sin caché por volumen pequeño (~17k filas) y se podrá optimizar después.
   * *Contramedida:* los tests cubren 36 puntos, 403 por rol, 403 por tenant ajeno, 404 por tenant inexistente y 422 por rango inválido.

---

### ADR-010: Intérprete determinista y ranking por tenant para el asistente de informes por voz

* **Estado:** Aceptado
* **Fecha:** 2026-11-20
* **Contexto:** El asistente de `POST /api/v1/ai/voice-report` solo clasificaba cuatro intenciones por palabras clave (`inventario`, `compras`, `logistica`, `auditoria`), ignoraba fechas y topes, usaba un `idtenant=1` como fallback, no filtraba la bitácora por empresa y permitía descargar cualquier snapshot de `REPORT_CACHE` sin validar tenant. El usuario pidió consultas ricas por empresa («los 10 productos más vendidos en el último trimestre o 3 meses»), chips sugeridos y una insignia con la interpretación aplicada, sin nuevas librerías ni rotura de contratos `/api/v1`.
* **Decisión:**
  1. Extraer la interpretación a un **parser determinista** (`app/services/ai/voice_query_parser.py`) con `ParsedQuery`: intención, rango temporal (hora Bolivia), `limit` 1..50, métrica (`unidades`/`ingresos`), estado, producto y proveedor. Ante ambigüedad, trimestre = 3 meses y sin período = todo el historial (comportamiento histórico preservado).
  2. Mantener a Gemini como **mejora opcional**: se le pasa la interpretación literal para que la respete; el fallback semántico sin API key pasa a describir el líder del ranking y continúa funcionando sin servicios externos.
  3. Agregar el ranking de ventas con joins P5 ya existentes (`Venta → VentaDetalle → VarianteProducto → Producto`) y aplicar el rango de fechas también a compras, logística, inventario y auditoría. La bitácora se filtra vía `UsuarioTenant` (ADR-001).
  4. Resolver la empresa con `resolve_tenant_id` (ADR-001/005) en la generación **y** en la exportación: `REPORT_CACHE` guarda `tenant_id` y `GET /ai/reports/{id}/export` exige JWT y responde 404 si la empresa activa no coincide, incluso para SuperAdmin (debe cambiar de empresa con `/auth/switch-tenant`).
  5. Hacer **aditiva** la respuesta: `period_label`, `interpretation`, `filters_applied` y `suggested_followups`; reflejar la interpretación en PDF/Excel y mostrar chips + badge en Angular y Flutter con campos opcionales en los modelos.
* **Consecuencias:**
  * *Positivas:* consultas naturales personalizables por tenant, cero dependencias nuevas, contratos históricos intactos, exportación ya no filtra datos de otra empresa y se corrigió el nombre de archivo PDF con acentos.
  * *Negativas:* más superficie de parsing determinista que mantener (nuevos modos de frase requieren nuevas reglas); el caché sigue en memoria por proceso.
  * *Contramedida:* 7 tests nuevos cubren parser, orden/límite del ranking, rango de 3 meses, aislamiento de ventas y bitácora, tope 999→50 y descarga ajena 404. Suite en **198 passed, 0 failed, 0 errors**; `npm run build` y `flutter analyze` en verde.

---

### ADR-011: Ficha detallada de producto a 36 meses y seed suplementario por tenant

* **Estado:** Aceptado
* **Fecha:** 2026-11-21
* **Contexto:** El ranking del asistente respondía consultas de «top N» pero no ofrecía una ficha analítica por producto: unidades, ingresos y N° ventas, además de otras métricas que aparecían en 0 (garantías, reportes de sospecha, unidades en tránsito). El usuario pidió que ese detalle viviera **dentro del asistente**, con **datos reales** y un rango **siempre amplio de 36 meses** aunque la consulta mencionara otro período, para los 5 tenants demo, sin nuevas librerías ni cambios de contrato.
* **Decisión:**
   1. Ampliar el parser determinista con `ParsedQuery.wants_detail` y las frases `analisis detallado`, `detalle de`, `ficha de`, `desglose de`, `informacion detallada`, `perfil de`. El producto se resuelve reutilizando `_resolver_filtros_catalogo()` contra `CatalogoTenant` del tenant activo; no se duplica resolución.
   2. `parse_detail_period(now)` fija el rango en **36 meses** (BOT, `2023-12 → 2026-11`) y `build_product_detail()` agrega todas las métricas cruzando solo padres con `idtenant`: `Venta`, `UnidadProducto`, `EventoTrazabilidad`, `Alerta` y `ReporteSospecha`. Las tablas hijas sin discriminador (`Pago`, `Devolucion`, `DevolucionUnidad`, `GarantiaUnidad`, `CodigoQR`, `ConsultaTrazabilidad`, `EventoUnidad`, `CondicionTransporte`) se alcanzan por join desde esos padres (ADR-001).
   3. La respuesta de `POST /ai/voice-report` sigue siendo **aditiva**: nuevo campo opcional `product_detail` con insignia `Detalle · 36 meses · <empresa>`, KPIs, métricas, tendencia mensual y tabla; `filters_applied` incorpora `analisis_detallado` y el rango del detalle. La consulta principal conserva su período original y los followups sugieren profundizar en el producto.
   4. `REPORT_CACHE` guarda el detalle y `report_generator.py` añade la hoja «Detalle Producto» (Excel) y una sección de ficha (PDF), manteniendo el membrete y la validación de tenant de la exportación (ADR-010).
   5. Extender `seed_historical_6m.py` —reutilizado por el envoltorio 36m— con claves naturales deterministas: **garantía por unidad vendida**, **reporte de sospecha por unidad** en meses `mes % 3 == 0` (tickets `-Uxx` que no chocan con el histórico) y **unidad en tránsito por variante activa** cada 6 meses. El manifest 36m pasa de 17.335 a **20.401 IDs** y la re-ejecución inserta 0 filas.
   6. Renderizar la ficha en Angular (`dashboard.view.html`) y Flutter (`_buildProductDetailCard`) con modelos opcionales, reutilizando los chips de seguimiento existentes.
* **Consecuencias:**
   * *Positivas:* ficha por producto con métricas reales y comparables entre empresas; rango fijo que evita resultados vacíos por períodos cortos; aislamiento reforzado en todas las tablas hijas; seed reproducible y seguro para `--dry-run`/`--reset-history`.
   * *Negativas:* más agregaciones por consulta y mayor volumen del manifest; las métricas de la ficha ignoran el período pedido por diseño (se explica en la insignia y en `filters_applied`).
   * *Contramedida:* 4 tests nuevos cubren detección del disparador, rango 36m aunque la consulta pida 1 mes, métricas > 0 con datos sembrados, invisibilidad de producto ajeno y exportación con la hoja de detalle. Suite en **202 passed, 0 failed, 0 errors**; `npm run build` y `flutter analyze` en verde.
