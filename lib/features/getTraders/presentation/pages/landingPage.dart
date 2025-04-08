import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/provider/auth_provider.dart';
import 'package:fx_trading_signal/features/getSIgnals/presentation/pages/signals.dart';
import 'package:fx_trading_signal/features/getSIgnals/presentation/provider/signalProvider.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/pages/home.dart';
import 'package:fx_trading_signal/features/getcopies/presentation/pages/copies.dart';
import 'package:fx_trading_signal/features/myProfile/presentation/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/snackBar.dart';

class homelanding extends ConsumerStatefulWidget {
  const homelanding({Key? key}) : super(key: key);

  @override
  ConsumerState<homelanding> createState() => _homelandingState();
}

class _homelandingState extends ConsumerState<homelanding> {
  int currentIndex = 0;
  Timer? _tokenRefreshTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SmartDialog.dismiss();
    _startTokenRefreshWatcher();
  }

  static const screens = [
    home(),
    SignalsPages(),
    Copies(),
    Profile(),
  ];

  void _startTokenRefreshWatcher() {
    _tokenRefreshTimer =
        Timer.periodic(const Duration(minutes: 5), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final tokenExpireDateString = prefs.getString('tokenexpiredate');

      if (tokenExpireDateString != null) {
        final tokenExpireDate = DateTime.tryParse(tokenExpireDateString);
        final now = DateTime.now();

        if (tokenExpireDate != null) {
          final minutesUntilExpire = tokenExpireDate.difference(now).inMinutes;
          if (minutesUntilExpire <= 30) {
            // Token is about to expire. Refresh the token.
            await ref.read(authproviderController).refreshToken(ref);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(signalController);
    if (controller.newSignalAdded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackBarService.showSnackBar(context,
            title: "New Signal Added",
            status: SnackbarStatus.info,
            body: ref.watch(signalController).message);
        // Reset the flag after showing the SnackBar.
        ref.read(signalController).resetNewSignalFlag();
      });
    } else if (controller.newSignalUpdated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackBarService.showSnackBar(context,
            title: "New Signal Updated",
            status: SnackbarStatus.info,
            body: ref.watch(signalController).message);
        // Reset the flag after showing the SnackBar.
        ref.read(signalController).resetNewSignalFlag();
      });
    }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          //backgroundColor: Theme.of(context).primaryColor,
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
                currentIndex = index;
              }),
          selectedItemColor: Theme.of(context).primaryColor,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedItemColor: Theme.of(context).colorScheme.onBackground,
          items: [
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/svg/home-2.svg',
                color: AppColors.kprimaryColor300,
              ),
              icon: SvgPicture.asset('assets/svg/home-2.svg',
                  color: AppColors.kgrayColor100),
              label: 'Home',
              //  backgroundColor: Color.fromARGB(200, 39, 39, 39),
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/svg/trend-up.svg',
                color: AppColors.kprimaryColor300,
              ),
              icon: SvgPicture.asset('assets/svg/trend-up.svg',
                  color: AppColors.kgrayColor100),
              label: 'Signals',
              //  backgroundColor: Color.fromARGB(200, 39, 39, 39),
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/svg/copy-success.svg',
                color: AppColors.kprimaryColor300,
              ),
              icon: SvgPicture.asset('assets/svg/copy-success.svg',
                  color: AppColors.kgrayColor100),
              label: 'My copies',
              // backgroundColor: Color.fromARGB(200, 39, 39, 39),
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                'assets/svg/user.svg',
                color: AppColors.kprimaryColor300,
              ),
              icon: SvgPicture.asset('assets/svg/user.svg',
                  color: AppColors.kgrayColor100),
              label: 'Profile',
              //  backgroundColor: Color.fromARGB(200, 39, 39, 39),
            )
          ]),
    );
  }
}
