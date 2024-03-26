import 'dart:convert';

AngelAvailableStatusResModel angelAvailableStatusResModelFromJson(String str) =>
    AngelAvailableStatusResModel.fromJson(json.decode(str));

String angelAvailableStatusResModelToJson(AngelAvailableStatusResModel data) => json.encode(data.toJson());

class AngelAvailableStatusResModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  AngelAvailableStatusResModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory AngelAvailableStatusResModel.fromJson(Map<String, dynamic> json) => AngelAvailableStatusResModel(
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
  String? callAvailableStatus;

  Data({
    this.name,
    this.mobileNumber,
    this.callAvailableStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        callAvailableStatus: json["call_available_status"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "call_available_status": callAvailableStatus,
      };
}
