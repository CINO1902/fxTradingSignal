import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/Pricing/presentation/controller/planController.dart';

import '../../../../core/service/locator.dart';

final planProvider = ChangeNotifierProvider((ref) => PlanController(locator()));
