import 'dart:convert';

CallStatusUpdateResModel callStatusUpdateResModelFromJson(String str) =>
    CallStatusUpdateResModel.fromJson(json.decode(str));

String callStatusUpdateResModelToJson(CallStatusUpdateResModel data) => json.encode(data.toJson());

class CallStatusUpdateResModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  CallStatusUpdateResModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory CallStatusUpdateResModel.fromJson(Map<String, dynamic> json) => CallStatusUpdateResModel(
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
  String? name;
  int? mobileNumber;
  String? callStatus;

  Data({
    this.name,
    this.mobileNumber,
    this.callStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        callStatus: json["callStatus"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "callStatus": callStatus,
      };
}
