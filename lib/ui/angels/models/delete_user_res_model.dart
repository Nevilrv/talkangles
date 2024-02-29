import 'dart:convert';

DeleteAngelsResModel deleteAngelsResModelFromJson(String str) =>
    DeleteAngelsResModel.fromJson(json.decode(str));

String deleteAngelsResModelToJson(DeleteAngelsResModel data) =>
    json.encode(data.toJson());

class DeleteAngelsResModel {
  int? status;
  bool? success;
  String? message;

  DeleteAngelsResModel({
    this.status,
    this.success,
    this.message,
  });

  factory DeleteAngelsResModel.fromJson(Map<String, dynamic> json) =>
      DeleteAngelsResModel(
        status: json["status"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "message": message,
      };
}
