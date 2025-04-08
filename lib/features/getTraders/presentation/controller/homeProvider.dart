import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/getTraders/domain/entities/sendcommentModel.dart';
import 'package:fx_trading_signal/features/getTraders/domain/repositories/homeRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/getPricesModel.dart';
import '../../domain/entities/getPricesPerModel.dart';
import '../../domain/entities/getcommentModel.dart';
import '../../domain/entities/sendCommentResponse.dart';
import '../../domain/usecases/pricesResult.dart';
import '../widgets/traderWidget.dart';

class homeController with ChangeNotifier {
  final GetTraderRepository getTraderRepository;
  homeController(this.getTraderRepository);

  Map<String, dynamic> userData = {
    "firstname": "",
    "lastname": "",
    "userId": "",
    "email": "",
    "imageUrl": "",
    "trading_experience": "",
    "phoneNumber": "",
    "verified": "",
    "token": "",
    "planId": "",
    "dateExpired": "",
    "datebought": ""
  };

  GetPricesResult getPricesResult =
      GetPricesResult(GetPricesResultState.isLoading, PricesPerPairResponse());
  GetCommentResult getCommentResult =
      GetCommentResult(GetCommentResultState.isLoading, GetComment());
  SendCommentResult sendCommentResult = SendCommentResult(
      SendCommentResultState.isLoading, SendCommentResponse());
  Future<void> getUserObject() async {
    final pref = await SharedPreferences.getInstance(); // Await the instance

    final String? firstname = pref.getString("firstname");
    final String? lastname = pref.getString("lastname");
    final String? email = pref.getString("email");
    final String? userId = pref.getString("userId");
    final String? imageUrl = pref.getString("imageUrl");
    final String? tradingExperience = pref.getString("trading_experience");
    final String? phoneNumber = pref.getString("phoneNumber");
    final String? token = pref.getString("token");
    final bool? verified = pref.getBool("verified");
    final String? planId = pref.getString("planId");
    final String? dateExpired = pref.getString("dateExpired");
    final String? datebought = pref.getString("datebought");
    userData.addAll({
      "firstname": firstname ?? "",
      "lastname": lastname ?? "",
      "email": email ?? "",
      "userId": userId ?? "",
      "imageUrl": imageUrl ?? "",
      "trading_experience": tradingExperience ?? "",
      "phoneNumber": phoneNumber ?? "",
      "verified": verified ?? "",
      "token": token ?? "",
      "planId": planId ?? "",
      "dateExpired": dateExpired ?? "",
      "datebought": datebought ?? ""
    });
    notifyListeners();
    print(userData); // Check if the data is stored correctly
  }

  Future<void> getprice(pair, WidgetRef ref) async {
    getPricesResult = GetPricesResult(
        GetPricesResultState.isLoading, PricesPerPairResponse());
    notifyListeners();
    final response = await getTraderRepository.getPrice(pair);
    getPricesResult = response;
    ref.read(getpriceProvider(pair).notifier).state =
        response.response.pricesList ?? PricesList();
    notifyListeners();
  }

  Future<void> getComment(signalid, WidgetRef ref) async {
    getCommentResult =
        GetCommentResult(GetCommentResultState.isLoading, GetComment());
    notifyListeners();
    final response = await getTraderRepository.getComment(signalid);
    getCommentResult = response;
    notifyListeners();
  }

  Future<void> sendComment(String firstname, String lastname, String comment,
      String image_url, String signal_id, WidgetRef ref) async {
    final SendComment sendComment = SendComment(
        firstname: firstname,
        lastname: lastname,
        imageUrl: image_url,
        comment: comment,
        signalId: signal_id);
    sendCommentResult = SendCommentResult(
        SendCommentResultState.isLoading, SendCommentResponse());
    notifyListeners();
    final response = await getTraderRepository.sendComment(sendComment);
    sendCommentResult = response;
    if (sendCommentResult.state == SendCommentResultState.isData) {
      Comment comment = Comment(
          id: sendCommentResult.response.data?.id ?? "",
          firstname: sendCommentResult.response.data?.firstname ?? "",
          lastname: sendCommentResult.response.data?.lastname ?? "",
          imageUrl: sendCommentResult.response.data?.imageUrl ?? "",
          dateCreated:
              sendCommentResult.response.data?.dateCreated ?? DateTime.now(),
          comment: sendCommentResult.response.data?.comment ?? "");

      final List<Comment> updatedComments =
          List.from(getCommentResult.response.comment ?? []);

// Add the new comment
      updatedComments.add(comment);
      //  getCommentResult.response.comment?.add(comment);
      getCommentResult = GetCommentResult(
          GetCommentResultState.isData, GetComment(comment: updatedComments));
    }
    notifyListeners();
  }
}
