import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/socket.dart';

final socketServiceProvider = Provider<SocketService>((ref) {
  final socketService = SocketService(ref);
  socketService.initialize();
  return socketService;
});
