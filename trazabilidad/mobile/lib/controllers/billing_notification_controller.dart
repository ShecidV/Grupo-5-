import 'package:flutter/foundation.dart';
import 'billing_notification_service.dart';
import '../models/billing_notification_model.dart';

class BillingNotificationController extends ChangeNotifier {
  BillingNotificationsResponse? response;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      response = await BillingNotificationService.fetchNotifications();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
