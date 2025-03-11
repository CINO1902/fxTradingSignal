// To parse this JSON data, do
//
//     final pricesPerPairResponse = pricesPerPairResponseFromJson(jsonString);

import 'dart:convert';

PricesPerPairResponse pricesPerPairResponseFromJson(String str) => PricesPerPairResponse.fromJson(json.decode(str));

String pricesPerPairResponseToJson(PricesPerPairResponse data) => json.encode(data.toJson());

class PricesPerPairResponse {
    String? status;
    String? msg;
    PricesList? pricesList;

    PricesPerPairResponse({
        this.status,
        this.msg,
        this.pricesList,
    });

    factory PricesPerPairResponse.fromJson(Map<String, dynamic> json) => PricesPerPairResponse(
        status: json["status"],
        msg: json["msg"],
        pricesList: json["pricesList"] == null ? null : PricesList.fromJson(json["pricesList"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "pricesList": pricesList?.toJson(),
    };
}

class PricesList {
    String? id;
    String? pair;
    String? price;
    DateTime? dateCreated;
    int? v;

    PricesList({
        this.id,
        this.pair,
        this.price,
        this.dateCreated,
        this.v,
    });

    factory PricesList.fromJson(Map<String, dynamic> json) => PricesList(
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
