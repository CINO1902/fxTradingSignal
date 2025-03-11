// To parse this JSON data, do
//
//     final sendCommentResponse = sendCommentResponseFromJson(jsonString);

import 'dart:convert';

SendCommentResponse sendCommentResponseFromJson(String str) => SendCommentResponse.fromJson(json.decode(str));

String sendCommentResponseToJson(SendCommentResponse data) => json.encode(data.toJson());

class SendCommentResponse {
    String? status;
    String? msg;
    Data? data;

    SendCommentResponse({
        this.status,
        this.msg,
        this.data,
    });

    factory SendCommentResponse.fromJson(Map<String, dynamic> json) => SendCommentResponse(
        status: json["status"],
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data?.toJson(),
    };
}

class Data {
    String? dataId;
    String? firstname;
    String? signalId;
    String? lastname;
    String? comment;
    String? imageUrl;
    DateTime? dateCreated;
    String? id;
    int? v;

    Data({
        this.dataId,
        this.firstname,
        this.signalId,
        this.lastname,
        this.comment,
        this.imageUrl,
        this.dateCreated,
        this.id,
        this.v,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dataId: json["id"],
        firstname: json["firstname"],
        signalId: json["signal_id"],
        lastname: json["lastname"],
        comment: json["comment"],
        imageUrl: json["image_url"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        id: json["_id"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "id": dataId,
        "firstname": firstname,
        "signal_id": signalId,
        "lastname": lastname,
        "comment": comment,
        "image_url": imageUrl,
        "date_created": dateCreated?.toIso8601String(),
        "_id": id,
        "__v": v,
    };
}
