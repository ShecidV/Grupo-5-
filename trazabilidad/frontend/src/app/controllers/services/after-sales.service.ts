import { Injectable, inject, signal } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import {
  Devolucion, DevolucionListResponse, CreateDevolucionRequest, UpdateEstadoRequest,
  Garantia, GarantiaListResponse, CreateGarantiaRequest
} from '../../models/sprint4.model';

@Injectable({ providedIn: 'root' })
export class AfterSalesService {
  private http = inject(HttpClient);
  private returnsUrl = `${environment.apiUrl}/returns`;
  private warrantiesUrl = `${environment.apiUrl}/warranties`;

  devolucionesSignal = signal<Devolucion[]>([]);
  garantiasSignal = signal<Garantia[]>([]);
  loadingSignal = signal<boolean>(false);

  getDevoluciones(estado = ''): Observable<DevolucionListResponse> {
    this.loadingSignal.set(true);
    let params = new HttpParams();
    if (estado) params = params.set('estado', estado);
    return this.http.get<DevolucionListResponse>(this.returnsUrl, { params }).pipe(
      tap({ next: r => { this.devolucionesSignal.set(r.items); this.loadingSignal.set(false); },
            error: () => this.loadingSignal.set(false) })
    );
  }

  createDevolucion(body: CreateDevolucionRequest): Observable<Devolucion> {
    return this.http.post<Devolucion>(this.returnsUrl, body);
  }

  updateDevolucionEstado(id: number, body: UpdateEstadoRequest): Observable<Devolucion> {
    return this.http.patch<Devolucion>(`${this.returnsUrl}/${id}/estado`, body);
  }

  assignReturnUnits(id: number, idunidades: number[]): Observable<Devolucion> {
    return this.http.post<Devolucion>(`${this.returnsUrl}/${id}/units`, { idunidades });
  }

  removeReturnUnit(id: number, idunidad: number): Observable<Devolucion> {
    return this.http.delete<Devolucion>(`${this.returnsUrl}/${id}/units/${idunidad}`);
  }

  getGarantias(idunidad?: number): Observable<GarantiaListResponse> {
    this.loadingSignal.set(true);
    let params = new HttpParams();
    if (idunidad) params = params.set('idunidad', idunidad.toString());
    return this.http.get<GarantiaListResponse>(this.warrantiesUrl, { params }).pipe(
      tap({ next: r => { this.garantiasSignal.set(r.items); this.loadingSignal.set(false); },
            error: () => this.loadingSignal.set(false) })
    );
  }

  getWarrantyByUnit(idunidad: number): Observable<Garantia> {
    return this.http.get<Garantia>(`${this.warrantiesUrl}/units/${idunidad}/current`);
  }

  createGarantia(body: CreateGarantiaRequest): Observable<Garantia> {
    return this.http.post<Garantia>(this.warrantiesUrl, body);
  }
}
