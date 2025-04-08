import 'dart:developer';

import 'package:fx_trading_signal/features/getcopies/data/repositories/CopyTadeRepo.dart';
import 'package:fx_trading_signal/features/getcopies/domain/entities/getCopyModel.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../entities/addCopyResponse.dart';
import '../usecases/addCopyState.dart';
import '../usecases/getCopyState.dart';

abstract class CopyTradeRepository {
  Future<GetCopyResult> getCopy(token);
  Future<AddCopyResult> addCopy(
    signalId,
    token,
  );
}

class CopyTradeRepositoryImp implements CopyTradeRepository {
  final CopyTradeDatasouce copyTradeDatasouce;
  CopyTradeRepositoryImp(this.copyTradeDatasouce);

  @override
  Future<GetCopyResult> getCopy(token) async {
    GetCopyResult getCopyResult =
        GetCopyResult(GetCopyResultState.isLoading, GetCopyResponse());

    try {
      getCopyResult = await copyTradeDatasouce.getCopy(token);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        getCopyResult = GetCopyResult(
            GetCopyResultState.isError, GetCopyResponse(msg: message));
      } else {
        getCopyResult = GetCopyResult(GetCopyResultState.isError,
            GetCopyResponse(msg: "Something Went Wrong"));
      }
    }
    return getCopyResult;
  }

  @override
  Future<AddCopyResult> addCopy(
    signalId,
    token,
  ) async {
    AddCopyResult addCopyResult =
        AddCopyResult(AddCopyResultState.isLoading, AddCopyResponse());

    try {
      addCopyResult = await copyTradeDatasouce.addCopy(
        signalId,
        token,
      );
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        addCopyResult = AddCopyResult(
            AddCopyResultState.isError, AddCopyResponse(msg: message));
      } else {
        addCopyResult = AddCopyResult(AddCopyResultState.isError,
            AddCopyResponse(msg: "Something Went Wrong"));
      }
    }
    return addCopyResult;
  }
}
