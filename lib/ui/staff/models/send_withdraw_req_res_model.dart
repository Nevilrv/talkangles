import 'dart:convert';

SendWithdrawReqResModel sendWithdrawReqResModelFromJson(String str) =>
    SendWithdrawReqResModel.fromJson(json.decode(str));

String sendWithdrawReqResModelToJson(SendWithdrawReqResModel data) =>
    json.encode(data.toJson());

class SendWithdrawReqResModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  SendWithdrawReqResModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory SendWithdrawReqResModel.fromJson(Map<String, dynamic> json) =>
      SendWithdrawReqResModel(
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
  String? requestAmount;
  int? currentAmount;
  int? pendingAmount;
  DateTime? date;
  String? requestStatus;

  Data({
    this.requestAmount,
    this.currentAmount,
    this.pendingAmount,
    this.date,
    this.requestStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        requestAmount: json["request_amount"],
        currentAmount: json["current_amount"],
        pendingAmount: json["pending_amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        requestStatus: json["request_status"],
      );

  Map<String, dynamic> toJson() => {
        "request_amount": requestAmount,
        "current_amount": currentAmount,
        "pending_amount": pendingAmount,
        "date": date?.toIso8601String(),
        "request_status": requestStatus,
      };
}
