import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/chat/presentation/controller.dart/chat_controller.dart';

import '../../../../core/service/locator.dart';

final chatProviderController =
    ChangeNotifierProvider((ref) => ChatController(locator()));
