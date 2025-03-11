import 'package:fx_trading_signal/features/notification/domain/entities/getNotificatiobn.dart';

class NotificatonResult {
  final NotificationState state;
  final GetNotification response;

  NotificatonResult(this.state, this.response);
}

enum NotificationState { isLoading, isError, isData, isEmpty, networkissue }
