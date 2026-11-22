// Modelos del Sprint 4 (CU-025 a CU-031, CU-035, CU-038 a CU-040).
// Los importes Decimal del backend se serializan como string.

export interface VentaUnidad {
  idunidad: number;
  numeroserie: string;
  estado: string;
}

export interface VentaDetalle {
  idventadetalle: number;
  idvariante: number;
  cantidad: number;
  preciounitario: string;
  subtotal: string;
  unidades: VentaUnidad[];
}

export interface Venta {
  idventa: number;
  idtenant: number;
  idcliente: number;
  clientenombre: string | null;
  fechaventa: string;
  total: string;
  estado: string;
  observacion: string | null;
  detalles: VentaDetalle[];
  monto_pagado: string;
  saldo: string;
}

export interface VentaListResponse {
  total: number;
  items: Venta[];
}

export interface CreateVentaDetalle {
  idvariante: number;
  cantidad: number;
  preciounitario: string;
  idunidades?: number[];
}

export interface CreateVentaRequest {
  idcliente: number;
  detalles: CreateVentaDetalle[];
  observacion?: string | null;
}

export interface AssignUnitsRequest {
  idventadetalle: number;
  idunidades: number[];
}

export interface UpdateEstadoRequest {
  estado: string;
}

export interface Pago {
  idpago: number;
  idventa: number;
  metodopago: string;
  monto: string;
  fechapago: string;
  estado: string;
  venta_estado: string;
}

export interface PagoListResponse {
  total: number;
  items: Pago[];
}

export interface CreatePagoRequest {
  idventa: number;
  metodopago: string;
  monto: string;
  estado?: string;
}

export interface CompraConsumidorUnidad {
  idunidad: number;
  numeroserie: string;
  uuidpublico: string;
  estado: string;
}

export interface CompraConsumidor {
  idventa: number;
  fechaventa: string;
  total: string;
  estado: string;
  unidades: CompraConsumidorUnidad[];
}

export interface HistorialConsumidorResponse {
  idcliente: number;
  clientenombre: string;
  totalcompras: number;
  montototal: string;
  items: CompraConsumidor[];
}

export interface DevolucionUnidad {
  iddevolucionunidad: number;
  idunidad: number;
  numeroserie: string;
}

export interface Devolucion {
  iddevolucion: number;
  idventa: number;
  fechadevolucion: string;
  motivo: string;
  descripcion: string | null;
  estado: string;
  unidades: DevolucionUnidad[];
}

export interface DevolucionListResponse {
  total: number;
  items: Devolucion[];
}

export interface CreateDevolucionRequest {
  idventa: number;
  motivo: string;
  descripcion?: string | null;
  idunidades?: number[];
}

export interface Garantia {
  idgarantia: number;
  idunidad: number;
  numeroserie: string;
  fechainicio: string;
  fechafin: string;
  proveedor: string | null;
  condiciones: string | null;
  diasrestantes: number;
  vigente: boolean;
}

export interface GarantiaListResponse {
  total: number;
  items: Garantia[];
}

export interface CreateGarantiaRequest {
  idunidad: number;
  fechainicio: string;
  fechafin: string;
  proveedor?: string | null;
  condiciones?: string | null;
}

export interface ReporteResumen {
  idtenant: number;
  generadoen: string;
  totalunidades: number;
  unidades_por_estado: Record<string, number>;
  totalventas: number;
  ingresos: string;
  totalpagoscompletados: number;
  totalalertas: number;
  alertasabiertas: number;
  totaleventos: number;
  eventosblockchain: number;
  planesusados: string | null;
  consumomes: Record<string, number> | null;
}

export interface SerieTemporalItem {
  periodo: string;
  cantidad: number;
}

export interface ReporteTrazabilidad {
  idtenant: number;
  eventosportipo: Record<string, number>;
  eventosportipo_camion: SerieTemporalItem[];
  alertasporgravedad: Record<string, number>;
  unidades_por_estado: Record<string, number>;
}

export interface DashboardResponse {
  idtenant: number;
  resumen: ReporteResumen;
  ultimoseventos: Array<Record<string, unknown>>;
  alertasrecientes: Array<Record<string, unknown>>;
}

export interface CuotaDetalle {
  permitido: number | null;
  usado: number;
  disponible: number | null;
  excedido: boolean;
}

export interface CuotaResponse {
  idtenant: number;
  periodo: string;
  plan: string;
  estado_suscripcion: string;
  limites: Record<string, CuotaDetalle>;
  actualizadoen: string | null;
}

export interface ConsumirCuotaRequest {
  concepto: string;
  cantidad?: number;
}

export interface FacturaDetalle {
  idfacturadetalle: number;
  concepto: string;
  cantidad: number;
  preciounitario: string;
  subtotal: string;
}

export interface Cobro {
  idcobro: number;
  fechacobro: string;
  monto: string;
  metodopago: string;
  referencia: string | null;
  estado: string;
}

export interface Factura {
  idfactura: number;
  idtenant: number;
  idsuscripcion: number | null;
  numero: string;
  fechaemision: string;
  fechavencimiento: string;
  monto: string;
  moneda: string;
  estado: string;
  saldo: string;
  items: FacturaDetalle[];
  cobros: Cobro[];
}

export interface FacturaListResponse {
  total: number;
  items: Factura[];
}

export interface FacturaItemRequest {
  concepto: string;
  cantidad?: number;
  preciounitario: string;
}

export interface CrearFacturaRequest {
  idsuscripcion?: number | null;
  numero?: string | null;
  fechavencimiento: string;
  moneda?: string;
  items: FacturaItemRequest[];
}

export interface RegistrarCobroRequest {
  monto: string;
  metodopago: string;
  referencia?: string | null;
}

export interface HistorialFacturacionResponse {
  idtenant: number;
  totalfacturado: string;
  totalcobrado: string;
  saldopendiente: string;
  facturas: number;
  cobros: number;
  items: Factura[];
}

export interface NotificacionFacturacion {
  id: string;
  tipo: string;
  titulo: string;
  contenido: string;
  destinatarios: number;
  enlaceaccion: string | null;
  enviadoen: string;
}

export interface NotificacionesFacturacionResponse {
  enviadas: number;
  items: NotificacionFacturacion[];
}

export interface ProcesarNotificacionesRequest {
  diasanticipacion?: number;
  incluirvencidas?: boolean;
}

export interface EnviarNotificacionRequest {
  titulo: string;
  contenido: string;
  enlaceaccion?: string | null;
}
