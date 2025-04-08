import 'dart:developer';

import 'package:fx_trading_signal/features/getSIgnals/domain/entities/SignalResponse.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/entities/signalByIDRes.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/usecases/signalStates.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../../data/repositories/signalRepo.dart';

abstract class SignalRepository {
  Future<SignalResponseResult> getSignal(accesstoken);
  Future<SignalResponseByIDResult> getSignalbyId(accesstoken, id);
}

class SignalRepositoryImp implements SignalRepository {
  final SignalDatasource signalDatasource;
  SignalRepositoryImp(this.signalDatasource);

  @override
  Future<SignalResponseResult> getSignal(accesstoken) async {
    SignalResponseResult signalResponseResult = SignalResponseResult(
        SignalResponseResultState.isLoading, SignalResponse());

    try {
      signalResponseResult = await signalDatasource.getSignal(accesstoken);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;
      final message = exp.errorMessage ?? e.message;
      signalResponseResult = SignalResponseResult(
          SignalResponseResultState.isError, SignalResponse(msg: message));
    }
    return signalResponseResult;
  }

  @override
  Future<SignalResponseByIDResult> getSignalbyId(accesstoken, id) async {
    SignalResponseByIDResult signalResponseResult = SignalResponseByIDResult(
        SignalResponseByIDResultState.isLoading, SignalById());

    try {
      signalResponseResult = await signalDatasource.getSignalbyId(accesstoken, id);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        signalResponseResult = SignalResponseByIDResult(
            SignalResponseByIDResultState.isError, SignalById(msg: message));
        if (exp.type.description == 'Not found') {
          signalResponseResult = SignalResponseByIDResult(
              SignalResponseByIDResultState.isNull, SignalById(msg: message));
        }
      } else {
        signalResponseResult = SignalResponseByIDResult(
            SignalResponseByIDResultState.isError,
            SignalById(msg: 'Something Went Wrong'));
      }
    }
    return signalResponseResult;
  }
}
