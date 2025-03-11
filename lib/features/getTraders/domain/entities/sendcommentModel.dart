// To parse this JSON data, do
//
//     final sendComment = sendCommentFromJson(jsonString);

import 'dart:convert';

SendComment sendCommentFromJson(String str) => SendComment.fromJson(json.decode(str));

String sendCommentToJson(SendComment data) => json.encode(data.toJson());

class SendComment {
    String? firstname;
    String? lastname;
    String? comment;
    String? imageUrl;
    String? signalId;

    SendComment({
        this.firstname,
        this.lastname,
        this.comment,
        this.imageUrl,
        this.signalId,
    });

    factory SendComment.fromJson(Map<String, dynamic> json) => SendComment(
        firstname: json["firstname"],
        lastname: json["lastname"],
        comment: json["comment"],
        imageUrl: json["image_url"],
        signalId: json["signal_id"],
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "comment": comment,
        "image_url": imageUrl,
        "signal_id": signalId,
    };
}
