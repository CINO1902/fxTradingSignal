import '../entities/addCopyResponse.dart';

class AddCopyResult {
  final AddCopyResultState state;
  final AddCopyResponse response;

  AddCopyResult(this.state, this.response);
}

enum AddCopyResultState {
  isLoading,
  isError,
  isAdded,
  isRemoved,
  idle
}
