import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/Pricing/domain/repositories/priceRepo.dart';
import 'package:fx_trading_signal/features/Pricing/presentation/provider/planProvider.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/provider/homeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/buyPlanResponse.dart';
import '../../domain/entities/checkActivePlanResponse.dart';
import '../../domain/entities/planResponse.dart';
import '../../domain/usecases/purchaseHelper.dart';
import '../../domain/usecases/states.dart';

class PlanController with ChangeNotifier {
  final PlanRepository planRepository;
  PlanController(this.planRepository);

  GetPlanResult getPlanResult =
      GetPlanResult(GetPlanResultState.isLoading, PlanResponse());

  BuyPlanResult buyPlanResult =
      BuyPlanResult(BuyPlanResultState.isLoading, BuyPlanResponse());
  CheckActivePlanResult checkActivePlanResult = CheckActivePlanResult(
      CheckActivePlanResultState.isLoading, CheckActivePlan());

  Future<void> getPlan(
    WidgetRef ref,
  ) async {
    getPlanResult = GetPlanResult(GetPlanResultState.isLoading, PlanResponse());
    notifyListeners();

    final response = await planRepository.getplan();
    getPlanResult = response;
    notifyListeners();
  }

  Future<void> buyPlan(
    WidgetRef ref,
    int id,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    buyPlanResult =
        BuyPlanResult(BuyPlanResultState.isLoading, BuyPlanResponse());
    notifyListeners();
    final accesstoken = ref.watch(getTraderController).userData['token'];
    final response = await planRepository.buyPlan(id, accesstoken);
    buyPlanResult = response;
    if (response.state == BuyPlanResultState.isData) {
      await prefs.setString('planId', response.response.plans?.planId ?? '');
      await prefs.setString('dateExpired',
          response.response.plans?.dateExpired?.toIso8601String() ?? '');
      await prefs.setString('datebought',
          response.response.plans?.dateBought?.toIso8601String() ?? '');
    }
    await ref.read(getTraderController).getUserObject();
    notifyListeners();
  }

  Future<void> checkPlan(
      WidgetRef ref) async {
    checkActivePlanResult = CheckActivePlanResult(
        CheckActivePlanResultState.isLoading, CheckActivePlan());
    notifyListeners();
 final accesstoken = ref.watch(getTraderController).userData['token'];
    final response = await planRepository.checkplanValidity(accesstoken);

    checkActivePlanResult = response;

    notifyListeners();
  }
}
