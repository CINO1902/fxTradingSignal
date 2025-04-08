import 'dart:developer';

import 'package:fx_trading_signal/core/exceptions/network_exception.dart';
import 'package:fx_trading_signal/features/Pricing/data/repositories/planDataRepo.dart';
import 'package:fx_trading_signal/features/Pricing/domain/entities/buyPlanResponse.dart';
import 'package:fx_trading_signal/features/Pricing/domain/entities/checkActivePlanResponse.dart';
import 'package:fx_trading_signal/features/Pricing/domain/entities/planResponse.dart';

import '../usecases/states.dart';

abstract class PlanRepository {
  Future<GetPlanResult> getplan();
  Future<BuyPlanResult> buyPlan(id, accesstoken);
  Future<CheckActivePlanResult> checkplanValidity(accesstoken);
}

class PlanRepositoryImp implements PlanRepository {
  final PlanDataSource planDataSource;
  PlanRepositoryImp(this.planDataSource);

  @override
  Future<GetPlanResult> getplan() async {
    GetPlanResult planResponseResult =
        GetPlanResult(GetPlanResultState.isLoading, PlanResponse());

    try {
      planResponseResult = await planDataSource.getplan();
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        planResponseResult = GetPlanResult(
            GetPlanResultState.isError, PlanResponse(msg: message));
        if (exp.type.description == 'Not found') {
          planResponseResult = GetPlanResult(
              GetPlanResultState.isEmpty, PlanResponse(msg: message));
        }
      } else {
        planResponseResult = GetPlanResult(GetPlanResultState.isError,
            PlanResponse(msg: 'Something Went Wrong'));
      }
    }
    return planResponseResult;
  }

  @override
  Future<BuyPlanResult> buyPlan(id, accesstoken) async {
    BuyPlanResult buyResponseResult =
        BuyPlanResult(BuyPlanResultState.isLoading, BuyPlanResponse());

    try {
      buyResponseResult = await planDataSource.buyPlan(id, accesstoken);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        buyResponseResult = BuyPlanResult(
            BuyPlanResultState.isError, BuyPlanResponse(msg: message));
        if (exp.type.description == 'Not found') {
          buyResponseResult = BuyPlanResult(
              BuyPlanResultState.isEmpty, BuyPlanResponse(msg: message));
        }
      } else {
        buyResponseResult = BuyPlanResult(BuyPlanResultState.isError,
            BuyPlanResponse(msg: 'Something Went Wrong'));
      }
    }
    return buyResponseResult;
  }

  @override
  Future<CheckActivePlanResult> checkplanValidity(accesstoken) async {
    CheckActivePlanResult checkActivePlanResult = CheckActivePlanResult(
        CheckActivePlanResultState.isLoading, CheckActivePlan());

    try {
      checkActivePlanResult =
          await planDataSource.checkplanValidity(accesstoken);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        checkActivePlanResult = CheckActivePlanResult(
            CheckActivePlanResultState.isError, CheckActivePlan(msg: message));
      } else {
        checkActivePlanResult = CheckActivePlanResult(
            CheckActivePlanResultState.isError,
            CheckActivePlan(msg: 'Something Went Wrong'));
      }
    }
    return checkActivePlanResult;
  }
}
