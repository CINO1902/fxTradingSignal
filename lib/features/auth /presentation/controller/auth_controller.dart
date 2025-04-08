import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fx_trading_signal/features/getTraders/presentation/provider/homeProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/createaccount.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/loginRequest.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/loginResponse.dart';
import 'package:fx_trading_signal/features/auth%20/domain/entities/registerResponse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat/domain/usecases/sqlite.dart';
import '../../domain/entities/States/AuthResultState.dart';
import '../../domain/repositories/authrepo.dart';

class authController with ChangeNotifier {
  final AuthRepository authReposity;
  authController(this.authReposity);

  RegisterResult registerResult =
      RegisterResult(RegisterState.isEmpty, RegisterResponse());
  LogoutResult logotResult = LogoutResult(LogoutState.isLoading, "");
  GetOtpResult getOtpResult = GetOtpResult(GetOtpState.isEmpty, {});
  VerifyOtpResult verifyOtpResult =
      VerifyOtpResult(VerifyOtpResultState.isEmpty, {});
  RefreshTokenResult refreshTokenResult =
      RefreshTokenResult(RefreshTokenResultState.isEmpty, {});
  LoginResult loginResult = LoginResult(LoginState.isEmpty, LoginResponse());
  CompleteProfileResult completeProfileResult =
      CompleteProfileResult(CompleteProfileState.isEmpty, {});
  ImageUploadResult imageUploadResult =
      ImageUploadResult(ImageUploadResultStates.isEmpty, {});
  File? image;
  String? imageUrl;
  bool imageloading = false;

  Future<void> login(email, password) async {
    final pref = await SharedPreferences.getInstance();
    final fcmtoken = pref.getString('fcmtoken') ?? '';
    LoginRequest loginRequest =
        LoginRequest(email: email, password: password, fcmtoken: fcmtoken);
    final response = await authReposity.login(loginRequest);

    loginResult = response;
    notifyListeners();
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    final fcmtoken = pref.getString('fcmtoken') ?? '';
    final email = pref.getString('email') ?? '';
    DatabaseHelper().clearDatabase();
    LoginRequest loginRequest = LoginRequest(email: email, fcmtoken: fcmtoken);
    final response = await authReposity.logout(loginRequest);

    logotResult = response;
    notifyListeners();
  }

  Future<void> refreshToken(WidgetRef ref) async {
    final pref = await SharedPreferences.getInstance();
    final refreshtoken = pref.getString('refreshtoken') ?? '';
    final email = pref.getString('email') ?? '';

    refreshTokenResult =
        RefreshTokenResult(RefreshTokenResultState.isLoading, {});
    final response = await authReposity.refreshToken(email, refreshtoken);
    if (response.state == RefreshTokenResultState.isData) {
      await pref.setString('token', response.response['accessToken']);

      await pref.setString('refreshtoken', response.response['refreshToken']);
    }

    ref.read(getTraderController).getUserObject();

    refreshTokenResult = response;
    notifyListeners();
  }

  Future<void> register(String firstname, String lastname, String phonenumber,
      String email, String password, String country) async {
    registerResult =
        RegisterResult(RegisterState.isLoading, RegisterResponse());

    Register register = Register(
        firstname: firstname,
        lastname: lastname,
        phoneNumber: phonenumber,
        email: email,
        country: country,
        password: password);
    final response = await authReposity.createacount(register);

    registerResult = response;
    notifyListeners();
  }

  Future<void> requestOtp(
    String email,
  ) async {
    final response = await authReposity.requestOtp(email);
    getOtpResult = response;
    // registerResult = response;
    notifyListeners();
  }

  Future<void> verifyOtp(String email, otp) async {
    final response = await authReposity.verifyemail(email, otp);
    verifyOtpResult = response;
    // registerResult = response;
    notifyListeners();
  }

  void discardImage() {
    image = null;
    notifyListeners();
  }

  Future<void> pickimageupdate() async {
    try {
      imageloading = true;
      notifyListeners();
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (result == null) {
      //   return;
      // }
      final ImageTemporary = File(result!.path);

      image = ImageTemporary;
      imageloading = false;
      print(image);
    } catch (e) {
    } finally {
      imageloading = false; // Stop loading
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> uploadImage(email, allowNotification, tradeExperience) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dlsavisdq/upload');
    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'profile_image'
        ..files.add(await http.MultipartFile.fromPath('file', image!.path));

      // Apply a timeout of 15 seconds
      final response = await request.send().timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        final url = jsonMap['url'];
        imageUrl = url;
        await completeProfile(
            email, imageUrl!, allowNotification, tradeExperience);
      } else {
        imageUrl = null;
        completeProfileResult = CompleteProfileResult(
            CompleteProfileState.isError, {"message": "Something went wrong"});
      }
    } catch (e) {
      if (e is TimeoutException) {
        completeProfileResult = CompleteProfileResult(
            CompleteProfileState.isError, {"message": "Request timed out"});
      } else {
        completeProfileResult = CompleteProfileResult(
            CompleteProfileState.isError, {"message": "Something went wrong"});
      }
    }

    notifyListeners();
  }

  Future<void> uploadImagePer() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dlsavisdq/upload');
    imageUploadResult =
        ImageUploadResult(ImageUploadResultStates.isLoading, {});
    notifyListeners();
    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'profile_image'
        ..files.add(await http.MultipartFile.fromPath('file', image!.path));

      // Apply a timeout of 15 seconds
      final response = await request.send().timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);

        final url = jsonMap['url'];
        imageUrl = url;
        imageUploadResult =
            ImageUploadResult(ImageUploadResultStates.isData, {"message": ""});
        discardImage();
      } else {
        imageUrl = null;
        imageUploadResult = ImageUploadResult(ImageUploadResultStates.isError,
            {"message": "Something went wrong"});
      }
    } catch (e) {
      if (e is TimeoutException) {
        imageUploadResult = ImageUploadResult(
            ImageUploadResultStates.isError, {"message": "Request timed out"});
      } else {
        imageUploadResult = ImageUploadResult(ImageUploadResultStates.isError,
            {"message": "Something went wrong"});
      }
    }

    notifyListeners();
  }

  Future<void> completeProfile(String email, String imageurl,
      bool allowNotification, String tradeExperience) async {
    final response = await authReposity.completeprofile(
        email, imageurl, allowNotification, tradeExperience);
    completeProfileResult = response;
    // registerResult = response;
    notifyListeners();
  }

  void clearUserData() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('firstname');
    pref.remove('firstname');
    pref.remove('email');
    pref.remove('imageUrl');
    pref.remove('trading_experience');
    pref.remove('phoneNumber');
    pref.remove('verified');
    pref.remove('token');
    pref.remove('userId');
    pref.remove('refreshtoken');
    pref.remove('planId');
    pref.remove('datebought');
    pref.remove('dateExpieed');
  }
}
