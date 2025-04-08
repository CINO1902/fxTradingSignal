import 'package:fx_trading_signal/features/Pricing/domain/entities/buyPlanResponse.dart';
import 'package:fx_trading_signal/features/Pricing/domain/entities/checkActivePlanResponse.dart';
import 'package:fx_trading_signal/features/Pricing/domain/entities/planResponse.dart';

class GetPlanResult {
  final GetPlanResultState state;
  final PlanResponse response;

  GetPlanResult(this.state, this.response);
}

enum GetPlanResultState { isLoading, isError, isData, isEmpty, networkissue }

class BuyPlanResult {
  final BuyPlanResultState state;
  final BuyPlanResponse response;

  BuyPlanResult(this.state, this.response);
}

enum BuyPlanResultState { isLoading, isError, isData, isEmpty, networkissue }

class CheckActivePlanResult {
  final CheckActivePlanResultState state;
  final CheckActivePlan response;

  CheckActivePlanResult(this.state, this.response);
}

enum CheckActivePlanResultState {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}
