import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotification();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final _messages = FirebaseMessaging.instance;
  final _localnotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationInitiazed = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);

    await _requestPermission();

    await _setupMessageHandlers();
    await _messages.getAPNSToken();
    final token = await _messages.getToken();
    final pref = await SharedPreferences.getInstance();
    pref.setString('fcmtoken', token ?? '');
    print('FCM token $token');
  }

  Future<void> _requestPermission() async {
    final settings = await _messages.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        criticalAlert: true);

    print('Permision Status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotification() async {
    if (_isFlutterLocalNotificationInitiazed) {
      return;
    }
    const channel = AndroidNotificationChannel(
        'high_importance_channel', 'High Importance Notification',
        description: 'This channel is used for important notification',
        importance: Importance.high);

    await _localnotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initizationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_Launcher');

    final initializationSettingDarwin = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
        android: initizationSettingsAndroid, iOS: initializationSettingDarwin);

    await _localnotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localnotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notification',
                channelDescription:
                    'This channel is used for important notification',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_Launcher',
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              )),
          payload: message.data.toString());
    }
  }

  Future _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handlebackgroundmessage);
    final initialMessage = await _messages.getInitialMessage();
    if (initialMessage != null) {
      _handlebackgroundmessage(initialMessage);
    }
  }

  void _handlebackgroundmessage(RemoteMessage message) {
    if (message.data['type'] == 'Chat') {}
  }
}
