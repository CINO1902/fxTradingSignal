import 'package:dio/dio.dart';
import 'package:fx_trading_signal/features/getSIgnals/data/datasources/remoteDatasource.dart';
import 'package:fx_trading_signal/features/getSIgnals/data/repositories/signalRepo.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/repositories/signalRepo.dart';
import 'package:fx_trading_signal/features/getTraders/data/datasources/getTraderDataSource.dart';
import 'package:fx_trading_signal/features/getTraders/data/repositories/getTraderRepository.dart';
import 'package:fx_trading_signal/features/getTraders/domain/repositories/homeRepo.dart';
import 'package:fx_trading_signal/features/getcopies/domain/repositories/getCopyRepo.dart';
import 'package:fx_trading_signal/features/notification/data/datasources/remoteDatasource.dart';
import 'package:fx_trading_signal/features/notification/domain/repositories/notification_repo.dart';
import 'package:fx_trading_signal/features/notification/presentation/controller/notificationController.dart';

import 'package:get_it/get_it.dart';

import '../../features/auth /data/datasources/remotedatasource.dart';
import '../../features/auth /data/repositories/auth_repo.dart';
import '../../features/auth /domain/repositories/authrepo.dart';
import '../../features/auth /presentation/controller/auth_controller.dart';
import '../../features/getSIgnals/presentation/controller/signalController.dart';
import '../../features/getTraders/presentation/controller/homeProvider.dart';
import '../../features/getcopies/data/datasources/remoteDatasourse.dart';
import '../../features/getcopies/data/repositories/CopyTadeRepo.dart';
import '../../features/getcopies/presentation/controller/controller.dart';
import '../../features/notification/data/repositories/nortificationRepo.dart';
import 'dio_service.dart';
import 'http_service.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator
    ..registerLazySingleton<AuthDatasourceImp>(
        () => AuthDatasourceImp(locator()))
    ..registerLazySingleton<AuthDatasource>(() => AuthDatasourceImp(locator()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(locator()))
    ..registerLazySingleton(() => authController(locator()))
    //GetTrader
    ..registerLazySingleton<GetTraderDataSourceImp>(
        () => GetTraderDataSourceImp(locator()))
    ..registerLazySingleton<GetTraderDataSource>(
        () => GetTraderDataSourceImp(locator()))
    ..registerLazySingleton<GetTraderRepository>(
        () => GetTraderRepositoryImp(locator()))
    ..registerLazySingleton(() => homeController(locator()))
    //GetSignal
    ..registerLazySingleton<SignalDatasourceImp>(
        () => SignalDatasourceImp(locator()))
    ..registerLazySingleton<SignalDatasource>(
        () => SignalDatasourceImp(locator()))
    ..registerLazySingleton<SignalRepository>(
        () => SignalRepositoryImp(locator()))
    ..registerLazySingleton(() => SignalController(locator()))
    //CopyTrade
    ..registerLazySingleton<CopyTradeDatasouceImp>(
        () => CopyTradeDatasouceImp(locator()))
    ..registerLazySingleton<CopyTradeDatasouce>(
        () => CopyTradeDatasouceImp(locator()))
    ..registerLazySingleton<CopyTradeRepository>(
        () => CopyTradeRepositoryImp(locator()))
    ..registerLazySingleton(() => CopyTradeContoller(locator()))
    //Notification
    ..registerLazySingleton<NotificationDatasourceImp>(
        () => NotificationDatasourceImp(locator()))
    ..registerLazySingleton<NotificationDatasource>(
        () => NotificationDatasourceImp(locator()))
    ..registerLazySingleton<NotificationRepository>(
        () => NotificationRepositoryImp(locator()))
    ..registerLazySingleton(() => NotificationController(locator()))
    //packages
    ..registerLazySingleton<HttpService>(() => DioService(locator()))
    ..registerLazySingleton(() => Dio());
}
