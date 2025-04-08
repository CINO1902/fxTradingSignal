import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/core/customTransition.dart';
import 'package:fx_trading_signal/features/Pricing/presentation/pages/plans.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/pages/completeProfile.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/pages/login.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/pages/otpVerification.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/pages/registration.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/pages/youAreSet.dart';
import 'package:fx_trading_signal/features/chat/presentation/pages/chatUi.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/pages/landingPage.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/pages/signalDetails.dart';
import 'package:fx_trading_signal/features/notification/presentation/pages/notification.dart';
import 'package:go_router/go_router.dart';

import '../features/init/presentation/pages/initScreen.dart';
import '../features/myProfile/presentation/pages/accountSettings.dart';
import '../features/myProfile/presentation/pages/helpAndSupport.dart';
import '../features/notification/presentation/pages/signalDetailsNotifcation.dart';

class AppRouter {
  AppRouter._();
  static GoRouter router = GoRouter(
    redirect: (context, state) {
      return null;
    },
    initialLocation: '/deciderScreen',
    observers: [FlutterSmartDialog.observer],
    routes: [
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const Registration(),
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Registration(),
        ),
      ),
      GoRoute(
          path: '/deciderScreen',
          name: 'deciderScreen',
          builder: (context, state) {
            return DeciderScreen();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: DeciderScreen(),
              )),
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return Login();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Login(),
              )),
      GoRoute(
          path: '/otpVerification',
          name: 'otpVerification',
          builder: (context, state) {
            return Login();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Otpverification(
                  email: (state.extra as Map)['email'],
                  firstName: (state.extra as Map)['firstName'],
                  lastname: (state.extra as Map)['lastname'],
                ),
              )),
      GoRoute(
          path: '/completeprofile',
          name: 'completeprofile',
          builder: (context, state) {
            return Completeprofile(
              firstName: (state.extra as Map)['firstName'],
              lastname: (state.extra as Map)['lastname'],
              email: (state.extra as Map)['email'],
            );
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Completeprofile(
                  firstName: (state.extra as Map)['firstName'],
                  lastname: (state.extra as Map)['lastname'],
                  email: (state.extra as Map)['email'],
                ),
              )),
      GoRoute(
          path: '/SignaldetailsNotification',
          name: 'SignaldetailsNotification',
          builder: (context, state) {
            return SignaldetailsNotification(
              refo: (state.extra as Map)['refo'],
              signalId: (state.extra as Map)['signalId'],
            );
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: SignaldetailsNotification(
                  refo: (state.extra as Map)['refo'],
                  signalId: (state.extra as Map)['signalId'],
                ),
              )),
      GoRoute(
          path: '/youareSet',
          name: 'youareSet',
          builder: (context, state) {
            return Youareset();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Youareset(),
              )),
      GoRoute(
          path: '/homelanding',
          name: 'homelanding',
          builder: (context, state) {
            return homelanding();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: homelanding(),
              )),
      GoRoute(
          path: '/notification',
          name: 'notification',
          builder: (context, state) {
            return NotificationPage();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: NotificationPage(),
              )),
      GoRoute(
          path: '/accountSettings',
          name: 'accountSettings',
          builder: (context, state) {
            return Accountsettings();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Accountsettings(),
              )),
      GoRoute(
          path: '/plans',
          name: 'plans',
          builder: (context, state) {
            return Plans();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Plans(),
              )),
      GoRoute(
          path: '/helpandsupports',
          name: 'helpandsupports',
          builder: (context, state) {
            return Helpandsupport();
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Helpandsupport(),
              )),
      GoRoute(
          path: '/chatUi',
          name: 'chatUi',
          builder: (context, state) {
            return ChatUI(
              UnreadMessage: (state.extra as Map)['UnreadMessage'],
              timeslastmessage: (state.extra as Map)['timeslastmessage'],
            );
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: ChatUI(
                  UnreadMessage: (state.extra as Map)['UnreadMessage'],
                  timeslastmessage: (state.extra as Map)['timeslastmessage'],
                ),
              )),
      GoRoute(
          path: '/signalDetails',
          name: 'signalDetails',
          builder: (context, state) {
            return Signaldetails(
              status: (state.extra as Map)['status'],
              signalId: (state.extra as Map)['signalId'],
              refo: (state.extra as Map)['refo'],
              pair: (state.extra as Map)['pair'],
              active: (state.extra as Map)['active'],
              entries: (state.extra as Map)['entries'],
              index: (state.extra as Map)['index'],
              accesstype: (state.extra as Map)['accesstype'],
              copyTraded: (state.extra as Map)['copyTraded'],
              order: (state.extra as Map)['order'],
              stoploss: (state.extra as Map)['stoploss'],
              takeprofit: (state.extra as Map)['takeprofit'],
              createdDate: (state.extra as Map)['createdDate'],
              entry: (state.extra as Map)['entry'],
            );
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: Signaldetails(
                  status: (state.extra as Map)['status'],
                  signalId: (state.extra as Map)['signalId'],
                  refo: (state.extra as Map)['refo'],
                  index: (state.extra as Map)['index'],
                  entries: (state.extra as Map)['entries'],
                  active: (state.extra as Map)['active'],
                  pair: (state.extra as Map)['pair'],
                  copyTraded: (state.extra as Map)['copyTraded'],
                  accesstype: (state.extra as Map)['accesstype'],
                  order: (state.extra as Map)['order'],
                  stoploss: (state.extra as Map)['stoploss'],
                  takeprofit: (state.extra as Map)['takeprofit'],
                  createdDate: (state.extra as Map)['createdDate'],
                  entry: (state.extra as Map)['entry'],
                ),
              ))
    ],
  );
}
