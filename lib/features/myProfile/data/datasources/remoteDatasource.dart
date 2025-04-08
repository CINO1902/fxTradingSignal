import 'dart:convert';

import 'package:fx_trading_signal/features/myProfile/domain/usecases/states.dart';

import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../repositories/profileRepo.dart';

class ProfileDataSourceImp implements ProfileDataSource {
  final HttpService httpService;

  ProfileDataSourceImp(this.httpService);

  @override
  Future<ChangePicResult> changeProfilePic(token, imageUrl) async {
    ChangePicResult changePicResult =
        ChangePicResult(ChangePicResultStates.isLoading, "");

    final response = await httpService.request(
      url: '/updateProfilePicture',
      methodrequest: RequestMethod.postWithToken,
      authtoken: token,
      data: jsonEncode({"imageUrl": imageUrl}),
    );

    if (response.statusCode == 200) {
      changePicResult =
          ChangePicResult(ChangePicResultStates.isData, response.data['msg']);
    } else {
      changePicResult =
          ChangePicResult(ChangePicResultStates.isError, response.data['msg']);
    }

    return changePicResult;
  }

  @override
  Future<DeleteAccountResult> deleteAccount(token) async {
    DeleteAccountResult deleteAccountResult =
        DeleteAccountResult(DeleteAccountResultStates.isLoading, "");

    final response = await httpService.request(
      url: '/deleteAccount',
      methodrequest: RequestMethod.postWithToken,
      authtoken: token,
    );

    if (response.statusCode == 200) {
      deleteAccountResult = DeleteAccountResult(
          DeleteAccountResultStates.isData, response.data['msg']);
    } else {
      deleteAccountResult = DeleteAccountResult(
          DeleteAccountResultStates.isError, response.data['msg']);
    }
    return deleteAccountResult;
  }
}
