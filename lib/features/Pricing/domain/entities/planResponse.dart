// To parse this JSON data, do
//
//     final planResponse = planResponseFromJson(jsonString);

import 'dart:convert';

PlanResponse planResponseFromJson(String str) => PlanResponse.fromJson(json.decode(str));

String planResponseToJson(PlanResponse data) => json.encode(data.toJson());

class PlanResponse {
    String? status;
    String? msg;
    List<Plan>? plans;

    PlanResponse({
        this.status,
        this.msg,
        this.plans,
    });

    PlanResponse copyWith({
        String? status,
        String? msg,
        List<Plan>? plans,
    }) => 
        PlanResponse(
            status: status ?? this.status,
            msg: msg ?? this.msg,
            plans: plans ?? this.plans,
        );

    factory PlanResponse.fromJson(Map<String, dynamic> json) => PlanResponse(
        status: json["status"],
        msg: json["msg"],
        plans: json["plans"] == null ? [] : List<Plan>.from(json["plans"]!.map((x) => Plan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "plans": plans == null ? [] : List<dynamic>.from(plans!.map((x) => x.toJson())),
    };
}

class Plan {
    String? id;
    String? planId;
    String? planName;
    double? planPrice;
    List<String>? planPrivielege;
    DateTime? dateCreated;
    int? v;

    Plan({
        this.id,
        this.planId,
        this.planName,
        this.planPrice,
        this.planPrivielege,
        this.dateCreated,
        this.v,
    });

    Plan copyWith({
        String? id,
        String? planId,
        String? planName,
        double? planPrice,
        List<String>? planPrivielege,
        DateTime? dateCreated,
        int? v,
    }) => 
        Plan(
            id: id ?? this.id,
            planId: planId ?? this.planId,
            planName: planName ?? this.planName,
            planPrice: planPrice ?? this.planPrice,
            planPrivielege: planPrivielege ?? this.planPrivielege,
            dateCreated: dateCreated ?? this.dateCreated,
            v: v ?? this.v,
        );

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["_id"],
        planId: json["id"],
        planName: json["planName"],
        planPrice: json["planPrice"]?.toDouble(),
        planPrivielege: json["planPrivielege"] == null ? [] : List<String>.from(json["planPrivielege"]!.map((x) => x)),
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": planId,
        "planName": planName,
        "planPrice": planPrice,
        "planPrivielege": planPrivielege == null ? [] : List<dynamic>.from(planPrivielege!.map((x) => x)),
        "date_created": dateCreated?.toIso8601String(),
        "__v": v,
    };
}
