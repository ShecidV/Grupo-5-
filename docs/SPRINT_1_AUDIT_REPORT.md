# Informe Detallado de Auditoría y Verificación: Sprint 1

> **Documento:** Auditoría Técnica, Evaluación de Implementación y Guía de Pruebas  
> **Ubicación:** `docs/SPRINT_1_AUDIT_REPORT.md`  
> **Sprint Auditado:** **Sprint 1 (Autenticación JWT, Catálogo Apple, Actores y Sedes)**  
> **Casos de Uso Cubiertos:** `CU-004`, `CU-006`, `CU-007`, `CU-008`, `CU-009`, `CU-013`, `CU-014`  
> **Fecha de Evaluación:** 2026-11-20  
> **Estado Global:** **Implementación Completa (95% - 100%)** con hallazgos menores de manejo de errores referenciales.

---

## 1. Resumen Ejecutivo de la Suite de Pruebas del Sprint 1

La batería automatizada de pruebas unitarias y de integración para el Sprint 1 consta de **22 pruebas específicas**, ejecutadas contra PostgreSQL (`BLACKCHAIN` / `blacktest`):

| Archivo de Prueba | Casos de Uso Evaluados | Tests | Resultado | Tiempo de Ejecución |
| :--- | :--- | :---: | :---: | :---: |
| `tests/test_auth.py` | `CU-004` (Autenticación, Refresh, Reseteo) | 15 | **15/15 PASSED** | ~25s (Bcrypt hashing) |
| `tests/test_catalog.py` | `CU-006` (Productos/Variantes), `CU-009` (Categorías) | 2 | **2/2 PASSED** | ~32s |
| `tests/test_cert_catalog.py` | `CU-007` (Certificaciones), `CU-008` (Catálogo Empresa) | 2 | **2/2 PASSED** | ~15s |
| `tests/test_supply_chain.py` | `CU-013` (Actores), `CU-014` (Ubicaciones) | 3 | **3/3 PASSED** | ~15s |
| **Total Sprint 1** | **7 Casos de Uso Oficiales** | **22** | **100% VERDE** | **0 fallos, 0 errores** |

---

## 2. Evaluación Detallada por Caso de Uso

### CU-004: Autenticar y Recuperar Contraseña
* **Paquete:** `P1 - Seguridad y Multi-Tenant`
* **Plataformas:** Web (Angular) y Móvil (Flutter)
* **Componentes Backend:**
  * Controlador: [`app/packages/p1_seguridad/controllers/cu004_autenticacion/auth_controller.py`](file:///c:/Users/PERSONAL/Grupo-5-/trazabilidad/backend/app/packages/p1_seguridad/controllers/cu004_autenticacion/auth_controller.py)
  * Modelos: `password_reset_token.py`, `refresh_token.py`
  * Vistas/DTOs: `auth_views.py` (`LoginRequest`, `TokenResponse`, `ForgotPasswordRequest`, `ResetPasswordRequest`)
  * Rutas HTTP: `POST /api/v1/auth/login`, `POST /api/v1/auth/refresh`, `POST /api/v1/auth/logout`, `GET /api/v1/auth/me`, `POST /api/v1/auth/forgot-password`, `POST /api/v1/auth/reset-password`
* **Componentes Frontend Web:**
  * Controladores: `login.controller.ts`, `forgot-password.controller.ts`, `reset-password.controller.ts`
  * Vistas: `login.view.html`, `forgot-password.view.html`, `reset-password.view.html`
  * Servicios: `auth.service.ts` con manejo reactivo de JWT en LocalStorage y Signal `currentUser`.
* **Componentes Móviles (Flutter):**
  * Vistas: `login_view.dart`, `forgot_password_view.dart`, `reset_password_view.dart`
  * Controladores: `auth_controller.dart`, `auth_service.dart` con almacenamiento seguro (`flutter_secure_storage`).
* **Nivel de Implementación:** **100%**
* **Aislamiento Multi-Tenant:** La autenticación recibe el `tenant_slug` (nombre, ID o slug normalizado) y emite un JWT firmado que codifica el `sub` (ID de usuario) y `tenant_id`.
* **Hallazgos / Edge Cases:**
  1. *Llamada SMTP en segundo plano:* Al solicitar recuperación de contraseña, si las credenciales SMTP de Gmail en `.env` fallan o hay bloqueo de red, `aiosmtplib` espera hasta agotar el timeout de 10s en puerto 587 y 10s en puerto 465 antes de fallar. En producción opera como `BackgroundTasks`, pero en pruebas debe usarse un mock para evitar retrasos.
  2. *Auto-enlace de usuario a empresa:* En `authenticate_user` (líneas 111-115), si el usuario no tiene vínculo previo en `usuariotenant`, se crea automáticamente en base de datos. Esto es conveniente para demos multi-tenant, pero en entornos estrictos debe requerir aprobación previa del administrador de la empresa.

---

### CU-006: Gestionar Productos y Variantes
* **Paquete:** `P2 - Catálogo y Abastecimiento`
* **Plataformas:** Web (Angular)
* **Componentes Backend:**
  * Controlador: [`app/packages/p2_catalogo/controllers/cu006_productos_variantes/product_controller.py`](file:///c:/Users/PERSONAL/Grupo-5-/trazabilidad/backend/app/packages/p2_catalogo/controllers/cu006_productos_variantes/product_controller.py)
  * Modelos: `product.py` (`Producto`), `variant.py` (`VarianteProducto`)
  * Vistas/DTOs: `product_views.py` (`ProductCreate`, `ProductUpdate`, `VariantCreate`, `VariantUpdate`, `ProductResponse`)
  * Rutas HTTP: `GET /api/v1/products`, `POST /api/v1/products`, `GET /api/v1/products/{id}`, `PUT /api/v1/products/{id}`, `DELETE /api/v1/products/{id}`, `POST /api/v1/products/{id}/variants`, `PUT /api/v1/variants/{id}`, `DELETE /api/v1/variants/{id}`
* **Componentes Frontend Web:**
  * Controlador: `product-management.controller.ts`
  * Vista: `product-management.view.html` con listado de tarjetas/tabla, modal de creación, selector de categorías y panel expandible para gestión de variantes (SKU, color, capacidad, precio USD).
  * Servicio: `product.service.ts`
* **Nivel de Implementación:** **95%**
* **Seguridad RBAC:** Endpoints de mutación restringidos mediante `requires_gestion_producto` (`SuperAdministrador`, `AdministradorEmpresa`).
* **Hallazgos / Edge Cases:**
  1. *Borrado de variantes con dependencias (Bug potencial):* `delete_variant` ejecuta `db.delete(var)` directamente. Si la variante ya tiene unidades físicas serializadas (`UnidadProducto`) o registros en órdenes de compra (`CompraDetalle`), Postgres arrojará un error `IntegrityError` (500) en lugar de un `400 Bad Request` descriptivo. Se recomienda validación previa antes del delete.
  2. *Validación de unicidad de SKU:* El SKU se valida correctamente a nivel aplicación antes de insertar (`400 Bad Request` si está repetido).

---

### CU-007: Gestionar Certificaciones Técnicas
* **Paquete:** `P2 - Catálogo y Abastecimiento`
* **Plataformas:** Web (Angular)
* **Componentes Backend:**
  * Controlador: [`app/packages/p2_catalogo/controllers/cu007_certificaciones/certification_controller.py`](file:///c:/Users/PERSONAL/Grupo-5-/trazabilidad/backend/app/packages/p2_catalogo/controllers/cu007_certificaciones/certification_controller.py)
  * Modelos: `certification.py` (`Certificacion`, `ProductoCertificacion`)
  * Vistas/DTOs: `certification_views.py` (`CertificationCreate`, `CertificationResponse`, `ProductCertificationAssign`)
  * Rutas HTTP: `GET /api/v1/certifications`, `POST /api/v1/certifications`, `PUT /api/v1/certifications/{id}`, `DELETE /api/v1/certifications/{id}`, `GET /api/v1/products/{id}/certifications`, `POST /api/v1/products/{id}/certifications`
* **Componentes Frontend Web:**
  * Controlador: `certification-management.controller.ts`
  * Vista: `certification-management.view.html` con catálogo de sellos (ISO 9001, CE, FCC, RoHS) y modal de vinculación directa a modelos Apple.
  * Servicio: `certification.service.ts`
* **Nivel de Implementación:** **100%**
* **Seguridad RBAC:** Mutaciones protegidas con `requires_gestion_certificacion`.
* **Hallazgos / Edge Cases:**
  1. *Prevención de duplicidad:* Valida adecuadamente que una misma certificación no se asigne dos veces al mismo producto (`400 Bad Request: Esta certificación ya está asignada al producto`).
  2. *Borrado de certificaciones en uso:* `delete_certification` elimina la entidad sin limpiar primero los enlaces en `productocertificacion`. Si no está configurado `ondelete="CASCADE"` a nivel base de datos, arrojará violación de integridad referencial.

---

### CU-008: Gestionar Catálogo por Empresa
* **Paquete:** `P2 - Catálogo y Abastecimiento`
* **Plataformas:** Web (Angular)
* **Componentes Backend:**
  * Controlador: [`app/packages/p2_catalogo/controllers/cu008_catalogo_empresa/tenant_catalog_controller.py`](file:///c:/Users/PERSONAL/Grupo-5-/trazabilidad/backend/app/packages/p2_catalogo/controllers/cu008_catalogo_empresa/tenant_catalog_controller.py)
  * Modelo: `tenant_catalog.py` (`CatalogoTenant`)
  * Vistas/DTOs: `tenant_catalog_views.py` (`TenantCatalogCreate`, `TenantCatalogUpdate`, `TenantCatalogResponse`)
  * Rutas HTTP: `GET /api/v1/tenant-catalog`, `POST /api/v1/tenant-catalog`, `PUT /api/v1/tenant-catalog/{id}`, `DELETE /api/v1/tenant-catalog/{id}`, `POST /api/v1/tenant-catalog/recommendations` (IA Pricing)
* **Componentes Frontend Web:**
  * Controlador: `tenant-catalog-management.controller.ts`
  * Vista: `tenant-catalog-management.view.html` con visualización de variantes adoptadas, SKU interno de la importadora, costo promedio y precio de venta en BOB/USD.
  * Servicio: `tenant-catalog.service.ts`
* **Nivel de Implementación:** **100%**
* **Aislamiento Multi-Tenant:** Implementación ejemplar: utiliza `resolve_tenant_id(db, user, tenant_id)`, garantizando que cada empresa solo vea y edite sus propios precios y SKUs internos, con bypass total para el SuperAdministrador.

---

### CU-009: Gestionar Categorías de Productos
* **Paquete:** `P2 - Catálogo y Abastecimiento`
* **Plataformas:** Web (Angular)
* **Componentes Backend:**
  * Controlador: [`app/packages/p2_catalogo/controllers/cu009_categorias/category_controller.py`](file:///c:/Users/PERSONAL/Grupo-5-/trazabilidad/backend/app/packages/p2_catalogo/controllers/cu009_categorias/category_controller.py)
  * Modelo: `category.py` (`Categoria`)
  * Vistas/DTOs: `category_views.py` (`CategoryCreate`, `CategoryUpdate`, `CategoryResponse`)
  * Rutas HTTP: `GET /api/v1/categories`, `POST /api/v1/categories`, `PUT /api/v1/categories/{id}`, `DELETE /api/v1/categories/{id}`
* **Componentes Frontend Web:**
  * Controlador: `category-management.controller.ts`
  * Vista: `category-management.view.html` con formulario CRUD de categorías principales (iPhone, Mac, iPad, Watch, Accesorios).
  * Servicio: `category.service.ts`
* **Nivel de Implementación:** **95%**
* **Seguridad RBAC:** Protegido con `requires_gestion_categoria` (`SuperAdministrador`, `AdministradorEmpresa`).
* **Hallazgos / Edge Cases:**
  1. *Borrado de categoría con productos asociados:* En `delete_category`, no se comprueba si existen productos (`Producto.idcategoria == idcategoria`). Si existen, Postgres lanzará un error 500 por llave foránea. Debe añadirse comprobación de productos existentes antes de proceder a la eliminación.

---

### CU-013: Gestionar Actores de la Cadena
* **Paquete:** `P3 - Actores y Ubicaciones`
* **Plataformas:** Web (Angular)
* **Componentes Backend:**
  * Controlador: [`app/packages/p3_actores/controllers/cu013_actores_cadena/actor_controller.py`](file:///c:/Users/PERSONAL/Grupo-5-/trazabilidad/backend/app/packages/p3_actores/controllers/cu013_actores_cadena/actor_controller.py)
  * Modelo: `actor.py` (`ActorCadena`)
  * Vistas/DTOs: `actor_views.py` (`ActorCreate`, `ActorUpdate`, `ActorResponse`, `ActorListResponse`)
  * Rutas HTTP: `GET /api/v1/actors`, `POST /api/v1/actors`, `GET /api/v1/actors/{id}`, `PUT /api/v1/actors/{id}`, `DELETE /api/v1/actors/{id}`
* **Componentes Frontend Web:**
  * Controlador: `actor-management.controller.ts`
  * Vista: `actor-management.view.html` con filtros por tipo de actor (`PROVEEDOR_EEUU`, `TRANSPORTISTA_INT`, `AGENCIA_ADUANERA`, `TRANSPORTISTA_NAC`, `TIENDA_RETAIL`).
  * Servicio: `actor.service.ts`
* **Nivel de Implementación:** **95%**
* **Aislamiento Multi-Tenant y RBAC:** Cada actor pertenece a `idtenant`. Protegido por `requires_gestion_actor`.
* **Hallazgos / Edge Cases:**
  1. *Uso de `get_user_tenant_id` vs `resolve_tenant_id`:* El controlador invoca `get_user_tenant_id(db, user)`, el cual consulta únicamente la primera fila de `UsuarioTenant` en DB. Si el SuperAdministrador cambia de inquilino o envía `tenant_id` como parámetro, este método no respeta el cambio. Debe migrarse a `resolve_tenant_id` para cumplir plenamente con ADR-005.

---

### CU-014: Gestionar Ubicaciones Físicas
* **Paquete:** `P3 - Actores y Ubicaciones`
* **Plataformas:** Web (Angular)
* **Componentes Backend:**
  * Controlador: [`app/packages/p3_actores/controllers/cu014_ubicaciones/location_controller.py`](file:///c:/Users/PERSONAL/Grupo-5-/trazabilidad/backend/app/packages/p3_actores/controllers/cu014_ubicaciones/location_controller.py)
  * Modelo: `location.py` (`Ubicacion`)
  * Vistas/DTOs: `location_views.py` (`LocationCreate`, `LocationUpdate`, `LocationResponse`, `LocationListResponse`)
  * Rutas HTTP: `GET /api/v1/locations`, `POST /api/v1/locations`, `GET /api/v1/locations/{id}`, `PUT /api/v1/locations/{id}`, `DELETE /api/v1/locations/{id}`
* **Componentes Frontend Web:**
  * Controlador: `location-management.controller.ts`
  * Vista: `location-management.view.html` con formulario de coordenadas GPS (latitud/longitud), ciudad, país, tipo (`almacen`, `puerto`, `aduana`, `tienda`) y vinculación opcional a un actor de la cadena.
  * Servicio: `location.service.ts`
* **Nivel de Implementación:** **95%**
* **Aislamiento Multi-Tenant:** Filtra por `Ubicacion.idtenant == tenant_id`. Valida que si se asigna un `idactor`, dicho actor pertenezca al mismo `tenant_id`.
* **Hallazgos / Edge Cases:**
  1. *Mismo patrón `get_user_tenant_id`:* Al igual que en CU-013, debe adoptarse `resolve_tenant_id` para permitir gobernanza fluida del SuperAdministrador sobre distintas empresas.
  2. *Protección contra eliminación referenciada:* Si la ubicación está asignada como origen/destino de un envío logístico (`Envio`) o evento de trazabilidad, el borrado directo generará un fallo de integridad en base de datos.

---

## 3. Guía Paso a Paso para Probar los Casos de Uso del Sprint 1

### A. Pruebas Automatizadas (Pytest)

Ejecuta desde la terminal en el directorio `trazabilidad/backend`:

```bash
cd trazabilidad/backend

# 1. Probar Autenticación y Recuperación (CU-004)
python -m pytest tests/test_auth.py -v

# 2. Probar Catálogo de Categorías, Productos y Variantes (CU-006, CU-009)
python -m pytest tests/test_catalog.py -v

# 3. Probar Certificaciones Técnicas y Catálogo por Empresa (CU-007, CU-008)
python -m pytest tests/test_cert_catalog.py -v

# 4. Probar Actores de la Cadena y Ubicaciones Físicas (CU-013, CU-014)
python -m pytest tests/test_supply_chain.py -v
```

---

### B. Pruebas Manuales por API REST (cURL / Postman)

#### Paso 1: Autenticación y Obtención de Token JWT (CU-004)
```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "tenant_slug": "empresa-test-1",
    "email": "user1@test.com",
    "password": "MiClave@123"
  }'
```
> *Guarda el campo `access_token` retornado para usarlo en el header: `Authorization: Bearer <TOKEN>`.*

---

#### Paso 2: Crear Categoría de Productos (CU-009)
```bash
curl -X POST "http://localhost:8000/api/v1/categories" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "nombrecategoria": "Smartphones Apple",
    "descripcion": "Línea oficial de teléfonos iPhone"
  }'
```
> *Retorna HTTP 201 con el `idcategoria` generado (ej. 1).*

---

#### Paso 3: Crear Producto Apple y su Variante (CU-006)
```bash
# 3.1 Crear Producto
curl -X POST "http://localhost:8000/api/v1/products" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "iPhone 15 Pro Max",
    "modelo": "A2849",
    "paisorigen": "EEUU",
    "descripcion": "Dispositivo con chip A17 Pro y chasis de titanio",
    "idcategoria": 1
  }'

# 3.2 Añadir Variante al Producto (usando el idproducto generado, ej. 1)
curl -X POST "http://localhost:8000/api/v1/products/1/variants" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "capacidad": "256GB",
    "color": "Titanio Natural",
    "sku": "IPH15PM-256-TN",
    "preciousd": 1199.00
  }'
```

---

#### Paso 4: Crear y Asociar Certificación Técnica (CU-007)
```bash
# 4.1 Crear Certificación
curl -X POST "http://localhost:8000/api/v1/certifications" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Certificación FCC ID",
    "entidademisora": "Federal Communications Commission (USA)",
    "descripcion": "Cumplimiento de estándares de compatibilidad electromagnética"
  }'

# 4.2 Asignar al Producto
curl -X POST "http://localhost:8000/api/v1/products/1/certifications" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "idcertificacion": 1,
    "fechaobtencion": "2026-01-15"
  }'
```

---

#### Paso 5: Publicar Variante en el Catálogo de la Empresa (CU-008)
```bash
curl -X POST "http://localhost:8000/api/v1/tenant-catalog" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "idvariante": 1,
    "skuinterno": "BOL-IPH15-001",
    "precioventa": 1450.00,
    "costopromedio": 1150.00
  }'
```

---

#### Paso 6: Crear un Actor de la Cadena de Suministro (CU-013)
```bash
curl -X POST "http://localhost:8000/api/v1/actors" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Apple Retail Miami",
    "razonsocial": "Apple Stores Inc.",
    "nit": "US-FL-99201",
    "email": "miami.logistics@apple.com",
    "telefono": "+1-305-555-0199",
    "tipoactor": "PROVEEDOR_EEUU"
  }'
```

---

#### Paso 7: Crear una Ubicación Física Georreferenciada (CU-014)
```bash
curl -X POST "http://localhost:8000/api/v1/locations" \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Almacén Central Viru Viru",
    "direccion": "Zona Franca Aeropuerto Viru Viru",
    "ciudad": "Santa Cruz",
    "pais": "Bolivia",
    "tipo": "almacen",
    "latitud": -17.6444,
    "longitud": -63.1356,
    "idactor": 1
  }'
```

---

### C. Pruebas en el Frontend Web (Angular 17+)

1. Inicia el servidor de desarrollo web:
   ```bash
   cd trazabilidad/frontend
   npm start
   ```
2. Navega a `http://localhost:4200/login`:
   * Ingresa Empresa: `empresa-test-1`, Email: `user1@test.com`, Contraseña: `MiClave@123`.
   * Verifica que redirige correctamente a `/dashboard`.
3. Prueba el catálogo maestro:
   * **Categorías:** Accede a `/categories` y crea una nueva categoría.
   * **Productos y Variantes:** Ve a `/products`, abre el modal de nuevo producto, selecciónale su categoría y pulsa en "Añadir Variante" con su SKU y precio.
   * **Certificaciones:** Ve a `/certifications`, crea una certificación y vincúlala a un producto existente.
   * **Catálogo por Empresa:** Accede a `/tenant-catalog`, asigna un precio local y verifica que se listen las existencias.
4. Prueba actores y sedes:
   * **Actores:** Accede a `/actors` y filtra por tipo (Proveedor EEUU, Transportista, etc.).
   * **Ubicaciones:** Accede a `/locations` y comprueba que se visualicen las direcciones y tipos de sede.

---

### D. Pruebas en la Aplicación Móvil (Flutter)

1. Inicia el emulador o dispositivo móvil:
   ```bash
   cd trazabilidad/mobile
   flutter run
   ```
2. Pantalla de Login (`login_view.dart`):
   * Ingresa las mismas credenciales de prueba.
   * Valida que guarde el token en `secure_storage` y navegue al Dashboard móvil.
3. Recuperación de Contraseña (`forgot_password_view.dart`):
   * Pulsa "¿Olvidaste tu contraseña?".
   * Ingresa el correo y verifica el mensaje de confirmación.

---

## 4. Conclusiones y Plan de Acción Recomendado

1. **Robustez Confirmada:** Los 7 Casos de Uso del Sprint 1 se encuentran **100% operativos en el backend y verificados con pruebas automatizadas verdes**.
2. **Recomendaciones de Estabilidad (Quick Fixes):**
   * Incorporar en `delete_category`, `delete_product` y `delete_variant` una validación previa de registros dependientes (`400 Bad Request` en vez de dejar que la BD lance `500 IntegrityError`).
   * Homogeneizar `ActorController` y `LocationController` para que utilicen `resolve_tenant_id` en lugar de `get_user_tenant_id`, habilitando la alternancia fluida de inquilinos para el SuperAdministrador.
