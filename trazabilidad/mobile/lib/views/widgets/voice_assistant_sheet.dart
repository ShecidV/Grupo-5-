import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/ai_assistant_controller.dart';
import '../../models/ai_report_model.dart';

class VoiceAssistantSheet extends StatefulWidget {
  final AiAssistantController controller;

  const VoiceAssistantSheet({super.key, required this.controller});

  static Future<void> show(BuildContext context, AiAssistantController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => VoiceAssistantSheet(controller: controller),
    );
  }

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  final TextEditingController _textQueryController = TextEditingController();

  final List<String> _quickPrompts = [
    '🏆 Top 10 productos más vendidos en el último trimestre',
    '📈 Top 5 por ingresos en los últimos 6 meses',
    '🛒 Compras de los últimos 3 meses',
    '🚚 Envíos de la última semana',
    '📦 Stock disponible de iPhones',
    '🛡️ Resumen de bitácora y auditoría',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.9,
      upperBound: 1.15,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textQueryController.dispose();
    super.dispose();
  }

  Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return const Color(0xFF38BDF8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final ctrl = widget.controller;
        final report = ctrl.currentReport;

        return DraggableScrollableSheet(
          initialChildSize: report != null ? 0.92 : 0.65,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Barra de agarre superior
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Header del Modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Color(0xFF38BDF8), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Informes Dinámicos con IA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (ctrl.hasReport)
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Color(0xFF94A3B8)),
                              tooltip: 'Nueva consulta',
                              onPressed: () {
                                ctrl.reset();
                                _textQueryController.clear();
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF1E293B)),

                  // Cuerpo del contenido
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        if (ctrl.errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7F1D1D),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Color(0xFFFECACA)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    ctrl.errorMessage!,
                                    style: const TextStyle(color: Color(0xFFFECACA), fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Sección de Micrófono y Comando de Voz
                        _buildVoiceInputSection(ctrl),

                        // Chips de consultas sugeridas rápidas
                        if (!ctrl.hasReport && !ctrl.isLoading) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'O prueba una consulta rápida sugerida:',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _quickPrompts.map((p) {
                              return ActionChip(
                                label: Text(p, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                backgroundColor: const Color(0xFF1E293B),
                                side: const BorderSide(color: Color(0xFF334155)),
                                onPressed: () {
                                  _textQueryController.text = p;
                                  ctrl.submitQuery(p);
                                },
                              );
                            }).toList(),
                          ),
                        ],

                        // Estado de Carga
                        if (ctrl.isLoading) ...[
                          const SizedBox(height: 36),
                          const Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(color: Color(0xFF38BDF8)),
                                SizedBox(height: 16),
                                Text(
                                  'Consultando datos del Tenant y sintetizando informe con IA...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Resultados del Reporte Generado
                        if (report != null && !ctrl.isLoading) ...[
                          const SizedBox(height: 16),
                          _buildReportResultView(report, ctrl),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVoiceInputSection(AiAssistantController ctrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ctrl.isListening ? const Color(0xFF38BDF8) : const Color(0xFF334155),
          width: ctrl.isListening ? 1.8 : 1.0,
        ),
      ),
      child: Column(
        children: [
          // Botón Pulsante de Micrófono
          Center(
            child: ScaleTransition(
              scale: ctrl.isListening ? _pulseController : const AlwaysStoppedAnimation(1.0),
              child: GestureDetector(
                onTap: () {
                  if (ctrl.isListening) {
                    ctrl.stopListeningAndSubmit();
                  } else {
                    ctrl.startListening();
                  }
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: ctrl.isListening
                          ? [const Color(0xFF0284C7), const Color(0xFF38BDF8)]
                          : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                    ),
                    boxShadow: ctrl.isListening
                        ? [
                            BoxShadow(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 4,
                            )
                          ]
                        : null,
                    border: Border.all(
                      color: ctrl.isListening ? Colors.white : const Color(0xFF38BDF8),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    ctrl.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            ctrl.isListening
                ? 'Escuchando... Di tu consulta en voz alta'
                : 'Toca el micrófono para hablar o escribe abajo',
            style: TextStyle(
              color: ctrl.isListening ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: ctrl.isListening ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          // Transcripción en vivo
          if (ctrl.spokenText.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '“${ctrl.spokenText}”',
                style: const TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Campo de texto alternativo por si hay mucho ruido
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textQueryController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'O escribe tu consulta aquí...',
                    hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      ctrl.submitQuery(val.trim());
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                ),
                icon: const Icon(Icons.send, size: 18),
                onPressed: () {
                  final text = _textQueryController.text.trim();
                  if (text.isNotEmpty) {
                    ctrl.submitQuery(text);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportResultView(VoiceReportModel report, AiAssistantController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Barra de Reproducción de Voz (TTS)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(
                    ctrl.isPlayingAudio ? Icons.pause_circle_filled : Icons.volume_up_rounded,
                    color: const Color(0xFF38BDF8),
                    size: 26,
                  ),
                  onPressed: () {
                    if (ctrl.isPlayingAudio) {
                      ctrl.stopSpeaking();
                    } else {
                      ctrl.speakSummary();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Síntesis por Voz',
                          style: TextStyle(
                            color: Color(0xFF38BDF8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (ctrl.isPlayingAudio) ...[
                          const SizedBox(width: 8),
                          const Text(
                            '• Reproduciendo...',
                            style: TextStyle(color: Colors.greenAccent, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.voiceSummary,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 1.5 Criterio interpretado por el asistente (empresa, período, métrica, filtros)
        if (report.interpretation != null && report.interpretation!.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0284C7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CONSULTA INTERPRETADA',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  report.interpretation!,
                  style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 12, height: 1.4),
                ),
                if (report.suggestedFollowups.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: report.suggestedFollowups
                        .map(
                          (seguimiento) => ActionChip(
                            label: Text(
                              seguimiento,
                              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                            ),
                            backgroundColor: const Color(0xFF1E293B),
                            side: const BorderSide(color: Color(0xFF334155)),
                            onPressed: () => ctrl.submitQuery(seguimiento),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 2. Botones de Descarga en PDF y Excel
        _buildExportButtons(report, ctrl),
        const SizedBox(height: 16),

        // 3. Tarjetas de KPIs
        if (report.kpis.isNotEmpty) ...[
          const Text(
            'Métricas Clave (KPIs)',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: report.kpis.length,
            itemBuilder: (ctx, i) {
              final kpi = report.kpis[i];
              final kColor = _parseHexColor(kpi.color);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kColor.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kpi.label,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      kpi.value,
                      style: TextStyle(color: kColor, fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (kpi.trend != null)
                      Text(
                        kpi.trend!,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 9),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],

        // 3b. Ficha detallada del producto (siempre 36 meses)
        if (report.productDetail != null) ...[
          _buildProductDetailCard(report.productDetail!),
          const SizedBox(height: 16),
        ],

        // 4. Gráfico Dinámico (Pie / Bar)
        if (report.chart.labels.isNotEmpty) ...[
          _buildDynamicChart(report.chart),
          const SizedBox(height: 16),
        ],

        // 5. Análisis Ejecutivo Detallado (Markdown)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.analytics_outlined, color: Color(0xFF38BDF8), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Análisis Ejecutivo y Conclusiones',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF334155), height: 20),
              Text(
                report.executiveSummary,
                style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 6. Vista previa de la Tabla de Datos
        if (report.tableHeaders.isNotEmpty && report.tableRows.isNotEmpty) ...[
          _buildDataTablePreview(report),
        ],
      ],
    );
  }

  Widget _buildExportButtons(VoiceReportModel report, AiAssistantController ctrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exportar Informe Oficial:',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Botón Descargar PDF
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: ctrl.isDownloading
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.picture_as_pdf, color: Colors.white, size: 18),
                  label: const Text('Descargar PDF', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: ctrl.isDownloading
                      ? null
                      : () async {
                          final path = await ctrl.downloadAndOpenReport(
                            reportId: report.reportId,
                            format: 'pdf',
                          );
                          if (path != null && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('PDF generado con éxito: $path'), backgroundColor: Colors.green),
                            );
                          }
                        },
                ),
              ),
              const SizedBox(width: 8),

              // Botón Exportar Excel
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: ctrl.isDownloading
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.table_view_rounded, color: Colors.white, size: 18),
                  label: const Text('Exportar Excel', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: ctrl.isDownloading
                      ? null
                      : () async {
                          final path = await ctrl.downloadAndOpenReport(
                            reportId: report.reportId,
                            format: 'excel',
                          );
                          if (path != null && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Excel exportado con éxito: $path'), backgroundColor: Colors.green),
                            );
                          }
                        },
                ),
              ),
              const SizedBox(width: 8),

              // Botón Compartir
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.share, color: Color(0xFF38BDF8), size: 20),
                tooltip: 'Compartir reporte',
                onPressed: () {
                  ctrl.downloadAndOpenReport(
                    reportId: report.reportId,
                    format: 'pdf',
                    share: true,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicChart(ChartDataModel chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chart.title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: chart.chartType == 'pie'
                ? _buildPieChart(chart)
                : _buildBarChart(chart),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(ChartDataModel chart) {
    final ds = chart.datasets.isNotEmpty ? chart.datasets.first : {};
    final data = List<num>.from(ds['data'] ?? []);
    final bgColors = List<String>.from(ds['backgroundColor'] ?? []);

    final total = data.fold<double>(0.0, (sum, val) => sum + val.toDouble());

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 36,
              sections: List.generate(data.length, (i) {
                final val = data[i].toDouble();
                final col = i < bgColors.length ? _parseHexColor(bgColors[i]) : const Color(0xFF38BDF8);
                final pct = total > 0 ? (val / total * 100).toStringAsFixed(0) : '0';
                return PieChartSectionData(
                  value: val,
                  title: '$pct%',
                  color: col,
                  radius: 40,
                  titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(chart.labels.length, (i) {
              final col = i < bgColors.length ? _parseHexColor(bgColors[i]) : const Color(0xFF38BDF8);
              final val = i < data.length ? data[i] : 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: col, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${chart.labels[i]}: $val',
                        style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(ChartDataModel chart) {
    final ds = chart.datasets.isNotEmpty ? chart.datasets.first : {};
    final data = List<num>.from(ds['data'] ?? []);
    final col = ds['backgroundColor'] != null ? _parseHexColor(ds['backgroundColor']) : const Color(0xFF38BDF8);

    return BarChart(
      BarChartData(
        barGroups: List.generate(data.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: data[i].toDouble(),
                color: col,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                final idx = val.toInt();
                if (idx >= 0 && idx < chart.labels.length) {
                  return Text(
                    chart.labels[idx].split('-').last,
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildProductDetailCard(ProductDetailModel detalle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C4A6E), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF0284C7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DETALLE · 36 MESES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            detalle.producto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${detalle.periodLabel} · ${detalle.desde} → ${detalle.hasta}',
            style: const TextStyle(color: Color(0xFFBAE6FD), fontSize: 11),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: detalle.kpis.map((k) {
              final color = _parseHexColor(k.color);
              return Container(
                width: 110,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(k.label,
                        style: const TextStyle(
                            color: Color(0xFF94A3B8), fontSize: 9),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(k.value,
                        style: TextStyle(
                            color: color,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            }).toList(),
          ),
          if (detalle.monthlyTrend.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Tendencia mensual',
                style: TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: detalle.monthlyTrend
                  .map((p) => Chip(
                        label: Text('${p['mes']}: ${p['unidades']} und',
                            style: const TextStyle(fontSize: 10)),
                        backgroundColor: const Color(0xFF0F172A),
                        labelStyle: const TextStyle(color: Color(0xFFCBD5E1)),
                        side: const BorderSide(color: Color(0xFF334155)),
                        padding: EdgeInsets.zero,
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataTablePreview(VoiceReportModel report) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        iconColor: const Color(0xFF38BDF8),
        collapsedIconColor: Colors.white70,
        title: Text(
          'Ver Registros Tabulares (${report.tableRows.length})',
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFF0F172A)),
              columns: report.tableHeaders.map((h) {
                return DataColumn(
                  label: Text(h, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
                );
              }).toList(),
              rows: report.tableRows.take(15).map((row) {
                return DataRow(
                  cells: row.map((cell) {
                    final str = cell is double ? '\$${cell.toStringAsFixed(2)}' : cell.toString();
                    return DataCell(
                      Text(str, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
