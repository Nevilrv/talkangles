import 'dart:convert';

AddRatingResModel addRatingResModelFromJson(String str) =>
    AddRatingResModel.fromJson(json.decode(str));

String addRatingResModelToJson(AddRatingResModel data) =>
    json.encode(data.toJson());

class AddRatingResModel {
  int? status;
  bool? success;
  String? message;

  AddRatingResModel({
    this.status,
    this.success,
    this.message,
  });

  factory AddRatingResModel.fromJson(Map<String, dynamic> json) =>
      AddRatingResModel(
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
