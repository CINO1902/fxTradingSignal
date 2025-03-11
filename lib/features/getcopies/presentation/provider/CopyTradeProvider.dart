import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/controller/controller.dart';

import '../../../../core/service/locator.dart';

final copyTradeController =
    ChangeNotifierProvider((ref) => CopyTradeContoller(locator()));
