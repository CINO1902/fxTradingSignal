import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/States/AuthResultState.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/provider/auth_provider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../constant/snackBar.dart';
import '../../../../core/utils/appColors.dart';

class Completeprofile extends ConsumerStatefulWidget {
  const Completeprofile(
      {super.key,
      required this.firstName,
      required this.lastname,
      required this.email});

  final String firstName;
  final String lastname;
  final String email;

  @override
  ConsumerState<Completeprofile> createState() => _CompleteprofileState();
}

class _CompleteprofileState extends ConsumerState<Completeprofile> {
  int SelectedNumber = 5;
  bool recieveSignal = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(authproviderController).pickimageupdate();
                print('object is picked');
              },
              child: Container(
                height: 83,
                width: 83,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kprimaryColor50,
                ),
                child: ref.watch(authproviderController).imageloading
                    ? Center(child: CircularProgressIndicator())
                    : ref.watch(authproviderController).image == null
                        ? Center(
                            // Ensures the image is centered within the container
                            child: Image.asset(
                              'assets/images/camera.png',
                              height: 30, // Directly set the image height
                              width: 30, // Directly set the image width
                            ),
                          )
                        : Center(
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(83),
                            child: Image.file(
                              ref.watch(authproviderController).image!,
                              fit: BoxFit.cover,
                              width: 83,
                              height: 83,
                            ),
                          )),
              ),
            ),
            Gap(10),
            Center(
              child: Text(
                'Add a profile picture',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.kgrayColor100),
              ),
            ),
            Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextField(
                  context,
                  0.42,
                  'First Name',
                  widget.firstName,
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
                  widget.lastname,
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
            // buildTextField(context, 0.92, 'User Name', _username,
            //     (String? value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Email cannot be empty';
            //   } else if (value.length < 3) {
            //     return 'Input must be at least 3 characters long';
            //   }
            //   return null;
            // }),
            // Gap(30),
            Text('Trading Experience'),
            Gap(10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              tradeExperience(1, 'Beginner'),
              tradeExperience(2, 'Intermediate'),
            ]),
            Gap(10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              tradeExperience(3, 'Advanced'),
              tradeExperience(4, 'Professional'),
            ]),
            Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Signal Notification',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.kprimaryColor300),
                      ),
                      Gap(10),
                      Text(
                        'Get Notified about new Signals',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.kgrayColor100),
                      )
                    ],
                  ),
                ),
                CupertinoSwitch(
                  activeColor: AppColors.kprimaryColor300,
                  value: recieveSignal,
                  onChanged: (newValue) {
                    setState(() {
                      recieveSignal = newValue;
                    });
                  },
                ),
              ],
            ),
            Gap(40),
            GestureDetector(
              onTap: () async {
                if (!(ref.watch(authproviderController).image == null &&
                    SelectedNumber != 5)) {
                  String getexperience() {
                    String experience = '';
                    if (SelectedNumber == 1) {
                      return experience = "Beginner";
                    } else if (SelectedNumber == 2) {
                      return experience = "Intermediate";
                    } else if (SelectedNumber == 3) {
                      return experience = "Advanced";
                    } else if (SelectedNumber == 4) {
                      return experience = "Professional";
                    }
                    return experience;
                  }

                  SmartDialog.showLoading();

                  await ref.read(authproviderController).uploadImage(
                      widget.email, recieveSignal, getexperience());
                  if (ref
                          .read(authproviderController)
                          .completeProfileResult
                          .state ==
                      CompleteProfileState.isData) {
                    SnackBarService.showSnackBar(context,
                        title: "Success",
                        status: SnackbarStatus.success,
                        body: ref
                                .read(authproviderController)
                                .completeProfileResult
                                .response['message'] ??
                            '');
                    context.pushReplacement('/youareSet');
                  } else {
                    SnackBarService.showSnackBar(context,
                        title: "Error",
                        status: SnackbarStatus.fail,
                        body: ref
                                .read(authproviderController)
                                .completeProfileResult
                                .response['message'] ??
                            '');
                  }
                  SmartDialog.dismiss();
                }
              },
              child: Container(
                  height: 54,
                  width: 305,
                  decoration: BoxDecoration(
                      color: (ref.watch(authproviderController).image == null &&
                              SelectedNumber != 5)
                          ? AppColors.kgrayColor100
                          : AppColors.kprimaryColor300,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Text('Complete Setup',
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

  GestureDetector tradeExperience(int num, String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          SelectedNumber = num;
        });
      },
      child: Container(
        height: 34,
        width: 184,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: SelectedNumber == num
              ? AppColors.kprimaryColor300
              : AppColors.kgrayColor50,
        ),
        child: Center(
            child: Text(
          name,
          style: TextStyle(
              color: SelectedNumber == num ? Colors.white : Colors.black),
        )),
      ),
    );
  }

  Column buildTextField(BuildContext context, double width, String title,
      String initialValue, String? Function(String?)? validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Gap(10),
        SizedBox(
          width: MediaQuery.of(context).size.width * width,
          child: TextFormField(
            initialValue: initialValue,
            readOnly: true,
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
