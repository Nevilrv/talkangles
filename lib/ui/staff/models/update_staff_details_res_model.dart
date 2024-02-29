import 'dart:convert';

UpdateStaffDetailResModel updateStaffDetailResModelFromJson(String str) =>
    UpdateStaffDetailResModel.fromJson(json.decode(str));

String updateStaffDetailResModelToJson(UpdateStaffDetailResModel data) => json.encode(data.toJson());

class UpdateStaffDetailResModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  UpdateStaffDetailResModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory UpdateStaffDetailResModel.fromJson(Map<String, dynamic> json) => UpdateStaffDetailResModel(
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
  Listing? listing;
  Earnings? earnings;
  String? id;
  String? userName;
  String? name;
  int? mobileNumber;
  int? countryCode;
  String? gender;
  String? bio;
  String? image;
  String? language;
  String? age;
  String? activeStatus;
  String? callStatus;
  int? status;
  int? charges;
  String? role;
  int? totalRating;
  int? logOut;
  List<Review>? reviews;
  DateTime? updatedAt;
  int? v;
  String? fcmToken;

  Data({
    this.listing,
    this.earnings,
    this.id,
    this.userName,
    this.name,
    this.mobileNumber,
    this.countryCode,
    this.gender,
    this.bio,
    this.image,
    this.language,
    this.age,
    this.activeStatus,
    this.callStatus,
    this.status,
    this.charges,
    this.role,
    this.totalRating,
    this.logOut,
    this.reviews,
    this.updatedAt,
    this.v,
    this.fcmToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        listing: json["listing"] == null ? null : Listing.fromJson(json["listing"]),
        earnings: json["earnings"] == null ? null : Earnings.fromJson(json["earnings"]),
        id: json["_id"],
        userName: json["user_name"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        countryCode: json["country_code"],
        gender: json["gender"],
        bio: json["bio"],
        image: json["image"],
        language: json["language"],
        age: json["age"],
        activeStatus: json["active_status"],
        callStatus: json["call_status"],
        status: json["status"],
        charges: json["charges"],
        role: json["role"],
        totalRating: json["total_rating"],
        logOut: json["log_out"],
        reviews: json["reviews"] == null ? [] : List<Review>.from(json["reviews"]!.map((x) => Review.fromJson(x))),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        v: json["__v"],
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "listing": listing?.toJson(),
        "earnings": earnings?.toJson(),
        "_id": id,
        "user_name": userName,
        "name": name,
        "mobile_number": mobileNumber,
        "country_code": countryCode,
        "gender": gender,
        "bio": bio,
        "image": image,
        "language": language,
        "age": age,
        "active_status": activeStatus,
        "call_status": callStatus,
        "status": status,
        "charges": charges,
        "role": role,
        "total_rating": totalRating,
        "log_out": logOut,
        "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
        "fcmToken": fcmToken,
      };
}

class Earnings {
  double? currentEarnings;
  int? totalMoneyWithdraws;
  double? totalPendingMoney;
  int? sentWithdrawRequest;

  Earnings({
    this.currentEarnings,
    this.totalMoneyWithdraws,
    this.totalPendingMoney,
    this.sentWithdrawRequest,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
        currentEarnings: json["current_earnings"]?.toDouble(),
        totalMoneyWithdraws: json["total_money_withdraws"],
        totalPendingMoney: json["total_pending_money"]?.toDouble(),
        sentWithdrawRequest: json["sent_withdraw_request"],
      );

  Map<String, dynamic> toJson() => {
        "current_earnings": currentEarnings,
        "total_money_withdraws": totalMoneyWithdraws,
        "total_pending_money": totalPendingMoney,
        "sent_withdraw_request": sentWithdrawRequest,
      };
}

class Listing {
  String? totalMinutes;
  List<CallHistory>? callHistory;

  Listing({
    this.totalMinutes,
    this.callHistory,
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        totalMinutes: json["total_minutes"],
        callHistory: json["call_history"] == null
            ? []
            : List<CallHistory>.from(json["call_history"]!.map((x) => CallHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_minutes": totalMinutes,
        "call_history": callHistory == null ? [] : List<dynamic>.from(callHistory!.map((x) => x.toJson())),
      };
}

class CallHistory {
  String? user;
  List<History>? history;
  String? id;

  CallHistory({
    this.user,
    this.history,
    this.id,
  });

  factory CallHistory.fromJson(Map<String, dynamic> json) => CallHistory(
        user: json["user"],
        history: json["history"] == null ? [] : List<History>.from(json["history"]!.map((x) => History.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "history": history == null ? [] : List<dynamic>.from(history!.map((x) => x.toJson())),
        "_id": id,
      };
}

class History {
  DateTime? date;
  String? callType;
  int? mobileNumber;
  String? minutes;
  String? id;

  History({
    this.date,
    this.callType,
    this.mobileNumber,
    this.minutes,
    this.id,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        callType: json["call_type"],
        mobileNumber: json["mobile_number"],
        minutes: json["minutes"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "call_type": callType,
        "mobile_number": mobileNumber,
        "minutes": minutes,
        "_id": id,
      };
}

class Review {
  String? user;
  List<UserReview>? userReviews;
  String? id;

  Review({
    this.user,
    this.userReviews,
    this.id,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        user: json["user"],
        userReviews: json["user_reviews"] == null
            ? []
            : List<UserReview>.from(json["user_reviews"]!.map((x) => UserReview.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "user_reviews": userReviews == null ? [] : List<dynamic>.from(userReviews!.map((x) => x.toJson())),
        "_id": id,
      };
}

class UserReview {
  int? rating;
  String? comment;
  DateTime? date;
  String? id;

  UserReview({
    this.rating,
    this.comment,
    this.date,
    this.id,
  });

  factory UserReview.fromJson(Map<String, dynamic> json) => UserReview(
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
