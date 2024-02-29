import 'dart:convert';

RatingAddResponseModel ratingAddResponseModelFromJson(String str) =>
    RatingAddResponseModel.fromJson(json.decode(str));

String ratingAddResponseModelToJson(RatingAddResponseModel data) =>
    json.encode(data.toJson());

class RatingAddResponseModel {
  int? status;
  bool? success;
  String? message;

  RatingAddResponseModel({
    this.status,
    this.success,
    this.message,
  });

  factory RatingAddResponseModel.fromJson(Map<String, dynamic> json) =>
      RatingAddResponseModel(
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
