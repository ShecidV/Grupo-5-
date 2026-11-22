import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { AfterSalesService } from '../services/after-sales.service';
import { Devolucion, Garantia } from '../../models/sprint4.model';

@Component({
  selector: 'app-after-sales-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: '../../views/pages/after-sales-management.view.html',
  styleUrls: ['../../views/pages/sales-management.view.css']
})
export class AfterSalesManagementController implements OnInit {
  private service = inject(AfterSalesService);

  devoluciones = this.service.devolucionesSignal;
  garantias = this.service.garantiasSignal;
  isLoading = this.service.loadingSignal;

  activeTab = signal<'devoluciones' | 'garantias'>('devoluciones');
  errorMessage = signal<string | null>(null);
  successMessage = signal<string | null>(null);

  filtroEstadoDev = '';
  filtroIdUnidad: number | null = null;
  garantiaUnidad: Garantia | null = null;

  returnForm = { idventa: 0 as number, motivo: 'defecto_fabrica', descripcion: '', unidadesCsv: '' };
  warrantyForm = { idunidad: 0 as number, fechainicio: '', fechafin: '', proveedor: 'Apple', condiciones: '' };
  isReturnOpen = signal(false);
  isWarrantyOpen = signal(false);
  assignReturn = signal<Devolucion | null>(null);
  assignCsv = '';

  readonly motivos = ['defecto_fabrica', 'daño_transporte', 'producto_incorrecto', 'insatisfaccion_cliente', 'garantia'];
  readonly estadosDev = ['solicitada', 'aprobada', 'rechazada', 'procesada'];

  ngOnInit(): void { this.loadAll(); }

  loadAll(): void {
    this.service.getDevoluciones(this.filtroEstadoDev).subscribe({ error: e => this.fail(e) });
    this.service.getGarantias(this.filtroIdUnidad ?? undefined).subscribe({ error: e => this.fail(e) });
  }

  setTab(tab: 'devoluciones' | 'garantias'): void { this.activeTab.set(tab); }

  private fail(e: any): void { this.errorMessage.set(e?.error?.detail ?? 'No se pudo completar la operación'); }
  private ok(msg: string): void { this.successMessage.set(msg); this.errorMessage.set(null); }

  onCreateReturn(): void {
    this.service.createDevolucion({
      idventa: Number(this.returnForm.idventa),
      motivo: this.returnForm.motivo,
      descripcion: this.returnForm.descripcion || null,
      idunidades: this.parseIds(this.returnForm.unidadesCsv)
    }).subscribe({
      next: () => { this.isReturnOpen.set(false); this.ok('Devolución solicitada (CU-029)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  onEstado(id: number, estado: string): void {
    this.service.updateDevolucionEstado(id, { estado }).subscribe({
      next: () => { this.ok('Estado de devolución actualizado'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  openAssign(d: Devolucion): void {
    this.assignReturn.set(d);
    this.assignCsv = d.unidades.map(u => u.idunidad).join(', ');
  }

  onAssign(): void {
    const d = this.assignReturn();
    if (!d) return;
    this.service.assignReturnUnits(d.iddevolucion, this.parseIds(this.assignCsv)).subscribe({
      next: () => { this.assignReturn.set(null); this.ok('Unidades asignadas a la devolución (CU-030)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  onRemoveUnit(iddevolucion: number, idunidad: number): void {
    this.service.removeReturnUnit(iddevolucion, idunidad).subscribe({
      next: () => { this.ok('Unidad eliminada de la devolución'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  onCreateWarranty(): void {
    this.service.createGarantia({
      idunidad: Number(this.warrantyForm.idunidad),
      fechainicio: this.warrantyForm.fechainicio,
      fechafin: this.warrantyForm.fechafin,
      proveedor: this.warrantyForm.proveedor || null,
      condiciones: this.warrantyForm.condiciones || null
    }).subscribe({
      next: () => { this.isWarrantyOpen.set(false); this.ok('Garantía registrada (CU-031)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  findWarranty(): void {
    if (!this.warrantyForm.idunidad) return;
    this.service.getWarrantyByUnit(Number(this.warrantyForm.idunidad)).subscribe({
      next: w => this.garantiaUnidad = w,
      error: e => { this.garantiaUnidad = null; this.fail(e); }
    });
  }

  private parseIds(csv: string): number[] {
    return csv.split(',').map(s => Number(s.trim())).filter(n => Number.isInteger(n) && n > 0);
  }
}
