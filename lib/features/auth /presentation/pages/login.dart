import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/States/AuthResultState.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/snackBar.dart';
import '../../../../core/utils/appColors.dart';
import '../provider/auth_provider.dart';
import '../widgets/TextWidget.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 60),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Enter your email to sign in to your account',
                  style: TextStyle(fontSize: 14),
                ),
                Gap(30),
                CustomTextField(
                    width: 0.92,
                    title: 'Email Address',
                    isPassword: false,
                    controller: _emailController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      // Regular expression for a valid email format
                      final RegExp emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null; // No error if valid
                    }),
                Gap(30),
                CustomTextField(
                  width: 0.92,
                  title: 'Passowrd',
                  isPassword: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
                Gap(30),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'New to Trade Signal? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed('register');
                              },
                            text: ' Create Account',
                            style: TextStyle(color: AppColors.kprimaryColor300),
                          ),
                        ])),
                Gap(50),
                GestureDetector(
                  onTap: () async {
                    _submitForm(ref);
                  },
                  child: Container(
                      height: 54,
                      width: 305,
                      decoration: BoxDecoration(
                          color: AppColors.kprimaryColor300,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: Text('Continue with Email',
                            style: TextStyle(
                                color: AppColors.kWhite,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
                Gap(30),
                Center(
                    child: Text(
                  'or',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kgrayColor200),
                )),
                Gap(30),
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                      height: 54,
                      width: 305,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Soft shadow color
                              blurRadius: 10, // Spread of the shadow
                              offset: Offset(0, 4), // Moves shadow downward
                            ),
                          ],
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset('assets/images/google.png')),
                            Gap(20),
                            Text('Continue with Google',
                                style: TextStyle(
                                    color: AppColors.kBlack,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )),
                ),
                Gap(30),
                GestureDetector(
                  onTap: () async {},
                  child: Container(
                      height: 54,
                      width: 305,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Soft shadow color
                              blurRadius: 10, // Spread of the shadow
                              offset: Offset(0, 4), // Moves shadow downward
                            ),
                          ],
                          color: AppColors.kBlack,
                          borderRadius: BorderRadius.circular(100)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset('assets/images/apple.png')),
                            Gap(20),
                            Text('Continue with Apple',
                                style: TextStyle(
                                    color: AppColors.kWhite,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          )),
    );
  }

  void _submitForm(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with your logic

      SmartDialog.showLoading();
      await ref.read(authproviderController).login(
            _emailController.text,
            _passwordController.text,
          );
      SmartDialog.dismiss();
      if (ref.read(authproviderController).loginResult.state ==
          LoginState.isError) {
        SnackBarService.showSnackBar(context,
            title: "Error",
            status: SnackbarStatus.fail,
            body: ref.read(authproviderController).loginResult.response.msg ??
                '');
      } else if (ref.read(authproviderController).loginResult.state ==
          LoginState.isData) {
        if (ref
                .watch(authproviderController)
                .loginResult
                .response
                .user
                ?.verified ==
            false) {
          context.push('/otpVerification', extra: {
            "email": _emailController.text,
            "firstName": ref
                .read(authproviderController)
                .loginResult
                .response
                .user
                ?.firstname,
            "lastname": ref
                .read(authproviderController)
                .loginResult
                .response
                .user
                ?.lastname
          });
        } else if (ref
                .watch(authproviderController)
                .loginResult
                .response
                .user
                ?.completeprofile ==
            false) {
          context.push('/completeprofile', extra: {
            "email": _emailController.text,
            "firstName": ref
                .read(authproviderController)
                .loginResult
                .response
                .user
                ?.firstname,
            "lastname": ref
                .read(authproviderController)
                .loginResult
                .response
                .user
                ?.lastname
          });
        } else {
          final pref = await SharedPreferences.getInstance();
          pref.setString(
              'firstname',
              ref
                      .read(authproviderController)
                      .loginResult
                      .response
                      .user
                      ?.firstname ??
                  '');
          pref.setString(
              'lastname',
              ref
                      .read(authproviderController)
                      .loginResult
                      .response
                      .user
                      ?.lastname ??
                  '');
          pref.setString(
              'email',
              ref
                      .read(authproviderController)
                      .loginResult
                      .response
                      .user
                      ?.email ??
                  '');
          pref.setString(
              'imageUrl',
              ref
                      .read(authproviderController)
                      .loginResult
                      .response
                      .user
                      ?.imageUrl ??
                  '');
          pref.setString(
              'trading_experience',
              ref
                      .read(authproviderController)
                      .loginResult
                      .response
                      .user
                      ?.tradingExperience ??
                  '');
          pref.setString(
              'phoneNumber',
              ref
                      .read(authproviderController)
                      .loginResult
                      .response
                      .user
                      ?.phoneNumber ??
                  '');
          pref.setBool(
              'verified',
              ref
                      .read(authproviderController)
                      .loginResult
                      .response
                      .user
                      ?.verified ??
                  false);
          pref.setString(
              'token',
              ref.read(authproviderController).loginResult.response.token ??
                  '');

          SnackBarService.showSnackBar(context,
              title: "Success",
              status: SnackbarStatus.success,
              body: ref.read(authproviderController).loginResult.response.msg ??
                  '');
          context.pushReplacement('/homelanding');
        }
      }
    }
  }
}
