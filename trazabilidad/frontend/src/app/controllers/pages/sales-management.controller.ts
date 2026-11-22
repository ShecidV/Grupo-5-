import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { SalesService } from '../services/sales.service';
import { ActorService } from '../services/actor.service';
import { Actor } from '../../models/auth.models';
import {
  Venta, VentaDetalle, HistorialConsumidorResponse
} from '../../models/sprint4.model';

@Component({
  selector: 'app-sales-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: '../../views/pages/sales-management.view.html',
  styleUrls: ['../../views/pages/sales-management.view.css']
})
export class SalesManagementController implements OnInit {
  private salesService = inject(SalesService);
  private actorService = inject(ActorService);

  ventas = this.salesService.ventasSignal;
  pagos = this.salesService.pagosSignal;
  isLoading = this.salesService.loadingSignal;

  activeTab = signal<'ventas' | 'pagos' | 'historial'>('ventas');
  clientes = signal<Actor[]>([]);
  historial = signal<HistorialConsumidorResponse | null>(null);
  errorMessage = signal<string | null>(null);
  successMessage = signal<string | null>(null);

  filtroEstado = '';
  filtroIdCliente: number | null = null;
  histIdCliente: number | null = null;

  createForm = {
    idcliente: 0 as number,
    idvariante: 0 as number,
    cantidad: 1 as number,
    preciounitario: '0.00',
    observacion: ''
  };
  unidadesCsv = '';
  isCreateOpen = signal(false);

  assignVenta = signal<Venta | null>(null);
  assignDetalle = signal<VentaDetalle | null>(null);
  assignCsv = '';

  pagoForm = {
    idventa: 0 as number,
    metodopago: 'efectivo',
    monto: '0.00',
    estado: 'completado'
  };
  isPagoOpen = signal(false);

  readonly estadosVenta = ['pendiente', 'pagada', 'enviada', 'entregada', 'cancelada', 'devuelta'];
  readonly metodosPago = ['efectivo', 'tarjeta_credito', 'tarjeta_debito', 'transferencia', 'criptomoneda'];

  ngOnInit(): void {
    this.loadAll();
    this.actorService.getActors('', '', 0, 200).subscribe({
      next: r => this.clientes.set(r.items),
      error: () => this.clientes.set([])
    });
  }

  loadAll(): void {
    this.salesService.getVentas(this.filtroEstado, this.filtroIdCliente ?? undefined).subscribe({
      error: e => this.fail(e)
    });
    this.salesService.getPagos().subscribe({ error: e => this.fail(e) });
  }

  setTab(tab: 'ventas' | 'pagos' | 'historial'): void {
    this.activeTab.set(tab);
    if (tab === 'historial') this.loadHistorial();
  }

  private fail(e: any): void {
    this.errorMessage.set(e?.error?.detail ?? 'No se pudo completar la operación');
  }

  private ok(msg: string): void {
    this.successMessage.set(msg);
    this.errorMessage.set(null);
  }

  openCreate(): void {
    this.createForm = { idcliente: this.clientes()[0]?.idactor ?? 0, idvariante: 0, cantidad: 1, preciounitario: '0.00', observacion: '' };
    this.unidadesCsv = '';
    this.isCreateOpen.set(true);
  }

  onCreate(): void {
    const ids = this.parseIds(this.unidadesCsv);
    this.salesService.createVenta({
      idcliente: Number(this.createForm.idcliente),
      detalles: [{
        idvariante: Number(this.createForm.idvariante),
        cantidad: Number(this.createForm.cantidad),
        preciounitario: String(this.createForm.preciounitario),
        idunidades: ids
      }],
      observacion: this.createForm.observacion || null
    }).subscribe({
      next: () => { this.isCreateOpen.set(false); this.ok('Venta registrada (CU-025/CU-026)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  openAssign(venta: Venta, detalle: VentaDetalle): void {
    this.assignVenta.set(venta);
    this.assignDetalle.set(detalle);
    this.assignCsv = detalle.unidades.map(u => u.idunidad).join(', ');
  }

  onAssign(): void {
    const venta = this.assignVenta();
    const detalle = this.assignDetalle();
    if (!venta || !detalle) return;
    this.salesService.assignUnits(venta.idventa, {
      idventadetalle: detalle.idventadetalle,
      idunidades: this.parseIds(this.assignCsv)
    }).subscribe({
      next: () => { this.assignVenta.set(null); this.ok('Unidades asignadas (CU-026)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  onRemoveUnit(venta: Venta, idunidad: number): void {
    this.salesService.removeUnit(venta.idventa, idunidad).subscribe({
      next: () => { this.ok('Unidad liberada (CU-026)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  onVentaEstado(venta: Venta, estado: string): void {
    this.salesService.updateVentaEstado(venta.idventa, { estado }).subscribe({
      next: () => { this.ok('Estado de venta actualizado'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  openPago(): void {
    this.pagoForm = { idventa: this.ventas()[0]?.idventa ?? 0, metodopago: 'efectivo', monto: '0.00', estado: 'completado' };
    this.isPagoOpen.set(true);
  }

  onCreatePago(): void {
    this.salesService.createPago({
      idventa: Number(this.pagoForm.idventa),
      metodopago: this.pagoForm.metodopago,
      monto: String(this.pagoForm.monto),
      estado: this.pagoForm.estado
    }).subscribe({
      next: () => { this.isPagoOpen.set(false); this.ok('Pago registrado (CU-027)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  onPagoEstado(idpago: number, estado: string): void {
    this.salesService.updatePagoEstado(idpago, { estado }).subscribe({
      next: () => { this.ok('Estado de pago actualizado'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  loadHistorial(): void {
    this.salesService.getConsumerHistory(this.histIdCliente ?? undefined).subscribe({
      next: r => this.historial.set(r),
      error: e => this.fail(e)
    });
  }

  private parseIds(csv: string): number[] {
    return csv.split(',').map(s => Number(s.trim())).filter(n => Number.isInteger(n) && n > 0);
  }
}
