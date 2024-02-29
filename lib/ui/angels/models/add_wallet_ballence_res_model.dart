import 'dart:convert';

AddWalletBallanceResponseModel addWalletBallanceResponseModelFromJson(
        String str) =>
    AddWalletBallanceResponseModel.fromJson(json.decode(str));

String addWalletBallanceResponseModelToJson(
        AddWalletBallanceResponseModel data) =>
    json.encode(data.toJson());

class AddWalletBallanceResponseModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  AddWalletBallanceResponseModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory AddWalletBallanceResponseModel.fromJson(Map<String, dynamic> json) =>
      AddWalletBallanceResponseModel(
        status: json["status"],
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? totalBallance;
  List<Transection>? transections;

  Data({
    this.totalBallance,
    this.transections,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalBallance: json["total_ballance"],
        transections: json["transections"] == null
            ? []
            : List<Transection>.from(
                json["transections"]!.map((x) => Transection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_ballance": totalBallance,
        "transections": transections == null
            ? []
            : List<dynamic>.from(transections!.map((x) => x.toJson())),
      };
}

class Transection {
  int? amount;
  String? paymentId;
  String? type;
  int? curentBellance;
  DateTime? date;
  String? id;

  Transection({
    this.amount,
    this.paymentId,
    this.type,
    this.curentBellance,
    this.date,
    this.id,
  });

  factory Transection.fromJson(Map<String, dynamic> json) => Transection(
        amount: json["amount"],
        paymentId: json["payment_id"],
        type: json["type"],
        curentBellance: json["curent_bellance"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "payment_id": paymentId,
        "type": type,
        "curent_bellance": curentBellance,
        "date": date?.toIso8601String(),
        "_id": id,
      };
}
