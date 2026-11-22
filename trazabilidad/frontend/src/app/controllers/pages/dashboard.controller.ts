import { Component, signal, Signal, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../services/auth.service';
import { TenantService } from '../services/tenant.service';
import { AiAssistantService } from '../services/ai-assistant.service';
import { User } from '../../models/auth.models';
import { AnalyticsPanelController } from './analytics-panel.controller';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule, AnalyticsPanelController],
  templateUrl: '../../views/pages/dashboard.view.html',
  styleUrls: ['../../views/pages/dashboard.view.scss']
})
export class DashboardController implements OnInit {
  private authService = inject(AuthService);
  private tenantService = inject(TenantService);
  aiService = inject(AiAssistantService);

  currentUser: Signal<User | null> = this.authService.currentUser;
  isLoading = signal(false);
  tenants = this.tenantService.tenantsSignal;

  showAiModal = signal(false);
  queryInput = '';
  quickPrompts = [
    '🏆 Top 10 productos más vendidos en el último trimestre',
    '📈 Top 5 por ingresos en los últimos 6 meses',
    '🛒 Compras de los últimos 3 meses',
    '🚚 Envíos de la última semana',
    '📦 Stock disponible de iPhones',
    '🛡️ Resumen de bitácora y auditoría'
  ];

  ngOnInit(): void {
    this.tenantService.getTenants().subscribe();
  }

  toggleAiModal(): void {
    this.showAiModal.update((v) => !v);
  }

  onStartVoice(): void {
    this.aiService.startListening((text) => {
      this.queryInput = text;
      this.onSubmitQuery(text);
    });
  }

  onStopVoice(): void {
    this.aiService.stopListening();
  }

  onSubmitQuery(text?: string): void {
    const q = (text !== undefined ? text : this.queryInput).trim();
    if (!q) return;
    this.queryInput = q;
    this.aiService.generateVoiceReport(q).subscribe();
  }

  onSelectPrompt(prompt: string): void {
    this.queryInput = prompt;
    this.onSubmitQuery(prompt);
  }

  onDownload(reportId: string, format: 'pdf' | 'excel'): void {
    this.aiService.downloadReportFile(reportId, format);
  }

  onTenantChange(event: Event): void {
    const selectElem = event.target as HTMLSelectElement;
    const tenantId = Number(selectElem.value);
    if (tenantId) {
      this.isLoading.set(true);
      this.authService.switchTenant(tenantId).subscribe({
        next: () => {
          this.isLoading.set(false);
          window.location.reload();
        },
        error: (err) => {
          this.isLoading.set(false);
          alert('Error al cambiar de empresa: ' + (err.error?.detail || 'Intente nuevamente'));
        }
      });
    }
  }

  onLogout(): void {
    this.authService.logout();
  }

  // El superadministrador puede estar viendo el contexto de otro tenant.
  analyticsTenantId(): number | undefined {
    const roles = this.currentUser()?.roles || [];
    if (!roles.includes('SuperAdministrador')) return undefined;
    const id = this.currentUser()?.tenant?.idtenant ?? this.currentUser()?.tenant_id;
    return id === undefined || id === null || id === '' ? undefined : Number(id);
  }

  canAccess(module: string): boolean {
    const roles = this.currentUser()?.roles || [];
    if (roles.includes('SuperAdministrador')) {
      return true;
    }

    switch (module) {
      case 'tenants':
        return roles.includes('AdministradorEmpresa');

      case 'users':
      case 'roles':
        return roles.includes('AdministradorEmpresa');

      case 'bitacora':
        return roles.includes('AdministradorEmpresa') || roles.includes('Auditor');

      case 'categories':
      case 'certifications':
      case 'actors':
      case 'locations':
      case 'receptions':
        return roles.includes('AdministradorEmpresa') || roles.includes('GestorOperaciones');

      case 'products':
      case 'tenant-catalog':
      case 'units':
      case 'qr-codes':
        return (
          roles.includes('AdministradorEmpresa') ||
          roles.includes('GestorOperaciones') ||
          roles.includes('GestorVentasPostventa') ||
          roles.includes('Auditor')
        );

      case 'purchases':
        return (
          roles.includes('AdministradorEmpresa') ||
          roles.includes('GestorOperaciones') ||
          roles.includes('GestorVentasPostventa')
        );

      case 'shipments':
        return (
          roles.includes('AdministradorEmpresa') ||
          roles.includes('GestorOperaciones') ||
          roles.includes('Auditor')
        );

      case 'alerts':
        return (
          roles.includes('AdministradorEmpresa') ||
          roles.includes('GestorOperaciones')
        );

      case 'documents':
        return (
          roles.includes('AdministradorEmpresa') ||
          roles.includes('GestorVentasPostventa')
        );

      case 'certificates':
        return (
          roles.includes('AdministradorEmpresa') ||
          roles.includes('GestorOperaciones') ||
          roles.includes('Auditor')
        );

      case 'sales':
      case 'post-sales':
        return roles.includes('AdministradorEmpresa') || roles.includes('GestorVentasPostventa');

      case 'reports':
      case 'quotas':
        return (
          roles.includes('AdministradorEmpresa') ||
          roles.includes('GestorOperaciones') ||
          roles.includes('GestorVentasPostventa') ||
          roles.includes('Auditor')
        );

      case 'billing':
        return roles.includes('AdministradorEmpresa');

      case 'traceability':
        return true;

      default:
        return false;
    }
  }
}
