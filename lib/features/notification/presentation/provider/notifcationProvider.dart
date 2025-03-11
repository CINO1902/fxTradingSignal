import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/core/service/locator.dart';
import 'package:fx_trading_signal/features/notification/presentation/controller/notificationController.dart';

final notificationproviderController =
    ChangeNotifierProvider((ref) => NotificationController(locator()));
