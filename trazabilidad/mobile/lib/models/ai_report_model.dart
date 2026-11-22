class KPIItemModel {
  final String label;
  final String value;
  final String? trend;
  final String color;

  KPIItemModel({
    required this.label,
    required this.value,
    this.trend,
    this.color = '#38BDF8',
  });

  factory KPIItemModel.fromJson(Map<String, dynamic> json) {
    return KPIItemModel(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      trend: json['trend'],
      color: json['color'] ?? '#38BDF8',
    );
  }
}

class ChartDataModel {
  final String chartType; // 'pie', 'bar', 'line', 'kpi'
  final String title;
  final List<String> labels;
  final List<Map<String, dynamic>> datasets;

  ChartDataModel({
    required this.chartType,
    required this.title,
    required this.labels,
    required this.datasets,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      chartType: json['chart_type'] ?? 'pie',
      title: json['title'] ?? 'Resumen Gráfico',
      labels: List<String>.from(json['labels'] ?? []),
      datasets: List<Map<String, dynamic>>.from(json['datasets'] ?? []),
    );
  }
}

class ProductDetailModel {
  final String producto;
  final String periodLabel;
  final String desde;
  final String hasta;
  final List<KPIItemModel> kpis;
  final List<Map<String, dynamic>> monthlyTrend;
  final List<String> tableHeaders;
  final List<List<dynamic>> tableRows;

  ProductDetailModel({
    required this.producto,
    required this.periodLabel,
    required this.desde,
    required this.hasta,
    required this.kpis,
    required this.monthlyTrend,
    required this.tableHeaders,
    required this.tableRows,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      producto: json['producto'] ?? '',
      periodLabel: json['period_label'] ?? '',
      desde: json['desde'] ?? '',
      hasta: json['hasta'] ?? '',
      kpis: (json['kpis'] as List<dynamic>?)
              ?.map((k) => KPIItemModel.fromJson(k as Map<String, dynamic>))
              .toList() ??
          [],
      monthlyTrend:
          List<Map<String, dynamic>>.from(json['monthly_trend'] ?? []),
      tableHeaders: List<String>.from(json['table_headers'] ?? []),
      tableRows: List<List<dynamic>>.from(
          (json['table_rows'] ?? []).map((row) => List<dynamic>.from(row))),
    );
  }
}

class VoiceReportModel {
  final String reportId;
  final String queryInterpreted;
  final String category;
  final String voiceSummary;
  final String executiveSummary;
  final List<KPIItemModel> kpis;
  final ChartDataModel chart;
  final List<String> tableHeaders;
  final List<List<dynamic>> tableRows;
  final String? periodLabel;
  final String? interpretation;
  final Map<String, dynamic> filtersApplied;
  final List<String> suggestedFollowups;
  final String generatedAt;
  final String pdfDownloadUrl;
  final String excelDownloadUrl;
  final ProductDetailModel? productDetail;

  VoiceReportModel({
    required this.reportId,
    required this.queryInterpreted,
    required this.category,
    required this.voiceSummary,
    required this.executiveSummary,
    required this.kpis,
    required this.chart,
    required this.tableHeaders,
    required this.tableRows,
    this.periodLabel,
    this.interpretation,
    this.filtersApplied = const {},
    this.suggestedFollowups = const [],
    required this.generatedAt,
    required this.pdfDownloadUrl,
    required this.excelDownloadUrl,
    this.productDetail,
  });

  factory VoiceReportModel.fromJson(Map<String, dynamic> json) {
    return VoiceReportModel(
      reportId: json['report_id'] ?? '',
      queryInterpreted: json['query_interpreted'] ?? '',
      category: json['category'] ?? 'general',
      voiceSummary: json['voice_summary'] ?? '',
      executiveSummary: json['executive_summary'] ?? '',
      kpis: (json['kpis'] as List<dynamic>?)
              ?.map((k) => KPIItemModel.fromJson(k as Map<String, dynamic>))
              .toList() ??
          [],
      chart: ChartDataModel.fromJson(json['chart'] ?? {}),
      tableHeaders: List<String>.from(json['table_headers'] ?? []),
      tableRows: List<List<dynamic>>.from(
          (json['table_rows'] ?? []).map((row) => List<dynamic>.from(row))),
      periodLabel: json['period_label'],
      interpretation: json['interpretation'],
      filtersApplied: Map<String, dynamic>.from(json['filters_applied'] ?? {}),
      suggestedFollowups: List<String>.from(json['suggested_followups'] ?? []),
      generatedAt: json['generated_at'] ?? '',
      pdfDownloadUrl: json['pdf_download_url'] ?? '',
      excelDownloadUrl: json['excel_download_url'] ?? '',
      productDetail: json['product_detail'] != null
          ? ProductDetailModel.fromJson(
              json['product_detail'] as Map<String, dynamic>)
          : null,
    );
  }
}
