import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../core/secure_storage.dart';
import '../models/qr_model.dart';

class QrService {
  static Future<List<UnitQrModel>> fetchUnits({bool? tieneQr, String? search}) async {
    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception('No autenticado.');

    final queryParams = <String, String>{};
    if (tieneQr != null) queryParams['tiene_qr'] = tieneQr.toString();
    if (search != null && search.trim().isNotEmpty) queryParams['search'] = search.trim();

    final uri = Uri.parse(ApiConfig.qrUnits).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((item) => UnitQrModel.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      await SecureStorageService.deleteToken();
      throw Exception('Sesión expirada. Inicie sesión nuevamente.');
    } else {
      throw Exception('Error al cargar unidades: ${response.statusCode}');
    }
  }

  static Future<GenerateQrResultModel> generateQr(int idunidad) async {
    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception('No autenticado.');

    final uri = Uri.parse('${ApiConfig.qrGenerate}/$idunidad');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return GenerateQrResultModel.fromJson(data);
    } else {
      throw Exception('Error al generar código QR: ${response.statusCode}');
    }
  }

  static Future<Uint8List> fetchQrImageBytes(int idunidad) async {
    final token = await SecureStorageService.getToken();
    if (token == null) throw Exception('No autenticado.');

    final uri = Uri.parse('${ApiConfig.qrBase}/$idunidad/image');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error al descargar imagen QR.');
    }
  }
}
