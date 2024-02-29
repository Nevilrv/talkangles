// To parse this JSON data, do
//
//     final rejectCallResModel = rejectCallResModelFromJson(jsonString);

import 'dart:convert';

RejectCallResModel rejectCallResModelFromJson(String str) =>
    RejectCallResModel.fromJson(json.decode(str));

String rejectCallResModelToJson(RejectCallResModel data) =>
    json.encode(data.toJson());

class RejectCallResModel {
  int? status;
  bool? success;
  String? message;

  RejectCallResModel({
    this.status,
    this.success,
    this.message,
  });

  factory RejectCallResModel.fromJson(Map<String, dynamic> json) =>
      RejectCallResModel(
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
