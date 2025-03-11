import 'package:fx_trading_signal/features/getcopies/domain/usecases/addCopyState.dart';
import 'package:fx_trading_signal/features/getcopies/domain/usecases/getCopyState.dart';

abstract class CopyTradeDatasouce {
  Future<GetCopyResult> getCopy(userId);
  Future<AddCopyResult> addCopy(
    signalId,
    userId,
  );
}
