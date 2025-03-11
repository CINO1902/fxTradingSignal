// To parse this JSON data, do
//
//     final signalResponse = signalResponseFromJson(jsonString);

import 'dart:convert';

SignalResponse signalResponseFromJson(String str) =>
    SignalResponse.fromJson(json.decode(str));

String signalResponseToJson(SignalResponse data) => json.encode(data.toJson());

class SignalResponse {
  String? status;
  String? msg;
  List<Signal>? signals;

  SignalResponse({
    this.status,
    this.msg,
    this.signals,
  });

  SignalResponse copyWith({
    String? status,
    String? msg,
    List<Signal>? signals,
  }) =>
      SignalResponse(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        signals: signals ?? this.signals,
      );

  factory SignalResponse.fromJson(Map<String, dynamic> json) => SignalResponse(
        status: json["status"],
        msg: json["msg"],
        signals: json["signals"] == null
            ? []
            : List<Signal>.from(
                json["signals"]!.map((x) => Signal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "signals": signals == null
            ? []
            : List<dynamic>.from(signals!.map((x) => x.toJson())),
      };
}

class Signal {
  String? id;
  String? signalName;
  String? signalType;
  String? stopLoss;
  String? order;
  String? entry;
  String? takeProfit;
  String? accessType;
  String? entries;
  DateTime? dateCreated;
  DateTime? dateCompleted;
  int? v;
  String? signalId;
  bool? copyTraded;
  bool? active;
  String? finalprice;

  Signal(
      {this.id,
      this.signalName,
      this.signalType,
      this.stopLoss,
      this.order,
      this.entry,
      this.takeProfit,
      this.entries,
      this.accessType,
      this.dateCreated,
      this.v,
      this.signalId,
      this.copyTraded,
      this.active,
      this.finalprice,
      this.dateCompleted});

  Signal copyWith({
    String? id,
    String? signalName,
    String? signalType,
    String? stopLoss,
    String? order,
    String? entry,
    String? takeProfit,
    String? entries,
    String? accessType,
    DateTime? dateCreated,
    int? v,
    String? signalId,
    bool? copyTraded,
    bool? active,
    String? finalprice,
    DateTime? dateCompleted,
  }) =>
      Signal(
          id: id ?? this.id,
          signalName: signalName ?? this.signalName,
          signalType: signalType ?? this.signalType,
          stopLoss: stopLoss ?? this.stopLoss,
          order: order ?? this.order,
          entry: entry ?? this.entry,
          entries: entries ?? this.entries,
          takeProfit: takeProfit ?? this.takeProfit,
          accessType: accessType ?? this.accessType,
          dateCreated: dateCreated ?? this.dateCreated,
          v: v ?? this.v,
          signalId: signalId ?? this.signalId,
          copyTraded: copyTraded ?? this.copyTraded,
          active: active ?? this.active,
          finalprice: finalprice ?? this.finalprice,
          dateCompleted: dateCompleted ?? this.dateCompleted);

  factory Signal.fromJson(Map<String, dynamic> json) => Signal(
        id: json["_id"],
        signalName: json["signal_name"],
        signalType: json["signal_type"],
        stopLoss: json["stop_loss"],
        order: json["order"],
        entry: json["entry"],
        entries: json["entries"],
        takeProfit: json["take_profit"],
        accessType: json["access_type"],
        dateCreated: json["date_created"] == null
            ? null
            : DateTime.parse(json["date_created"]),
        v: json["__v"],
        signalId: json["id"],
        copyTraded: json["copyTraded"],
        active: json['active'],
        finalprice: json['final_price'],
        dateCompleted: json["date_completed"] == null
            ? null
            : DateTime.parse(json["date_completed"]),
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
        "id": signalId,
        "copyTraded": copyTraded,
      };
}
