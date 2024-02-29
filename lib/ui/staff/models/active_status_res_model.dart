import 'dart:convert';

ActiveStatusResModel activeStatusResModelFromJson(String str) =>
    ActiveStatusResModel.fromJson(json.decode(str));

String activeStatusResModelToJson(ActiveStatusResModel data) =>
    json.encode(data.toJson());

class ActiveStatusResModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  ActiveStatusResModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory ActiveStatusResModel.fromJson(Map<String, dynamic> json) =>
      ActiveStatusResModel(
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
  String? activeStatus;

  Data({
    this.name,
    this.mobileNumber,
    this.activeStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        mobileNumber: json["mobile_number"],
        activeStatus: json["active_status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "active_status": activeStatus,
      };
}
