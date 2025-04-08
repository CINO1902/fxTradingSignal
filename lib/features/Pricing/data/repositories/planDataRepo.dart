import '../../domain/usecases/states.dart';

abstract class PlanDataSource {
  Future<GetPlanResult> getplan();
  Future<BuyPlanResult> buyPlan(id, accesstoken);
  Future<CheckActivePlanResult> checkplanValidity(accesstoken);
}
