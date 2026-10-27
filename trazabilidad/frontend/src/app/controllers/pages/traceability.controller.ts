import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { TraceService } from '../services/trace.service';
import { CertificateService } from '../services/certificate.service';
import { UnitService } from '../services/unit.service';
import { PublicTraceResponse } from '../../models/trace.model';
import { UnitCertificateResponse } from '../../models/certificate.model';

@Component({
  selector: 'app-traceability',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: '../../views/pages/traceability.view.html',
  styleUrls: ['../../views/pages/traceability.view.css']
})
export class TraceabilityController implements OnInit {
  private traceService = inject(TraceService);
  private certificateService = inject(CertificateService);
  private unitService = inject(UnitService);
  private route = inject(ActivatedRoute);

  units = this.unitService.unitsSignal;

  uuidInput = signal<string>('');
  trace = signal<PublicTraceResponse | null>(null);
  certificate = signal<UnitCertificateResponse | null>(null);
  isLoading = signal<boolean>(false);
  isLoadingCert = signal<boolean>(false);

  errorMessage = signal<string>('');

  ngOnInit(): void {
    const uuidParam = this.route.snapshot.queryParamMap.get('uuid');
    if (uuidParam) {
      this.uuidInput.set(uuidParam);
      this.consultar();
    }

    this.unitService.getUnits('', '', undefined, 0, 10).subscribe({
      next: (res) => {
        if (!this.uuidInput() && res.items.length > 0) {
          const firstWithUuid = res.items.find(u => u.uuidpublico) || res.items[0];
          if (firstWithUuid?.uuidpublico) {
            this.uuidInput.set(firstWithUuid.uuidpublico);
            this.consultar();
          }
        }
      }
    });
  }

  seleccionarUnidad(uuid: string): void {
    this.uuidInput.set(uuid);
    this.consultar();
  }

  consultar(): void {
    const uuid = this.uuidInput().trim();
    if (!uuid) {
      this.errorMessage.set('Ingrese el UUID público de la unidad.');
      return;
    }
    this.errorMessage.set('');
    this.isLoading.set(true);
    this.trace.set(null);
    this.certificate.set(null);
    this.traceService.getTrace(uuid).subscribe({
      next: (res) => {
        this.trace.set(res);
        this.isLoading.set(false);
      },
      error: (err) => {
        this.isLoading.set(false);
        this.errorMessage.set(err?.error?.detail || 'Unidad no encontrada.');
      }
    });
  }

  verCertificado(): void {
    const uuid = this.trace()?.uuidpublico;
    if (!uuid) return;
    this.isLoadingCert.set(true);
    this.certificateService.getPublicCertificate(uuid).subscribe({
      next: (res) => {
        this.certificate.set(res);
        this.isLoadingCert.set(false);
      },
      error: (err) => {
        this.isLoadingCert.set(false);
        this.errorMessage.set(err?.error?.detail || 'No se pudo cargar el certificado.');
      }
    });
  }

  autenticidad(): 'verificado' | 'registrado' | 'sin_datos' {
    const t = this.trace();
    if (!t || t.eventos.length === 0) return 'sin_datos';
    const verificado = t.eventos.some(
      (e) => (e.estadoverificacion || '').toLowerCase().includes('verific')
    );
    return verificado ? 'verificado' : 'registrado';
  }
}
