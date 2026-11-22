import {
  Component,
  Input,
  OnChanges,
  OnInit,
  SimpleChanges,
  computed,
  inject,
  signal
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { AnalyticsService } from '../services/analytics.service';
import {
  AnalyticsDistribucionItem,
  AnalyticsKpi,
  AnalyticsPunto,
  AnalyticsResponse
} from '../../models/analytics.model';

interface AnalyticsTab {
  clave: string;
  etiqueta: string;
}

interface GraficoPunto {
  x: number;
  y: number;
  periodo: string;
  valor: number;
}

interface GraficoRejilla {
  y: number;
  etiqueta: string;
}

interface GraficoEtiquetaX {
  x: number;
  texto: string;
}

interface Grafico {
  linea: string;
  area: string;
  rejillas: GraficoRejilla[];
  etiquetasX: GraficoEtiquetaX[];
  puntos: GraficoPunto[];
  actual: GraficoPunto | null;
}

interface CeldaCadencia {
  periodo: string;
  etiqueta: string;
  titulo: string;
  tieneDatos: boolean;
  esActual: boolean;
}

interface DistribucionBloque {
  clave: string;
  items: AnalyticsDistribucionItem[];
}

interface EntradaNumerica {
  clave: string;
  valor: number;
}

@Component({
  selector: 'app-analytics-panel',
  standalone: true,
  imports: [CommonModule],
  templateUrl: '../../views/pages/analytics-panel.view.html',
  styleUrls: ['../../views/pages/analytics-panel.view.css']
})
export class AnalyticsPanelController implements OnInit, OnChanges {
  @Input() idtenant?: number;
  @Input() compact = false;

  private service = inject(AnalyticsService);
  private inicializado = false;
  private ultimoTenant: number | undefined;

  readonly MESES = 36;
  readonly tabs: readonly AnalyticsTab[] = [
    { clave: 'resumen', etiqueta: 'Resumen' },
    { clave: 'tendencias', etiqueta: 'Tendencias 36 meses' },
    { clave: 'trazabilidad', etiqueta: 'Trazabilidad' },
    { clave: 'comercial', etiqueta: 'Comercial' },
    { clave: 'alertas', etiqueta: 'Alertas' },
    { clave: 'logistica', etiqueta: 'Logística' },
    { clave: 'facturacion', etiqueta: 'Facturación' },
    { clave: 'actividad', etiqueta: 'Actividad' }
  ];

  readonly datos = signal<AnalyticsResponse | null>(null);
  readonly isLoading = signal(false);
  readonly errorMessage = signal<string | null>(null);
  readonly tabActiva = signal('resumen');
  readonly metricaActiva = signal<string | null>(null);

  readonly serieActiva = computed(() => {
    const series = this.datos()?.series ?? [];
    return series.find((s) => s.clave === this.metricaActiva()) ?? series[0] ?? null;
  });

  readonly puntosActivos = computed<AnalyticsPunto[]>(() => this.serieActiva()?.puntos ?? []);

  readonly unidadActiva = computed(() => this.serieActiva()?.unidad ?? '');

  readonly kpisPorClave = computed<Record<string, AnalyticsKpi>>(() => {
    const mapa: Record<string, AnalyticsKpi> = {};
    for (const kpi of this.datos()?.kpis ?? []) {
      mapa[kpi.clave] = kpi;
    }
    return mapa;
  });

  readonly distribuciones = computed<DistribucionBloque[]>(() =>
    Object.entries(this.datos()?.distribuciones ?? {}).map(([clave, items]) => ({
      clave,
      items: items ?? []
    }))
  );

  readonly totales = computed(() => ({
    serie: this.num(this.serieActiva()?.total),
    promedioMensual: this.num(this.serieActiva()?.promediomensual),
    puntos: this.puntosActivos().length,
    kpis: this.datos()?.kpis.length ?? 0,
    series: this.datos()?.series.length ?? 0
  }));

  readonly ultimos12 = computed<AnalyticsPunto[]>(() => this.puntosActivos().slice(-12));

  readonly grafico = computed<Grafico>(() => this.calcularGrafico(this.puntosActivos()));

  readonly cadencia = computed<CeldaCadencia[]>(() => {
    const d = this.datos();
    const puntos = this.puntosActivos();
    const inicio = this.claveMes(d?.periodo?.desde ?? puntos[0]?.periodo);
    const total = Math.min(Math.max(this.num(d?.periodo?.meses) || this.MESES, 1), 60);
    const actual = this.claveMes(d?.periodo?.hasta) ?? this.claveMes(new Date().toISOString());
    const conDatos = new Set(puntos.map((p) => this.claveMes(p.periodo)).filter(Boolean));
    const celdas: CeldaCadencia[] = [];

    for (let i = 0; i < total; i++) {
      const fecha = this.sumarMeses(inicio, i);
      const clave = this.claveMes(fecha) ?? '';
      celdas.push({
        periodo: clave,
        etiqueta: this.etiquetaCorta(clave),
        titulo: clave || 'Sin periodo',
        tieneDatos: conDatos.has(clave),
        esActual: !!actual ? clave === actual : i === total - 1
      });
    }
    return celdas;
  });

  readonly rankingProductos = computed(() => this.datos()?.ranking?.productos ?? []);
  readonly rankingTiposEvento = computed(() => this.datos()?.ranking?.tipos_evento ?? []);

  ngOnInit(): void {
    this.inicializado = true;
    this.ultimoTenant = this.idtenant;
    this.cargar();
  }

  ngOnChanges(changes: SimpleChanges): void {
    const cambio = changes['idtenant'];
    if (!cambio || !this.inicializado) return;
    if (cambio.currentValue !== this.ultimoTenant) {
      this.ultimoTenant = this.idtenant;
      this.cargar();
    }
  }

  recargar(): void {
    this.cargar();
  }

  cambiarTab(clave: string): void {
    if (this.tabs.some((t) => t.clave === clave)) {
      this.tabActiva.set(clave);
    }
  }

  cambiarMetrica(clave: string): void {
    this.metricaActiva.set(clave);
  }

  esTabActiva(clave: string): boolean {
    return this.tabActiva() === clave;
  }

  num(valor: unknown): number {
    if (valor === null || valor === undefined || valor === '') return 0;
    const n = typeof valor === 'number' ? valor : Number(valor);
    return Number.isFinite(n) ? n : 0;
  }

  formatoNumero(valor: unknown, decimales = 0): string {
    if (valor === null || valor === undefined || valor === '') return '—';
    const n = typeof valor === 'number' ? valor : Number(valor);
    if (!Number.isFinite(n)) return '—';
    return n.toLocaleString('es-BO', {
      minimumFractionDigits: decimales,
      maximumFractionDigits: decimales
    });
  }

  formatoMoneda(valor: unknown): string {
    const texto = this.formatoNumero(valor, 2);
    return texto === '—' ? texto : `USD ${texto}`;
  }

  porcentaje(valor: unknown): string {
    const texto = this.formatoNumero(valor, 2);
    return texto === '—' ? texto : `${texto} %`;
  }

  formatoVariacion(valor: number | null | undefined): string {
    if (valor === null || valor === undefined) return '—';
    const n = this.num(valor);
    return `${n > 0 ? '+' : ''}${this.formatoNumero(n, 1)} %`;
  }

  claseVariacion(valor: number | null | undefined): string {
    if (valor === null || valor === undefined || this.num(valor) === 0) return 'delta neutro';
    return this.num(valor) > 0 ? 'delta positivo' : 'delta negativo';
  }

  formatoFecha(valor: string | null | undefined): string {
    if (!valor) return '—';
    // Los periodos del panel son YYYY-MM: mostrarlos tal cual evita el
    // desplazamiento de zona horaria de new Date('YYYY-MM') (UTC -> BO).
    const mensual = /^(\d{4})-(\d{2})$/.exec(valor);
    if (mensual) return valor;
    const fecha = new Date(valor);
    if (!Number.isNaN(fecha.getTime())) {
      return fecha.toLocaleDateString('es-BO', {
        day: '2-digit',
        month: 'short',
        year: 'numeric'
      });
    }
    return valor;
  }

  entradas(documento: Record<string, number> | null | undefined): EntradaNumerica[] {
    return Object.entries(documento ?? {}).map(([clave, valor]) => ({
      clave,
      valor: this.num(valor)
    }));
  }

  titulo(clave: string): string {
    const texto = (clave ?? '').replace(/[_-]+/g, ' ').trim();
    return texto ? texto.charAt(0).toUpperCase() + texto.slice(1) : '—';
  }

  etiquetaEje(periodo: string): string {
    const match = /^(\d{4})-(\d{2})/.exec(periodo ?? '');
    if (!match) return periodo || '—';
    const anio = match[1];
    const mes = Number(match[2]);
    if (mes === 1) return anio;
    if (mes % 3 === 1) return `T${Math.floor((mes - 1) / 3) + 1} ${anio.slice(2)}`;
    return `${match[2]}/${anio.slice(2)}`;
  }

  private cargar(): void {
    this.isLoading.set(true);
    this.errorMessage.set(null);
    this.service.clearError();

    this.service.getAnalytics(this.MESES, this.idtenant).subscribe({
      next: (respuesta) => {
        this.datos.set(respuesta);
        const claves = (respuesta?.series ?? []).map((s) => s.clave);
        if (!this.metricaActiva() || !claves.includes(this.metricaActiva()!)) {
          this.metricaActiva.set(claves[0] ?? null);
        }
      },
      error: (error: unknown) => {
        const e = error as { error?: { detail?: unknown } };
        const detalle = e?.error?.detail;
        const mensaje =
          typeof detalle === 'string'
            ? detalle
            : detalle && typeof detalle === 'object' && 'mensaje' in detalle
              ? String((detalle as { mensaje: unknown }).mensaje)
              : 'No se pudo cargar el panel analítico.';
        this.errorMessage.set(mensaje);
        this.service.errorMessage.set(mensaje);
      },
      complete: () => this.isLoading.set(false)
    });
  }

  private calcularGrafico(puntos: AnalyticsPunto[]): Grafico {
    const vacio: Grafico = {
      linea: '',
      area: '',
      rejillas: [],
      etiquetasX: [],
      puntos: [],
      actual: null
    };
    if (!puntos.length) return vacio;

    const ancho = 720;
    const alto = 230;
    const izquierda = 46;
    const derecha = ancho - 12;
    const arriba = 12;
    const abajo = alto - 30;

    const valores = puntos.map((p) => this.num(p.valor));
    let min = Math.min(...valores);
    let max = Math.max(...valores);
    if (min === max) {
      const margen = Math.max(1, Math.abs(min) * 0.1);
      min -= margen;
      max += margen;
    } else {
      const margen = (max - min) * 0.12;
      min -= margen;
      max += margen;
    }

    const x = (i: number): number =>
      puntos.length === 1
        ? (izquierda + derecha) / 2
        : izquierda + (i * (derecha - izquierda)) / (puntos.length - 1);
    const y = (valor: number): number => abajo - ((valor - min) / (max - min)) * (abajo - arriba);

    const geometricos: GraficoPunto[] = puntos.map((p, i) => ({
      x: x(i),
      y: y(this.num(p.valor)),
      periodo: p.periodo,
      valor: this.num(p.valor)
    }));

    const linea = geometricos
      .map((p, i) => `${i === 0 ? 'M' : 'L'} ${p.x.toFixed(2)} ${p.y.toFixed(2)}`)
      .join(' ');
    const primero = geometricos[0];
    const ultimo = geometricos[geometricos.length - 1];
    const area = `${linea} L ${ultimo.x.toFixed(2)} ${abajo} L ${primero.x.toFixed(2)} ${abajo} Z`;

    const decimales = valores.some((v) => !Number.isInteger(v)) ? 1 : 0;
    const rejillas: GraficoRejilla[] = [0, 0.25, 0.5, 0.75, 1].map((fraccion) => ({
      y: arriba + fraccion * (abajo - arriba),
      etiqueta: this.formatoNumero(max - fraccion * (max - min), decimales)
    }));

    const indices = new Set<number>([0, puntos.length - 1]);
    const paso = Math.max(1, Math.ceil((puntos.length - 1) / 7));
    for (let i = 0; i < puntos.length; i += paso) indices.add(i);
    const etiquetasX = Array.from(indices)
      .sort((a, b) => a - b)
      .map((i) => ({ x: x(i), texto: this.etiquetaEje(puntos[i].periodo) }));

    return { linea, area, rejillas, etiquetasX, puntos: geometricos, actual: ultimo };
  }

  private claveMes(valor: string | Date | null | undefined): string | null {
    if (!valor) return null;
    if (valor instanceof Date) {
      return `${valor.getUTCFullYear()}-${String(valor.getUTCMonth() + 1).padStart(2, '0')}`;
    }
    const match = /^(\d{4})-(\d{2})/.exec(valor);
    return match ? `${match[1]}-${match[2]}` : null;
  }

  private sumarMeses(inicio: string | null, incremento: number): Date | null {
    if (!inicio) return null;
    const [anio, mes] = inicio.split('-').map(Number);
    if (!anio || !mes) return null;
    return new Date(Date.UTC(anio, mes - 1 + incremento, 1));
  }

  private etiquetaCorta(clave: string): string {
    const match = /^(\d{4})-(\d{2})/.exec(clave);
    return match ? `${match[2]}/${match[1].slice(2)}` : '—';
  }
}
