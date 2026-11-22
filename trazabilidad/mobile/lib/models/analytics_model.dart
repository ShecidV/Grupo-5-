// Modelos defensivos para el Panel Integral (CU-035).
// La API puede omitir cualquiera de los bloques; en ese caso se exponen
// valores neutros (0, cadena vacía o listas vacías) para que la vista nunca
// tenga que manejar `null`.

num _num(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value) ?? 0;
  return 0;
}

num? _numOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

int _int(dynamic value) => _num(value).round();

String _str(dynamic value) => value == null ? '' : value.toString();

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

List<dynamic> _list(dynamic value) => value is List ? value : <dynamic>[];

class AnalyticsPeriodo {
  final String desde;
  final String hasta;
  final int meses;

  AnalyticsPeriodo({this.desde = '', this.hasta = '', this.meses = 0});

  factory AnalyticsPeriodo.fromJson(Map<String, dynamic> json) => AnalyticsPeriodo(
        desde: _str(json['desde']),
        hasta: _str(json['hasta']),
        meses: _int(json['meses']),
      );
}

class AnalyticsComparacion {
  final String etiqueta;
  final String desde;
  final String hasta;
  final String anteriorDesde;
  final String anteriorHasta;

  AnalyticsComparacion({
    this.etiqueta = '',
    this.desde = '',
    this.hasta = '',
    this.anteriorDesde = '',
    this.anteriorHasta = '',
  });

  factory AnalyticsComparacion.fromJson(Map<String, dynamic> json) => AnalyticsComparacion(
        etiqueta: _str(json['etiqueta']),
        desde: _str(json['desde']),
        hasta: _str(json['hasta']),
        anteriorDesde: _str(json['anterior_desde']),
        anteriorHasta: _str(json['anterior_hasta']),
      );
}

class AnalyticsKpi {
  final String clave;
  final String etiqueta;
  final num valor;
  final String unidad;
  final num? variacion;
  final String? base;

  AnalyticsKpi({
    this.clave = '',
    this.etiqueta = '',
    this.valor = 0,
    this.unidad = '',
    this.variacion,
    this.base,
  });

  factory AnalyticsKpi.fromJson(Map<String, dynamic> json) => AnalyticsKpi(
        clave: _str(json['clave']),
        etiqueta: _str(json['etiqueta']),
        valor: _num(json['valor']),
        unidad: _str(json['unidad']),
        variacion: _numOrNull(json['variacion']),
        base: json['base'] == null ? null : _str(json['base']),
      );
}

class AnalyticsPunto {
  final String periodo;
  final num valor;

  AnalyticsPunto({this.periodo = '', this.valor = 0});

  factory AnalyticsPunto.fromJson(Map<String, dynamic> json) => AnalyticsPunto(
        periodo: _str(json['periodo']),
        valor: _num(json['valor']),
      );
}

class AnalyticsSerie {
  final String clave;
  final String etiqueta;
  final String unidad;
  final List<AnalyticsPunto> puntos;
  final num total;
  final num promediomensual;

  AnalyticsSerie({
    this.clave = '',
    this.etiqueta = '',
    this.unidad = '',
    List<AnalyticsPunto>? puntos,
    this.total = 0,
    this.promediomensual = 0,
  }) : puntos = puntos ?? <AnalyticsPunto>[];

  factory AnalyticsSerie.fromJson(Map<String, dynamic> json) => AnalyticsSerie(
        clave: _str(json['clave']),
        etiqueta: _str(json['etiqueta']),
        unidad: _str(json['unidad']),
        puntos: _list(json['puntos'])
            .whereType<Map>()
            .map((p) => AnalyticsPunto.fromJson(Map<String, dynamic>.from(p)))
            .toList(),
        total: _num(json['total']),
        promediomensual: _num(json['promediomensual']),
      );
}

class AnalyticsDistribucionItem {
  final String clave;
  final int cantidad;
  final num porcentaje;

  AnalyticsDistribucionItem({
    this.clave = '',
    this.cantidad = 0,
    this.porcentaje = 0,
  });

  factory AnalyticsDistribucionItem.fromJson(Map<String, dynamic> json) =>
      AnalyticsDistribucionItem(
        clave: _str(json['clave']),
        cantidad: _int(json['cantidad']),
        porcentaje: _num(json['porcentaje']),
      );
}

class AnalyticsItem {
  final String clave;
  final int cantidad;
  final num monto;

  AnalyticsItem({this.clave = '', this.cantidad = 0, this.monto = 0});

  factory AnalyticsItem.fromJson(Map<String, dynamic> json) => AnalyticsItem(
        clave: _str(json['clave']),
        cantidad: _int(json['cantidad']),
        monto: _num(json['monto']),
      );
}

class AnalyticsComercial {
  final num ventas;
  final num ingresos;
  final num pagoscompletados;
  final num ticketpromedio;
  final num devoluciones;
  final num garantiasactivas;

  AnalyticsComercial({
    this.ventas = 0,
    this.ingresos = 0,
    this.pagoscompletados = 0,
    this.ticketpromedio = 0,
    this.devoluciones = 0,
    this.garantiasactivas = 0,
  });

  factory AnalyticsComercial.fromJson(Map<String, dynamic> json) => AnalyticsComercial(
        ventas: _num(json['ventas']),
        ingresos: _num(json['ingresos']),
        pagoscompletados: _num(json['pagoscompletados']),
        ticketpromedio: _num(json['ticketpromedio']),
        devoluciones: _num(json['devoluciones']),
        garantiasactivas: _num(json['garantiasactivas']),
      );
}

class AnalyticsAlertas {
  final num total;
  final num abiertas;
  final num criticas;
  final num reportessospecha;
  final num tasaresolucion;
  final num scoremlpromedio;

  AnalyticsAlertas({
    this.total = 0,
    this.abiertas = 0,
    this.criticas = 0,
    this.reportessospecha = 0,
    this.tasaresolucion = 0,
    this.scoremlpromedio = 0,
  });

  factory AnalyticsAlertas.fromJson(Map<String, dynamic> json) => AnalyticsAlertas(
        total: _num(json['total']),
        abiertas: _num(json['abiertas']),
        criticas: _num(json['criticas']),
        reportessospecha: _num(json['reportessospecha']),
        tasaresolucion: _num(json['tasaresolucion']),
        scoremlpromedio: _num(json['scoremlpromedio']),
      );
}

class AnalyticsLogistica {
  final num envios;
  final num entregasatiempo;
  final num eventos;
  final num temperaturaPromedio;
  final num humedadPromedio;
  final num vibracionPromedio;

  AnalyticsLogistica({
    this.envios = 0,
    this.entregasatiempo = 0,
    this.eventos = 0,
    this.temperaturaPromedio = 0,
    this.humedadPromedio = 0,
    this.vibracionPromedio = 0,
  });

  factory AnalyticsLogistica.fromJson(Map<String, dynamic> json) => AnalyticsLogistica(
        envios: _num(json['envios']),
        entregasatiempo: _num(json['entregasatiempo']),
        eventos: _num(json['eventos']),
        temperaturaPromedio: _num(json['temperatura_promedio']),
        humedadPromedio: _num(json['humedad_promedio']),
        vibracionPromedio: _num(json['vibracion_promedio']),
      );
}

class AnalyticsFacturacion {
  final num facturado;
  final num cobrado;
  final num saldo;
  final num facturas;
  final num cobros;

  AnalyticsFacturacion({
    this.facturado = 0,
    this.cobrado = 0,
    this.saldo = 0,
    this.facturas = 0,
    this.cobros = 0,
  });

  factory AnalyticsFacturacion.fromJson(Map<String, dynamic> json) => AnalyticsFacturacion(
        facturado: _num(json['facturado']),
        cobrado: _num(json['cobrado']),
        saldo: _num(json['saldo']),
        facturas: _num(json['facturas']),
        cobros: _num(json['cobros']),
      );
}

class AnalyticsActividad {
  final num bitacora;
  final num notificaciones;
  final num notificacionesLeidas;
  final num consultasQr;
  final num consultasPorUnidad;
  final num certificados;

  AnalyticsActividad({
    this.bitacora = 0,
    this.notificaciones = 0,
    this.notificacionesLeidas = 0,
    this.consultasQr = 0,
    this.consultasPorUnidad = 0,
    this.certificados = 0,
  });

  factory AnalyticsActividad.fromJson(Map<String, dynamic> json) => AnalyticsActividad(
        bitacora: _num(json['bitacora']),
        notificaciones: _num(json['notificaciones']),
        notificacionesLeidas: _num(json['notificaciones_leidas']),
        consultasQr: _num(json['consultas_qr']),
        consultasPorUnidad: _num(json['consultas_por_unidad']),
        certificados: _num(json['certificados']),
      );
}

class AnalyticsSuscripcion {
  final String plan;
  final String estado;
  final Map<String, num> consumomes;

  AnalyticsSuscripcion({
    this.plan = '',
    this.estado = '',
    Map<String, num>? consumomes,
  }) : consumomes = consumomes ?? <String, num>{};

  factory AnalyticsSuscripcion.fromJson(Map<String, dynamic> json) =>
      AnalyticsSuscripcion(
        plan: _str(json['plan']),
        estado: _str(json['estado']),
        consumomes: _map(json['consumomes']).map(
          (key, value) => MapEntry(key, _num(value)),
        ),
      );
}

class AnalyticsResponse {
  final int idtenant;
  final String tenantnombre;
  final String generadoen;
  final String moneda;
  final String zonahoraria;
  final AnalyticsPeriodo periodo;
  final AnalyticsComparacion comparacion;
  final List<AnalyticsKpi> kpis;
  final List<AnalyticsSerie> series;
  final Map<String, List<AnalyticsDistribucionItem>> distribuciones;
  final List<AnalyticsItem> rankingProductos;
  final List<AnalyticsItem> rankingTiposEvento;
  final AnalyticsComercial comercial;
  final AnalyticsAlertas alertas;
  final AnalyticsLogistica logistica;
  final AnalyticsFacturacion facturacion;
  final AnalyticsActividad actividad;
  final AnalyticsSuscripcion suscripcion;

  AnalyticsResponse({
    this.idtenant = 0,
    this.tenantnombre = '',
    this.generadoen = '',
    this.moneda = '',
    this.zonahoraria = '',
    AnalyticsPeriodo? periodo,
    AnalyticsComparacion? comparacion,
    List<AnalyticsKpi>? kpis,
    List<AnalyticsSerie>? series,
    Map<String, List<AnalyticsDistribucionItem>>? distribuciones,
    List<AnalyticsItem>? rankingProductos,
    List<AnalyticsItem>? rankingTiposEvento,
    AnalyticsComercial? comercial,
    AnalyticsAlertas? alertas,
    AnalyticsLogistica? logistica,
    AnalyticsFacturacion? facturacion,
    AnalyticsActividad? actividad,
    AnalyticsSuscripcion? suscripcion,
  })  : periodo = periodo ?? AnalyticsPeriodo(),
        comparacion = comparacion ?? AnalyticsComparacion(),
        kpis = kpis ?? <AnalyticsKpi>[],
        series = series ?? <AnalyticsSerie>[],
        distribuciones = distribuciones ?? <String, List<AnalyticsDistribucionItem>>{},
        rankingProductos = rankingProductos ?? <AnalyticsItem>[],
        rankingTiposEvento = rankingTiposEvento ?? <AnalyticsItem>[],
        comercial = comercial ?? AnalyticsComercial(),
        alertas = alertas ?? AnalyticsAlertas(),
        logistica = logistica ?? AnalyticsLogistica(),
        facturacion = facturacion ?? AnalyticsFacturacion(),
        actividad = actividad ?? AnalyticsActividad(),
        suscripcion = suscripcion ?? AnalyticsSuscripcion();

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) {
    final ranking = _map(json['ranking']);
    final distribucionesJson = _map(json['distribuciones']);
    final distribuciones = <String, List<AnalyticsDistribucionItem>>{};

    distribucionesJson.forEach((key, value) {
      distribuciones[key] = _list(value)
          .whereType<Map>()
          .map((item) =>
              AnalyticsDistribucionItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    });

    return AnalyticsResponse(
      idtenant: _int(json['idtenant']),
      tenantnombre: _str(json['tenantnombre']),
      generadoen: _str(json['generadoen']),
      moneda: _str(json['moneda']),
      zonahoraria: _str(json['zonahoraria']),
      periodo: AnalyticsPeriodo.fromJson(_map(json['periodo'])),
      comparacion: AnalyticsComparacion.fromJson(_map(json['comparacion'])),
      kpis: _list(json['kpis'])
          .whereType<Map>()
          .map((k) => AnalyticsKpi.fromJson(Map<String, dynamic>.from(k)))
          .toList(),
      series: _list(json['series'])
          .whereType<Map>()
          .map((s) => AnalyticsSerie.fromJson(Map<String, dynamic>.from(s)))
          .toList(),
      distribuciones: distribuciones,
      rankingProductos: _list(ranking['productos'])
          .whereType<Map>()
          .map((p) => AnalyticsItem.fromJson(Map<String, dynamic>.from(p)))
          .toList(),
      rankingTiposEvento: _list(ranking['tipos_evento'])
          .whereType<Map>()
          .map((p) => AnalyticsItem.fromJson(Map<String, dynamic>.from(p)))
          .toList(),
      comercial: AnalyticsComercial.fromJson(_map(json['comercial'])),
      alertas: AnalyticsAlertas.fromJson(_map(json['alertas'])),
      logistica: AnalyticsLogistica.fromJson(_map(json['logistica'])),
      facturacion: AnalyticsFacturacion.fromJson(_map(json['facturacion'])),
      actividad: AnalyticsActividad.fromJson(_map(json['actividad'])),
      suscripcion: AnalyticsSuscripcion.fromJson(_map(json['suscripcion'])),
    );
  }
}
