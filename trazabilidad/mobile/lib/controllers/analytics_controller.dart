import 'package:flutter/material.dart';

import '../models/analytics_model.dart';
import 'analytics_service.dart';

/// Estado del Panel Integral (CU-035): datos, carga, error y navegación por tabs.
class AnalyticsController extends ChangeNotifier {
  AnalyticsResponse? datos;
  bool isLoading = false;
  String? errorMessage;
  int tabIndex = 0;
  String metricaClave = '';

  Future<void> cargar({int meses = 36, int? idtenant}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      datos = await AnalyticsService.fetch(meses: meses, idtenant: idtenant);
      final series = datos?.series ?? <AnalyticsSerie>[];
      if (series.isEmpty) {
        metricaClave = '';
      } else if (!series.any((s) => s.clave == metricaClave)) {
        metricaClave = series.first.clave;
      }
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void cambiarTab(int indice) {
    if (indice < 0 || indice > 7 || indice == tabIndex) return;
    tabIndex = indice;
    notifyListeners();
  }

  void cambiarMetrica(String clave) {
    if (clave == metricaClave) return;
    metricaClave = clave;
    notifyListeners();
  }
}
