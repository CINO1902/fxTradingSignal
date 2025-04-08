import 'dart:convert';

import 'package:fx_trading_signal/features/getSIgnals/domain/entities/SignalResponse.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/usecases/signalStates.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/entities/signalByIDRes.dart';
import '../repositories/signalRepo.dart';

class SignalDatasourceImp implements SignalDatasource {
  final HttpService httpService;

  SignalDatasourceImp(this.httpService);

  @override
  Future<SignalResponseResult> getSignal(accesstoken) async {
    SignalResponseResult signalResponseResult = SignalResponseResult(
        SignalResponseResultState.isLoading, SignalResponse());

    final response = await httpService.request(
        url: '/getSignals',
        methodrequest: RequestMethod.postWithToken,
        authtoken: accesstoken);

    if (response.statusCode == 200) {
      final decodedResponse = SignalResponse.fromJson(response.data);
      if (decodedResponse.signals!.isEmpty) {
        signalResponseResult = SignalResponseResult(
            SignalResponseResultState.isEmpty, decodedResponse);
      } else {
        signalResponseResult = SignalResponseResult(
            SignalResponseResultState.isData, decodedResponse);
      }
    } else {
      final decodedResponse = SignalResponse.fromJson(response.data);
      signalResponseResult = SignalResponseResult(
          SignalResponseResultState.isError, decodedResponse);
    }

    return signalResponseResult;
  }

  @override
  Future<SignalResponseByIDResult> getSignalbyId(accesstoken, id) async {
    SignalResponseByIDResult signalResponseResult = SignalResponseByIDResult(
        SignalResponseByIDResultState.isLoading, SignalById());

    final response = await httpService.request(
        url: '/getSignalsbyId?signalId=$id',
        methodrequest: RequestMethod.getWithToken,
        authtoken: accesstoken);

    if (response.statusCode == 200) {
      final decodedResponse = SignalById.fromJson(response.data);

      signalResponseResult = SignalResponseByIDResult(
          SignalResponseByIDResultState.isData, decodedResponse);
    } else if (response.statusCode == 404) {
      final decodedResponse = SignalById.fromJson(response.data);
      signalResponseResult = SignalResponseByIDResult(
          SignalResponseByIDResultState.isNull, decodedResponse);
    } else {
      final decodedResponse = SignalById.fromJson(response.data);
      signalResponseResult = SignalResponseByIDResult(
          SignalResponseByIDResultState.isError, decodedResponse);
    }

    return signalResponseResult;
  }
}
