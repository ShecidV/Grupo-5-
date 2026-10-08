import { Injectable, signal, inject } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { UnitQrItem, GenerateQRResult, BulkQRResponse } from '../../models/qr.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class QrService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/qr`;

  unitsSignal = signal<UnitQrItem[]>([]);
  loadingSignal = signal<boolean>(false);

  getUnits(tieneQr?: boolean, search: string = '', skip: number = 0, limit: number = 50): Observable<UnitQrItem[]> {
    this.loadingSignal.set(true);
    let params = new HttpParams()
      .set('skip', skip.toString())
      .set('limit', limit.toString());

    if (tieneQr !== undefined && tieneQr !== null) {
      params = params.set('tiene_qr', tieneQr.toString());
    }
    if (search) {
      params = params.set('search', search);
    }

    return this.http.get<UnitQrItem[]>(`${this.apiUrl}/units`, { params }).pipe(
      tap({
        next: (res) => {
          this.unitsSignal.set(res);
          this.loadingSignal.set(false);
        },
        error: () => this.loadingSignal.set(false)
      })
    );
  }

  generateQr(idunidad: number): Observable<GenerateQRResult> {
    return this.http.post<GenerateQRResult>(`${this.apiUrl}/generate/${idunidad}`, {});
  }

  downloadQrBlob(idunidad: number): Observable<Blob> {
    return this.http.get(`${this.apiUrl}/${idunidad}/image?download=true`, {
      responseType: 'blob'
    });
  }

  generateBulk(idunidades: number[]): Observable<BulkQRResponse> {
    return this.http.post<BulkQRResponse>(`${this.apiUrl}/generate-bulk`, { idunidades });
  }
}
