import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/chat/domain/usecases/sqlite.dart';
import 'package:fx_trading_signal/features/chat/presentation/pages/chatUi.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/controller/controller.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/provider/CopyTradeProvider.dart';
import 'package:fx_trading_signal/features/notification/presentation/provider/notifcationProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    socket = IO
        .io('https://fxwebsocket-production.up.railway.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    // socket = IO.io('ws://192.168.0.100:4000/', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
  }

  void initialize() {
    socket.connect();
    print('Connected Initialized');
    socket.on('connect', (_) {
      onReconnect(); // Trigger sending pending messages when the socket reconnects
    });
    // Existing event listeners...
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

    // Listen for new messages from the server
    socket.on('newMessage', (data) async {
      if (data['message'] != null) {
        print('New message received: ${data['message']}');

        // DatabaseHelper().updateMessageStatus(data['message']['messageId'], 1,
        //     data['message']['createdAt'], data['message']['_id']);
        final pref = await SharedPreferences.getInstance();
        final email = pref.getString('email');

        int? insertedId;

        final message = data['message'];

// Extract message IDs safely
        final messageIdSender = message['messageId_sender'];
        final messageIdReceiver = message['messageId_receiver'];

        if (messageIdSender != null && messageIdSender.contains('_')) {
          final idSender = messageIdSender.split('_')[1];

          if (idSender == email) {
            insertedId = int.tryParse(messageIdSender.split('_')[0]);
          }
        }

        if (insertedId == null &&
            messageIdReceiver != null &&
            messageIdReceiver.contains('_')) {
          insertedId = int.tryParse(messageIdReceiver.split('_')[0]);
        }
        pref.setString('convoId', data['message']['conversation']);
        ref.read(convoMongoProvider.notifier).state =
            data['message']['conversation'];
        DatabaseHelper().upsertMessage(
            id: insertedId,
            message: {
              'conversationId': data['message']['conversation'],
              'sender': data['message']['sender'],
              'content': data['message']['content'],
              'timestamp': data['message']['createdAt'],
              'isSent': 1,
              'isRead': data['message']['isRead'],
              'mongooseId': data['message']['_id'],
            },
            isSent: 1,
            timestamp: data['message']['createdAt'],
            mongooseId: data['message']['_id'],
            conversation: data['message']['conversation'],
            isRead: data['message']['isRead']);
      }
      // Handle the received data (update UI, state management, etc.)
      // For example: ref.read(chatController).addMessage(data);
    });

    socket.on('messageDeleted', (data) {
      print('New message received: $data');
      String newMessageId = data['messageId'].toString();
      DatabaseHelper().deleteMessage(newMessageId);
      // Handle the received data (update UI, state management, etc.)
      // For example: ref.read(chatController).addMessage(data);
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the socket server');
    });

    socket.on('error', (error) {
      print('Socket error: $error');
    });
  }

  void updateMessage({
    required String messageId,
  }) {
    final payload = {
      'messageId': messageId,
    };
    socket.emit('updateMessage', payload);
  }

  /// Sends a message to the server.
  /// The backend will automatically create the conversation if it does not exist.
  void sendMessage({
    required String sender,
    required String messageId,
    required String conversationId,
    required String recipient,
    required String content,
  }) {
    final payload = {
      'sender': sender,
      'messageId': messageId,
      'conversationId': conversationId,
      'recipient': recipient,
      'content': content,
    };
    print(payload);
    socket.emit('sendMessage', payload);
  }

  void onReconnect() async {
    print('Reconnected to the socket server');
    final pendingMessage = await DatabaseHelper().getPendingMessages();

    for (var pend in pendingMessage) {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      final uniqueMessageId = "${pend['id']}_$email";
      final uniqueConvoId = "${pend['convoId']}_$email";
      final payload = {
        'sender': 'Admin',
        'messageId': uniqueMessageId,
        'conversationId': uniqueConvoId,
        'recipient': pend['recipient'],
        'content': pend['content'],
      };
      socket.emit('sendMessage', payload);
    }
  }

  Stream<dynamic> get stream => _streamController.stream;

  void dispose() {
    socket.dispose();
    _streamController.close();
  }
}
