# 🅰️ Frontend - Sistema Multi-Tenant empresarial (Angular 21)

Este es el cliente web frontend del Sistema Empresarial Multi-Tenant construido con **Angular 21 (Standalone Components)**, **TypeScript**, **RxJS** y **SCSS (Glassmorphism UI)**.

---

## 📦 Librerías y Dependencias Instaladas

A continuación se detallan las librerías principales instaladas en Node.js (`package.json`):

### 1. Framework Angular (Versión 21)
* **`@angular/core`** (`^21.2.0`): Motor principal del framework Angular (Inyección de dependencias, Signals y componentes Standalone).
* **`@angular/common`** (`^21.2.0`): Directivas comunes (`@if`, `@for`, Pipes, HttpClient).
* **`@angular/forms`** (`^21.2.0`): Formularios reactivos (`ReactiveFormsModule`, `FormBuilder`, `Validators`).
* **`@angular/router`** (`^21.2.0`): Enrutador oficial para gestión de SPA (`Routes`, `RouterOutlet`, `RouterLink`, Guards).
* **`@angular/platform-browser`** (`^21.2.0`): Renderizado de la aplicación en navegadores web.

### 2. Detección de Cambios y Asincronía
* **`zone.js`** (`^0.16.2`): Manejo de contexto de zonas asíncronas y detección de cambios para Angular.
* **`rxjs`** (`~7.8.0`): Programación reactiva con Observables para manejo de eventos e Interceptores HTTP.
* **`tslib`** (`^2.3.0`): Librería de ayuda de TypeScript para soporte de decoradores y helpers de compilación.

### 3. Herramientas de Desarrollo y Compilación (DevDependencies)
* **`@angular/cli`** (`^21.2.22`): Interfaz de línea de comandos de Angular para desarrollo, serve y build.
* **`typescript`** (`~5.9.2`): Lenguaje tipado sobre el cual está construido todo el proyecto.
* **`prettier`** (`^3.8.1`): Formateador automático de código.

---

## 🧩 Extensiones Recomendadas para VSCode

Para desarrollar cómodamente en Angular con VSCode, se recomienda instalar:
1. **Angular Language Service** (`Angular.ng-template`): Autocompletado e Intellisense en plantillas HTML de Angular.
2. **Prettier - Code formatter** (`esbenp.prettier-vscode`): Formateo de archivos `.ts`, `.html` y `.scss`.
3. **SCSS IntelliSense** (`mrmlnc.vscode-scss`): Autocompletado de variables e importaciones SCSS.

---

## 🚀 Cómo Levantar el Frontend Paso a Paso

### 1. Requisitos Previos
* Node.js v18 o superior (Verificado con Node.js 22.22.0).
* npm 10.9.0 o superior.

### 2. Pasos para Iniciar
1. Abre tu terminal en la carpeta del frontend:
   ```bash
   cd trazabilidad/frontend
   ```

2. Instalar dependencias (si es la primera vez):
   ```bash
   npm install
   ```

3. Iniciar el servidor de desarrollo de Angular:
   ```bash
   ng serve
   ```
   *(Si `ng` no se reconoce de forma global, puedes ejecutar: `npx ng serve`)*

4. Abrir en tu navegador web:
   🌐 **[http://localhost:4200](http://localhost:4200)**

---

## 🔑 Credenciales de Prueba en la Aplicación
* **Empresa (Slug):** `empresa-demo`
* **Correo electrónico:** `diogomars2026@gmail.com`
* **Contraseña:** `Admin123.`
