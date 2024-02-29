import 'dart:convert';

StaffReportProblemResModel staffReportProblemResModelFromJson(String str) =>
    StaffReportProblemResModel.fromJson(json.decode(str));

String staffReportProblemResModelToJson(StaffReportProblemResModel data) =>
    json.encode(data.toJson());

class StaffReportProblemResModel {
  int? status;
  bool? success;
  String? message;

  StaffReportProblemResModel({
    this.status,
    this.success,
    this.message,
  });

  factory StaffReportProblemResModel.fromJson(Map<String, dynamic> json) =>
      StaffReportProblemResModel(
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
