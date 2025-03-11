// To parse this JSON data, do
//
//     final signalById = signalByIdFromJson(jsonString);

import 'dart:convert';

SignalById signalByIdFromJson(String str) =>
    SignalById.fromJson(json.decode(str));

String signalByIdToJson(SignalById data) => json.encode(data.toJson());

class SignalById {
  String? status;
  String? msg;
  Signals? signals;

  SignalById({
    this.status,
    this.msg,
    this.signals,
  });

  SignalById copyWith({
    String? status,
    String? msg,
    Signals? signals,
  }) =>
      SignalById(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        signals: signals ?? this.signals,
      );

  factory SignalById.fromJson(Map<String, dynamic> json) => SignalById(
        status: json["status"],
        msg: json["msg"],
        signals:
            json["signals"] == null ? null : Signals.fromJson(json["signals"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "signals": signals?.toJson(),
      };
}

class Signals {
  String? id;
  String? signalName;
  String? signalType;
  String? stopLoss;
  String? order;
  String? entry;
  String? takeProfit;
  String? accessType;
  DateTime? dateCreated;
  int? v;
  String? signalsId;
  bool? active;
  String? entries;
  DateTime? dateCompleted;
  String? finalPrice;
  bool? copyTraded;

  Signals({
    this.id,
    this.signalName,
    this.signalType,
    this.stopLoss,
    this.order,
    this.entry,
    this.takeProfit,
    this.accessType,
    this.dateCreated,
    this.v,
    this.signalsId,
    this.active,
    this.entries,
    this.dateCompleted,
    this.finalPrice,
    this.copyTraded,
  });

  Signals copyWith({
    String? id,
    String? signalName,
    String? signalType,
    String? stopLoss,
    String? order,
    String? entry,
    String? takeProfit,
    String? accessType,
    DateTime? dateCreated,
    int? v,
    String? signalsId,
    bool? active,
    String? entries,
    DateTime? dateCompleted,
    String? finalPrice,
    bool? copyTraded,
  }) =>
      Signals(
        id: id ?? this.id,
        signalName: signalName ?? this.signalName,
        signalType: signalType ?? this.signalType,
        stopLoss: stopLoss ?? this.stopLoss,
        order: order ?? this.order,
        entry: entry ?? this.entry,
        takeProfit: takeProfit ?? this.takeProfit,
        accessType: accessType ?? this.accessType,
        dateCreated: dateCreated ?? this.dateCreated,
        v: v ?? this.v,
        signalsId: signalsId ?? this.signalsId,
        active: active ?? this.active,
        entries: entries ?? this.entries,
        dateCompleted: dateCompleted ?? this.dateCompleted,
        finalPrice: finalPrice ?? this.finalPrice,
        copyTraded: copyTraded ?? this.copyTraded,
      );

  factory Signals.fromJson(Map<String, dynamic> json) => Signals(
        id: json["_id"],
        signalName: json["signal_name"],
        signalType: json["signal_type"],
        stopLoss: json["stop_loss"],
        order: json["order"],
        entry: json["entry"],
        takeProfit: json["take_profit"],
        accessType: json["access_type"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        v: json["__v"],
        signalsId: json["id"],
        active: json["active"],
        entries: json["entries"],
        dateCompleted: json["date_completed"] == null
            ? null
            : DateTime.parse(json["date_completed"]),
        finalPrice: json["final_price"],
        copyTraded: json["copyTraded"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "signal_name": signalName,
        "signal_type": signalType,
        "stop_loss": stopLoss,
        "order": order,
        "entry": entry,
        "take_profit": takeProfit,
        "access_type": accessType,
        "date_created": dateCreated?.toIso8601String(),
        "__v": v,
        "id": signalsId,
        "active": active,
        "entries": entries,
        "date_completed": dateCompleted?.toIso8601String(),
        "final_price": finalPrice,
        "copyTraded": copyTraded,
      };
}
