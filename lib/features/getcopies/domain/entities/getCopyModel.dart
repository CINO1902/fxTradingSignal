// To parse this JSON data, do
//
//     final getCopyResponse = getCopyResponseFromJson(jsonString);

import 'dart:convert';

import '../../../getSIgnals/domain/entities/SignalResponse.dart';

GetCopyResponse getCopyResponseFromJson(String str) =>
    GetCopyResponse.fromJson(json.decode(str));

String getCopyResponseToJson(GetCopyResponse data) =>
    json.encode(data.toJson());

class GetCopyResponse {
  String? status;
  String? msg;
  List<CopyTrade>? copyTrade;

  GetCopyResponse({
    this.status,
    this.msg,
    this.copyTrade,
  });

  factory GetCopyResponse.fromJson(Map<String, dynamic> json) =>
      GetCopyResponse(
        status: json["status"],
        msg: json["msg"],
        copyTrade: json["copyTrade"] == null
            ? []
            : List<CopyTrade>.from(
                json["copyTrade"]!.map((x) => CopyTrade.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "copyTrade": copyTrade == null
            ? []
            : List<dynamic>.from(copyTrade!.map((x) => x.toJson())),
      };
}
class CopyTrade {
  String? id;
  String? copyTradeId;
  String? userId;
  String? signalId;
  DateTime? dateCreated;
  int? v;
  Signal? relatedData;

  CopyTrade({
    this.id,
    this.copyTradeId,
    this.userId,
    this.signalId,
    this.dateCreated,
    this.v,
    this.relatedData,
  });

  CopyTrade copyWith({
    String? id,
    String? copyTradeId,
    String? userId,
    String? signalId,
    DateTime? dateCreated,
    int? v,
    Signal? relatedData,
  }) =>
      CopyTrade(
        id: id ?? this.id,
        copyTradeId: copyTradeId ?? this.copyTradeId,
        userId: userId ?? this.userId,
        signalId: signalId ?? this.signalId,
        dateCreated: dateCreated ?? this.dateCreated,
        v: v ?? this.v,
        relatedData: relatedData ?? this.relatedData,
      );

  factory CopyTrade.fromJson(Map<String, dynamic> json) => CopyTrade(
        id: json["_id"],
        copyTradeId: json["id"],
        userId: json["user_id"],
        signalId: json["signal_id"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        v: json["__v"],
        relatedData: json["relatedData"] == null
            ? null
            : Signal.fromJson(json["relatedData"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": copyTradeId,
        "user_id": userId,
        "signal_id": signalId,
        "date_created": dateCreated?.toIso8601String(),
        "__v": v,
        "relatedData": relatedData?.toJson(),
      };
}
