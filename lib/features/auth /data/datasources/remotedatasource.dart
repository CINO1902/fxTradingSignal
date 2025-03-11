import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/loginRequest.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/loginResponse.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/registerResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/enum.dart';
import '../../../../core/service/http_service.dart';
import '../../domain/entities/States/AuthResultState.dart';
import '../../domain/entities/createaccount.dart';
import '../repositories/auth_repo.dart';

class AuthDatasourceImp implements AuthDatasource {
  final HttpService httpService;

  AuthDatasourceImp(this.httpService);
  @override
  Future<RegisterResult> createacount(createaccount) async {
    RegisterResult registerResult =
        RegisterResult(RegisterState.isEmpty, RegisterResponse());

    final response = await httpService.request(
        url: '/createaccount',
        methodrequest: RequestMethod.post,
        data: registerToJson(createaccount));
    print(response.data);
    if (response.statusCode == 201) {
      final decodedResponse = RegisterResponse.fromJson(response.data);
      registerResult = RegisterResult(RegisterState.isData, decodedResponse);
    } else {
      final decodedResponse = RegisterResponse.fromJson(response.data);
      registerResult = RegisterResult(RegisterState.isError, decodedResponse);
    }

    return registerResult;
  }

  @override
  Future<LoginResult> login(login) async {
    LoginResult loginResult =
        LoginResult(LoginState.isLoading, LoginResponse());

    final response = await httpService.request(
        url: '/login',
        methodrequest: RequestMethod.post,
        data: loginRequestToJson(login));
    if (response.statusCode == 200) {
      final decodedResponse = LoginResponse.fromJson(response.data);

      loginResult = LoginResult(LoginState.isData, decodedResponse);
    } else {
      final decodedResponse = LoginResponse.fromJson(response.data);
      loginResult = LoginResult(LoginState.isError, decodedResponse);
    }

    return loginResult;
  }

  @override
  Future<GetOtpResult> requestOtp(email) async {
    GetOtpResult returnresponse = GetOtpResult(GetOtpState.isEmpty, {});

    final response = await httpService.request(
      url: '/request-otp',
      methodrequest: RequestMethod.post,
      data: jsonEncode({
        "email": email,
      }),
    );
    if (response.statusCode == 200) {
      returnresponse = GetOtpResult(GetOtpState.isData, response.data);
    } else {
      returnresponse = GetOtpResult(GetOtpState.isError, response.data);
    }

    return returnresponse;
  }

  @override
  Future<VerifyOtpResult> verifyemail(email, otp) async {
    VerifyOtpResult returnresponse =
        VerifyOtpResult(VerifyOtpResultState.isEmpty, {});
    final response = await httpService
        .request(url: '/verify-otp', methodrequest: RequestMethod.post, data: {
      "email": email,
      "otp": otp,
    });
    if (response.statusCode == 200) {
      returnresponse =
          VerifyOtpResult(VerifyOtpResultState.isData, response.data);
    } else {
      returnresponse =
          VerifyOtpResult(VerifyOtpResultState.isError, response.data);
    }

    return returnresponse;
  }

  @override
  Future<CompleteProfileResult> completeprofile(String email, String imageurl,
      bool allowNotification, String tradeExperience) async {
    CompleteProfileResult returnresponse =
        CompleteProfileResult(CompleteProfileState.isEmpty, {});
    final response = await httpService.request(
        url: '/complete-profile',
        methodrequest: RequestMethod.post,
        data: {
          "imageUrl": imageurl,
          "allownotification": allowNotification,
          "tradeExperience": tradeExperience,
          "email": email,
        });
    if (response.statusCode == 200) {
      returnresponse =
          CompleteProfileResult(CompleteProfileState.isData, response.data);
    } else {
      returnresponse =
          CompleteProfileResult(CompleteProfileState.isError, response.data);
    }

    return returnresponse;
  }

  @override
  Future<LogoutResult> logout(logout) async {
    LogoutResult logotResult = LogoutResult(LogoutState.isLoading, "");

    final response = await httpService.request(
        url: '/logout',
        methodrequest: RequestMethod.post,
        data: loginRequestToJson(logout));
    if (response.statusCode == 200) {
      // final decodedResponse = jsonDecode(response.)

      logotResult = LogoutResult(LogoutState.isData, response.data['msg']);
    } else {
      // final decodedResponse = LoginResponse.fromJson(response.data);
      logotResult = LogoutResult(LogoutState.isError, response.data['msg']);
    }

    return logotResult;
  }
}
