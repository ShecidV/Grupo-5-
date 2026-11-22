class BillingNotificationModel {
  final String id;
  final String tipo;
  final String titulo;
  final String contenido;
  final int destinatarios;
  final DateTime enviadoen;
  final String? enlaceaccion;

  BillingNotificationModel({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.contenido,
    required this.destinatarios,
    required this.enviadoen,
    this.enlaceaccion,
  });

  factory BillingNotificationModel.fromJson(Map<String, dynamic> json) {
    return BillingNotificationModel(
      id: json['id']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      contenido: json['contenido']?.toString() ?? '',
      destinatarios: json['destinatarios'] is int
          ? json['destinatarios']
          : int.parse(json['destinatarios']?.toString() ?? '0'),
      enviadoen: DateTime.tryParse(json['enviadoen']?.toString() ?? '') ?? DateTime.now(),
      enlaceaccion: json['enlaceaccion']?.toString(),
    );
  }
}

class BillingNotificationsResponse {
  final int enviadas;
  final List<BillingNotificationModel> items;

  BillingNotificationsResponse({required this.enviadas, required this.items});

  factory BillingNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return BillingNotificationsResponse(
      enviadas: json['enviadas'] is int ? json['enviadas'] : int.parse(json['enviadas'].toString()),
      items: (json['items'] as List? ?? [])
          .map((e) => BillingNotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
