import 'dart:convert';

import 'package:fx_trading_signal/features/getTraders/data/repositories/getTraderRepository.dart';
import 'package:fx_trading_signal/features/getTraders/domain/entities/sendcommentModel.dart';
import 'package:fx_trading_signal/features/getTraders/domain/usecases/pricesResult.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/entities/getPricesPerModel.dart';
import '../../domain/entities/getcommentModel.dart';
import '../../domain/entities/sendCommentResponse.dart';

class GetTraderDataSourceImp implements GetTraderDataSource {
  final HttpService httpService;

  GetTraderDataSourceImp(this.httpService);

  @override
  Future<GetPricesResult> getPrice(pair) async {
    GetPricesResult getPricesResult = GetPricesResult(
        GetPricesResultState.isLoading, PricesPerPairResponse());

    final response = await httpService.request(
      url: '/getpricesPair',
      data: jsonEncode({
        "pair": pair,
      }),
      methodrequest: RequestMethod.post,
    );

    if (response.statusCode == 200) {
      final decodedResponse = PricesPerPairResponse.fromJson(response.data);

      getPricesResult =
          GetPricesResult(GetPricesResultState.isData, decodedResponse);
    } else {
      final decodedResponse = PricesPerPairResponse.fromJson(response.data);
      getPricesResult =
          GetPricesResult(GetPricesResultState.isError, decodedResponse);
    }

    return getPricesResult;
  }

  @override
  Future<GetCommentResult> getComment(signalId) async {
    GetCommentResult getCommentResult =
        GetCommentResult(GetCommentResultState.isLoading, GetComment());

    final response = await httpService.request(
      url: '/callcomments',
      data: jsonEncode({
        "signal_id": signalId,
      }),
      methodrequest: RequestMethod.post,
    );
    if (response.statusCode == 200) {
      final decodedResponse = GetComment.fromJson(response.data);

      getCommentResult =
          GetCommentResult(GetCommentResultState.isData, decodedResponse);
    } else if (response.statusCode == 404) {
      final decodedResponse = GetComment.fromJson(response.data);

      getCommentResult =
          GetCommentResult(GetCommentResultState.isEmpty, decodedResponse);
    } else {
      final decodedResponse = GetComment.fromJson(response.data);
      getCommentResult =
          GetCommentResult(GetCommentResultState.isError, decodedResponse);
    }

    return getCommentResult;
  }

  @override
  Future<SendCommentResult> sendComment(SendComment sencomment) async {
    SendCommentResult sendCommentResult = SendCommentResult(
        SendCommentResultState.isLoading, SendCommentResponse());

    final response = await httpService.request(
      url: '/createComment',
      data: sendCommentToJson(sencomment),
      methodrequest: RequestMethod.post,
    );
    if (response.statusCode == 201) {
      final decodedResponse = SendCommentResponse.fromJson(response.data);

      sendCommentResult =
          SendCommentResult(SendCommentResultState.isData, decodedResponse);
    } else {
      final decodedResponse = SendCommentResponse.fromJson(response.data);
      sendCommentResult =
          SendCommentResult(SendCommentResultState.isError, decodedResponse);
    }

    return sendCommentResult;
  }
}
