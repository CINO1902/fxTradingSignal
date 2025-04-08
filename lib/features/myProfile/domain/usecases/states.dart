class ChangePicResult {
  final ChangePicResultStates state;
  final String response;

  ChangePicResult(this.state, this.response);
}

enum ChangePicResultStates { isLoading, isError, isData, isEmpty, networkissue }

class DeleteAccountResult {
  final DeleteAccountResultStates state;
  final String response;

  DeleteAccountResult(this.state, this.response);
}

enum DeleteAccountResultStates {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}
