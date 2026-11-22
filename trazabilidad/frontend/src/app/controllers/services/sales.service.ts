import { Injectable, inject, signal } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import {
  Venta, VentaListResponse, CreateVentaRequest, AssignUnitsRequest, UpdateEstadoRequest,
  Pago, PagoListResponse, CreatePagoRequest, HistorialConsumidorResponse
} from '../../models/sprint4.model';

@Injectable({ providedIn: 'root' })
export class SalesService {
  private http = inject(HttpClient);
  private salesUrl = `${environment.apiUrl}/sales`;
  private paymentsUrl = `${environment.apiUrl}/payments`;
  private consumerUrl = `${environment.apiUrl}/consumer`;

  ventasSignal = signal<Venta[]>([]);
  pagosSignal = signal<Pago[]>([]);
  loadingSignal = signal<boolean>(false);

  getVentas(estado = '', idcliente?: number): Observable<VentaListResponse> {
    this.loadingSignal.set(true);
    let params = new HttpParams();
    if (estado) params = params.set('estado', estado);
    if (idcliente) params = params.set('idcliente', idcliente.toString());
    return this.http.get<VentaListResponse>(this.salesUrl, { params }).pipe(
      tap({ next: r => { this.ventasSignal.set(r.items); this.loadingSignal.set(false); },
            error: () => this.loadingSignal.set(false) })
    );
  }

  getVenta(idventa: number): Observable<Venta> {
    return this.http.get<Venta>(`${this.salesUrl}/${idventa}`);
  }

  createVenta(body: CreateVentaRequest): Observable<Venta> {
    return this.http.post<Venta>(this.salesUrl, body);
  }

  assignUnits(idventa: number, body: AssignUnitsRequest): Observable<Venta> {
    return this.http.post<Venta>(`${this.salesUrl}/${idventa}/units`, body);
  }

  removeUnit(idventa: number, idunidad: number): Observable<Venta> {
    return this.http.delete<Venta>(`${this.salesUrl}/${idventa}/units/${idunidad}`);
  }

  updateVentaEstado(idventa: number, body: UpdateEstadoRequest): Observable<Venta> {
    return this.http.patch<Venta>(`${this.salesUrl}/${idventa}/estado`, body);
  }

  getPagos(estado = '', idventa?: number): Observable<PagoListResponse> {
    this.loadingSignal.set(true);
    let params = new HttpParams();
    if (estado) params = params.set('estado', estado);
    if (idventa) params = params.set('idventa', idventa.toString());
    return this.http.get<PagoListResponse>(this.paymentsUrl, { params }).pipe(
      tap({ next: r => { this.pagosSignal.set(r.items); this.loadingSignal.set(false); },
            error: () => this.loadingSignal.set(false) })
    );
  }

  createPago(body: CreatePagoRequest): Observable<Pago> {
    return this.http.post<Pago>(this.paymentsUrl, body);
  }

  updatePagoEstado(idpago: number, body: UpdateEstadoRequest): Observable<Pago> {
    return this.http.patch<Pago>(`${this.paymentsUrl}/${idpago}/estado`, body);
  }

  getConsumerHistory(idcliente?: number): Observable<HistorialConsumidorResponse> {
    let params = new HttpParams();
    if (idcliente) params = params.set('idcliente', idcliente.toString());
    return this.http.get<HistorialConsumidorResponse>(`${this.consumerUrl}/history`, { params });
  }
}
