// To parse this JSON data, do
//
//     final buyPlanResponse = buyPlanResponseFromJson(jsonString);

import 'dart:convert';

import '../../../auth /domain/entities/loginResponse.dart';

BuyPlanResponse buyPlanResponseFromJson(String str) =>
    BuyPlanResponse.fromJson(json.decode(str));

String buyPlanResponseToJson(BuyPlanResponse data) =>
    json.encode(data.toJson());

class BuyPlanResponse {
  String? status;
  String? msg;
  Plan? plans;

  BuyPlanResponse({
    this.status,
    this.msg,
    this.plans,
  });

  BuyPlanResponse copyWith({
    String? status,
    String? msg,
    Plan? plans,
  }) =>
      BuyPlanResponse(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        plans: plans ?? this.plans,
      );

  factory BuyPlanResponse.fromJson(Map<String, dynamic> json) =>
      BuyPlanResponse(
        status: json["status"],
        msg: json["msg"],
        plans: json["plans"] == null ? null : Plan.fromJson(json["plans"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "plans": plans?.toJson(),
      };
}
