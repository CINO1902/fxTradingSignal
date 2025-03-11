// To parse this JSON data, do
//
//     final addCopyResponse = addCopyResponseFromJson(jsonString);

import 'dart:convert';

import 'getCopyModel.dart';

AddCopyResponse addCopyResponseFromJson(String str) => AddCopyResponse.fromJson(json.decode(str));

String addCopyResponseToJson(AddCopyResponse data) => json.encode(data.toJson());

class AddCopyResponse {
    String? status;
    String? msg;
    CopyTrade? data;

    AddCopyResponse({
        this.status,
        this.msg,
        this.data,
    });

    AddCopyResponse copyWith({
        String? status,
        String? msg,
        CopyTrade? data,
    }) => 
        AddCopyResponse(
            status: status ?? this.status,
            msg: msg ?? this.msg,
            data: data ?? this.data,
        );

    factory AddCopyResponse.fromJson(Map<String, dynamic> json) => AddCopyResponse(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? null : CopyTrade.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
    };
}

class Data {
    String? dataId;
    String? userId;
    String? signalId;
    DateTime? dateCreated;
    String? id;
    int? v;
    RelatedData? relatedData;

    Data({
        this.dataId,
        this.userId,
        this.signalId,
        this.dateCreated,
        this.id,
        this.v,
        this.relatedData,
    });

    Data copyWith({
        String? dataId,
        String? userId,
        String? signalId,
        DateTime? dateCreated,
        String? id,
        int? v,
        RelatedData? relatedData,
    }) => 
        Data(
            dataId: dataId ?? this.dataId,
            userId: userId ?? this.userId,
            signalId: signalId ?? this.signalId,
            dateCreated: dateCreated ?? this.dateCreated,
            id: id ?? this.id,
            v: v ?? this.v,
            relatedData: relatedData ?? this.relatedData,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dataId: json["id"],
        userId: json["user_id"],
        signalId: json["signal_id"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        id: json["_id"],
        v: json["__v"],
        relatedData: json["relatedData"] == null ? null : RelatedData.fromJson(json["relatedData"]),
    );

    Map<String, dynamic> toJson() => {
        "id": dataId,
        "user_id": userId,
        "signal_id": signalId,
        "date_created": dateCreated?.toIso8601String(),
        "_id": id,
        "__v": v,
        "relatedData": relatedData?.toJson(),
    };
}

class RelatedData {
    String? id;
    String? relatedDataId;
    String? signalName;
    String? signalType;
    String? stopLoss;
    String? order;
    String? entry;
    String? takeProfit;
    String? accessType;
    DateTime? dateCreated;
    int? v;
    bool? active;

    RelatedData({
        this.id,
        this.relatedDataId,
        this.signalName,
        this.signalType,
        this.stopLoss,
        this.order,
        this.entry,
        this.takeProfit,
        this.accessType,
        this.dateCreated,
        this.v,
        this.active,
    });

    RelatedData copyWith({
        String? id,
        String? relatedDataId,
        String? signalName,
        String? signalType,
        String? stopLoss,
        String? order,
        String? entry,
        String? takeProfit,
        String? accessType,
        DateTime? dateCreated,
        int? v,
        bool? active,
    }) => 
        RelatedData(
            id: id ?? this.id,
            relatedDataId: relatedDataId ?? this.relatedDataId,
            signalName: signalName ?? this.signalName,
            signalType: signalType ?? this.signalType,
            stopLoss: stopLoss ?? this.stopLoss,
            order: order ?? this.order,
            entry: entry ?? this.entry,
            takeProfit: takeProfit ?? this.takeProfit,
            accessType: accessType ?? this.accessType,
            dateCreated: dateCreated ?? this.dateCreated,
            v: v ?? this.v,
            active: active ?? this.active,
        );

    factory RelatedData.fromJson(Map<String, dynamic> json) => RelatedData(
        id: json["_id"],
        relatedDataId: json["id"],
        signalName: json["signal_name"],
        signalType: json["signal_type"],
        stopLoss: json["stop_loss"],
        order: json["order"],
        entry: json["entry"],
        takeProfit: json["take_profit"],
        accessType: json["access_type"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        v: json["__v"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": relatedDataId,
        "signal_name": signalName,
        "signal_type": signalType,
        "stop_loss": stopLoss,
        "order": order,
        "entry": entry,
        "take_profit": takeProfit,
        "access_type": accessType,
        "date_created": dateCreated?.toIso8601String(),
        "__v": v,
        "active": active,
    };
}
