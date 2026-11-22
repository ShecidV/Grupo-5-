import { Injectable, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import {
  TenantBackup,
  TenantBackupListResponse,
  CreateBackupResponse,
  DownloadBackupResponse,
  BackupSchedule,
  CreateBackupScheduleRequest,
  BackupScheduleListResponse
} from '../../models/backup.model';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class BackupService {
  private http = inject(HttpClient);
  private apiUrl = `${environment.apiUrl}/backups`;

  backupsSignal = signal<TenantBackup[]>([]);
  isLoadingSignal = signal<boolean>(false);
  isGeneratingSignal = signal<boolean>(false);

  getBackups(idtenant: number): Observable<TenantBackupListResponse> {
    this.isLoadingSignal.set(true);
    return this.http.get<TenantBackupListResponse>(`${this.apiUrl}/tenants/${idtenant}`).pipe(
      tap((res) => {
        this.backupsSignal.set(res.items);
        this.isLoadingSignal.set(false);
      })
    );
  }

  createBackup(idtenant: number): Observable<CreateBackupResponse> {
    this.isGeneratingSignal.set(true);
    return this.http.post<CreateBackupResponse>(`${this.apiUrl}/tenants/${idtenant}`, {}).pipe(
      tap(() => {
        this.isGeneratingSignal.set(false);
      })
    );
  }

  getDownloadUrl(idtenant: number, idbackup: number): Observable<DownloadBackupResponse> {
    return this.http.get<DownloadBackupResponse>(`${this.apiUrl}/tenants/${idtenant}/${idbackup}/download`);
  }

  downloadBackupFile(downloadPath: string, filename: string): void {
    if (downloadPath.startsWith('http')) {
      const a = document.createElement('a');
      a.href = downloadPath;
      a.download = filename;
      a.target = '_blank';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    } else {
      const fullUrl = downloadPath.startsWith('/api')
        ? `${environment.apiUrl.replace('/api/v1', '')}${downloadPath}`
        : `${this.apiUrl}/${downloadPath}`;

      this.http.get(fullUrl, { responseType: 'blob' }).subscribe({
        next: (blob) => {
          const blobUrl = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = blobUrl;
          a.download = filename;
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
          window.URL.revokeObjectURL(blobUrl);
        },
        error: (err) => {
          console.error('Error al descargar el archivo de backup:', err);
          alert('Error al descargar el archivo de copia de seguridad local.');
        }
      });
    }
  }

  // --- PROGRAMACIÓN AUTOMÁTICA DE COPIAS ---
  getSchedules(idtenant: number): Observable<BackupScheduleListResponse> {
    return this.http.get<BackupScheduleListResponse>(`${this.apiUrl}/tenants/${idtenant}/schedule`);
  }

  createSchedule(idtenant: number, data: CreateBackupScheduleRequest): Observable<BackupSchedule> {
    return this.http.post<BackupSchedule>(`${this.apiUrl}/tenants/${idtenant}/schedule`, data);
  }

  cancelSchedule(idtenant: number, idschedule: number): Observable<{ message: string }> {
    return this.http.delete<{ message: string }>(`${this.apiUrl}/tenants/${idtenant}/schedule/${idschedule}`);
  }
}
