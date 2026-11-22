import { Injectable, inject, signal } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, finalize } from 'rxjs';
import { environment } from '../../../environments/environment';
import { AnalyticsResponse } from '../../models/analytics.model';

@Injectable({ providedIn: 'root' })
export class AnalyticsService {
  private http = inject(HttpClient);
  private base = `${environment.apiUrl}/reports/analytics`;

  readonly isLoading = signal(false);
  readonly errorMessage = signal<string | null>(null);

  getAnalytics(meses = 36, idtenant?: number): Observable<AnalyticsResponse> {
    let params = new HttpParams().set('meses', String(meses));
    if (idtenant !== undefined && idtenant !== null && !Number.isNaN(Number(idtenant))) {
      params = params.set('idtenant', String(idtenant));
    }

    this.isLoading.set(true);
    this.errorMessage.set(null);

    return this.http.get<AnalyticsResponse>(this.base, { params }).pipe(
      finalize(() => this.isLoading.set(false))
    );
  }

  clearError(): void {
    this.errorMessage.set(null);
  }
}
