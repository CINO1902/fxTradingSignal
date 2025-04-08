import 'package:fx_trading_signal/features/chat/domain/usecases/chatStates.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../repositories/chat_repo.dart';

class ChatDatasourceImp implements ChatDatasource {
  final HttpService httpService;

  ChatDatasourceImp(this.httpService);

  @override
  Future<GetChatResult> getallMessage(String converstionId) async {
    GetChatResult getChatResult = GetChatResult(GetChatResultState.isEmpty, {});
    // final int = 8920222;
    final response = await httpService.request(
      url: '/$converstionId/messages',
      methodrequest: RequestMethod.get,
    );
    print(response.data);
    if (response.statusCode == 200) {
      getChatResult = GetChatResult(GetChatResultState.isData, response.data);
    } else {
      getChatResult = GetChatResult(GetChatResultState.isError, response.data);
    }

    return getChatResult;
  }

  @override
  Future<SyncLastChatResult> synclastmessage(
      conversationId, lastMessageTimestamp) async {
    SyncLastChatResult syncLastChatResult =
        SyncLastChatResult(SyncLastChatResultStates.isEmpty, {});
    print(lastMessageTimestamp);
    final response = await httpService.request(
      url:
          '/conversations/$conversationId/messages?since=$lastMessageTimestamp',
      methodrequest: RequestMethod.get,
    );
    if (response.statusCode == 200) {
      syncLastChatResult =
          SyncLastChatResult(SyncLastChatResultStates.isData, response.data);
    } else {
      syncLastChatResult =
          SyncLastChatResult(SyncLastChatResultStates.isError, response.data);
    }
    return syncLastChatResult;
  }

  @override
  Future<GetConVoIDResult> getConVoID(userId) async {
    GetConVoIDResult getConVoIDResult =
        GetConVoIDResult(GetConVoIDResultStates.isLoading, {});

    final response = await httpService.request(
        url: '/getConversation',
        methodrequest: RequestMethod.getWithToken,
        authtoken: userId);

    if (response.statusCode == 200) {
      getConVoIDResult =
          GetConVoIDResult(GetConVoIDResultStates.isData, response.data);
    } else {
      getConVoIDResult =
          GetConVoIDResult(GetConVoIDResultStates.isError, response.data);
    }
    return getConVoIDResult;
  }
}
