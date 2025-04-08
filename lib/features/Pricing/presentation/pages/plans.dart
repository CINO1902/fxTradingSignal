import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fx_trading_signal/core/utils/appColors.dart';
import 'package:fx_trading_signal/features/Pricing/domain/usecases/purchaseHelper.dart';
import 'package:fx_trading_signal/features/Pricing/domain/usecases/states.dart';
import 'package:fx_trading_signal/features/Pricing/presentation/provider/planProvider.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/provider/homeProvider.dart';
import 'package:gap/gap.dart';

import '../../../../constant/snackBar.dart';

class Plans extends ConsumerStatefulWidget {
  const Plans({super.key});

  @override
  ConsumerState<Plans> createState() => _PlansState();
}

class _PlansState extends ConsumerState<Plans> {
  List<String> priveleges = [
    'Basic trading signals',
    '2 saved signals',
    'Limited signal history',
    'Community access'
  ];

  List<String> propriveleges = [
    'Premium trading signals',
    'Unlimited signal saves',
    'Full signal history',
    'Priority notifications',
    'Expert community access'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(planProvider).getPlan(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(surfaceTintColor: null),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ListView(
          children: [
            Text(
              'Choose your plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            Text(
              'Select the plan that fits your need',
              style: TextStyle(fontSize: 14),
            ),
            Gap(30),
            Plans('0', priveleges, 'free', 000),
            Builder(
              builder: (context) {
                final planState = ref.watch(planProvider).getPlanResult.state;
                return planState == GetPlanResultState.isLoading
                    ? CircularProgressIndicator.adaptive()
                    : planState == GetPlanResultState.isEmpty
                        ? Center(child: Text('There is no pro plan available'))
                        : planState == GetPlanResultState.isError
                            ? Text(ref
                                    .watch(planProvider)
                                    .getPlanResult
                                    .response
                                    .msg ??
                                '')
                            : ref
                                        .watch(planProvider)
                                        .getPlanResult
                                        .response
                                        .plans ==
                                    null
                                ? Center(
                                    child:
                                        Text('There is no pro plan available'))
                                : ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: ref
                                        .watch(planProvider)
                                        .getPlanResult
                                        .response
                                        .plans!
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final plans = ref
                                          .watch(planProvider)
                                          .getPlanResult
                                          .response
                                          .plans;
                                      return Plans(
                                          plans![index].planPrice.toString(),
                                          plans[index].planPrivielege ?? [],
                                          'pro',
                                          int.parse(
                                              plans[index].planId ?? '0'));
                                    },
                                  );
              },
            )
          ],
        ),
      ),
    );
  }

  Container Plans(price, List<String> rights, String type, int planId) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.kgrayColor50)),
      child: Column(children: [
        Row(
          children: [
            SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset('assets/svg/favourite.svg')),
            Gap(10),
            Text(
              'Free',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )
          ],
        ),
        Gap(20),
        Row(
          children: [
            Text(
              "\$$price",
              style: TextStyle(
                  fontFamily: 'Catamaran',
                  fontSize: 29,
                  fontWeight: FontWeight.w700),
            ),
            Text('/per month',
                style: TextStyle(
                  color: AppColors.kgrayColor100,
                ))
          ],
        ),
        Gap(10),
        ...List.generate(
          rights.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  rights[index],
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        ),
        Gap(10),
        TriggerButton(type, planId)
      ]),
    );
  }

  GestureDetector TriggerButton(String type, int planId) {
    return GestureDetector(
      onTap: type == 'free'
          ? null
          : () async {
              if (ref.watch(getTraderController).userData['planId'] ==
                  planId.toString()) {
                SnackBarService.notifyAction(context,
                    status: SnackbarStatus.fail,
                    message: 'you can\'t buy an active plan');
              } else {
                SmartDialog.showLoading();

                await ref.read(planProvider).checkPlan(ref);
                if (ref.watch(planProvider).checkActivePlanResult.state ==
                    CheckActivePlanResultState.isData) {
                  SnackBarService.showSnackBar(context,
                      title: "Success",
                      status: SnackbarStatus.success,
                      body: ref
                              .read(planProvider)
                              .checkActivePlanResult
                              .response
                              .msg ??
                          '');
                } else {
                  SnackBarService.showSnackBar(context,
                      title: "Error",
                      status: SnackbarStatus.fail,
                      body: ref
                              .read(planProvider)
                              .checkActivePlanResult
                              .response
                              .msg ??
                          '');
                }
                if (ref.watch(planProvider).checkActivePlanResult.state ==
                    CheckActivePlanResultState.isData) {
                  final response = await PurchaseHelper(
                          context: context,
                          userId:
                              ref.watch(getTraderController).userData['userId'],
                          serviceName: type)
                      .fetchAndPurchase('ProService', planId, 0, ref);
                  if (response) {
                    if (ref.watch(planProvider).buyPlanResult.state ==
                        BuyPlanResultState.isData) {
                      SnackBarService.showSnackBar(context,
                          title: "Success",
                          status: SnackbarStatus.success,
                          body: ref
                                  .read(planProvider)
                                  .buyPlanResult
                                  .response
                                  .msg ??
                              '');
                    } else {
                      SnackBarService.showSnackBar(context,
                          title: "Error",
                          status: SnackbarStatus.fail,
                          body: ref
                                  .read(planProvider)
                                  .buyPlanResult
                                  .response
                                  .msg ??
                              '');
                    }
                  }
                }

                SmartDialog.dismiss();
              }
            },
      child: Container(
        height: 44,
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
          color: type == 'free'
              ? AppColors.kgrayColor50
              : AppColors.kprimaryColor300,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
            child: Text(
          type == 'free'
              ? 'Start Free'
              : ref.watch(getTraderController).userData['planId'] ==
                      planId.toString()
                  ? 'CurrentPlan'
                  : 'Upgrade to Pro',
          style: TextStyle(
              color: type == 'free' ? AppColors.kBlack : Colors.white,
              fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
