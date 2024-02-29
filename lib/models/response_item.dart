import 'dart:convert';

ResponseItem responseItemFromJson(String str) => ResponseItem.fromJson(json.decode(str));

String responseItemToJson(ResponseItem data) => json.encode(data.toJson());

class ResponseItem {
  ResponseItem({
    this.data,
    this.message = "",
    this.status = false,
    this.statusCode,
  });

  dynamic data;
  String? message;
  bool status;
  int? statusCode;

  factory ResponseItem.fromJson(Map<String, dynamic> json) => ResponseItem(
        data: json["data"],
        message: json["msg"],
        status: json["result"] ?? false,
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "msg": message,
        "status": status ?? false,
        "statusCode": statusCode,
      };
}
