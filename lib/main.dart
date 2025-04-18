import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/constant/notification.dart';
import 'package:fx_trading_signal/firebase_options.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'core/router.dart';
import 'core/service/locator.dart';
import 'features/chat/domain/usecases/sqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Firebase;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final DatabaseHelper _dbHelper = DatabaseHelper();
  _dbHelper.database;

  await NotificationService.instance.initialize();
  _initialiseRevenueCat();
  runApp(const MyApp());
  setup();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'FX Trading Signal',
        // navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}

Future<void> _initialiseRevenueCat() async {
  print('revenue initialized');
  await Purchases.setLogLevel(LogLevel.verbose);

  PurchasesConfiguration configuration;

  configuration = PurchasesConfiguration('appl_tUYkbfekpqmwYYqQYVDoHpsYbXN');

  await Purchases.configure(configuration..appUserID);
}
