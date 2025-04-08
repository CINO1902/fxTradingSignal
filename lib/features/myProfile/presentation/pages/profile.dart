import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fx_trading_signal/features/auth%20/presentation/provider/auth_provider.dart';
import 'package:fx_trading_signal/features/myProfile/domain/usecases/isoStringConverter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../../core/utils/appColors.dart';
import '../../../getTraders/presentation/provider/homeProvider.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kWhite,
        body: SafeArea(
          child: Container(
            color: AppColors.kgrayColor50,
            child: Column(
              children: [
                Container(
                  height: 110,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        ref.watch(getTraderController).userData['imageUrl'] ==
                                ""
                            ? SizedBox(
                                height: 60,
                                width: 60,
                                child: ClipOval(
                                    child: Image.asset(
                                        'assets/images/images.png')))
                            : SizedBox(
                                height: 60,
                                width: 60,
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
                        Gap(20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ref.watch(getTraderController).userData['firstname']} ${ref.watch(getTraderController).userData['lastname']},',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${ref.watch(getTraderController).userData['email']} ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ref.watch(getTraderController).userData['planId'] != ""
                    ? Container(
                        margin: EdgeInsets.only(top: 15, bottom: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/crown.svg'),
                                Gap(20),
                                Text(
                                  'Pro Member',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Text(
                              'Valid Until ${formatDateFromISO(ref.watch(getTraderController).userData['dateExpired'])}',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                Gap(15),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white,
                    height: 50,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SETTINGS',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    )),
                Gap(5),
                GestureDetector(
                    onTap: () {
                      context.push('/accountSettings');
                    },
                    child: ProfileActions(
                        'assets/svg/setting-2.svg', 'Account Settings')),
                Gap(3),
                GestureDetector(
                    onTap: () {
                      context.push('/plans');
                    },
                    child:
                        ProfileActions('assets/svg/wallet.svg', 'Choose Plan')),
                Gap(3),
                ProfileActions('assets/svg/notification.svg', 'Notification'),
                Gap(15),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white,
                    height: 50,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SUPPORT',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    )),
                Gap(5),
                GestureDetector(
                    onTap: () {
                      context.push('/helpandsupports');
                    },
                    child: ProfileActions(
                        'assets/svg/24-support.svg', 'Help Center')),
                Gap(3),
                ProfileActions(
                    'assets/svg/setting-2.svg', 'Privacy and Policy'),
                Gap(30),
                GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.bottomSlide,
                      title: 'Sign Out',
                      desc: 'Are you sure you want to sign out',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        SmartDialog.showLoading();
                        await ref.read(authproviderController).logout();

                        ref.read(authproviderController).clearUserData();
                        context.pushReplacement('/login');
                        SmartDialog.dismiss();
                      },
                    ).show();
                  },
                  child: Container(
                    color: Colors.white,
                    height: 54,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svg/logout.svg'),
                        Gap(5),
                        Text('Sign Out',
                            style: TextStyle(
                                color: AppColors.kErrorColor400,
                                fontSize: 14,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Container ProfileActions(image, title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(image),
              Gap(20),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          SvgPicture.asset('assets/svg/arrowleft.svg')
        ],
      ),
    );
  }
}
