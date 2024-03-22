import 'dart:convert';

GetAngleListResModel getAngleListResModelFromJson(String str) => GetAngleListResModel.fromJson(json.decode(str));

String getAngleListResModelToJson(GetAngleListResModel data) => json.encode(data.toJson());

class GetAngleListResModel {
  int? status;
  bool? success;
  List<AngleData>? data;

  GetAngleListResModel({
    this.status,
    this.success,
    this.data,
  });

  factory GetAngleListResModel.fromJson(Map<String, dynamic> json) => GetAngleListResModel(
        status: json["status"],
        success: json["success"],
        data: json["data"] == null ? [] : List<AngleData>.from(json["data"]!.map((x) => AngleData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AngleData {
  String? id;
  String? userName;
  String? name;
  int? mobileNumber;
  String? gender;
  String? bio;
  String? image;
  String? language;
  int? age;
  String? activeStatus;
  String? callStatus;
  int? charges;
  String? fcmToken;
  int? countryCode;
  double? totalRating;
  String? totalListing;
  List<Review>? reviews;

  AngleData({
    this.id,
    this.userName,
    this.name,
    this.mobileNumber,
    this.gender,
    this.bio,
    this.image,
    this.language,
    this.age,
    this.activeStatus,
    this.callStatus,
    this.charges,
    this.fcmToken,
    this.countryCode,
    this.totalRating,
    this.totalListing,
    this.reviews,
  });

  factory AngleData.fromJson(Map<String, dynamic> json) => AngleData(
        id: json["_id"],
        userName: json["user_name"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        gender: json["gender"],
        bio: json["bio"],
        image: json["image"],
        language: json["language"],
        age: json["age"],
        activeStatus: json["active_status"],
        callStatus: json["call_status"],
        charges: json["charges"],
        fcmToken: json["fcmToken"],
        countryCode: json["country_code"],
        totalRating: json["total_rating"]?.toDouble(),
        totalListing: json["total_listing"],
        reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_name": userName,
        "name": name,
        "mobile_number": mobileNumber,
        "gender": gender,
        "bio": bio,
        "image": image,
        "language": language,
        "age": age,
        "active_status": activeStatus,
        "call_status": callStatus,
        "charges": charges,
        "fcmToken": fcmToken,
        "country_code": countryCode,
        "total_rating": totalRating,
        "total_listing": totalListing,
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class Review {
  int? rating;
  String? comment;
  DateTime? date;
  String? id;

  Review({
    this.rating,
    this.comment,
    this.date,
    this.id,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json["rating"],
        comment: json["comment"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "comment": comment,
        "date": date?.toIso8601String(),
        "_id": id,
      };
}
