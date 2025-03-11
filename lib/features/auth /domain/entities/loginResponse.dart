// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String? token;
    String? msg;
    String? success;
    User? user;

    LoginResponse({
        this.token,
        this.msg,
        this.success,
        this.user,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        msg: json["msg"],
        success: json["success"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "msg": msg,
        "success": success,
        "user": user?.toJson(),
    };
}

class User {
    String? firstname;
    String? lastname;
    String? email;
    String? imageUrl;
    String? phoneNumber;
    String? tradingExperience;
    bool? verified;
        bool? completeprofile;

    User({
        this.firstname,
        this.lastname,
        this.email,
        this.imageUrl,
        this.phoneNumber,
        this.tradingExperience,
        this.verified,
        this.completeprofile
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        phoneNumber: json["phoneNumber"],
        tradingExperience: json["tradingExperience"],
        verified: json["verified"],
        completeprofile: json["completeprofile"]
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "imageUrl": imageUrl,
        "phoneNumber": phoneNumber,
        "tradingExperience": tradingExperience,
        "verified": verified,
    };
}
