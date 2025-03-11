import 'dart:convert';

import 'package:fx_trading_signal/features/notification/domain/entities/getNotificatiobn.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/usecases/NotificatonResult.dart';
import '../repositories/nortificationRepo.dart';

class NotificationDatasourceImp implements NotificationDatasource {
  final HttpService httpService;

  NotificationDatasourceImp(this.httpService);
  @override
  @override
  Future<NotificatonResult> getNotifcation(userId) async {
    NotificatonResult notificatonResult =
        NotificatonResult(NotificationState.isEmpty, GetNotification());

    final response = await httpService.request(
      url: '/getNotification?userID=$userId',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      final decodedResponse = GetNotification.fromJson(response.data);
      notificatonResult =
          NotificatonResult(NotificationState.isData, decodedResponse);
    } else {
      final decodedResponse = GetNotification.fromJson(response.data);
      notificatonResult =
          NotificatonResult(NotificationState.isError, decodedResponse);
    }

    return notificatonResult;
  }
}
