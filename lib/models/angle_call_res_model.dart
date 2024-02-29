import 'dart:convert';

AngleCallResModel angleCallResModelFromJson(String str) =>
    AngleCallResModel.fromJson(json.decode(str));

String angleCallResModelToJson(AngleCallResModel data) =>
    json.encode(data.toJson());

class AngleCallResModel {
  int? status;
  bool? success;
  String? message;
  Data? data;

  AngleCallResModel({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory AngleCallResModel.fromJson(Map<String, dynamic> json) =>
      AngleCallResModel(
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
  String? angelName;
  AgoraInfo? agoraInfo;

  Data({
    this.angelName,
    this.agoraInfo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        angelName: json["angel_name"],
        agoraInfo: json["agoraInfo"] == null
            ? null
            : AgoraInfo.fromJson(json["agoraInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "angel_name": angelName,
        "agoraInfo": agoraInfo?.toJson(),
      };
}

class AgoraInfo {
  String? channelName;
  Token? token;

  AgoraInfo({
    this.channelName,
    this.token,
  });

  factory AgoraInfo.fromJson(Map<String, dynamic> json) => AgoraInfo(
        channelName: json["channelName"],
        token: json["token"] == null ? null : Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "channelName": channelName,
        "token": token?.toJson(),
      };
}

class Token {
  String? appId;
  String? agoraToken;

  Token({
    this.appId,
    this.agoraToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        appId: json["app_id"],
        agoraToken: json["agora_token"],
      );

  Map<String, dynamic> toJson() => {
        "app_id": appId,
        "agora_token": agoraToken,
      };
}
