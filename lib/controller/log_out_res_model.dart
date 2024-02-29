import 'dart:convert';

LogOutResModel logOutResModelFromJson(String str) => LogOutResModel.fromJson(json.decode(str));

String logOutResModelToJson(LogOutResModel data) => json.encode(data.toJson());

class LogOutResModel {
  int? status;
  bool? success;
  String? message;

  LogOutResModel({
    this.status,
    this.success,
    this.message,
  });

  factory LogOutResModel.fromJson(Map<String, dynamic> json) => LogOutResModel(
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
