import 'package:fx_trading_signal/features/notification/domain/usecases/NotificatonResult.dart';


abstract class NotificationDatasource {
  Future<NotificatonResult> getNotifcation(token);
}
