import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ReportingService } from '../services/reporting.service';
import { ReporteResumen, ReporteTrazabilidad, DashboardResponse } from '../../models/sprint4.model';
import { AnalyticsPanelController } from './analytics-panel.controller';

@Component({
  selector: 'app-reporting',
  standalone: true,
  imports: [CommonModule, RouterLink, AnalyticsPanelController],
  templateUrl: '../../views/pages/reporting.view.html',
  styleUrls: ['../../views/pages/sales-management.view.css']
})
export class ReportingController implements OnInit {
  private service = inject(ReportingService);

  resumen = signal<ReporteResumen | null>(null);
  trazabilidad = signal<ReporteTrazabilidad | null>(null);
  dashboard = signal<DashboardResponse | null>(null);
  isLoading = signal(false);
  errorMessage = signal<string | null>(null);
  successMessage = signal<string | null>(null);

  ngOnInit(): void { this.loadAll(); }

  loadAll(): void {
    this.isLoading.set(true);
    this.service.getSummary().subscribe({
      next: r => this.resumen.set(r),
      error: e => this.fail(e)
    });
    this.service.getTraceability().subscribe({
      next: r => this.trazabilidad.set(r),
      error: e => this.fail(e)
    });
    this.service.getDashboard().subscribe({
      next: r => { this.dashboard.set(r); this.isLoading.set(false); },
      error: e => { this.fail(e); this.isLoading.set(false); }
    });
  }

  downloadPdf(): void {
    this.service.downloadPdf().subscribe({
      next: blob => {
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'reporte-trazabilidad.pdf';
        a.click();
        URL.revokeObjectURL(url);
        this.successMessage.set('Reporte PDF descargado (CU-035)');
      },
      error: e => this.fail(e)
    });
  }

  entries(obj: Record<string, number> | null | undefined): Array<{ key: string; value: number }> {
    if (!obj) return [];
    return Object.entries(obj).map(([key, value]) => ({ key, value }));
  }

  private fail(e: any): void {
    this.errorMessage.set(e?.error?.detail ?? 'No se pudo cargar el reporte');
  }
}
