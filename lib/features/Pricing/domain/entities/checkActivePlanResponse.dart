// To parse this JSON data, do
//
//     final checkActivePlan = checkActivePlanFromJson(jsonString);

import 'dart:convert';

CheckActivePlan checkActivePlanFromJson(String str) => CheckActivePlan.fromJson(json.decode(str));

String checkActivePlanToJson(CheckActivePlan data) => json.encode(data.toJson());

class CheckActivePlan {
    String? status;
    String? msg;
    bool? hasActivePlan;
    Plan? plan;

    CheckActivePlan({
        this.status,
        this.msg,
        this.hasActivePlan,
        this.plan,
    });

    CheckActivePlan copyWith({
        String? status,
        String? msg,
        bool? hasActivePlan,
        Plan? plan,
    }) => 
        CheckActivePlan(
            status: status ?? this.status,
            msg: msg ?? this.msg,
            hasActivePlan: hasActivePlan ?? this.hasActivePlan,
            plan: plan ?? this.plan,
        );

    factory CheckActivePlan.fromJson(Map<String, dynamic> json) => CheckActivePlan(
        status: json["status"],
        msg: json["msg"],
        hasActivePlan: json["hasActivePlan"],
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "hasActivePlan": hasActivePlan,
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
