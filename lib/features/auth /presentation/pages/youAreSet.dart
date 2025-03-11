import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/appColors.dart';

class Youareset extends StatefulWidget {
  const Youareset({super.key});

  @override
  State<Youareset> createState() => _YouaresetState();
}

class _YouaresetState extends State<Youareset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * .96,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'You\'re All Set!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Gap(40),
            Text(
              'Your profile is complete and ready to stary',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Gap(40),
            GestureDetector(
              onTap: () async {
                context.pushReplacement('/login');
              },
              child: Container(
                  height: 54,
                  width: 305,
                  decoration: BoxDecoration(
                      color: AppColors.kprimaryColor300,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Text('Start Exploring',
                        style: TextStyle(
                            color: AppColors.kWhite,
                            fontWeight: FontWeight.bold)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
