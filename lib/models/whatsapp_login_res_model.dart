import 'dart:convert';

WhatsappLoginResponseModel whatsappLoginResponseModelFromJson(String str) =>
    WhatsappLoginResponseModel.fromJson(json.decode(str));

String whatsappLoginResponseModelToJson(WhatsappLoginResponseModel data) =>
    json.encode(data.toJson());

class WhatsappLoginResponseModel {
  String? token;
  String? timestamp;
  String? timezone;
  Mobile? mobile;
  String? waNumber;
  String? waName;

  WhatsappLoginResponseModel({
    this.token,
    this.timestamp,
    this.timezone,
    this.mobile,
    this.waNumber,
    this.waName,
  });

  factory WhatsappLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      WhatsappLoginResponseModel(
        token: json["token"],
        timestamp: json["timestamp"],
        timezone: json["timezone"],
        mobile: json["mobile"] == null ? null : Mobile.fromJson(json["mobile"]),
        waNumber: json["waNumber"],
        waName: json["waName"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "timestamp": timestamp,
        "timezone": timezone,
        "mobile": mobile?.toJson(),
        "waNumber": waNumber,
        "waName": waName,
      };
}

class Mobile {
  String? name;
  String? number;

  Mobile({
    this.name,
    this.number,
  });

  factory Mobile.fromJson(Map<String, dynamic> json) => Mobile(
        name: json["name"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
      };
}
