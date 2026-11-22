import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { BillingService } from '../services/billing.service';
import { Factura, HistorialFacturacionResponse } from '../../models/sprint4.model';

@Component({
  selector: 'app-billing-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: '../../views/pages/billing-management.view.html',
  styleUrls: ['../../views/pages/sales-management.view.css']
})
export class BillingManagementController implements OnInit {
  private service = inject(BillingService);

  facturas = this.service.facturasSignal;
  notificaciones = this.service.notificacionesSignal;
  isLoading = this.service.loadingSignal;

  activeTab = signal<'facturas' | 'historial' | 'notificaciones'>('facturas');
  historial = signal<HistorialFacturacionResponse | null>(null);
  errorMessage = signal<string | null>(null);
  successMessage = signal<string | null>(null);

  invoiceForm = {
    idsuscripcion: 0 as number | null,
    numero: '',
    fechavencimiento: '',
    moneda: 'USD',
    concepto: 'Suscripción mensual',
    cantidad: 1 as number,
    preciounitario: '99.00'
  };
  chargeTarget = signal<Factura | null>(null);
  chargeForm = { monto: '0.00', metodopago: 'transferencia', referencia: '' };
  processForm = { diasanticipacion: 7, incluirvencidas: true };
  pushForm = { titulo: '', contenido: '', enlaceaccion: '' };

  isInvoiceOpen = signal(false);
  isPushOpen = signal(false);

  ngOnInit(): void { this.loadAll(); }

  loadAll(): void {
    this.service.getInvoices().subscribe({ error: e => this.fail(e) });
    this.service.getNotifications().subscribe({ error: e => this.fail(e) });
    this.service.getBillingHistory().subscribe({
      next: r => this.historial.set(r),
      error: e => this.fail(e)
    });
  }

  setTab(tab: 'facturas' | 'historial' | 'notificaciones'): void { this.activeTab.set(tab); }

  private fail(e: any): void { this.errorMessage.set(e?.error?.detail ?? 'No se pudo completar la operación'); }
  private ok(msg: string): void { this.successMessage.set(msg); this.errorMessage.set(null); }

  onCreateInvoice(): void {
    this.service.createInvoice({
      idsuscripcion: this.invoiceForm.idsuscripcion || null,
      numero: this.invoiceForm.numero || null,
      fechavencimiento: this.invoiceForm.fechavencimiento,
      moneda: this.invoiceForm.moneda,
      items: [{
        concepto: this.invoiceForm.concepto,
        cantidad: Number(this.invoiceForm.cantidad),
        preciounitario: this.invoiceForm.preciounitario
      }]
    }).subscribe({
      next: () => { this.isInvoiceOpen.set(false); this.ok('Factura creada (CU-039)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  openCharge(f: Factura): void {
    this.chargeTarget.set(f);
    this.chargeForm = { monto: f.saldo, metodopago: 'transferencia', referencia: '' };
  }

  onCharge(): void {
    const f = this.chargeTarget();
    if (!f) return;
    this.service.registerCharge(f.idfactura, {
      monto: this.chargeForm.monto,
      metodopago: this.chargeForm.metodopago,
      referencia: this.chargeForm.referencia || null
    }).subscribe({
      next: () => { this.chargeTarget.set(null); this.ok('Cobro registrado (CU-039)'); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  processNotifications(): void {
    this.service.processNotifications({
      diasanticipacion: Number(this.processForm.diasanticipacion),
      incluirvencidas: this.processForm.incluirvencidas
    }).subscribe({
      next: r => { this.ok(`Notificaciones procesadas (CU-040): ${r.enviadas}`); this.loadAll(); },
      error: e => this.fail(e)
    });
  }

  push(): void {
    this.service.pushNotification({
      titulo: this.pushForm.titulo,
      contenido: this.pushForm.contenido,
      enlaceaccion: this.pushForm.enlaceaccion || null
    }).subscribe({
      next: r => { this.isPushOpen.set(false); this.ok(`Push enviado a ${r.destinatarios} destinatario(s) (CU-005)`); },
      error: e => this.fail(e)
    });
  }
}
