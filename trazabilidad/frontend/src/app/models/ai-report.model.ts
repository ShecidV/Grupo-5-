export interface KPIItem {
  label: string;
  value: string;
  trend?: string;
  color?: string;
}

export interface ChartData {
  chart_type: string;
  title: string;
  labels: string[];
  datasets: Array<{
    data: number[];
    backgroundColor?: string[];
    label?: string;
  }>;
}

export interface VoiceReportResponse {
  report_id: string;
  query_interpreted: string;
  category: string;
  voice_summary: string;
  executive_summary: string;
  kpis: KPIItem[];
  chart: ChartData;
  table_headers: string[];
  table_rows: any[][];
  period_label?: string;
  interpretation?: string;
  filters_applied?: Record<string, unknown>;
  suggested_followups?: string[];
  product_detail?: {
    producto: string;
    tenant_name: string;
    period_label: string;
    desde: string;
    hasta: string;
    kpis: Array<{ label: string; value: string; trend?: string; color?: string }>;
    metrics: Record<string, number | string>;
    monthly_trend: Array<{ mes: string; unidades: number }>;
    table_headers: string[];
    table_rows: any[][];
  } | null;
  generated_at: string;
  pdf_download_url: string;
  excel_download_url: string;
}
