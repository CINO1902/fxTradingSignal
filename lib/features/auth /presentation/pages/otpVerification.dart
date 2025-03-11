import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/core/router.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/States/AuthResultState.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/provider/auth_provider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../constant/snackBar.dart';

class Otpverification extends ConsumerStatefulWidget {
  const Otpverification(
      {super.key,
      required this.email,
      required this.firstName,
      required this.lastname});
  final String email;
  final String firstName;
  final String lastname;
  @override
  ConsumerState<Otpverification> createState() => _OtpverificationState();
}

class _OtpverificationState extends ConsumerState<Otpverification> {
  int _secondsRemaining = 30; // Start from 30 seconds
  late Timer _timer;
  bool completePin = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    requestOtp();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  void requestOtp() async {
    SmartDialog.showLoading();
    await ref.read(authproviderController).requestOtp(widget.email);
    setState(() {
      _secondsRemaining = 30;
    });
    startTimer();
    SmartDialog.dismiss();
  }

  String? currentText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 60),
        child: ListView(
          children: [
            Text(
              'Verify Your Email',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Text(
              'We\'ve sent a verification code to ${widget.email}',
              style: TextStyle(fontSize: 14),
            ),
            Gap(20),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              animationDuration: Duration(milliseconds: 300),
              // onChanged: (value) {
              //   setState(() {
              //     currentText = value;
              //   });
              // },
              onChanged: (value) {
                setState(() {
                  currentText = value;
                });

                if (value.length < 6) {
                  completePin = false;
                  print("Incomplete PIN");
                } else {
                  completePin = true;
                }
              },
              // onCompleted: (value) {
              //   setState(() {
              //     currentText = value;
              //   });
              // },
              cursorColor: AppColors.kprimaryColor300,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box, // Makes each digit inside a box
                borderRadius: BorderRadius.circular(8), // Rounded corners
                fieldHeight: 50,
                fieldWidth: 40,

                activeFillColor: AppColors.kgrayColor50,
                inactiveFillColor: AppColors.kgrayColor50,
                selectedFillColor: AppColors.kgrayColor50,
                activeColor:
                    AppColors.kprimaryColor300, // Border color when active
                inactiveColor: Color(0xffF3F3F5), // Border color when inactive
                selectedColor: Color(0xffF3F3F5), // Border color when selected
                borderWidth: 2,
              ),
              enableActiveFill: true,
            ),
            Gap(20),
            _secondsRemaining == 0
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        requestOtp();
                      },
                      child: Text(
                        'Requst Otp',
                        style: TextStyle(color: AppColors.kprimaryColor300),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'You can request a code in $_secondsRemaining seconds',
                    ),
                  ),
            Gap(100),
            GestureDetector(
              onTap: () async {
                if (completePin == true) {
                  SmartDialog.showLoading();
                  await ref
                      .read(authproviderController)
                      .verifyOtp(widget.email, currentText);

                  SmartDialog.dismiss();
                  if (ref.read(authproviderController).verifyOtpResult.state ==
                      VerifyOtpResultState.isError) {
                    SnackBarService.showSnackBar(context,
                        title: "Error",
                        status: SnackbarStatus.fail,
                        body: ref
                            .read(authproviderController)
                            .verifyOtpResult
                            .response['message']);
                  } else if (ref
                          .read(authproviderController)
                          .verifyOtpResult
                          .state ==
                      VerifyOtpResultState.isData) {
                    context.push('/completeprofile', extra: {
                      "firstName": widget.firstName,
                      "lastname": widget.lastname,
                      "email": widget.email
                    });
                    SnackBarService.showSnackBar(context,
                        title: "Success",
                        status: SnackbarStatus.success,
                        body: ref
                            .read(authproviderController)
                            .verifyOtpResult
                            .response['message']);
                  }
                }
              },
              child: Container(
                  height: 54,
                  width: 305,
                  decoration: BoxDecoration(
                      color: completePin
                          ? AppColors.kprimaryColor300
                          : AppColors.kgrayColor100,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Text('Verify and Continue',
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
