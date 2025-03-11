import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/controller/controller.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/provider/CopyTradeProvider.dart';
import 'package:fx_trading_signal/features/notification/presentation/provider/notifcationProvider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../features/getSIgnals/domain/entities/SignalResponse.dart';
import '../../features/getSIgnals/presentation/provider/signalProvider.dart';
import '../../features/getTraders/domain/entities/getPricesPerModel.dart';
import '../../features/getTraders/presentation/widgets/traderWidget.dart';
import '../../features/notification/domain/entities/getNotificatiobn.dart';

class SocketService {
  final Ref ref;
  late IO.Socket socket;
  final StreamController<dynamic> _streamController =
      StreamController.broadcast();

  SocketService(this.ref) {
    // Connect to the default namespace by using the root URL.
    // socket = IO
    //     .io('https://fxwebsocket-production.up.railway.app', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': true,
    // });

    socket = IO.io('ws://192.168.0.100:4000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
  }

  void initialize() {
    socket.connect();

    // Listen for the 'documentUpdated' event (make sure the event name matches the server)
    socket.on('documentInserted', (data) {
      final newSignal = Signal.fromJson(data);
      print(newSignal);
      ref.read(signalController).updateSignalFromSocket(newSignal, ref);
      ref.read(copyTradeController).updateCopyTradeFromSocket(newSignal, ref);
    });

    socket.on('priceUpdated', (data) {
      final newprice = PricesList.fromJson(data);
      final pair = newprice.pair ?? '';
      ref.read(getpriceProvider(pair).notifier).state = newprice;
    });

    socket.on('notificationUpdated', (data) {
      final newNotification = Notification.fromJson(data);
      ref
          .read(notificationproviderController)
          .updateNotificationFromSocket(newNotification, ref);
      // ref.read(getpriceProvider(pair).notifier).state = newprice;
    });

    // Listen for a generic 'message' event.
    socket.on('message', (data) {
      print('Received message: $data');
      _streamController.sink.add(data);
    });

    // Listen for disconnection.
    socket.on('disconnect', (_) {
      print('Disconnected from the socket server');
    });

    // Listen for errors.
    socket.on('error', (error) {
      print('Socket error: $error');
    });
  }

  Stream<dynamic> get stream => _streamController.stream;

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }

  void dispose() {
    socket.dispose();
    _streamController.close();
  }
}
