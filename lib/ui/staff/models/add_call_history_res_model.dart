import 'dart:convert';

AddCallHistoryResModel addCallHistoryResModelFromJson(String str) =>
    AddCallHistoryResModel.fromJson(json.decode(str));

String addCallHistoryResModelToJson(AddCallHistoryResModel data) =>
    json.encode(data.toJson());

class AddCallHistoryResModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  AddCallHistoryResModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory AddCallHistoryResModel.fromJson(Map<String, dynamic> json) =>
      AddCallHistoryResModel(
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
  String? userId;
  String? callType;
  DateTime? date;
  String? minutes;

  Data({
    this.name,
    this.mobileNumber,
    this.userId,
    this.callType,
    this.date,
    this.minutes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        userId: json["user_id"],
        callType: json["call_type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        minutes: json["minutes"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "user_id": userId,
        "call_type": callType,
        "date": date?.toIso8601String(),
        "minutes": minutes,
      };
}
