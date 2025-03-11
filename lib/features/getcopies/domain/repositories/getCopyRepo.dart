import 'dart:developer';

import 'package:fx_trading_signal/features/getcopies/data/repositories/CopyTadeRepo.dart';
import 'package:fx_trading_signal/features/getcopies/domain/entities/getCopyModel.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../entities/addCopyResponse.dart';
import '../usecases/addCopyState.dart';
import '../usecases/getCopyState.dart';

abstract class CopyTradeRepository {
  Future<GetCopyResult> getCopy(userId);
  Future<AddCopyResult> addCopy(
    signalId,
    userId,
  );
}

class CopyTradeRepositoryImp implements CopyTradeRepository {
  final CopyTradeDatasouce copyTradeDatasouce;
  CopyTradeRepositoryImp(this.copyTradeDatasouce);

  @override
  Future<GetCopyResult> getCopy(userId) async {
    GetCopyResult getCopyResult =
        GetCopyResult(GetCopyResultState.isLoading, GetCopyResponse());

    try {
      getCopyResult = await copyTradeDatasouce.getCopy(userId);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;
      final message = exp.errorMessage ?? e.message;
      getCopyResult = GetCopyResult(
          GetCopyResultState.isError, GetCopyResponse(msg: message));
    }
    return getCopyResult;
  }

  @override
  Future<AddCopyResult> addCopy(
    signalId,
    userId,
  ) async {
    AddCopyResult addCopyResult =
        AddCopyResult(AddCopyResultState.isLoading, AddCopyResponse());

    try {
      addCopyResult = await copyTradeDatasouce.addCopy(
        signalId,
        userId,
      );
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;
      final message = exp.errorMessage ?? e.message;
      addCopyResult = AddCopyResult(
          AddCopyResultState.isError, AddCopyResponse(msg: message));
    }
    return addCopyResult;
  }
}
