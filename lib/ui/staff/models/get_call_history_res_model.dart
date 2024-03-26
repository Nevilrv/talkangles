import 'dart:convert';

GetCallHistoryResModel getCallHistoryResModelFromJson(String str) => GetCallHistoryResModel.fromJson(json.decode(str));

String getCallHistoryResModelToJson(GetCallHistoryResModel data) => json.encode(data.toJson());

class GetCallHistoryResModel {
  int? status;
  bool? success;
  List<CallHistory>? data;

  GetCallHistoryResModel({
    this.status,
    this.success,
    this.data,
  });

  factory GetCallHistoryResModel.fromJson(Map<String, dynamic> json) => GetCallHistoryResModel(
        status: json["status"],
        success: json["success"],
        data: json["data"] == null ? [] : List<CallHistory>.from(json["data"]!.map((x) => CallHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CallHistory {
  User? user;
  List<History>? history;

  CallHistory({
    this.user,
    this.history,
  });

  factory CallHistory.fromJson(Map<String, dynamic> json) => CallHistory(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        history: json["history"] == null ? [] : List<History>.from(json["history"]!.map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "history": history == null ? [] : List<dynamic>.from(history!.map((x) => x.toJson())),
      };
}

class History {
  DateTime? date;
  String? callType;
  String? callTime;
  String? minutes;
  int? mobileNumber;

  History({
    this.date,
    this.callType,
    this.callTime,
    this.minutes,
    this.mobileNumber,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        callType: json["call_type"],
        callTime: json["call_time"],
        minutes: json["minutes"],
        mobileNumber: json["mobile_number"],
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "call_type": callType,
        "call_time": callTime,
        "minutes": minutes,
        "mobile_number": mobileNumber,
      };
}

class User {
  String? userName;
  int? mobileNumber;
  String? image;

  User({
    this.userName,
    this.mobileNumber,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userName: json["user_name"],
        mobileNumber: json["mobile_number"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "mobile_number": mobileNumber,
        "image": image,
      };
}
