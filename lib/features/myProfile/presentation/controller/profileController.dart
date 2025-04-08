import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/myProfile/domain/repositories/profileRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../getTraders/presentation/provider/homeProvider.dart';
import '../../domain/usecases/states.dart';

class Profilecontroller with ChangeNotifier {
  final ProfileRepository profileRepository;
  Profilecontroller(this.profileRepository);

  ChangePicResult changePicResult =
      ChangePicResult(ChangePicResultStates.isLoading, "");
  DeleteAccountResult deleteAccountResult =
      DeleteAccountResult(DeleteAccountResultStates.isLoading, "");

  Future<void> changeProfilePic(WidgetRef ref, String imageUrl) async {
    final token = ref.watch(getTraderController).userData['token'];
    changePicResult = ChangePicResult(ChangePicResultStates.isLoading, "");

    notifyListeners();
    final response = await profileRepository.changeProfilePic(token, imageUrl);
    changePicResult = response;
    if (changePicResult.state == ChangePicResultStates.isData) {
      final pref = await SharedPreferences.getInstance();
      pref.setString('imageUrl', imageUrl);
      await ref.read(getTraderController).getUserObject();
    }

    notifyListeners();
  }

  Future<void> deleteAccount(
    WidgetRef ref,
  ) async {
    final token = ref.watch(getTraderController).userData['token'];
    deleteAccountResult =
        DeleteAccountResult(DeleteAccountResultStates.isLoading, "");

    notifyListeners();
    final response = await profileRepository.deleteAccount(token);
    deleteAccountResult = response;

    notifyListeners();
  }
}
