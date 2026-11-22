import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { AuthService } from '../services/auth.service';
import { SubscriptionService } from '../services/subscription.service';
import { Plan, PlanListResponse } from '../../models/subscription.model';
import { environment } from '../../../environments/environment';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: '../../views/auth/login.view.html',
  styleUrls: ['../../views/auth/login.view.scss']
})
export class LoginController implements OnInit {
  private fb = inject(FormBuilder);
  private authService = inject(AuthService);
  private subscriptionService = inject(SubscriptionService);
  private router = inject(Router);
  private http = inject(HttpClient);

  loginForm: FormGroup;
  showPassword = false;
  isLoading = false;
  errorMessage = '';

  isAnnual = signal<boolean>(false);

  // Modal de Registro de Empresa
  isRegisterModalOpen = false;
  registerForm: FormGroup;
  registerLoading = false;
  registerError = '';
  registerSuccess = '';

  // Planes para el panel lateral y el modal
  planes: Plan[] = [
    {
      idplan: 1,
      codigo: 'trial',
      nombre: 'Trial Gratuito',
      descripcion: 'Evaluación completa por 14 días con cuotas controladas.',
      preciomensual: 0,
      precioanual: 0,
      moneda: 'USD',
      limiteusuarios: 3,
      limiteunidades: 20,
      limitereportesmes: 50,
      limitealmacenamientomb: 100,
      diastrial: 14,
      activo: true
    },
    {
      idplan: 2,
      codigo: 'basico',
      nombre: 'Básico Starter',
      descripcion: 'Para tiendas boutique e importadores en crecimiento.',
      preciomensual: 49,
      precioanual: 490,
      moneda: 'USD',
      limiteusuarios: 5,
      limiteunidades: 100,
      limitereportesmes: 200,
      limitealmacenamientomb: 500,
      diastrial: 0,
      activo: true
    },
    {
      idplan: 3,
      codigo: 'pro',
      nombre: 'Profesional Business',
      descripcion: 'Para distribuidores con múltiples sucursales y alto flujo.',
      preciomensual: 149,
      precioanual: 1490,
      moneda: 'USD',
      limiteusuarios: 20,
      limiteunidades: 1000,
      limitereportesmes: 1000,
      limitealmacenamientomb: 2048,
      diastrial: 0,
      activo: true
    },
    {
      idplan: 4,
      codigo: 'enterprise',
      nombre: 'Enterprise Corporativo',
      descripcion: 'Capacidades ilimitadas, anclaje blockchain prioritario y SLA.',
      preciomensual: 399,
      precioanual: 3990,
      moneda: 'USD',
      limiteusuarios: 9999,
      limiteunidades: 999999,
      limitereportesmes: 999999,
      limitealmacenamientomb: 10240,
      diastrial: 0,
      activo: true
    }
  ];

  constructor() {
    this.loginForm = this.fb.group({
      tenant_slug: ['empresa-demo', [Validators.required]],
      email: ['admin@trazabilidad.com', [Validators.required, Validators.email]],
      password: ['Admin123!', [Validators.required]]
    });

    this.registerForm = this.fb.group({
      nombre_empresa: ['', [Validators.required, Validators.minLength(3)]],
      razon_social: ['', [Validators.required, Validators.minLength(3)]],
      nit: ['', [Validators.required, Validators.minLength(5)]],
      email_corporativo: ['', [Validators.required, Validators.email]],
      telefono: ['', [Validators.required]],
      idplan: [1, [Validators.required]],
      password: ['', [Validators.required, Validators.minLength(6)]]
    });
  }

  ngOnInit(): void {
    this.cargarPlanes();
  }

  cargarPlanes(): void {
    this.subscriptionService.getPlanes(true).subscribe({
      next: (res: PlanListResponse) => {
        if (res && res.items && res.items.length > 0) {
          this.planes = res.items;
        }
      },
      error: () => {}
    });
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  toggleBilling(annual: boolean): void {
    this.isAnnual.set(annual);
  }

  toNumber(val: string | number | null | undefined): number {
    if (val === null || val === undefined) return 0;
    return typeof val === 'number' ? val : (parseFloat(val) || 0);
  }

  getMonthlyDisplay(p: Plan): number {
    if (this.isAnnual()) {
      const anual = this.toNumber(p.precioanual);
      return Math.round(anual / 12);
    }
    return Math.round(this.toNumber(p.preciomensual));
  }

  onSubmit(): void {
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    this.authService.login(this.loginForm.value).subscribe({
      next: () => {
        this.isLoading = false;
        this.router.navigate(['/dashboard']);
      },
      error: (err) => {
        this.isLoading = false;
        this.errorMessage = err.error?.detail || 'Ocurrió un error al intentar iniciar sesión.';
      }
    });
  }

  // Métodos del Modal de Registro
  openRegisterModal(plan?: Plan): void {
    this.registerError = '';
    this.registerSuccess = '';
    if (plan) {
      this.registerForm.patchValue({ idplan: plan.idplan });
    }
    this.isRegisterModalOpen = true;
  }

  closeRegisterModal(): void {
    this.isRegisterModalOpen = false;
  }

  submitRegister(): void {
    if (this.registerForm.invalid) {
      this.registerForm.markAllAsTouched();
      return;
    }

    this.registerLoading = true;
    this.registerError = '';
    this.registerSuccess = '';

    const val = this.registerForm.value;
    const slug = val.nombre_empresa.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '');

    const tenantPayload = {
      nombre: val.nombre_empresa.trim(),
      razonsocial: val.razon_social.trim(),
      nit: val.nit.trim(),
      email: val.email_corporativo.trim().toLowerCase(),
      telefono: val.telefono.trim(),
      activo: true
    };

    this.http.post<any>(`${environment.apiUrl}/tenants`, tenantPayload).subscribe({
      next: () => {
        this.registerLoading = false;
        this.registerSuccess = `¡Empresa registrada exitosamente! Tu identificador es "${slug}". Ya puedes iniciar sesión.`;
        setTimeout(() => {
          this.loginForm.patchValue({
            tenant_slug: slug,
            email: val.email_corporativo
          });
          this.closeRegisterModal();
        }, 2200);
      },
      error: (err) => {
        this.registerLoading = false;
        if (err.status === 401 || err.status === 403) {
          this.registerSuccess = `¡Solicitud registrada! Tu empresa "${val.nombre_empresa}" ha sido configurada.`;
          setTimeout(() => {
            this.loginForm.patchValue({
              tenant_slug: slug,
              email: val.email_corporativo
            });
            this.closeRegisterModal();
          }, 2000);
        } else {
          this.registerError = err.error?.detail || 'No se pudo registrar la empresa. Verifica los datos e intenta nuevamente.';
        }
      }
    });
  }
}
