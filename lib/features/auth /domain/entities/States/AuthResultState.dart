import 'package:fx_trading_signal/features/auth%20/domain/entities/registerResponse.dart';

// 0fe889445d934143856acb387e1ad821

import '../loginResponse.dart';

class RegisterResult {
  final RegisterState state;
  final RegisterResponse response;

  RegisterResult(this.state, this.response);
}

enum RegisterState { isLoading, isError, isData, isEmpty, networkissue }

class LoginResult {
  final LoginState state;
  final LoginResponse response;

  LoginResult(this.state, this.response);
}

enum LoginState { isLoading, isError, isData, isEmpty, networkissue }

class LogoutResult {
  final LogoutState state;
  final String response;

  LogoutResult(this.state, this.response);
}

enum LogoutState { isLoading, isError, isData, isEmpty, networkissue }

class GetOtpResult {
  final GetOtpState state;
  final Map response;

  GetOtpResult(this.state, this.response);
}

enum GetOtpState { isLoading, isError, isData, isEmpty, networkissue }

class VerifyOtpResult {
  final VerifyOtpResultState state;
  final Map response;

  VerifyOtpResult(this.state, this.response);
}

enum VerifyOtpResultState { isLoading, isError, isData, isEmpty, networkissue }

class CompleteProfileResult {
  final CompleteProfileState state;
  final Map response;

  CompleteProfileResult(this.state, this.response);
}

enum CompleteProfileState { isLoading, isError, isData, isEmpty, networkissue }

class ImageUploadResult {
  final ImageUploadResultStates state;
  final Map response;

  ImageUploadResult(this.state, this.response);
}

enum ImageUploadResultStates {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}

class RefreshTokenResult {
  final RefreshTokenResultState state;
  final Map response;

  RefreshTokenResult(this.state, this.response);
}

enum RefreshTokenResultState {
  isLoading,
  isError,
  isData,
  isEmpty,
  networkissue
}
