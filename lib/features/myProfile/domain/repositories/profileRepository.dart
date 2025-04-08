import 'dart:developer';

import 'package:fx_trading_signal/features/myProfile/data/repositories/profileRepo.dart';
import 'package:fx_trading_signal/features/myProfile/domain/usecases/states.dart';

import '../../../../core/exceptions/network_exception.dart';

abstract class ProfileRepository {
  Future<ChangePicResult> changeProfilePic(token, imageUrl);
  Future<DeleteAccountResult> deleteAccount(token);
}

class ProfileRepositoryImp implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  ProfileRepositoryImp(this.profileDataSource);

  @override
  Future<ChangePicResult> changeProfilePic(token, imageUrl) async {
    ChangePicResult changePicResult =
        ChangePicResult(ChangePicResultStates.isLoading, "");

    try {
      changePicResult =
          await profileDataSource.changeProfilePic(token, imageUrl);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        changePicResult =
            ChangePicResult(ChangePicResultStates.isError, message);
      } else {
        changePicResult = ChangePicResult(
            ChangePicResultStates.isError, "Something Went Wrong");
      }
    }
    return changePicResult;
  }

  @override
  Future<DeleteAccountResult> deleteAccount(token) async {
    DeleteAccountResult deleteAccountResult =
        DeleteAccountResult(DeleteAccountResultStates.isLoading, "");

    try {
      deleteAccountResult = await profileDataSource.deleteAccount(token);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        deleteAccountResult =
            DeleteAccountResult(DeleteAccountResultStates.isError, message);
      } else {
        deleteAccountResult = DeleteAccountResult(
            DeleteAccountResultStates.isError, "Something Went Wrong");
      }
    }
    return deleteAccountResult;
  }
}
