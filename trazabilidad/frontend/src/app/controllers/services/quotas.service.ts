import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { environment } from '../../../environments/environment';
import { CuotaResponse, ConsumirCuotaRequest } from '../../models/sprint4.model';

@Injectable({ providedIn: 'root' })
export class QuotasService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/quotas`;

  cuotasSignal = signal<CuotaResponse | null>(null);
  loadingSignal = signal<boolean>(false);

  getQuotas(): Observable<CuotaResponse> {
    this.loadingSignal.set(true);
    return this.http.get<CuotaResponse>(this.apiUrl).pipe(
      tap({ next: r => { this.cuotasSignal.set(r); this.loadingSignal.set(false); },
            error: () => this.loadingSignal.set(false) })
    );
  }

  consume(body: ConsumirCuotaRequest): Observable<CuotaResponse> {
    return this.http.post<CuotaResponse>(`${this.apiUrl}/consume`, body).pipe(
      tap(r => this.cuotasSignal.set(r))
    );
  }
}
