import '../../domain/usecases/states.dart';

abstract class ProfileDataSource {
  Future<ChangePicResult> changeProfilePic(email, imageUrl);
  Future<DeleteAccountResult> deleteAccount(email);
}
