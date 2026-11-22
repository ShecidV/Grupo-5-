import { Injectable, inject, signal } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import {
  Factura, FacturaListResponse, CrearFacturaRequest, RegistrarCobroRequest,
  HistorialFacturacionResponse, NotificacionesFacturacionResponse,
  ProcesarNotificacionesRequest, EnviarNotificacionRequest
} from '../../models/sprint4.model';

@Injectable({ providedIn: 'root' })
export class BillingService {
  private http = inject(HttpClient);
  private invoicesUrl = `${environment.apiUrl}/invoices`;
  private billingUrl = `${environment.apiUrl}/billing`;

  facturasSignal = signal<Factura[]>([]);
  notificacionesSignal = signal<NotificacionesFacturacionResponse | null>(null);
  loadingSignal = signal<boolean>(false);

  getInvoices(estado = ''): Observable<FacturaListResponse> {
    this.loadingSignal.set(true);
    let params = new HttpParams();
    if (estado) params = params.set('estado', estado);
    return this.http.get<FacturaListResponse>(this.invoicesUrl, { params }).pipe(
      tap({ next: r => { this.facturasSignal.set(r.items); this.loadingSignal.set(false); },
            error: () => this.loadingSignal.set(false) })
    );
  }

  getInvoice(id: number): Observable<Factura> {
    return this.http.get<Factura>(`${this.invoicesUrl}/${id}`);
  }

  createInvoice(body: CrearFacturaRequest): Observable<Factura> {
    return this.http.post<Factura>(this.invoicesUrl, body);
  }

  registerCharge(id: number, body: RegistrarCobroRequest): Observable<Factura> {
    return this.http.post<Factura>(`${this.invoicesUrl}/${id}/charges`, body);
  }

  getBillingHistory(): Observable<HistorialFacturacionResponse> {
    return this.http.get<HistorialFacturacionResponse>(`${this.billingUrl}/history`);
  }

  getNotifications(): Observable<NotificacionesFacturacionResponse> {
    this.loadingSignal.set(true);
    return this.http.get<NotificacionesFacturacionResponse>(`${this.billingUrl}/notifications`).pipe(
      tap({ next: r => { this.notificacionesSignal.set(r); this.loadingSignal.set(false); },
            error: () => this.loadingSignal.set(false) })
    );
  }

  processNotifications(body: ProcesarNotificacionesRequest): Observable<NotificacionesFacturacionResponse> {
    return this.http.post<NotificacionesFacturacionResponse>(`${this.billingUrl}/notifications/process`, body).pipe(
      tap(r => this.notificacionesSignal.set(r))
    );
  }

  pushNotification(body: EnviarNotificacionRequest): Observable<{ destinatarios: number }> {
    return this.http.post<{ destinatarios: number }>(`${environment.apiUrl}/notifications/push`, body);
  }
}
