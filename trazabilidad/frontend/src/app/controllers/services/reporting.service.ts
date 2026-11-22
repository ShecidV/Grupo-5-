import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { ReporteResumen, ReporteTrazabilidad, DashboardResponse } from '../../models/sprint4.model';

@Injectable({ providedIn: 'root' })
export class ReportingService {
  private http = inject(HttpClient);
  private base = `${environment.apiUrl}/reports`;

  getSummary(): Observable<ReporteResumen> {
    return this.http.get<ReporteResumen>(`${this.base}/summary`);
  }

  getTraceability(): Observable<ReporteTrazabilidad> {
    return this.http.get<ReporteTrazabilidad>(`${this.base}/traceability`);
  }

  getDashboard(): Observable<DashboardResponse> {
    return this.http.get<DashboardResponse>(`${environment.apiUrl}/dashboard`);
  }

  downloadPdf(): Observable<Blob> {
    return this.http.get(`${this.base}/pdf`, { responseType: 'blob' });
  }
}
