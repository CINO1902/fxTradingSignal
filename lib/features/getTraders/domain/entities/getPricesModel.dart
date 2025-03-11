// To parse this JSON data, do
//
//     final pricesResponse = pricesResponseFromJson(jsonString);

import 'dart:convert';

PricesResponse pricesResponseFromJson(String str) => PricesResponse.fromJson(json.decode(str));

String pricesResponseToJson(PricesResponse data) => json.encode(data.toJson());

class PricesResponse {
    String? status;
    String? msg;
    List<PriceModel>? pricemodel;

    PricesResponse({
        this.status,
        this.msg,
        this.pricemodel,
    });

    factory PricesResponse.fromJson(Map<String, dynamic> json) => PricesResponse(
        status: json["status"],
        msg: json["msg"],
        pricemodel: json["signals"] == null ? [] : List<PriceModel>.from(json["signals"]!.map((x) => PriceModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "signals": pricemodel == null ? [] : List<dynamic>.from(pricemodel!.map((x) => x.toJson())),
    };
}

class PriceModel {
    String? id;
    String? pair;
    String? price;
    DateTime? dateCreated;
    int? v;

    PriceModel({
        this.id,
        this.pair,
        this.price,
        this.dateCreated,
        this.v,
    });

    factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
        id: json["_id"],
        pair: json["pair"],
        price: json["price"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "pair": pair,
        "price": price,
        "date_created": dateCreated?.toIso8601String(),
        "__v": v,
    };
}
