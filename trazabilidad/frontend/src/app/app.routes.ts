import { Routes } from '@angular/router';
import { LoginController } from './controllers/auth/login.controller';
import { ForgotPasswordController } from './controllers/auth/forgot-password.controller';
import { ResetPasswordController } from './controllers/auth/reset-password.controller';
import { DashboardController } from './controllers/pages/dashboard.controller';
import { TenantManagementController } from './controllers/pages/tenant-management.controller';
import { UserManagementController } from './controllers/pages/user-management.controller';
import { RoleManagementController } from './controllers/pages/role-management.controller';
import { AuditNotificationController } from './controllers/pages/audit-notification.controller';
import { SubscriptionPlansController } from './controllers/pages/subscription-plans.controller';
import { SubscriptionManagementController } from './controllers/pages/subscription-management.controller';
import { CategoryManagementController } from './controllers/pages/category-management.controller';
import { ProductManagementController } from './controllers/pages/product-management.controller';
import { CertificationManagementController } from './controllers/pages/certification-management.controller';
import { TenantCatalogManagementController } from './controllers/pages/tenant-catalog-management.controller';
import { ActorManagementController } from './controllers/pages/actor-management.controller';
import { LocationManagementController } from './controllers/pages/location-management.controller';
import { UnitManagementController } from './controllers/pages/unit-management.controller';
import { PurchaseManagementController } from './controllers/pages/purchase-management.controller';
import { ReceptionManagementController } from './controllers/pages/reception-management.controller';
import { QrManagementController } from './controllers/pages/qr-management.controller';
import { TransportManagementController } from './controllers/pages/transport-management.controller';
import { AlertManagementController } from './controllers/pages/alert-management.controller';
import { DocumentManagementController } from './controllers/pages/document-management.controller';
import { CertificateManagementController } from './controllers/pages/certificate-management.controller';
import { TraceabilityController } from './controllers/pages/traceability.controller';
import { PublicTraceController } from './controllers/pages/public-trace.controller';
import { ReportSuspicionController } from './controllers/pages/report-suspicion.controller';
import { SalesManagementController } from './controllers/pages/sales-management.controller';
import { AfterSalesManagementController } from './controllers/pages/after-sales-management.controller';
import { ReportingController } from './controllers/pages/reporting.controller';
import { QuotasManagementController } from './controllers/pages/quotas-management.controller';
import { BillingManagementController } from './controllers/pages/billing-management.controller';
import { authGuard } from './core/guards/auth.guard';
import { roleGuard } from './core/guards/role.guard';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginController },
  { path: 'forgot-password', component: ForgotPasswordController },
  { path: 'reset-password', component: ResetPasswordController },
  { path: 'dashboard', component: DashboardController, canActivate: [authGuard] },
  { path: 'tenants', component: TenantManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa'])] },
  { path: 'users', component: UserManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa'])] },
  { path: 'roles', component: RoleManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa'])] },
  { path: 'bitacora', component: AuditNotificationController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'Auditor'])] },
  { path: 'subscription-plans', component: SubscriptionPlansController, canActivate: [authGuard, roleGuard(['SuperAdministrador'])] },
  { path: 'subscriptions', component: SubscriptionManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'Auditor'])] },
  { path: 'categories', component: CategoryManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones'])] },
  { path: 'products', component: ProductManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'GestorVentasPostventa'])] },
  { path: 'certifications', component: CertificationManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones'])] },
  { path: 'tenant-catalog', component: TenantCatalogManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'GestorVentasPostventa'])] },
  { path: 'actors', component: ActorManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones'])] },
  { path: 'locations', component: LocationManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones'])] },
  { path: 'units', component: UnitManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'GestorVentasPostventa', 'Auditor'])] },
  { path: 'purchases', component: PurchaseManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'GestorVentasPostventa'])] },
  { path: 'receptions', component: ReceptionManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones'])] },
  { path: 'qr-codes', component: QrManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'GestorVentasPostventa'])] },
  { path: 'shipments', component: TransportManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'Auditor'])] },
  { path: 'alerts', component: AlertManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones'])] },
  { path: 'documents', component: DocumentManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorVentasPostventa'])] },
  { path: 'certificates', component: CertificateManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'Auditor'])] },
  { path: 'traceability', component: TraceabilityController, canActivate: [authGuard] },
  { path: 'trace/:uuid', component: PublicTraceController },
  { path: 'report-suspicion', component: ReportSuspicionController },
  { path: 'sales', component: SalesManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorVentasPostventa'])] },
  { path: 'post-sales', component: AfterSalesManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorVentasPostventa'])] },
  { path: 'reports', component: ReportingController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'GestorVentasPostventa', 'Auditor'])] },
  { path: 'quotas', component: QuotasManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa', 'GestorOperaciones', 'GestorVentasPostventa', 'Auditor'])] },
  { path: 'billing', component: BillingManagementController, canActivate: [authGuard, roleGuard(['SuperAdministrador', 'AdministradorEmpresa'])] },
  { path: '**', redirectTo: 'login' }
];
