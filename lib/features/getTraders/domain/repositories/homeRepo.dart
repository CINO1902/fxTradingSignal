import 'dart:developer';

import 'package:fx_trading_signal/features/getTraders/data/repositories/getTraderRepository.dart';
import 'package:fx_trading_signal/features/getTraders/domain/entities/sendcommentModel.dart';
import 'package:fx_trading_signal/features/getTraders/domain/usecases/pricesResult.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../entities/getPricesPerModel.dart';
import '../entities/getcommentModel.dart';
import '../entities/sendCommentResponse.dart';

abstract class GetTraderRepository {
  Future<GetPricesResult> getPrice(pair);
  Future<GetCommentResult> getComment(signalId);
  Future<SendCommentResult> sendComment(SendComment sencomment);
}

class GetTraderRepositoryImp implements GetTraderRepository {
  final GetTraderDataSource getTraderDataSource;
  GetTraderRepositoryImp(this.getTraderDataSource);

  @override
  Future<GetPricesResult> getPrice(pair) async {
    GetPricesResult getPricesResult = GetPricesResult(
        GetPricesResultState.isLoading, PricesPerPairResponse());

    try {
      getPricesResult = await getTraderDataSource.getPrice(pair);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;
      final message = exp.errorMessage ?? e.message;
      getPricesResult = GetPricesResult(
          GetPricesResultState.isError, PricesPerPairResponse(msg: message));
    }
    return getPricesResult;
  }

  @override
  Future<GetCommentResult> getComment(pair) async {
    GetCommentResult getCommentResult =
        GetCommentResult(GetCommentResultState.isLoading, GetComment());

    try {
      getCommentResult = await getTraderDataSource.getComment(pair);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;
      final message = exp.errorMessage ?? e.message;
      getCommentResult = GetCommentResult(
          GetCommentResultState.isError, GetComment(msg: message));
    }
    return getCommentResult;
  }

  @override
  Future<SendCommentResult> sendComment(pair) async {
    SendCommentResult sendCommentResult = SendCommentResult(
        SendCommentResultState.isLoading, SendCommentResponse());

    try {
      sendCommentResult = await getTraderDataSource.sendComment(pair);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;
      final message = exp.errorMessage ?? e.message;
      sendCommentResult = SendCommentResult(
          SendCommentResultState.isError, SendCommentResponse(msg: message));
    }
    return sendCommentResult;
  }
}
