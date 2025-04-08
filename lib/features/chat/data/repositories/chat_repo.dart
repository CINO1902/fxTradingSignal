import '../../domain/usecases/chatStates.dart';

abstract class ChatDatasource {
  Future<GetChatResult> getallMessage(String converstionId);
  Future<GetConVoIDResult> getConVoID(userId);
  Future<SyncLastChatResult> synclastmessage(
      converstionId, lastMessageTimestamp);
}
