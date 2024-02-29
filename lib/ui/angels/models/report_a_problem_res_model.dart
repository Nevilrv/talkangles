import 'dart:convert';

ReportAProblemResModel reportAProblemResModelFromJson(String str) =>
    ReportAProblemResModel.fromJson(json.decode(str));

String reportAProblemResModelToJson(ReportAProblemResModel data) =>
    json.encode(data.toJson());

class ReportAProblemResModel {
  int? status;
  bool? success;
  String? message;

  ReportAProblemResModel({
    this.status,
    this.success,
    this.message,
  });

  factory ReportAProblemResModel.fromJson(Map<String, dynamic> json) =>
      ReportAProblemResModel(
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
