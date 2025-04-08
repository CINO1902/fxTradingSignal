import 'package:dio/dio.dart';
import 'package:fx_trading_signal/features/Pricing/domain/repositories/priceRepo.dart';
import 'package:fx_trading_signal/features/Pricing/presentation/controller/planController.dart';
import 'package:fx_trading_signal/features/chat/data/datasources/remoteDataSource.dart';
import 'package:fx_trading_signal/features/chat/data/repositories/chat_repo.dart';
import 'package:fx_trading_signal/features/chat/domain/repositories/chat_repo.dart';
import 'package:fx_trading_signal/features/chat/presentation/controller.dart/chat_controller.dart';
import 'package:fx_trading_signal/features/getSIgnals/data/datasources/remoteDatasource.dart';
import 'package:fx_trading_signal/features/getSIgnals/data/repositories/signalRepo.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/repositories/signalRepo.dart';
import 'package:fx_trading_signal/features/getTraders/data/datasources/getTraderDataSource.dart';
import 'package:fx_trading_signal/features/getTraders/data/repositories/getTraderRepository.dart';
import 'package:fx_trading_signal/features/getTraders/domain/repositories/homeRepo.dart';
import 'package:fx_trading_signal/features/getcopies/domain/repositories/getCopyRepo.dart';
import 'package:fx_trading_signal/features/myProfile/data/datasources/remoteDatasource.dart';
import 'package:fx_trading_signal/features/myProfile/data/repositories/profileRepo.dart';
import 'package:fx_trading_signal/features/myProfile/domain/repositories/profileRepository.dart';
import 'package:fx_trading_signal/features/myProfile/presentation/controller/profileController.dart';
import 'package:fx_trading_signal/features/notification/data/datasources/remoteDatasource.dart';
import 'package:fx_trading_signal/features/notification/domain/repositories/notification_repo.dart';
import 'package:fx_trading_signal/features/notification/presentation/controller/notificationController.dart';

import 'package:get_it/get_it.dart';

import '../../features/Pricing/data/datasources/remoteDatasource.dart';
import '../../features/Pricing/data/repositories/planDataRepo.dart';
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
    //Profile
    ..registerLazySingleton<ProfileDataSourceImp>(
        () => ProfileDataSourceImp(locator()))
    ..registerLazySingleton<ProfileDataSource>(
        () => ProfileDataSourceImp(locator()))
    ..registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImp(locator()))
    ..registerLazySingleton(() => Profilecontroller(locator()))
    //Plans
    ..registerLazySingleton<PlanDataSourceImp>(
        () => PlanDataSourceImp(locator()))
    ..registerLazySingleton<PlanDataSource>(() => PlanDataSourceImp(locator()))
    ..registerLazySingleton<PlanRepository>(() => PlanRepositoryImp(locator()))
    ..registerLazySingleton(() => PlanController(locator()))
    //Chat
    ..registerLazySingleton<ChatDatasourceImp>(
        () => ChatDatasourceImp(locator()))
    ..registerLazySingleton<ChatDatasource>(() => ChatDatasourceImp(locator()))
    ..registerLazySingleton<ChatRepository>(() => chatRepositoryImp(locator()))
    ..registerLazySingleton(() => ChatController(locator()))
    //packages
    ..registerLazySingleton<HttpService>(() => DioService(locator()))
    ..registerLazySingleton(() => Dio());
}
