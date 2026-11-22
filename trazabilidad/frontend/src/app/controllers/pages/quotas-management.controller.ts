import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { QuotasService } from '../services/quotas.service';
import { CuotaDetalle } from '../../models/sprint4.model';

@Component({
  selector: 'app-quotas-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: '../../views/pages/quotas-management.view.html',
  styleUrls: ['../../views/pages/sales-management.view.css']
})
export class QuotasManagementController implements OnInit {
  private service = inject(QuotasService);

  cuotas = this.service.cuotasSignal;
  isLoading = this.service.loadingSignal;
  errorMessage = signal<string | null>(null);
  successMessage = signal<string | null>(null);

  concepto = 'reportesgenerados';
  cantidad = 1;
  readonly conceptos = ['reportesgenerados', 'unidadesregistradas', 'usuariosactivos'];

  ngOnInit(): void { this.load(); }

  load(): void {
    this.service.getQuotas().subscribe({ error: e => this.fail(e) });
  }

  consume(): void {
    this.service.consume({ concepto: this.concepto, cantidad: Number(this.cantidad) }).subscribe({
      next: () => this.successMessage.set(`Cuota consumida: ${this.concepto} (CU-038)`),
      error: e => this.fail(e)
    });
  }

  entries(limites: Record<string, CuotaDetalle> | null | undefined): Array<{ key: string; value: CuotaDetalle }> {
    if (!limites) return [];
    return Object.entries(limites).map(([key, value]) => ({ key, value }));
  }

  private fail(e: any): void {
    this.errorMessage.set(e?.status === 429 ? 'Límite de plan excedido (429)' : (e?.error?.detail ?? 'No se pudo cargar la cuota'));
  }
}
