import 'dart:developer';

import 'package:fx_trading_signal/constant/enum.dart';
import 'package:fx_trading_signal/features/chat/data/repositories/chat_repo.dart';

import '../../../../core/exceptions/network_exception.dart';
import '../usecases/chatStates.dart';

abstract class ChatRepository {
  Future<GetChatResult> getallMessage(converstionId);
  Future<GetConVoIDResult> getConVoID(userId);
  Future<SyncLastChatResult> synclastmessage(
      converstionId, lastMessageTimestamp);
}

class chatRepositoryImp implements ChatRepository {
  final ChatDatasource chatDatasource;
  chatRepositoryImp(this.chatDatasource);

  @override
  Future<GetChatResult> getallMessage(converstionId) async {
    GetChatResult getChatResult = GetChatResult(GetChatResultState.isEmpty, {});

    try {
      // final newId = int.parse(converstionId);
      getChatResult = await chatDatasource.getallMessage(converstionId);
    } catch (e) {
      // log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        print(exp.type);
        //
        if (exp.type == NetworkExceptionType.notFound) {
          getChatResult = GetChatResult(GetChatResultState.isEmpty,
              {"message": 'You haven\'t had a conversation with the admin'});
        } else {
          getChatResult =
              GetChatResult(GetChatResultState.isError, {"message": message});
        }
      } else {
        getChatResult = GetChatResult(
            GetChatResultState.isError, {"message": "Something Went Wrong"});
      }
    }
    return getChatResult;
  }

  @override
  Future<SyncLastChatResult> synclastmessage(
      converstionId, lastMessageTimestamp) async {
    SyncLastChatResult syncLastChatResult =
        SyncLastChatResult(SyncLastChatResultStates.isEmpty, {});

    try {
      syncLastChatResult = await chatDatasource.synclastmessage(
          converstionId, lastMessageTimestamp);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        syncLastChatResult = SyncLastChatResult(
            SyncLastChatResultStates.isError, {"message": message});
      } else {
        syncLastChatResult = SyncLastChatResult(
            SyncLastChatResultStates.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return syncLastChatResult;
  }

  @override
  Future<GetConVoIDResult> getConVoID(userId) async {
    GetConVoIDResult getConVoIDResult =
        GetConVoIDResult(GetConVoIDResultStates.isEmpty, {});

    try {
      getConVoIDResult = await chatDatasource.getConVoID(userId);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        getConVoIDResult = GetConVoIDResult(
            GetConVoIDResultStates.isError, {"message": message});
      } else {
        getConVoIDResult = GetConVoIDResult(GetConVoIDResultStates.isError,
            {"message": "Something Went Wrong"});
      }
    }
    return getConVoIDResult;
  }
}
