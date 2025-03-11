// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String? email;
  String? password;
  String? fcmtoken;

  LoginRequest({
    this.email,
    this.password,
    this.fcmtoken,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
      email: json["email"],
      password: json["password"],
      fcmtoken: json['fcmtoken']);

  Map<String, dynamic> toJson() =>
      {"email": email, "password": password, "fcmtoken": fcmtoken};
}
