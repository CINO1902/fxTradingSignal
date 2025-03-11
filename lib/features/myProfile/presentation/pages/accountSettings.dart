import 'package:flutter/material.dart';

import '../../../../core/utils/appColors.dart';

class Accountsettings extends StatefulWidget {
  const Accountsettings({super.key});

  @override
  State<Accountsettings> createState() => _AccountsettingsState();
}

class _AccountsettingsState extends State<Accountsettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kgrayColor50,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Account Settings',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
