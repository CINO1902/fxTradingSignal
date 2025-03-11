import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/constant/snackBar.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/States/AuthResultState.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../provider/auth_provider.dart';
import '../widgets/TextWidget.dart';

class Registration extends ConsumerStatefulWidget {
  const Registration({super.key});

  @override
  ConsumerState<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState<Registration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  PhoneNumber number =
      PhoneNumber(countryISOCode: '', countryCode: '', number: '');
  Country country = Country(
    name: "Nigeria",
    nameTranslations: {
      "sk": "Nigéria",
      "se": "Nigeria",
      "pl": "Nigeria",
      "no": "Nigeria",
      "ja": "ナイジェリア",
      "it": "Nigeria",
      "zh": "尼日利亚",
      "nl": "Nigeria",
      "de": "Nigeria",
      "fr": "Nigéria",
      "es": "Nigeria",
      "en": "Nigeria",
      "pt_BR": "Nigéria",
      "sr-Cyrl": "Нигерија",
      "sr-Latn": "Nigerija",
      "zh_TW": "奈及利亞",
      "tr": "Nijerya",
      "ro": "Nigeria",
      "ar": "نيجيريا",
      "fa": "نیجریه",
      "yue": "尼日利亞"
    },
    flag: "🇳🇬",
    code: "NG",
    dialCode: "234",
    minLength: 10,
    maxLength: 11,
  );
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
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Text(
                'Enter your email below to create your account',
                style: TextStyle(fontSize: 14),
              ),
              Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTextField(
                    context,
                    0.42,
                    'First Name',
                    _firstNameController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      } else if (value.length < 3) {
                        return 'Input must be at least 3 characters long';
                      }
                      return null;
                    },
                  ),
                  buildTextField(
                    context,
                    0.42,
                    'Last Name',
                    _lastNameController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      } else if (value.length < 3) {
                        return 'Input must be at least 3 characters long';
                      }
                      return null;
                    },
                  )
                ],
              ),
              Gap(30),
              buildTextField(context, 0.92, 'Email Address', _emailController,
                  (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Email cannot be empty';
                }
                // Regular expression for a valid email format
                final RegExp emailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null; // No error if valid
              }),
              Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number'),
                  Gap(10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: IntlPhoneField(
                      initialCountryCode: '+234',
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          number = value;
                        });
                      },
                      onCountryChanged: (value) {
                        setState(() {
                          country = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.kgrayColor50,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none, // Removes default border
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Color(0xff9C9FAC),
                          ), // Bottom border when not focused
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: AppColors.kprimaryColor300,
                              width: 2), // Bottom border when focused
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(20),
              CustomTextField(
                width: 0.92,
                title: 'Passowrd',
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 8) {
                    return 'Password must be at least 7 characters long';
                  }
                  return null;
                },
              ),
              Gap(30),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              GoRouter.of(context).go('/login');
                            },
                          text: ' Log In',
                          style: TextStyle(color: AppColors.kprimaryColor300),
                        ),
                      ])),
              Gap(30),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'By continuing, you agree to our ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: ' Terms of Service',
                          style: TextStyle(color: AppColors.kprimaryColor300),
                        ),
                        TextSpan(text: ' and'),
                        TextSpan(
                          text: ' Policy',
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
        ),
      ),
    );
  }

  void _submitForm(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with your logic
      if (_numberController.text.isEmpty) {
        SnackBarService.notifyAction(context,
            message: 'Phone Number field cannot be Empty',
            status: SnackbarStatus.fail);
      } else {
        SmartDialog.showLoading();
        await ref.read(authproviderController).register(
            _firstNameController.text,
            _lastNameController.text,
            number.countryCode + _numberController.text,
            _emailController.text,
            _passwordController.text,
            country.name);
        SmartDialog.dismiss();
        if (ref.read(authproviderController).registerResult.state ==
            RegisterState.isError) {
          SnackBarService.showSnackBar(context,
              title: "Error",
              status: SnackbarStatus.fail,
              body: ref
                      .read(authproviderController)
                      .registerResult
                      .response
                      .msg ??
                  '');
        } else if (ref.read(authproviderController).registerResult.state ==
            RegisterState.isData) {
          context.push('/otpVerification', extra: {
            "email": _emailController.text,
            "firstName": _firstNameController.text,
            "lastname": _lastNameController.text
          });
          SnackBarService.showSnackBar(context,
              title: "Success",
              status: SnackbarStatus.success,
              body: ref
                      .read(authproviderController)
                      .registerResult
                      .response
                      .msg ??
                  '');
        }
      }
    } else {
      if (_numberController.text.isEmpty) {
        SnackBarService.notifyAction(context,
            message: 'Phone Number field cannot be Empty',
            status: SnackbarStatus.fail);
      }
    }
  }

  Column buildTextField(BuildContext context, double width, String title,
      TextEditingController _controller, String? Function(String?)? validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Gap(10),
        SizedBox(
          width: MediaQuery.of(context).size.width * width,
          child: TextFormField(
            controller: _controller,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.kgrayColor50,
              border: OutlineInputBorder(
                borderSide: BorderSide.none, // Removes default border
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xff9C9FAC),
                ), // Bottom border when not focused
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: AppColors.kprimaryColor300,
                    width: 2), // Bottom border when focused
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
