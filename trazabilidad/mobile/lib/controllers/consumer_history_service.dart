import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../core/secure_storage.dart';
import '../models/consumer_history_model.dart';

class ConsumerHistoryService {
  static Future<Map<String, String>> _getHeaders() async {
    final token = await SecureStorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<ConsumerHistoryModel> fetchHistory() async {
    final response = await http
        .get(Uri.parse(ApiConfig.consumerHistory), headers: await _getHeaders())
        .timeout(const Duration(seconds: 10));
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return ConsumerHistoryModel.fromJson(body as Map<String, dynamic>);
    }
    throw Exception(body['detail'] ?? 'Error al cargar el historial de compras');
  }
}
