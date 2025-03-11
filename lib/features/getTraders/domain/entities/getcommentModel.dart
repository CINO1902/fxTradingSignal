import 'dart:convert';

GetComment getCommentFromJson(String str) => GetComment.fromJson(json.decode(str));

String getCommentToJson(GetComment data) => json.encode(data.toJson());

class GetComment {
    String? status;
    String? msg;
    List<Comment>? comment;

    GetComment({
        this.status,
        this.msg,
        this.comment,
    });

    factory GetComment.fromJson(Map<String, dynamic> json) => GetComment(
        status: json["status"],
        msg: json["msg"],
        comment: json["comment"] == null ? [] : List<Comment>.from(json["comment"]!.map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "comment": comment == null ? [] : List<dynamic>.from(comment!.map((x) => x.toJson())),
    };
}

class Comment {
    String? id;
    String? commentId;
    String? firstname;
    String? signalId;
    String? lastname;
    String? comment;
    String? imageUrl;
    DateTime? dateCreated;
    int? v;

    Comment({
        this.id,
        this.commentId,
        this.firstname,
        this.signalId,
        this.lastname,
        this.comment,
        this.imageUrl,
        this.dateCreated,
        this.v,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        commentId: json["id"],
        firstname: json["firstname"],
        signalId: json["signal_id"],
        lastname: json["lastname"],
        comment: json["comment"],
        imageUrl: json["image_url"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "id": commentId,
        "firstname": firstname,
        "signal_id": signalId,
        "lastname": lastname,
        "comment": comment,
        "image_url": imageUrl,
        "date_created": dateCreated?.toIso8601String(),
        "__v": v,
    };
}
