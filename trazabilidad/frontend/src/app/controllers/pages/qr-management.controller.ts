import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { QrService } from '../services/qr.service';
import { UnitQrItem } from '../../models/qr.model';

@Component({
  selector: 'app-qr-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: '../../views/pages/qr-management.view.html',
  styleUrls: ['../../views/pages/qr-management.view.css']
})
export class QrManagementController implements OnInit {
  private qrService = inject(QrService);

  units = this.qrService.unitsSignal;
  isLoading = this.qrService.loadingSignal;

  searchQuery = signal<string>('');
  selectedQrFilter = signal<string>(''); // '', 'true', 'false'

  selectedUnit = signal<UnitQrItem | null>(null);
  isPreviewModalOpen = signal<boolean>(false);
  previewQrImageUrl = signal<string | null>(null);
  isLoadingPreview = signal<boolean>(false);

  selectedUnitIds = signal<number[]>([]);

  errorMessage = signal<string>('');
  successMessage = signal<string>('');

  ngOnInit(): void {
    this.loadUnits();
  }

  loadUnits(): void {
    this.errorMessage.set('');
    let filterBool: boolean | undefined = undefined;
    if (this.selectedQrFilter() === 'true') filterBool = true;
    if (this.selectedQrFilter() === 'false') filterBool = false;

    this.qrService.getUnits(filterBool, this.searchQuery()).subscribe({
      error: (err) => this.errorMessage.set(err.error?.detail || 'Error al cargar unidades.')
    });
  }

  onSearch(): void {
    this.loadUnits();
  }

  openPreview(unit: UnitQrItem): void {
    this.selectedUnit.set(unit);
    this.isPreviewModalOpen.set(true);
    this.isLoadingPreview.set(true);

    if (this.previewQrImageUrl() && this.previewQrImageUrl()?.startsWith('blob:')) {
      URL.revokeObjectURL(this.previewQrImageUrl()!);
      this.previewQrImageUrl.set(null);
    }

    this.qrService.downloadQrBlob(unit.idunidad).subscribe({
      next: (blob) => {
        const objectUrl = URL.createObjectURL(blob);
        this.previewQrImageUrl.set(objectUrl);
        this.isLoadingPreview.set(false);
      },
      error: () => {
        this.errorMessage.set('No se pudo cargar la imagen del QR.');
        this.isLoadingPreview.set(false);
      }
    });
  }

  closePreview(): void {
    if (this.previewQrImageUrl() && this.previewQrImageUrl()?.startsWith('blob:')) {
      URL.revokeObjectURL(this.previewQrImageUrl()!);
    }
    this.previewQrImageUrl.set(null);
    this.isPreviewModalOpen.set(false);
  }

  generateQr(unit: UnitQrItem): void {
    this.errorMessage.set('');
    this.qrService.generateQr(unit.idunidad).subscribe({
      next: (res) => {
        this.successMessage.set(res.message);
        this.loadUnits();
        this.openPreview({
          ...unit,
          tiene_qr: true,
          idcodigoqr: res.idcodigoqr,
          tokenpublico: res.tokenpublico,
          url: res.url,
          fechageneracion: res.fechageneracion
        });
        setTimeout(() => this.successMessage.set(''), 5000);
      },
      error: (err) => this.errorMessage.set(err.error?.detail || 'Error al generar código QR.')
    });
  }

  downloadQr(unit: UnitQrItem): void {
    this.qrService.downloadQrBlob(unit.idunidad).subscribe({
      next: (blob) => {
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `QR_${unit.numeroserie}.png`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
      },
      error: (err) => this.errorMessage.set('Error al descargar la imagen del QR.')
    });
  }

  printLabel(): void {
    window.print();
  }

  toggleSelectAll(event: any): void {
    if (event.target.checked) {
      this.selectedUnitIds.set(this.units().map(u => u.idunidad));
    } else {
      this.selectedUnitIds.set([]);
    }
  }

  toggleSelectUnit(id: number): void {
    const current = [...this.selectedUnitIds()];
    const index = current.indexOf(id);
    if (index >= 0) {
      current.splice(index, 1);
    } else {
      current.push(id);
    }
    this.selectedUnitIds.set(current);
  }

  isUnitSelected(id: number): boolean {
    return this.selectedUnitIds().includes(id);
  }

  generateBulk(): void {
    const ids = this.selectedUnitIds();
    if (ids.length === 0) {
      this.errorMessage.set('Seleccione al menos una unidad para generar códigos en lote.');
      return;
    }

    this.errorMessage.set('');
    this.qrService.generateBulk(ids).subscribe({
      next: (res) => {
        this.successMessage.set(`Se generaron exitosamente ${res.total_generados} códigos QR.`);
        this.selectedUnitIds.set([]);
        this.loadUnits();
        setTimeout(() => this.successMessage.set(''), 5000);
      },
      error: (err) => this.errorMessage.set(err.error?.detail || 'Error en la generación en lote.')
    });
  }
}
