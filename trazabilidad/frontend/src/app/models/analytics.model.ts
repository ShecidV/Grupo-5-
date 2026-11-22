// Modelos del panel analítico consolidado (CU-035).
// Contrato: GET /api/v1/reports/analytics?meses=36&idtenant=2

export interface AnalyticsKpi {
  clave: string;
  etiqueta: string;
  valor: number;
  unidad: string;
  variacion: number | null;
  base: string | null;
}

export interface AnalyticsPunto {
  periodo: string;
  valor: number;
}

export interface AnalyticsSerie {
  clave: string;
  etiqueta: string;
  unidad: string;
  puntos: AnalyticsPunto[];
  total: number;
  promediomensual: number;
}

export interface AnalyticsDistribucionItem {
  clave: string;
  cantidad: number;
  porcentaje: number;
}

export interface AnalyticsRankingItem {
  clave: string;
  cantidad: number;
  monto: number;
}

export interface AnalyticsRanking {
  productos: AnalyticsRankingItem[];
  tipos_evento: AnalyticsRankingItem[];
}

export interface AnalyticsPeriodo {
  desde: string;
  hasta: string;
  meses: number;
}

export interface AnalyticsComparacion {
  etiqueta: string;
  desde: string;
  hasta: string;
  anterior_desde: string;
  anterior_hasta: string;
}

export interface AnalyticsComercial {
  ventas: number;
  ingresos: number;
  pagoscompletados: number;
  ticketpromedio: number;
  devoluciones: number;
  garantiasactivas: number;
}

export interface AnalyticsAlertas {
  total: number;
  abiertas: number;
  criticas: number;
  reportessospecha: number;
  tasaresolucion: number;
  scoremlpromedio: number;
}

export interface AnalyticsLogistica {
  envios: number;
  entregasatiempo: number;
  eventos: number;
  temperatura_promedio: number;
  humedad_promedio: number;
  vibracion_promedio: number;
}

export interface AnalyticsFacturacion {
  facturado: number;
  cobrado: number;
  saldo: number;
  facturas: number;
  cobros: number;
}

export interface AnalyticsActividad {
  bitacora: number;
  notificaciones: number;
  notificaciones_leidas: number;
  consultas_qr: number;
  consultas_por_unidad: number;
  certificados: number;
}

export interface AnalyticsSuscripcion {
  plan: string | null;
  estado: string | null;
  consumomes: Record<string, number> | null;
}

export interface AnalyticsResponse {
  idtenant: number;
  tenantnombre: string;
  generadoen: string;
  moneda: 'USD';
  zonahoraria: string;
  periodo: AnalyticsPeriodo;
  comparacion: AnalyticsComparacion;
  kpis: AnalyticsKpi[];
  series: AnalyticsSerie[];
  distribuciones: Record<string, AnalyticsDistribucionItem[]>;
  ranking: AnalyticsRanking;
  comercial: AnalyticsComercial;
  alertas: AnalyticsAlertas;
  logistica: AnalyticsLogistica;
  facturacion: AnalyticsFacturacion;
  actividad: AnalyticsActividad;
  suscripcion: AnalyticsSuscripcion;
}
