// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String? token;
    String? refreshToken;
    String? msg;
    String? success;
    User? user;

    LoginResponse({
        this.token,
        this.refreshToken,
        this.msg,
        this.success,
        this.user,
    });

    LoginResponse copyWith({
        String? token,
        String? refreshToken,
        String? msg,
        String? success,
        User? user,
    }) => 
        LoginResponse(
            token: token ?? this.token,
            refreshToken: refreshToken ?? this.refreshToken,
            msg: msg ?? this.msg,
            success: success ?? this.success,
            user: user ?? this.user,
        );

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        refreshToken: json["refreshToken"],
        msg: json["msg"],
        success: json["success"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "refreshToken": refreshToken,
        "msg": msg,
        "success": success,
        "user": user?.toJson(),
    };
}

class User {
    String? firstname;
    String? lastname;
    String? userId;
    String? email;
    String? imageUrl;
    String? phoneNumber;
    String? tradingExperience;
    bool? verified;
    bool? completeprofile;
    Plan? plan;

    User({
        this.firstname,
        this.lastname,
        this.userId,
        this.email,
        this.imageUrl,
        this.phoneNumber,
        this.tradingExperience,
        this.verified,
        this.completeprofile,
        this.plan,
    });

    User copyWith({
        String? firstname,
        String? lastname,
        String? userId,
        String? email,
        String? imageUrl,
        String? phoneNumber,
        String? tradingExperience,
        bool? verified,
        bool? completeprofile,
        Plan? plan,
    }) => 
        User(
            firstname: firstname ?? this.firstname,
            lastname: lastname ?? this.lastname,
            userId: userId ?? this.userId,
            email: email ?? this.email,
            imageUrl: imageUrl ?? this.imageUrl,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            tradingExperience: tradingExperience ?? this.tradingExperience,
            verified: verified ?? this.verified,
            completeprofile: completeprofile ?? this.completeprofile,
            plan: plan ?? this.plan,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        firstname: json["firstname"],
        lastname: json["lastname"],
        userId: json["userId"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        phoneNumber: json["phoneNumber"],
        tradingExperience: json["tradingExperience"],
        verified: json["verified"],
        completeprofile: json["completeprofile"],
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "userId": userId,
        "email": email,
        "imageUrl": imageUrl,
        "phoneNumber": phoneNumber,
        "tradingExperience": tradingExperience,
        "verified": verified,
        "completeprofile": completeprofile,
        "plan": plan?.toJson(),
    };
}

class Plan {
    String? id;
    String? planId;
    String? planName;
    String? userId;
    double? planPrice;
    List<String>? planPrivielege;
    DateTime? dateBought;
    DateTime? dateExpired;
    int? v;

    Plan({
        this.id,
        this.planId,
        this.planName,
        this.userId,
        this.planPrice,
        this.planPrivielege,
        this.dateBought,
        this.dateExpired,
        this.v,
    });

    Plan copyWith({
        String? id,
        String? planId,
        String? planName,
        String? userId,
        double? planPrice,
        List<String>? planPrivielege,
        DateTime? dateBought,
        DateTime? dateExpired,
        int? v,
    }) => 
        Plan(
            id: id ?? this.id,
            planId: planId ?? this.planId,
            planName: planName ?? this.planName,
            userId: userId ?? this.userId,
            planPrice: planPrice ?? this.planPrice,
            planPrivielege: planPrivielege ?? this.planPrivielege,
            dateBought: dateBought ?? this.dateBought,
            dateExpired: dateExpired ?? this.dateExpired,
            v: v ?? this.v,
        );

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["_id"],
        planId: json["id"],
        planName: json["planName"],
        userId: json["user_id"],
        planPrice: json["planPrice"]?.toDouble(),
        planPrivielege: json["planPrivielege"] == null ? [] : List<String>.from(json["planPrivielege"]!.map((x) => x)),
        dateBought: json["date_bought"] == null ? null : DateTime.parse(json["date_bought"]),
        dateExpired: json["date_expired"] == null ? null : DateTime.parse(json["date_expired"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": planId,
        "planName": planName,
        "user_id": userId,
        "planPrice": planPrice,
        "planPrivielege": planPrivielege == null ? [] : List<dynamic>.from(planPrivielege!.map((x) => x)),
        "date_bought": dateBought?.toIso8601String(),
        "date_expired": dateExpired?.toIso8601String(),
        "__v": v,
    };
}
