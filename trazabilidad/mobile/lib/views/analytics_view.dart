import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../controllers/analytics_controller.dart';
import '../models/analytics_model.dart';

/// Panel Integral (CU-035): 8 secciones con series, distribuciones y métricas.
class AnalyticsView extends StatefulWidget {
  final AnalyticsController? controller;

  const AnalyticsView({super.key, this.controller});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView>
    with SingleTickerProviderStateMixin {
  static const Color _bg = Color(0xFF0F1115);
  static const Color _surface = Color(0xFF14171D);
  static const Color _accent = Color(0xFF38BDF8);
  static const Color _positive = Color(0xFF3FB27F);
  static const Color _negative = Color(0xFFE06B6B);
  static const Color _texto = Color(0xFFE2E8F0);
  static const Color _textoSecondary = Color(0xFF94A3B8);

  static const List<String> _tabs = <String>[
    'Resumen',
    'Comercial',
    'Alertas',
    'Logística',
    'Facturación',
    'Actividad',
    'Distribución',
    'Suscripción',
  ];

  late final AnalyticsController _controller;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AnalyticsController();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.cambiarTab(_tabController.index);
      }
    });
    if (_controller.datos == null && !_controller.isLoading) {
      _controller.cargar();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        title: const Text(
          'Panel Integral',
          style: TextStyle(color: _texto, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: _accent),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar panel',
            onPressed: () => _controller.cargar(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: _accent,
          unselectedLabelColor: _textoSecondary,
          indicatorColor: _accent,
          dividerColor: const Color(0xFF29303B),
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: [for (final nombre in _tabs) Tab(text: nombre)],
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final datos = _controller.datos;
          if (datos == null) {
            if (_controller.isLoading) return _buildLoading();
            return _buildError(_controller.errorMessage ?? 'Sin datos disponibles.');
          }

          return Column(
            children: [
              if (_controller.errorMessage != null && !_controller.isLoading)
                _buildErrorBanner(_controller.errorMessage!),
              _buildHeader(datos),
              _buildKpis(datos),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildResumen(datos),
                    _buildComercial(datos),
                    _buildAlertas(datos),
                    _buildLogistica(datos),
                    _buildFacturacion(datos),
                    _buildActividad(datos),
                    _buildDistribuciones(datos),
                    _buildSuscripcion(datos),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: _accent),
          SizedBox(height: 16),
          Text('Cargando panel integral...', style: TextStyle(color: _textoSecondary)),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: _surface,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, color: _negative, size: 36),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _texto),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: _accent, foregroundColor: _bg),
                  onPressed: () => _controller.cargar(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      color: _negative.withValues(alpha: 0.18),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: _negative, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Datos de la última carga: $message',
              style: const TextStyle(color: _texto, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AnalyticsResponse datos) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            datos.tenantnombre.isEmpty ? 'Panel Integral' : datos.tenantnombre,
            style: const TextStyle(
              color: _texto,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_o(datos.periodo.desde)} - ${_o(datos.periodo.hasta)}  ·  '
            '${datos.periodo.meses} meses  ·  ${_o(datos.moneda)}  ·  '
            '${_o(datos.zonahoraria)}',
            style: const TextStyle(color: _textoSecondary, fontSize: 12),
          ),
          if (datos.comparacion.etiqueta.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              datos.comparacion.etiqueta,
              style: const TextStyle(color: _accent, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKpis(AnalyticsResponse datos) {
    if (datos.kpis.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: datos.kpis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final kpi = datos.kpis[index];
          final variacion = kpi.variacion;
          final color = variacion == null
              ? _textoSecondary
              : variacion >= 0
                  ? _positive
                  : _negative;
          return Container(
            width: 158,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF29303B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kpi.etiqueta.isEmpty ? kpi.clave : kpi.etiqueta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _textoSecondary, fontSize: 11),
                ),
                Text(
                  '${_fmt(kpi.valor)}${kpi.unidad.isNotEmpty ? ' ${kpi.unidad}' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _texto,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  variacion == null ? '—' : '${variacion >= 0 ? '+' : ''}${_fmt(variacion)}%',
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResumen(AnalyticsResponse datos) {
    final serie = _serieActiva(datos);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _seccionTitulo('Series mensuales'),
          if (datos.series.isEmpty)
            _vacio('No hay series disponibles para el periodo seleccionado.')
          else ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final s in datos.series)
                  ChoiceChip(
                    label: Text(s.etiqueta.isEmpty ? s.clave : s.etiqueta),
                    selected: s.clave == _controller.metricaClave,
                    onSelected: (_) => _controller.cambiarMetrica(s.clave),
                    backgroundColor: _bg,
                    selectedColor: _accent.withValues(alpha: 0.18),
                    side: const BorderSide(color: Color(0xFF29303B)),
                    labelStyle: TextStyle(
                      color: s.clave == _controller.metricaClave ? _accent : _textoSecondary,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (serie != null) ...[
              _lineaCard(serie, datos.moneda),
              const SizedBox(height: 12),
              _cadenciaCard(serie),
            ] else
              _vacio('Seleccione una métrica para visualizar la serie.'),
          ],
          const SizedBox(height: 16),
          _seccionTitulo('Distribuciones'),
          if (datos.distribuciones.isEmpty)
            _vacio('No hay distribuciones disponibles.')
          else
            for (final entry in datos.distribuciones.entries) ...[
              _barChartCard(_label(entry.key), entry.value),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Widget _lineaCard(AnalyticsSerie serie, String moneda) {
    final puntos = serie.puntos;
    final maxX = (puntos.length - 1).toDouble();
    if (puntos.isEmpty) return _vacio('La serie seleccionada no tiene puntos.');

    return Card(
      color: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              serie.etiqueta.isEmpty ? serie.clave : serie.etiqueta,
              style: const TextStyle(color: _texto, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Total ${_fmt(serie.total)}  ·  Promedio mensual ${_fmt(serie.promediomensual)}'
              '${moneda.isNotEmpty ? ' $moneda' : ''}',
              style: const TextStyle(color: _textoSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: maxX < 0 ? 1 : maxX,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < puntos.length; i++)
                          FlSpot(i.toDouble(), puntos[i].valor.toDouble()),
                      ],
                      color: _accent,
                      barWidth: 2.4,
                      isCurved: false,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: _accent.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text(
                            _compacto(value),
                            style: const TextStyle(color: _textoSecondary, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final indice = value.round();
                          if (indice < 0 ||
                              indice >= puntos.length ||
                              (indice != 0 &&
                                  indice % 6 != 0 &&
                                  indice != puntos.length - 1)) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              _mesCorto(puntos[indice].periodo),
                              style: const TextStyle(color: _textoSecondary, fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Color(0xFF29303B),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Color(0xFF29303B)),
                      bottom: BorderSide(color: Color(0xFF29303B)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cadenciaCard(AnalyticsSerie serie) {
    final puntos = serie.puntos;
    if (puntos.isEmpty) return const SizedBox.shrink();
    final actual = _indiceActual(puntos);

    return Card(
      color: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cadencia mensual',
              style: TextStyle(color: _texto, fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 0; i < puntos.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: i == actual ? _accent : _bg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: i == actual ? _accent : const Color(0xFF29303B),
                      ),
                    ),
                    child: Text(
                      _mesCorto(puntos[i].periodo),
                      style: TextStyle(
                        color: i == actual ? _bg : _textoSecondary,
                        fontSize: 11,
                        fontWeight: i == actual ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _barChartCard(String titulo, List<AnalyticsDistribucionItem> items) {
    if (items.isEmpty) return _vacio('Sin datos para $titulo.');
    return Card(
      color: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              titulo,
              style: const TextStyle(color: _texto, fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 190,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text(
                            _compacto(value),
                            style: const TextStyle(color: _textoSecondary, fontSize: 9),
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final indice = value.round();
                          if (indice < 0 || indice >= items.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            angle: -0.5,
                            child: Text(
                              _cortar(items[indice].clave),
                              style: const TextStyle(color: _textoSecondary, fontSize: 9),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < items.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: items[i].cantidad.toDouble(),
                            color: _accent,
                            width: 16,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                for (final item in items)
                  Text(
                    '${_o(item.clave)}: ${_fmt(item.cantidad)} (${_fmt(item.porcentaje)}%)',
                    style: const TextStyle(color: _textoSecondary, fontSize: 11),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComercial(AnalyticsResponse datos) {
    final c = datos.comercial;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _statsCard('Comercialización', [
            _stat('Ventas', c.ventas),
            _stat('Ingresos', c.ingresos, unidad: datos.moneda),
            _stat('Pagos completados', c.pagoscompletados),
            _stat('Ticket promedio', c.ticketpromedio, unidad: datos.moneda),
            _stat('Devoluciones', c.devoluciones),
            _stat('Garantías activas', c.garantiasactivas),
          ]),
          const SizedBox(height: 12),
          _rankingCard('Ranking de productos', datos.rankingProductos, datos.moneda),
          const SizedBox(height: 12),
          if (datos.comparacion.anteriorDesde.isNotEmpty)
            _statsCard('Comparación con periodo anterior', [
              _statText('Desde', datos.comparacion.anteriorDesde),
              _statText('Hasta', datos.comparacion.anteriorHasta),
            ]),
        ],
      ),
    );
  }

  Widget _buildAlertas(AnalyticsResponse datos) {
    final a = datos.alertas;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _statsCard('Alertas e incidencias', [
        _stat('Total', a.total),
        _stat('Abiertas', a.abiertas),
        _stat('Críticas', a.criticas),
        _stat('Reportes de sospecha', a.reportessospecha),
        _stat('Tasa de resolución', a.tasaresolucion, unidad: '%'),
        _stat('Score ML promedio', a.scoremlpromedio),
      ]),
    );
  }

  Widget _buildLogistica(AnalyticsResponse datos) {
    final l = datos.logistica;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _statsCard('Logística y telemetría', [
            _stat('Envíos', l.envios),
            _stat('Entregas a tiempo', l.entregasatiempo),
            _stat('Eventos registrados', l.eventos),
            _stat('Temperatura promedio', l.temperaturaPromedio),
            _stat('Humedad promedio', l.humedadPromedio),
            _stat('Vibración promedio', l.vibracionPromedio),
          ]),
          const SizedBox(height: 12),
          _rankingCard('Tipos de evento', datos.rankingTiposEvento, datos.moneda),
        ],
      ),
    );
  }

  Widget _buildFacturacion(AnalyticsResponse datos) {
    final f = datos.facturacion;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _statsCard('Facturación y cobros', [
        _stat('Facturado', f.facturado, unidad: datos.moneda),
        _stat('Cobrado', f.cobrado, unidad: datos.moneda),
        _stat('Saldo', f.saldo, unidad: datos.moneda),
        _stat('Facturas', f.facturas),
        _stat('Cobros', f.cobros),
      ]),
    );
  }

  Widget _buildActividad(AnalyticsResponse datos) {
    final a = datos.actividad;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _statsCard('Actividad de la plataforma', [
        _stat('Entradas de bitácora', a.bitacora),
        _stat('Notificaciones', a.notificaciones),
        _stat('Notificaciones leídas', a.notificacionesLeidas),
        _stat('Consultas QR', a.consultasQr),
        _stat('Consultas por unidad', a.consultasPorUnidad),
        _stat('Certificados', a.certificados),
      ]),
    );
  }

  Widget _buildDistribuciones(AnalyticsResponse datos) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (datos.distribuciones.isEmpty)
            _vacio('No hay distribuciones disponibles.')
          else
            for (final entry in datos.distribuciones.entries) ...[
              _barChartCard(_label(entry.key), entry.value),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Widget _buildSuscripcion(AnalyticsResponse datos) {
    final s = datos.suscripcion;
    final consumos = s.consumomes.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _statsCard('Suscripción', [
            _statText('Plan', s.plan.isEmpty ? '—' : s.plan),
            _statText('Estado', s.estado.isEmpty ? '—' : s.estado),
          ]),
          const SizedBox(height: 12),
          _statsCard(
            'Consumo del mes',
            [
              for (final entry in consumos)
                _stat(_label(entry.key), entry.value),
            ],
          ),
        ],
      ),
    );
  }

  MapEntry<String, String> _stat(String etiqueta, num valor, {String unidad = ''}) {
    final sufijo = unidad.isEmpty ? '' : ' $unidad';
    return MapEntry(etiqueta, '${_fmt(valor)}$sufijo');
  }

  MapEntry<String, String> _statText(String etiqueta, String valor) {
    return MapEntry(etiqueta, valor.isEmpty ? '—' : valor);
  }

  Widget _statsCard(String titulo, List<MapEntry<String, String>> filas) {
    return Card(
      color: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(color: _texto, fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 10),
            for (final fila in filas)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        fila.key,
                        style: const TextStyle(color: _textoSecondary, fontSize: 12),
                      ),
                    ),
                    Text(
                      fila.value,
                      style: const TextStyle(
                        color: _texto,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _rankingCard(
    String titulo,
    List<AnalyticsItem> items,
    String moneda,
  ) {
    return Card(
      color: _surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(color: _texto, fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('Sin datos', style: TextStyle(color: _textoSecondary, fontSize: 12))
            else
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _o(item.clave),
                          style: const TextStyle(color: _texto, fontSize: 12),
                        ),
                      ),
                      Text(
                        '${_fmt(item.cantidad)} uds',
                        style: const TextStyle(color: _textoSecondary, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_fmt(item.monto)}${moneda.isNotEmpty ? ' $moneda' : ''}',
                        style: const TextStyle(color: _accent, fontSize: 12),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _seccionTitulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: const TextStyle(color: _texto, fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _vacio(String mensaje) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF29303B)),
      ),
      child: Text(
        mensaje,
        style: const TextStyle(color: _textoSecondary, fontSize: 12),
      ),
    );
  }

  AnalyticsSerie? _serieActiva(AnalyticsResponse datos) {
    if (datos.series.isEmpty) return null;
    for (final serie in datos.series) {
      if (serie.clave == _controller.metricaClave) return serie;
    }
    return datos.series.first;
  }

  int _indiceActual(List<AnalyticsPunto> puntos) {
    final mesActual = DateTime.now().toString().substring(0, 7);
    for (var i = 0; i < puntos.length; i++) {
      if (puntos[i].periodo.length >= 7 &&
          puntos[i].periodo.substring(0, 7) == mesActual) {
        return i;
      }
    }
    return puntos.length - 1;
  }

  String _mesCorto(String periodo) {
    if (periodo.length >= 7) {
      return '${periodo.substring(5, 7)}/${periodo.substring(2, 4)}';
    }
    return _o(periodo);
  }

  String _cortar(String texto, [int max = 9]) {
    if (texto.length <= max) return texto;
    return '${texto.substring(0, max - 1)}…';
  }

  String _label(String clave) {
    if (clave.isEmpty) return 'Sin nombre';
    final nombre = clave.replaceAll('_', ' ').trim();
    if (nombre.isEmpty) return clave;
    return nombre[0].toUpperCase() + nombre.substring(1);
  }

  String _o(String valor) => valor.isEmpty ? '—' : valor;

  String _compacto(double valor) {
    if (valor == 0) return '0';
    final abs = valor.abs();
    if (abs >= 1000000) return '${(valor / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) return '${(valor / 1000).toStringAsFixed(abs >= 10000 ? 0 : 1)}k';
    return _fmt(valor);
  }

  String _fmt(num? valor) {
    if (valor == null) return '—';
    if (valor == 0) return '0';
    final doble = valor.toDouble();
    if (doble == doble.roundToDouble() && doble.abs() < 1e15) {
      return doble.round().toString();
    }
    return doble
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}
