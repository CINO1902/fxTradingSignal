import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/myProfile/presentation/controller/profileController.dart';

import '../../../../core/service/locator.dart';

final profileproviderController =
    ChangeNotifierProvider((ref) => Profilecontroller(locator()));
