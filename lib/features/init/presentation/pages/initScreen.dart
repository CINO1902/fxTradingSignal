import 'package:flutter/material.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/pages/login.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/pages/landingPage.dart';
import 'package:fx_trading_signal/features/init/presentation/pages/onboardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeciderScreen extends StatefulWidget {
  @override
  _DeciderScreenState createState() => _DeciderScreenState();
}

class _DeciderScreenState extends State<DeciderScreen> {
  bool? hasSeenOnboarding;
  String? token;

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
  }

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen_onboarding') ?? false;
    token = prefs.getString('token');
    setState(() {
      hasSeenOnboarding = seen;
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasSeenOnboarding == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return token != null
        ? homelanding()
        : hasSeenOnboarding!
            ? Login()
            : onBoarding();
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Home Screen")),
    );
  }
}
