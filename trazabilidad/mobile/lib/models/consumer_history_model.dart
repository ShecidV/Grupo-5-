class ConsumerUnitModel {
  final int idunidad;
  final String numeroserie;
  final String uuidpublico;
  final String? estado;

  ConsumerUnitModel({
    required this.idunidad,
    required this.numeroserie,
    required this.uuidpublico,
    this.estado,
  });

  factory ConsumerUnitModel.fromJson(Map<String, dynamic> json) {
    return ConsumerUnitModel(
      idunidad: json['idunidad'] is int ? json['idunidad'] : int.parse(json['idunidad'].toString()),
      numeroserie: json['numeroserie']?.toString() ?? '',
      uuidpublico: json['uuidpublico']?.toString() ?? '',
      estado: json['estado']?.toString(),
    );
  }
}

class ConsumerPurchaseModel {
  final int idventa;
  final DateTime fechaventa;
  final double total;
  final String estado;
  final List<ConsumerUnitModel> unidades;

  ConsumerPurchaseModel({
    required this.idventa,
    required this.fechaventa,
    required this.total,
    required this.estado,
    required this.unidades,
  });

  factory ConsumerPurchaseModel.fromJson(Map<String, dynamic> json) {
    return ConsumerPurchaseModel(
      idventa: json['idventa'] is int ? json['idventa'] : int.parse(json['idventa'].toString()),
      fechaventa: DateTime.tryParse(json['fechaventa']?.toString() ?? '') ?? DateTime.now(),
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
      estado: json['estado']?.toString() ?? '',
      unidades: (json['unidades'] as List? ?? [])
          .map((e) => ConsumerUnitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ConsumerHistoryModel {
  final int idcliente;
  final String clientenombre;
  final int totalcompras;
  final double montototal;
  final List<ConsumerPurchaseModel> items;

  ConsumerHistoryModel({
    required this.idcliente,
    required this.clientenombre,
    required this.totalcompras,
    required this.montototal,
    required this.items,
  });

  factory ConsumerHistoryModel.fromJson(Map<String, dynamic> json) {
    return ConsumerHistoryModel(
      idcliente: json['idcliente'] is int ? json['idcliente'] : int.parse(json['idcliente'].toString()),
      clientenombre: json['clientenombre']?.toString() ?? '',
      totalcompras: json['totalcompras'] is int ? json['totalcompras'] : int.parse(json['totalcompras'].toString()),
      montototal: double.tryParse(json['montototal']?.toString() ?? '0') ?? 0,
      items: (json['items'] as List? ?? [])
          .map((e) => ConsumerPurchaseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
