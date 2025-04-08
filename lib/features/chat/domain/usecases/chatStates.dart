class GetChatResult {
  final GetChatResultState state;
  final dynamic response;

  GetChatResult(this.state, this.response);
}

enum GetChatResultState { isLoading, isError, isData, isNull, isEmpty, networkissue }

class SyncLastChatResult {
  final SyncLastChatResultStates state;
  final dynamic response;

  SyncLastChatResult(this.state, this.response);
}

enum SyncLastChatResultStates {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}

class GetConVoIDResult {
  final GetConVoIDResultStates state;
  final dynamic response;

  GetConVoIDResult(this.state, this.response);
}

enum GetConVoIDResultStates {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}

