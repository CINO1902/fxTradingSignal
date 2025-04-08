import 'dart:io';

import 'package:fx_trading_signal/features/auth%20/domain/entities/States/AuthResultState.dart';

abstract class AuthDatasource {
  Future<RegisterResult> createacount(createaccount);
  Future<LoginResult> login(login);
  Future<LogoutResult> logout(logout);
  Future<GetOtpResult> requestOtp(email);
  Future<VerifyOtpResult> verifyemail(email, otp);
  Future<RefreshTokenResult> refreshToken(email, refreshtoken);
  Future<CompleteProfileResult> completeprofile(String email, String imageurl,
      bool allowNotification, String tradeExperience);
}
