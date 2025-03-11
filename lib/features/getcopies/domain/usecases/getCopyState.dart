

import '../entities/getCopyModel.dart';

class GetCopyResult {
  final GetCopyResultState state;
  final GetCopyResponse response;

  GetCopyResult(this.state, this.response);
}

enum GetCopyResultState {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}
