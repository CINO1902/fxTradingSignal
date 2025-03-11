import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/homeProvider.dart';

final getTraderController =
    ChangeNotifierProvider((ref) => homeController(locator()));
