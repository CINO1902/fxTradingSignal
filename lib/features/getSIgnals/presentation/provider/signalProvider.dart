import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/signalController.dart';


final signalController =
    ChangeNotifierProvider((ref) => SignalController(locator()));
