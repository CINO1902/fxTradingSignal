import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/notification/domain/repositories/notification_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/getNotificatiobn.dart';
import '../../domain/usecases/NotificatonResult.dart';

class NotificationController with ChangeNotifier {
  final NotificationRepository notificationRepository;
  NotificationController(this.notificationRepository);

  NotificatonResult notificatonResult =
      NotificatonResult(NotificationState.isLoading, GetNotification());

  List<Notification> notification = [];

  Future<void> getNotificationn() async {
    notificatonResult =
        NotificatonResult(NotificationState.isLoading, GetNotification());
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token') ?? '';
    final response = await notificationRepository.getNotifcation(token);
    notificatonResult = response;
    notification = response.response.notifications ?? [];
    notifyListeners();
  }

  Future<void> reverseNotification() async {
    notificatonResult =
        NotificatonResult(NotificationState.isLoading, GetNotification());

    notifyListeners();
  }

  void updateNotificationFromSocket(Notification newNotification, Ref ref) {
    // final signals = signalResponseResult.response.signals;
    // final List<Notification> not = ref.read(signalProvider.notifier).state;
    // // if (signals == null) return;

    // final index =
    //     signals.indexWhere((signal) => signal.signalId == newSignal.signalId);

    // print(newSignal);

    // Optionally add the signal if not found.
    notification.insert(0, newNotification);
    notifyListeners();
  }
}
