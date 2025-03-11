import 'package:fx_trading_signal/features/getTraders/domain/usecases/pricesResult.dart';

import '../../domain/entities/sendcommentModel.dart';

abstract class GetTraderDataSource {
  Future<GetPricesResult> getPrice(pair);
     Future<GetCommentResult> getComment(signalId);
    Future<SendCommentResult> sendComment(SendComment sencomment);
}
