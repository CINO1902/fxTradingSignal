// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
    String? status;
    String? msg;
    String? token;

    RegisterResponse({
        this.status,
        this.msg,
        this.token,
    });

    factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
        status: json["status"],
        msg: json["msg"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "token": token,
    };
}
