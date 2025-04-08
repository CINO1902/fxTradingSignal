import 'dart:convert';

import 'package:fx_trading_signal/features/getSIgnals/domain/entities/SignalResponse.dart';
import 'package:fx_trading_signal/features/getSIgnals/domain/usecases/signalStates.dart';
import 'package:fx_trading_signal/features/getcopies/data/repositories/CopyTadeRepo.dart';
import 'package:fx_trading_signal/features/getcopies/domain/usecases/addCopyState.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/entities/addCopyResponse.dart';
import '../../domain/entities/getCopyModel.dart';
import '../../domain/usecases/getCopyState.dart';

class CopyTradeDatasouceImp implements CopyTradeDatasouce {
  final HttpService httpService;

  CopyTradeDatasouceImp(this.httpService);

  @override
  Future<GetCopyResult> getCopy(token) async {
    GetCopyResult getCopyResult =
        GetCopyResult(GetCopyResultState.isLoading, GetCopyResponse());

    final response = await httpService.request(
        url: '/getCopy',
        methodrequest: RequestMethod.postWithToken,
        authtoken: token);

    if (response.statusCode == 200) {
      final decodedResponse = GetCopyResponse.fromJson(response.data);
      if (decodedResponse.copyTrade!.isEmpty) {
        getCopyResult =
            GetCopyResult(GetCopyResultState.isEmpty, decodedResponse);
      } else {
        getCopyResult =
            GetCopyResult(GetCopyResultState.isData, decodedResponse);
      }
    } else {
      final decodedResponse = GetCopyResponse.fromJson(response.data);
      getCopyResult =
          GetCopyResult(GetCopyResultState.isError, decodedResponse);
    }

    return getCopyResult;
  }

  @override
  Future<AddCopyResult> addCopy(signalId, token) async {
    AddCopyResult addCopyResult =
        AddCopyResult(AddCopyResultState.isLoading, AddCopyResponse());
    final response = await httpService.request(
      url: '/addCopy',
      methodrequest: RequestMethod.postWithToken,
      authtoken: token,
      data: jsonEncode({
        "signalId": signalId,
      }),
    );
    final decodedResponse = AddCopyResponse.fromJson(response.data);
    if (response.statusCode == 201) {
      addCopyResult =
          AddCopyResult(AddCopyResultState.isAdded, decodedResponse);
    } else if (response.statusCode == 200) {
      // final decodedResponse = jsonDecode(response.data);

      addCopyResult =
          AddCopyResult(AddCopyResultState.isRemoved, decodedResponse);
    } else {
      // final decodedResponse = jsonDecode(response.data);
      addCopyResult =
          AddCopyResult(AddCopyResultState.isError, decodedResponse);
    }

    return addCopyResult;
  }
}
