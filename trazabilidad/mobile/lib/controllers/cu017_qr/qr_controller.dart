import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/qr_model.dart';
import 'qr_service.dart';

class QrController extends ChangeNotifier {
  List<UnitQrModel> units = [];
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  bool? filterTieneQr;
  String searchQuery = '';

  Future<void> loadUnits() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      units = await QrService.fetchUnits(tieneQr: filterTieneQr, search: searchQuery);
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(bool? tieneQr) {
    filterTieneQr = tieneQr;
    loadUnits();
  }

  void setSearch(String query) {
    searchQuery = query;
    loadUnits();
  }

  Future<GenerateQrResultModel?> generateQr(int idunidad) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await QrService.generateQr(idunidad);
      successMessage = 'Código QR generado correctamente.';
      await loadUnits();
      return res;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<Uint8List?> getQrImageBytes(int idunidad) async {
    try {
      return await QrService.fetchQrImageBytes(idunidad);
    } catch (e) {
      errorMessage = 'Error al cargar imagen QR.';
      notifyListeners();
      return null;
    }
  }
}
