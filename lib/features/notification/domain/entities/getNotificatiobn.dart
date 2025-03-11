// To parse this JSON data, do
//
//     final getNotification = getNotificationFromJson(jsonString);

import 'dart:convert';

GetNotification getNotificationFromJson(String str) =>
    GetNotification.fromJson(json.decode(str));

String getNotificationToJson(GetNotification data) =>
    json.encode(data.toJson());

class GetNotification {
  String? status;
  String? msg;
  List<Notification>? notifications;

  GetNotification({
    this.status,
    this.msg,
    this.notifications,
  });

  GetNotification copyWith({
    String? status,
    String? msg,
    List<Notification>? notifications,
  }) =>
      GetNotification(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        notifications: notifications ?? this.notifications,
      );

  factory GetNotification.fromJson(Map<String, dynamic> json) =>
      GetNotification(
        status: json["status"],
        msg: json["msg"],
        notifications: json["notifications"] == null
            ? []
            : List<Notification>.from(
                json["notifications"]!.map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "notifications": notifications == null
            ? []
            : List<dynamic>.from(notifications!.map((x) => x.toJson())),
      };
}

class Notification {
  String? id;
  String? notificationId;
  String? signalId;
  String? title;
  String? body;
  String? payload;
  DateTime? date;
  int? v;

  Notification(
      {this.id,
      this.notificationId,
      this.signalId,
      this.title,
      this.body,
      this.payload,
      this.date,
      this.v});

  Notification copyWith({
    String? id,
    String? notificationId,
    String? signalId,
    String? title,
    String? body,
    String? payload,
    DateTime? date,
    int? v,
  }) =>
      Notification(
        id: id ?? this.id,
        notificationId: notificationId ?? this.notificationId,
        signalId: signalId ?? this.signalId,
        title: title ?? this.title,
        body: body ?? this.body,
        payload: payload ?? this.payload,
        date: date ?? this.date,
        v: v ?? this.v,
      );

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["_id"],
        notificationId: json["id"],
        signalId: json["signal_id"],
        title: json["title"],
        body: json["body"],
        payload: json["payload"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": notificationId,
        "signal_id": signalId,
        "title": title,
        "body": body,
        "payload": payload,
        "__v": v,
      };
}
