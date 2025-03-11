import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/service/locator.dart';
import '../controller/auth_controller.dart';

final authproviderController =
    ChangeNotifierProvider((ref) => authController(locator()));
