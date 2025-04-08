import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fx_trading_signal/features/myProfile/presentation/provider/profile_provider.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../constant/snackBar.dart';
import '../../../../core/utils/appColors.dart';
import '../../../auth /domain/entities/States/AuthResultState.dart';
import '../../../auth /presentation/provider/auth_provider.dart';
import '../../../getTraders/presentation/provider/homeProvider.dart';
import '../../domain/usecases/states.dart';

class Accountsettings extends ConsumerStatefulWidget {
  const Accountsettings({super.key});

  @override
  ConsumerState<Accountsettings> createState() => _AccountsettingsState();
}

class _AccountsettingsState extends ConsumerState<Accountsettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Account Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        leading: ref.watch(authproviderController).image != null
            ? GestureDetector(
                onTap: () {
                  ref.read(authproviderController).discardImage();
                },
                child: Icon(Icons.cancel))
            : GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(authproviderController).pickimageupdate();
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
                            child: ref
                                        .watch(getTraderController)
                                        .userData['imageUrl'] ==
                                    ""
                                ? Image.asset(
                                    'assets/images/camera.png',
                                    height: 30, // Directly set the image height
                                    width: 30, // Directly set the image width
                                  )
                                : Stack(
                                    children: [
                                      SizedBox(
                                        width: 83,
                                        height: 83,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: ref
                                                .watch(getTraderController)
                                                .userData['imageUrl'],
                                            fit: BoxFit
                                                .cover, // Ensures the image fills the circle properly
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 2,
                                        right: 5,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: AppColors.kgrayColor50,
                                          ),
                                          child: Image.asset(
                                            'assets/images/camera.png',
                                            height:
                                                30, // Directly set the image height
                                            width:
                                                30, // Directly set the image width
                                          ),
                                        ),
                                      )
                                    ],
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
                'Change profile picture',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.kgrayColor100),
              ),
            ),
            Gap(40),
            Column(
              children: [
                buildTextField(
                  context,
                  0.9,
                  'First Name',
                  ref.watch(getTraderController).userData['firstname'],
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    } else if (value.length < 3) {
                      return 'Input must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                Gap(20),
                buildTextField(
                  context,
                  0.9,
                  'Last Name',
                  ref.watch(getTraderController).userData['lastname'],
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    } else if (value.length < 3) {
                      return 'Input must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                Gap(20),
                buildTextField(
                  context,
                  0.9,
                  'Email',
                  ref.watch(getTraderController).userData['email'],
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    } else if (value.length < 3) {
                      return 'Input must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                Gap(20),
                buildTextField(
                  context,
                  0.9,
                  'Phone Number',
                  ref.watch(getTraderController).userData['phoneNumber'],
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
            GestureDetector(
              onTap: () async {
                if (ref.watch(authproviderController).image != null) {
                  SmartDialog.showLoading();
                  await ref.read(authproviderController).uploadImagePer();
                  if (ref
                          .read(authproviderController)
                          .imageUploadResult
                          .state ==
                      ImageUploadResultStates.isError) {
                    SnackBarService.showSnackBar(context,
                        title: "Error",
                        status: SnackbarStatus.fail,
                        body: ref
                            .read(authproviderController)
                            .imageUploadResult
                            .response['message']);
                  } else {
                    if (ref.watch(authproviderController).imageUrl != null) {
                      await ref
                          .read(profileproviderController)
                          .changeProfilePic(
                              ref, ref.watch(authproviderController).imageUrl!);
                      if (ref
                              .read(profileproviderController)
                              .changePicResult
                              .state ==
                          ChangePicResultStates.isError) {
                        SnackBarService.showSnackBar(context,
                            title: "Error",
                            status: SnackbarStatus.fail,
                            body: ref
                                .read(profileproviderController)
                                .changePicResult
                                .response);
                      } else {
                        SnackBarService.showSnackBar(context,
                            title: "Success",
                            status: SnackbarStatus.success,
                            body: ref
                                .read(profileproviderController)
                                .changePicResult
                                .response);
                      }
                    }
                  }

                  SmartDialog.dismiss();
                }
              },
              child: Container(
                  height: 54,
                  width: 305,
                  decoration: BoxDecoration(
                      color: ref.watch(authproviderController).image == null
                          ? AppColors.kgrayColor100
                          : AppColors.kprimaryColor300,
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: Text('Save Changes',
                        style: TextStyle(
                            color: AppColors.kWhite,
                            fontWeight: FontWeight.bold)),
                  )),
            ),
            Gap(20),
            Center(
                child: GestureDetector(
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Delete Account',
                  desc: 'Are you sure you want to delete your Profile',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    SmartDialog.showLoading();
                    await ref
                        .read(profileproviderController)
                        .deleteAccount(ref);
                    if (ref
                            .read(profileproviderController)
                            .deleteAccountResult
                            .state ==
                        DeleteAccountResultStates.isError) {
                      SnackBarService.showSnackBar(context,
                          title: "Error",
                          status: SnackbarStatus.fail,
                          body: ref
                              .read(profileproviderController)
                              .deleteAccountResult
                              .response);
                    } else {
                      SnackBarService.showSnackBar(context,
                          title: "Success",
                          status: SnackbarStatus.success,
                          body: ref
                              .read(profileproviderController)
                              .deleteAccountResult
                              .response);
                      ref.read(authproviderController).clearUserData();
                      context.pushReplacement('/login');
                    }

                    SmartDialog.dismiss();
                  },
                ).show();
              },
              child: Text(
                'Delete Account',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kErrorColor400),
              ),
            ))
          ],
        ),
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
