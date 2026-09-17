import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../core/secure_storage.dart';
import '../models/transport_model.dart';

class TransportService {
  static Future<List<ShipmentModel>> fetchShipments({String? estado}) async {
    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception('No autenticado.');

    final queryParams = <String, String>{};
    if (estado != null && estado.trim().isNotEmpty) {
      queryParams['estado'] = estado.trim();
    }

    final uri = Uri.parse(ApiConfig.shipments).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => ShipmentModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      await SecureStorageService.deleteToken();
      throw Exception('Sesión expirada. Inicie sesión nuevamente.');
    } else {
      throw Exception('Error al cargar envíos: ${response.statusCode}');
    }
  }

  static Future<ShipmentTimelineModel> fetchTimeline(int idenvio) async {
    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception('No autenticado.');

    final uri = Uri.parse('${ApiConfig.shipments}/$idenvio/timeline');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return ShipmentTimelineModel.fromJson(data);
    } else if (response.statusCode == 401) {
      await SecureStorageService.deleteToken();
      throw Exception('Sesión expirada. Inicie sesión nuevamente.');
    } else {
      throw Exception('Error al cargar línea de tiempo: ${response.statusCode}');
    }
  }

  static Future<TransportEventModel> recordEvent({
    required int idenvio,
    required String tipoevento,
    required int idubicacion,
    String? descripcion,
    TransportConditionModel? condiciones,
  }) async {
    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception('No autenticado.');

    final uri = Uri.parse('${ApiConfig.shipments}/$idenvio/events');

    final payload = {
      'tipoevento': tipoevento,
      'idubicacion': idubicacion,
      if (descripcion != null && descripcion.isNotEmpty) 'descripcion': descripcion,
      if (condiciones != null) 'condiciones': condiciones.toJson(),
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return TransportEventModel.fromJson(data);
    } else if (response.statusCode == 401) {
      await SecureStorageService.deleteToken();
      throw Exception('Sesión expirada. Inicie sesión nuevamente.');
    } else {
      try {
        final Map<String, dynamic> err = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(err['detail'] ?? 'Error al registrar evento de transporte');
      } catch (e) {
        if (e.toString().contains('Exception:')) rethrow;
        throw Exception('Error al registrar evento: ${response.statusCode}');
      }
    }
  }
}
