import 'package:fx_trading_signal/features/getTraders/domain/entities/getPricesModel.dart';
import 'package:fx_trading_signal/features/getTraders/domain/entities/getcommentModel.dart';

import '../entities/getPricesPerModel.dart';
import '../entities/sendCommentResponse.dart';

class GetPricesResult {
  final GetPricesResultState state;
  final PricesPerPairResponse response;

  GetPricesResult(this.state, this.response);
}

enum GetPricesResultState { isLoading, isError, isData, isEmpty, networkissue }

class SendCommentResult {
  final SendCommentResultState state;
  final SendCommentResponse response;

  SendCommentResult(this.state, this.response);
}

enum SendCommentResultState {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}

class GetCommentResult {
  final GetCommentResultState state;
  final GetComment response;

  GetCommentResult(this.state, this.response);
}

enum GetCommentResultState { isLoading, isError, isData, isEmpty, networkissue }
