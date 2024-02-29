import 'dart:convert';

UserDetailsResponseModel userDetailsResponseModelFromJson(String str) =>
    UserDetailsResponseModel.fromJson(json.decode(str));

String userDetailsResponseModelToJson(UserDetailsResponseModel data) => json.encode(data.toJson());

class UserDetailsResponseModel {
  int? status;
  bool? success;
  Data? data;

  UserDetailsResponseModel({
    this.status,
    this.success,
    this.data,
  });

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) => UserDetailsResponseModel(
        status: json["status"],
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  TalkAngelWallet? talkAngelWallet;
  String? id;
  String? name;
  String? userName;
  int? mobileNumber;
  int? countryCode;
  String? referCode;
  int? referCodeStatus;
  String? image;
  int? status;
  String? role;
  int? v;
  String? fcmToken;

  Data({
    this.talkAngelWallet,
    this.id,
    this.name,
    this.userName,
    this.mobileNumber,
    this.countryCode,
    this.referCode,
    this.referCodeStatus,
    this.image,
    this.status,
    this.role,
    this.v,
    this.fcmToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        talkAngelWallet: json["talk_angel_wallet"] == null ? null : TalkAngelWallet.fromJson(json["talk_angel_wallet"]),
        id: json["_id"],
        name: json["name"],
        userName: json["user_name"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        referCode: json["refer_code"],
        referCodeStatus: json["refer_code_status"],
        image: json["image"],
        status: json["status"],
        role: json["role"],
        v: json["__v"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "talk_angel_wallet": talkAngelWallet?.toJson(),
        "_id": id,
        "name": name,
        "user_name": userName,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "refer_code": referCode,
        "refer_code_status": referCodeStatus,
        "image": image,
        "status": status,
        "role": role,
        "__v": v,
        "fcmToken": fcmToken,
      };
}

class TalkAngelWallet {
  double? totalBallance;
  List<Transection>? transections;

  TalkAngelWallet({
    this.totalBallance,
    this.transections,
  });

  factory TalkAngelWallet.fromJson(Map<String, dynamic> json) => TalkAngelWallet(
        totalBallance: json["total_ballance"]?.toDouble(),
        transections: json["transections"] == null
            ? []
            : List<Transection>.from(json["transections"]!.map((x) => Transection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_ballance": totalBallance,
        "transections": transections == null ? [] : List<dynamic>.from(transections!.map((x) => x.toJson())),
      };
}

class Transection {
  double? amount;
  String? paymentId;
  String? type;
  double? curentBellance;
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
        amount: json["amount"]?.toDouble(),
        paymentId: json["payment_id"],
        type: json["type"],
        curentBellance: json["curent_bellance"]?.toDouble(),
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
