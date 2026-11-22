import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { TenantService } from '../services/tenant.service';
import { AuthService } from '../services/auth.service';
import { BackupService } from '../services/backup.service';
import { Tenant } from '../../models/auth.models';
import { TenantBackup, BackupSchedule } from '../../models/backup.model';

@Component({
  selector: 'app-tenant-management',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  templateUrl: '../../views/pages/tenant-management.view.html',
  styleUrls: ['../../views/pages/tenant-management.view.css']
})
export class TenantManagementController implements OnInit {
  private tenantService = inject(TenantService);
  private authService = inject(AuthService);
  private backupService = inject(BackupService);
  private router = inject(Router);
  private fb = inject(FormBuilder);

  tenants = this.tenantService.tenantsSignal;
  totalTenants = this.tenantService.totalTenantsSignal;
  isLoading = this.tenantService.isLoadingSignal;

  searchQuery = signal<string>('');
  showModal = signal<boolean>(false);
  isEditing = signal<boolean>(false);
  selectedTenantId = signal<number | null>(null);
  errorMessage = signal<string | null>(null);
  successMessage = signal<string | null>(null);

  // Estados para Copias de Seguridad (Backups)
  showBackupModal = signal<boolean>(false);
  activeBackupTab = signal<'history' | 'schedule'>('history');
  selectedBackupTenant = signal<Tenant | null>(null);
  backups = this.backupService.backupsSignal;
  isLoadingBackups = this.backupService.isLoadingSignal;
  isGeneratingBackup = this.backupService.isGeneratingSignal;
  backupFeedback = signal<string | null>(null);

  // Estados para Programación Automática de Copias
  schedules = signal<BackupSchedule[]>([]);
  isLoadingSchedules = signal<boolean>(false);
  isSavingSchedule = signal<boolean>(false);
  scheduleDateTime = signal<string>('');
  scheduleFrequency = signal<string>('UNA_VEZ');
  scheduleFeedback = signal<string | null>(null);

  tenantForm: FormGroup = this.fb.group({
    nombre: ['', [Validators.required, Validators.maxLength(100)]],
    razonsocial: ['', [Validators.required, Validators.maxLength(100)]],
    nit: ['', [Validators.required, Validators.maxLength(50)]],
    email: ['', [Validators.required, Validators.email]],
    telefono: ['', [Validators.maxLength(20)]],
    activo: [true]
  });

  ngOnInit(): void {
    this.loadTenants();
  }

  loadTenants(): void {
    this.tenantService.getTenants(this.searchQuery()).subscribe({
      error: (err) => {
        this.errorMessage.set(err.error?.detail || 'Error al cargar las empresas.');
      }
    });
  }

  onSearchChange(): void {
    this.loadTenants();
  }

  openCreateModal(): void {
    this.isEditing.set(false);
    this.selectedTenantId.set(null);
    this.tenantForm.reset({
      nombre: '',
      razonsocial: '',
      nit: '',
      email: '',
      telefono: '',
      activo: true
    });
    this.errorMessage.set(null);
    this.showModal.set(true);
  }

  openEditModal(tenant: Tenant): void {
    this.isEditing.set(true);
    this.selectedTenantId.set(tenant.idtenant);
    this.tenantForm.patchValue({
      nombre: tenant.nombre,
      razonsocial: tenant.razonsocial,
      nit: tenant.nit,
      email: tenant.email,
      telefono: tenant.telefono || '',
      activo: tenant.activo ?? true
    });
    this.errorMessage.set(null);
    this.showModal.set(true);
  }

  closeModal(): void {
    this.showModal.set(false);
  }

  onSubmit(): void {
    if (this.tenantForm.invalid) {
      this.tenantForm.markAllAsTouched();
      return;
    }

    const formValues = this.tenantForm.value;
    this.errorMessage.set(null);

    if (this.isEditing() && this.selectedTenantId()) {
      this.tenantService.updateTenant(this.selectedTenantId()!, formValues).subscribe({
        next: () => {
          this.successMessage.set('Empresa actualizada correctamente.');
          this.closeModal();
          this.loadTenants();
          setTimeout(() => this.successMessage.set(null), 3000);
        },
        error: (err) => {
          this.errorMessage.set(err.error?.detail || 'Error al actualizar la empresa.');
        }
      });
    } else {
      this.tenantService.createTenant(formValues).subscribe({
        next: () => {
          this.successMessage.set('Empresa registrada correctamente.');
          this.closeModal();
          this.loadTenants();
          setTimeout(() => this.successMessage.set(null), 3000);
        },
        error: (err) => {
          this.errorMessage.set(err.error?.detail || 'Error al registrar la empresa.');
        }
      });
    }
  }

  onDelete(tenant: Tenant): void {
    if (confirm(`¿Estás seguro de desactivar la empresa '${tenant.nombre}'?`)) {
      this.tenantService.deleteTenant(tenant.idtenant).subscribe({
        next: () => {
          this.successMessage.set(`Empresa '${tenant.nombre}' desactivada correctamente.`);
          this.loadTenants();
          setTimeout(() => this.successMessage.set(null), 3000);
        },
        error: (err) => {
          this.errorMessage.set(err.error?.detail || 'Error al desactivar la empresa.');
        }
      });
    }
  }

  switchToTenant(tenant: Tenant): void {
    this.authService.switchTenant(tenant.idtenant).subscribe({
      next: () => {
        this.router.navigate(['/dashboard']).then(() => {
          window.location.reload();
        });
      },
      error: (err) => {
        this.errorMessage.set(err.error?.detail || 'Error al cambiar a esta empresa.');
      }
    });
  }

  navigateToDashboard(): void {
    this.router.navigate(['/dashboard']);
  }

  // --- MÉTODOS DE COPIAS DE SEGURIDAD (SUPERADMIN Y ADMIN) ---
  openBackupModal(tenant: Tenant): void {
    this.selectedBackupTenant.set(tenant);
    this.activeBackupTab.set('history');
    this.backupFeedback.set(null);
    this.scheduleFeedback.set(null);

    // Sugerir fecha y hora por defecto: 15 minutos en el futuro
    const defaultDate = new Date(Date.now() + 15 * 60000);
    const localIso = new Date(defaultDate.getTime() - defaultDate.getTimezoneOffset() * 60000)
      .toISOString()
      .slice(0, 16);
    this.scheduleDateTime.set(localIso);
    this.scheduleFrequency.set('UNA_VEZ');

    this.showBackupModal.set(true);
    this.loadBackups(tenant.idtenant);
    this.loadSchedules(tenant.idtenant);
  }

  closeBackupModal(): void {
    this.showBackupModal.set(false);
    this.selectedBackupTenant.set(null);
    this.backupFeedback.set(null);
    this.scheduleFeedback.set(null);
  }

  switchBackupTab(tab: 'history' | 'schedule'): void {
    this.activeBackupTab.set(tab);
    const tenant = this.selectedBackupTenant();
    if (tenant) {
      if (tab === 'history') {
        this.loadBackups(tenant.idtenant);
      } else {
        this.loadSchedules(tenant.idtenant);
      }
    }
  }

  loadBackups(idtenant: number): void {
    this.backupService.getBackups(idtenant).subscribe({
      error: (err) => {
        this.backupFeedback.set(err.error?.detail || 'Error al obtener las copias de seguridad.');
      }
    });
  }

  loadSchedules(idtenant: number): void {
    this.isLoadingSchedules.set(true);
    this.backupService.getSchedules(idtenant).subscribe({
      next: (res) => {
        this.schedules.set(res.items);
        this.isLoadingSchedules.set(false);
      },
      error: (err) => {
        this.isLoadingSchedules.set(false);
        this.scheduleFeedback.set(err.error?.detail || 'Error al cargar las programaciones.');
      }
    });
  }

  triggerBackup(): void {
    const tenant = this.selectedBackupTenant();
    if (!tenant) return;

    this.backupFeedback.set(null);
    this.backupService.createBackup(tenant.idtenant).subscribe({
      next: (res) => {
        this.backupFeedback.set(`✓ ${res.message}`);
        this.loadBackups(tenant.idtenant);
      },
      error: (err) => {
        this.backupFeedback.set(err.error?.detail || 'Error al generar la copia de seguridad.');
      }
    });
  }

  createSchedule(): void {
    const tenant = this.selectedBackupTenant();
    if (!tenant) return;

    if (!this.scheduleDateTime()) {
      this.scheduleFeedback.set('Debe seleccionar una fecha y hora válida.');
      return;
    }

    this.isSavingSchedule.set(true);
    this.scheduleFeedback.set(null);

    this.backupService.createSchedule(tenant.idtenant, {
      fecha_hora_programada: this.scheduleDateTime(),
      frecuencia: this.scheduleFrequency()
    }).subscribe({
      next: () => {
        this.isSavingSchedule.set(false);
        this.scheduleFeedback.set('✓ Copia de seguridad programada con éxito.');
        this.loadSchedules(tenant.idtenant);
      },
      error: (err) => {
        this.isSavingSchedule.set(false);
        this.scheduleFeedback.set(err.error?.detail || 'Error al guardar la programación.');
      }
    });
  }

  cancelSchedule(schedule: BackupSchedule): void {
    const tenant = this.selectedBackupTenant();
    if (!tenant) return;

    if (!confirm(`¿Está seguro de cancelar la programación automática #${schedule.idschedule}?`)) {
      return;
    }

    this.backupService.cancelSchedule(tenant.idtenant, schedule.idschedule).subscribe({
      next: () => {
        this.scheduleFeedback.set(`Programación #${schedule.idschedule} cancelada.`);
        this.loadSchedules(tenant.idtenant);
      },
      error: (err) => {
        this.scheduleFeedback.set(err.error?.detail || 'Error al cancelar la programación.');
      }
    });
  }

  downloadBackup(backup: TenantBackup): void {
    if (backup.estado !== 'COMPLETADO') return;

    this.backupService.getDownloadUrl(backup.idtenant, backup.idbackup).subscribe({
      next: (res) => {
        this.backupService.downloadBackupFile(res.download_url, res.nombre_archivo);
      },
      error: (err) => {
        this.backupFeedback.set(err.error?.detail || 'Error al generar el enlace de descarga.');
      }
    });
  }

  formatBytes(bytes: number): string {
    if (!bytes || bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  }
}
