// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  String? firstname;
  String? lastname;
  String? email;
  String? country;
  String? phoneNumber;
  String? password;

  Register({
    this.firstname,
    this.lastname,
    this.email,
    this.country,
    this.phoneNumber,
    this.password,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        country: json["country"],
        phoneNumber: json["phone_number"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "country": country,
        "phone_number": phoneNumber,
        "password": password,
      };
}
