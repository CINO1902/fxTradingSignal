import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fx_trading_signal/features/auth%20/domain/entities/loginResponse.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../data/repositories/auth_repo.dart';
import '../entities/States/AuthResultState.dart';
import '../entities/createaccount.dart';
import '../entities/loginRequest.dart';

import '../entities/registerResponse.dart';

abstract class AuthRepository {
  Future<RegisterResult> createacount(Register createaccount);
  Future<LoginResult> login(LoginRequest login);
  Future<LogoutResult> logout(logout);
  Future<GetOtpResult> requestOtp(email);
  Future<VerifyOtpResult> verifyemail(email, otp);
  Future<RefreshTokenResult> refreshToken(email, refreshtoken);
  Future<CompleteProfileResult> completeprofile(String email, String imageurl,
      bool allowNotification, String tradeExperience);
}

class AuthRepositoryImp implements AuthRepository {
  final AuthDatasource authDatasource;
  AuthRepositoryImp(this.authDatasource);
  @override
  Future<RegisterResult> createacount(createaccount) async {
    RegisterResult registerResult =
        RegisterResult(RegisterState.isEmpty, RegisterResponse());

    try {
      registerResult = await authDatasource.createacount(createaccount);
    } catch (e) {
      log(e.toString());
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;
        final message = exp.errorMessage ?? e.message;
        registerResult = RegisterResult(
            RegisterState.isError, RegisterResponse(msg: message));
      } else {
        registerResult = RegisterResult(RegisterState.isError,
            RegisterResponse(msg: "Something Went Wrong "));
      }
    }
    return registerResult;
  }

  @override
  Future<LoginResult> login(LoginRequest login) async {
    LoginResult loginResult = LoginResult(LoginState.isEmpty, LoginResponse());

    try {
      loginResult = await authDatasource.login(login);
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;

        final message = exp.errorMessage ?? e.message;
        loginResult =
            LoginResult(LoginState.isError, LoginResponse(msg: message));
      } else {
        log(e.toString());
        print(e);
        loginResult = LoginResult(
            LoginState.isError, LoginResponse(msg: 'Something went wrong'));
      }
    }
    return loginResult;
  }

  @override
  Future<VerifyOtpResult> verifyemail(email, otp) async {
    VerifyOtpResult returnresponse =
        VerifyOtpResult(VerifyOtpResultState.isEmpty, {});
    try {
      returnresponse = await authDatasource.verifyemail(email, otp);
    } catch (e) {
      NetworkException exp = e as NetworkException;

      log(e.toString());

      final message = exp.errorMessage ?? e.message;
      returnresponse =
          VerifyOtpResult(VerifyOtpResultState.isError, {"message": message});
    }
    return returnresponse;
  }

  @override
  Future<GetOtpResult> requestOtp(email) async {
    GetOtpResult returnresponse = GetOtpResult(GetOtpState.isEmpty, {});
    try {
      returnresponse = await authDatasource.requestOtp(email);
    } catch (e) {
      log(e.toString());
      NetworkException exp = e as NetworkException;

      final message = exp.errorMessage ?? e.message;
      returnresponse = GetOtpResult(GetOtpState.isError, {"message": message});
    }
    return returnresponse;
  }

  @override
  Future<CompleteProfileResult> completeprofile(String email, String imageurl,
      bool allowNotification, String tradeExperience) async {
    CompleteProfileResult returnresponse =
        CompleteProfileResult(CompleteProfileState.isEmpty, {});
    try {
      returnresponse = await authDatasource.completeprofile(
          email, imageurl, allowNotification, tradeExperience);
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        log(e.toString());
        NetworkException exp = e as NetworkException;

        final message = exp.errorMessage ?? e.message;
        returnresponse = CompleteProfileResult(
            CompleteProfileState.isError, {"message": message});
      } else {
        returnresponse = CompleteProfileResult(
            CompleteProfileState.isError, {"message": 'Something went wrong'});
      }
    }
    return returnresponse;
  }

  @override
  Future<LogoutResult> logout(logout) async {
    LogoutResult logotResult = LogoutResult(LogoutState.isLoading, "");

    try {
      logotResult = await authDatasource.logout(logout);
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;

        final message = exp.errorMessage ?? e.message;
        logotResult = LogoutResult(LogoutState.isError, message);
      } else {
        log(e.toString());
        print(e);
        logotResult = LogoutResult(LogoutState.isError, 'Something went wrong');
      }
    }
    return logotResult;
  }

  @override
  Future<RefreshTokenResult> refreshToken(email, refreshtoken) async {
    RefreshTokenResult refreshTokenResult =
        RefreshTokenResult(RefreshTokenResultState.isLoading, {});

    try {
      refreshTokenResult =
          await authDatasource.refreshToken(email, refreshtoken);
    } catch (e) {
      if (e.runtimeType == NetworkException) {
        NetworkException exp = e as NetworkException;

        final message = exp.errorMessage ?? e.message;
        refreshTokenResult = RefreshTokenResult(
            RefreshTokenResultState.isError, {"msg": message});
      } else {
        log(e.toString());
        print(e);
        refreshTokenResult = RefreshTokenResult(
            RefreshTokenResultState.isError, {"msg": 'Something went wrong'});
      }
    }
    return refreshTokenResult;
  }
}
