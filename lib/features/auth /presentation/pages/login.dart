import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/States/AuthResultState.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constant/snackBar.dart';
import '../../../../core/utils/appColors.dart';
import '../../domain/entities/loginResponse.dart';
import '../provider/auth_provider.dart';
import '../widgets/TextWidget.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildWelcomeText(),
              const Gap(30),
              CustomTextField(
                width: 0.92,
                title: 'Email Address',
                isPassword: false,
                controller: _emailController,
                validator: _validateEmail,
              ),
              const Gap(30),
              CustomTextField(
                width: 0.92,
                title: 'Password',
                isPassword: true,
                controller: _passwordController,
                validator: _validatePassword,
              ),
              const Gap(30),
              _buildSignUpText(),
              const Gap(50),
              _buildEmailSignInButton(),
              const Gap(30),
              _buildDivider(),
              const Gap(30),
              _buildSocialSignInButton(
                assetPath: 'assets/images/google.png',
                buttonText: 'Continue with Google',
                backgroundColor: AppColors.kWhite,
                textColor: AppColors.kBlack,
                onTap: () {
                  // TODO: Implement Google sign in.
                },
              ),
              const Gap(30),
              _buildSocialSignInButton(
                assetPath: 'assets/images/apple.png',
                buttonText: 'Continue with Apple',
                backgroundColor: AppColors.kBlack,
                textColor: AppColors.kWhite,
                onTap: () {
                  // TODO: Implement Apple sign in.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome Back',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        Text(
          'Enter your email to sign in to your account',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSignUpText() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'New to Trade Signal? ',
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: 'Create Account',
              style: const TextStyle(color: AppColors.kprimaryColor300),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.pushNamed('register');
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSignInButton() {
    return GestureDetector(
      onTap: () async => _submitForm(ref),
      child: Container(
        height: 54,
        width: 305,
        decoration: BoxDecoration(
          color: AppColors.kprimaryColor300,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Center(
          child: Text(
            'Continue with Email',
            style: TextStyle(
              color: AppColors.kWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Center(
      child: Text(
        'or',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.kgrayColor200,
        ),
      ),
    );
  }

  Widget _buildSocialSignInButton({
    required String assetPath,
    required String buttonText,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: 305,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(assetPath),
              ),
              const Gap(20),
              Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'This field cannot be empty';
    return null;
  }

  Future<void> _submitForm(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    SmartDialog.showLoading();
    await ref.read(authproviderController).login(
          _emailController.text,
          _passwordController.text,
        );
    SmartDialog.dismiss();

    final authState = ref.read(authproviderController).loginResult.state;
    final authResponse = ref.read(authproviderController).loginResult.response;

    if (authState == LoginState.isError) {
      SnackBarService.showSnackBar(
        context,
        title: "Error",
        status: SnackbarStatus.fail,
        body: authResponse.msg ?? '',
      );
    } else if (authState == LoginState.isData) {
      if (authResponse.user?.verified == false) {
        context.push('/otpVerification', extra: {
          "email": _emailController.text,
          "firstName": authResponse.user?.firstname,
          "lastname": authResponse.user?.lastname,
        });
      } else if (authResponse.user?.completeprofile == false) {
        context.push('/completeprofile', extra: {
          "email": _emailController.text,
          "firstName": authResponse.user?.firstname,
          "lastname": authResponse.user?.lastname,
        });
      } else {
        await _saveUserData(authResponse);
        SnackBarService.showSnackBar(
          context,
          title: "Success",
          status: SnackbarStatus.success,
          body: authResponse.msg ?? '',
        );
        context.pushReplacement('/homelanding');
      }
    }
  }

  Future<void> _saveUserData(LoginResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    final tokenExpireDate = DateTime.now().add(Duration(hours: 24));
    await prefs.setString('tokenexpiredate', tokenExpireDate.toIso8601String());
    await prefs.setString('firstname', authResponse.user?.firstname ?? '');
    await prefs.setString('lastname', authResponse.user?.lastname ?? '');
    await prefs.setString('email', authResponse.user?.email ?? '');
    await prefs.setString('imageUrl', authResponse.user?.imageUrl ?? '');
    await prefs.setString(
        'trading_experience', authResponse.user?.tradingExperience ?? '');
    await prefs.setString('phoneNumber', authResponse.user?.phoneNumber ?? '');
    await prefs.setBool('verified', authResponse.user?.verified ?? false);
    await prefs.setString("userId", authResponse.user?.userId ?? '');
    await prefs.setString('token', authResponse.token ?? '');

    await prefs.setString('refreshtoken', authResponse.refreshToken ?? '');
    if (authResponse.user?.plan != null) {
      await prefs.setString('planId', authResponse.user?.plan?.planId ?? '');
      await prefs.setString('dateExpired',
          authResponse.user?.plan?.dateExpired?.toIso8601String() ?? '');
      await prefs.setString('datebought',
          authResponse.user?.plan?.dateBought?.toIso8601String() ?? '');
    }
  }
}
