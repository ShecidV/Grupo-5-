import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../core/secure_storage.dart';
import '../models/analytics_model.dart';

/// Servicio del Panel Integral (CU-035): GET /reports/analytics.
class AnalyticsService {
  static const Duration _timeout = Duration(seconds: 15);

  static Future<Map<String, String>> _authHeaders() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.trim().isEmpty) {
      throw Exception('No autenticado. Inicie sesión nuevamente.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static String _errorMessage(http.Response response) {
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is Map && data['detail'] != null) {
        final detail = data['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          return detail.map((e) => e.toString()).join('\n');
        }
        return detail.toString();
      }
    } catch (_) {}
    return 'Error al consultar el panel integral (${response.statusCode}).';
  }

  static Future<AnalyticsResponse> fetch({
    int meses = 36,
    int? idtenant,
  }) async {
    final headers = await _authHeaders();
    final queryParameters = <String, String>{'meses': meses.toString()};
    if (idtenant != null) {
      queryParameters['idtenant'] = idtenant.toString();
    }

    final uri = Uri.parse(ApiConfig.reportsAnalytics)
        .replace(queryParameters: queryParameters);

    http.Response response;
    try {
      response = await http.get(uri, headers: headers).timeout(_timeout);
    } on SocketException {
      throw Exception('No se pudo conectar con el servidor en ${ApiConfig.baseUrl}.');
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado al consultar el panel integral.');
    } on http.ClientException catch (e) {
      throw Exception('Fallo de conexión al consultar el panel integral: ${e.message}');
    } catch (e) {
      throw Exception('Error de red al consultar el panel integral: $e');
    }

    if (response.statusCode != 200) {
      throw Exception(_errorMessage(response));
    }

    dynamic data;
    try {
      data = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      throw Exception('Respuesta no válida del servidor (${response.statusCode}).');
    }

    if (data is! Map<String, dynamic>) {
      throw Exception('Formato inesperado del panel integral.');
    }
    return AnalyticsResponse.fromJson(data);
  }
}
