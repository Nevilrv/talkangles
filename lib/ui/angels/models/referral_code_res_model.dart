import 'dart:convert';

ReferralCodeResponseModel referralCodeResponseModelFromJson(String str) =>
    ReferralCodeResponseModel.fromJson(json.decode(str));

String referralCodeResponseModelToJson(ReferralCodeResponseModel data) =>
    json.encode(data.toJson());

class ReferralCodeResponseModel {
  int? status;
  bool? success;
  String? message;

  ReferralCodeResponseModel({
    this.status,
    this.success,
    this.message,
  });

  factory ReferralCodeResponseModel.fromJson(Map<String, dynamic> json) =>
      ReferralCodeResponseModel(
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
