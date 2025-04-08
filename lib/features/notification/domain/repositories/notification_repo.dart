import 'dart:developer';

import 'package:fx_trading_signal/features/notification/data/repositories/nortificationRepo.dart';
import 'package:fx_trading_signal/features/notification/domain/entities/getNotificatiobn.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../usecases/NotificatonResult.dart';

abstract class NotificationRepository {
  Future<NotificatonResult> getNotifcation(token);
}

class NotificationRepositoryImp implements NotificationRepository {
  final NotificationDatasource notificationDatasource;
  NotificationRepositoryImp(this.notificationDatasource);
  @override
  Future<NotificatonResult> getNotifcation(token) async {
    NotificatonResult notificatonResult =
        NotificatonResult(NotificationState.isEmpty, GetNotification());

    try {
      notificatonResult = await notificationDatasource.getNotifcation(token);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        notificatonResult = NotificatonResult(
            NotificationState.isError, GetNotification(msg: message));
      } else {
        notificatonResult = NotificatonResult(NotificationState.isError,
            GetNotification(msg: 'Something went wrong'));
      }
    }
    return notificatonResult;
  }
}
