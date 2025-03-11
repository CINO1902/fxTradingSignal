import 'package:fx_trading_signal/features/getSIgnals/domain/entities/SignalResponse.dart';

import '../entities/signalByIDRes.dart';

class SignalResponseResult {
  final SignalResponseResultState state;
  final SignalResponse response;

  SignalResponseResult(this.state, this.response);
}

enum SignalResponseResultState {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}

class SignalResponseByIDResult {
  final SignalResponseByIDResultState state;
  final SignalById response;

  SignalResponseByIDResult(this.state, this.response);
}

enum SignalResponseByIDResultState {
  isLoading,
  isError,
  isData,
  isNull,
  networkissue
}
