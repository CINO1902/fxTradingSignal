import 'dart:convert';

import 'package:fx_trading_signal/features/Pricing/domain/entities/buyPlanResponse.dart';
import 'package:fx_trading_signal/features/Pricing/domain/entities/checkActivePlanResponse.dart';
import 'package:fx_trading_signal/features/Pricing/domain/entities/planResponse.dart';
import 'package:fx_trading_signal/features/Pricing/domain/usecases/states.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../repositories/planDataRepo.dart';

class PlanDataSourceImp implements PlanDataSource {
  final HttpService httpService;

  PlanDataSourceImp(this.httpService);

  @override
  Future<GetPlanResult> getplan() async {
    GetPlanResult getPlanResult =
        GetPlanResult(GetPlanResultState.isLoading, PlanResponse());

    final response = await httpService.request(
      url: '/getPlan',
      methodrequest: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      final decodedResponse = PlanResponse.fromJson(response.data);

      getPlanResult = GetPlanResult(GetPlanResultState.isData, decodedResponse);
    } else if (response.statusCode == 404) {
      final decodedResponse = PlanResponse.fromJson(response.data);
      getPlanResult =
          GetPlanResult(GetPlanResultState.isEmpty, decodedResponse);
    } else {
      final decodedResponse = PlanResponse.fromJson(response.data);
      getPlanResult =
          GetPlanResult(GetPlanResultState.isError, decodedResponse);
    }

    return getPlanResult;
  }

  @override
  Future<BuyPlanResult> buyPlan(planId, accesstoken) async {
    BuyPlanResult buyPlanResult =
        BuyPlanResult(BuyPlanResultState.isLoading, BuyPlanResponse());

    final response = await httpService.request(
        url: '/buyPlan',
        methodrequest: RequestMethod.postWithToken,
        data: jsonEncode({"id": planId}),
        authtoken: accesstoken);

    if (response.statusCode == 200) {
      final decodedResponse = BuyPlanResponse.fromJson(response.data);

      buyPlanResult = BuyPlanResult(BuyPlanResultState.isData, decodedResponse);
    } else {
      final decodedResponse = BuyPlanResponse.fromJson(response.data);
      buyPlanResult =
          BuyPlanResult(BuyPlanResultState.isError, decodedResponse);
    }

    return buyPlanResult;
  }

  @override
  Future<CheckActivePlanResult> checkplanValidity(accesstoken) async {
    CheckActivePlanResult checkActivePlanResult = CheckActivePlanResult(
        CheckActivePlanResultState.isLoading, CheckActivePlan());

    final response = await httpService.request(
        url: '/checkActivePlan',
        methodrequest: RequestMethod.getWithToken,
        authtoken: accesstoken);

    if (response.statusCode == 200) {
      final decodedResponse = CheckActivePlan.fromJson(response.data);
      if (decodedResponse.status == 'active') {
        checkActivePlanResult = CheckActivePlanResult(
            CheckActivePlanResultState.isError, decodedResponse);
      } else {
        checkActivePlanResult = CheckActivePlanResult(
            CheckActivePlanResultState.isData, decodedResponse);
      }
    } else {
      final decodedResponse = CheckActivePlan.fromJson(response.data);
      checkActivePlanResult = CheckActivePlanResult(
          CheckActivePlanResultState.isError, decodedResponse);
    }

    return checkActivePlanResult;
  }
}
