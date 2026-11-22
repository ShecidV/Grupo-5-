import 'package:flutter/foundation.dart';
import 'consumer_history_service.dart';
import '../models/consumer_history_model.dart';

class ConsumerHistoryController extends ChangeNotifier {
  ConsumerHistoryModel? history;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      history = await ConsumerHistoryService.fetchHistory();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
