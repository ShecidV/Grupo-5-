# Próximos Pasos Operativos (Next Steps - Agentes de IA)

> **Documento:** Checklist Táctico y Cola de Trabajo Inmediata para Agentes  
> **Ubicación:** `docs/ai/NEXT_STEPS.md`  
> **Metodología:** SCRUM · **Sprint Activo:** **Sprint 4 (cerrado en backend/web/móvil)**  
> **Estado de Base de Código:** Sprints 0, 1, 2, 3 y 4 implementados + Panel Integral 36 meses + Asistente de Informes personalizable + Ficha Detallada de Producto · **202 tests verdes** · Angular build OK · Flutter analyze OK

---

## 1. Contexto Operativo Inmediato

El Sprint 4 quedó implementado de extremo a extremo:

* **P5 (CU-025 a CU-031):** ventas, asignación de unidades, pagos, historial del consumidor, devoluciones y garantías.
* **P7 (CU-035):** reportes, trazabilidad consolidada, PDF y dashboard.
* **P8 (CU-036 a CU-040):** planes/suscripciones migrados, cuotas con límite duro, facturación/cobros y notificaciones de facturación.
* **CU-005:** push implementado y conectado con la UI web.
* **Web:** 5 rutas nuevas (`/sales`, `/post-sales`, `/reports`, `/quotas`, `/billing`) con guardas RBAC y enlaces en el dashboard.
* **Móvil:** historial del consumidor y notificaciones de facturación integrados en el dashboard.

No quedan CUs pendientes del listado Sprint 4. Se agregó el **Panel Integral por tenant con 36 meses** (extensión de CU-035): `GET /reports/analytics`, panel de 8 pestañas en web y móvil, e histórico real `2023-12 → 2026-11`. También se personalizó el **Asistente de Informes Dinámicos por Voz** (CU-022): parser determinista con períodos/top N/métrica/filtros, ranking de ventas por tenant, chips sugeridos y badge de interpretación en web y móvil (ADR-010). Finalmente se añadió la **ficha detallada por producto** dentro del asistente (ADR-011): `product_detail` con rango fijo de 36 meses, métricas reales y exportación en PDF/Excel, con seed suplementario idempotente para los 5 tenants. La cola siguiente es de **verificación y cierre**, no de implementación funcional.

---

## 2. Checklist de Cierre (en orden)

- [x] Backend P5/P7/P8 y push CU-005 implementados.
- [x] Tests Sprint 4 creados y suite global en verde (188 → 191 con el Panel Integral).
- [x] Panel Integral 36 meses: endpoint `/reports/analytics`, 3 tests nuevos, series completas, panel web/móvil y seed 36m (17.335 filas, idempotente).
- [x] QA visual del panel a 1440 y 390 px: 8 pestañas, SVG + 36 celdas, sin overflow horizontal; corregido `formatoFecha` y nav responsive.
- [x] Migración Alembic aplicada y `alembic current` en head.
- [x] Angular: rutas, servicios, modelos, vistas y dashboard actualizados; `npm run build` OK.
- [x] Flutter: modelos, servicios, controladores, vistas y dashboard actualizados; `flutter analyze` OK.
- [x] ADR-008 redactado, ADR-006 corregido y documentación de 7→8 paquetes actualizada.
- [x] Aislamiento multi-tenant de `POST /billing/notifications/process` (CU-040) corregido y cubierto por test.
- [x] Asistente de informes (CU-022, ADR-010): parser + ranking ventas + fechas en todos los intentos + auditoría por tenant + 404 en exportación ajena; 7 tests nuevos (suite 198), chips y badge en web/móvil; build y analyze OK.
- [x] Ficha detallada de producto (CU-022, ADR-011): `product_detail` aditivo con 36 meses fijos, métricas filtradas por tenant, tarjeta web/móvil y sección PDF/Excel; seed suplementario idempotente (20.401 IDs, 0 filas en re-ejecución); 4 tests nuevos (suite 202); build y analyze OK.
- [x] Smoke test de endpoints con las credenciales demo (todos 200; `/reports/pdf` devuelve PDF; `/consumer/history` con `idcliente=1839`).
- [x] Poblado historico de 6 meses (`2026-06`→`2026-11`) en la BD local: 2.894 filas, idempotente, serie de 6 puntos en `/reports/traceability` y suite en verde (188).
- [ ] **Pendiente (sin acceso):** ejecutar `python seed_historical_36m.py` en Railway Shell con el `DATABASE_URL` de produccion (previamente `python seed.py` si la BD remota esta vacia). Los datos locales NO se suben con `git push`.
- [ ] **Verificación manual end-to-end con las credenciales demo** de `docs/ai/HANDOFF_LATEST.md`:
  * `/sales` → crear venta, asignar unidades, registrar pago y cambiar estados.
  * `/post-sales` → crear devolución, asignar unidades y registrar garantía.
  * `/reports` → resumen, trazabilidad, dashboard y descarga PDF.
  * `/quotas` → consultar y consumir hasta exceder (429).
  * `/billing` → crear factura, registrar cobro, procesar vencimientos y enviar push.
  * Móvil → tarjetas “Mis Compras (CU-028)” y “Notificaciones de Facturación (CU-040)”.
- [ ] Opcional: ajustar el presupuesto de `anyComponentStyle` en `angular.json` para eliminar warnings preexistentes de CSS.
- [x] Roles en `UserModel` de Flutter registrados: la tarjeta del Panel Integral se oculta a `Consumidor`.
- [ ] Opcional: corregir el 403 preexistente de `GET /planes?solo_activos=true` que el dashboard solicita al iniciar (parámetro no reconocido por `_requires_lectura_planes`).

---

## 3. Notas para el siguiente agente

* **No alterar** los prefijos `/api/v1/...` existentes; Angular y Flutter dependen de ellos.
* **Multi-tenant:** las tablas hijas (`pago`, `devolucionunidad`, `garantiaunidad`, `ventaunidad`, etc.) no tienen `idtenant`; filtrar siempre por join a `venta.idtenant` o `unidadproducto.idtenant`.
* **Notarización de ventas:** es best-effort; un fallo de Blockchain no debe revertir la venta.
* **ADR-006** queda parcialmente supersedido por **ADR-008**; no reintroducir planes/suscripciones en P1.
* Si se crean nuevos tests, ejecutar `cd trazabilidad/backend && python -m pytest tests/ -q` y mantener **≥202 passed, 0 failed, 0 errors**.
* Asistente (ADR-010, ADR-011): no alterar los campos nuevos de `VoiceReportResponse` (`period_label`, `interpretation`, `filters_applied`, `suggested_followups`, `product_detail`); son aditivos y los clientes móvil/web ya los consumen de forma opcional. El `top N` se acota a 50 y sin período se mantiene "todo el historico". La ficha detallada ignora el período de la consulta y usa siempre 36 meses; el producto se resuelve contra `CatalogoTenant` del tenant activo. `/ai/reports/{id}/export` exige JWT y valida empresa activa: el SuperAdmin debe cambiar de tenant antes de descargar un informe ajeno.
* `/reports/analytics` es el único agregado nuevo: no modificar los contratos existentes de P7. El rango `meses` está limitado a `1..36`; los 36 puntos se rellenan con `0` en meses sin datos (nunca se omiten).
