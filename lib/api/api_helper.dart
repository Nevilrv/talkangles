import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:talkangels/api/api_exception.dart';
import 'package:talkangels/const/request_constant.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:http/http.dart' as http;
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';

/// Angels
class BaseApiHelper {
  ///===========
  static Future<ResponseItem> postRequest(String requestUrl, Map<String, dynamic> requestData) async {
    // log("request:$requestUrl");
    print("REQUEST::$requestUrl");
    print("STAFF_ID::${PreferenceManager().getId()}");
    log("body:${json.encode(requestData)}");
    return await http
        .post(
          Uri.parse(requestUrl),
          body: requestData,
        )
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  ///===========
  static Future<ResponseItem> getRequest(String requestUrl) async {
    // log("request:$requestUrl");
    print("request::$requestUrl");
    print("STAFF_ID::${PreferenceManager().getId().toString()}");
    String token = PreferenceManager().getToken().toString();
    print("TOKEN::${token}");

    return await http
        .get(Uri.parse(requestUrl), headers: {"Authorization": token})
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  ///===========
  static Future<ResponseItem> postRequestToken(String requestUrl, Map<String, dynamic> requestData) async {
    // log("request:$requestUrl");
    print("request::$requestUrl");
    print("STAFF_ID::${PreferenceManager().getId().toString()}");
    String token = PreferenceManager().getToken().toString();

    return await http
        .post(Uri.parse(requestUrl), body: requestData, headers: {"Authorization": token})
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  /// Put Active Status
  static Future<ResponseItem> putRequestToken(String requestUrl, Map<String, dynamic> requestData) async {
    // log("request:$requestUrl");
    print("request::$requestUrl");
    print("STAFF_ID::${PreferenceManager().getId().toString()}");
    String token = PreferenceManager().getToken().toString();
    return await http
        .put(Uri.parse(requestUrl), body: requestData, headers: {"Authorization": token})
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  /// Delete Angel
  static Future<ResponseItem> deleteAngel(String requestUrl) async {
    // log("request:$requestUrl");
    print("request::$requestUrl");
    print("STAFF_ID::${PreferenceManager().getId().toString()}");
    String token = PreferenceManager().getToken().toString();
    return await http
        .delete(Uri.parse(requestUrl), headers: {"Authorization": token})
        .then((response) => onValue(response))
        .onError((error, stackTrace) => onError(error));
  }

  /// Put Staff Details API
  static Future<dynamic> putStaffDetails({
    String? image,
    String? userName,
    String? name,
    String? gender,
    String? bio,
    String? language,
    String? age,
    String? fileType,
  }) async {
    HomeController homeController = Get.put(HomeController());
    String userId = PreferenceManager().getId().toString();
    String requestUrl = AppUrls.BASE_URL + MethodNamesStaff.updateStaffDetails + userId;

    var request = http.MultipartRequest('PUT', Uri.parse(requestUrl));

    final Map<String, String> data = <String, String>{};
    data['user_name'] = "$userName";
    data['name'] = "$name";
    data['gender'] = "$gender";
    data['bio'] = "$bio";
    data['language'] = "$language";
    data['age'] = "$age";

    var headers = {
      'Authorization': PreferenceManager().getToken().toString(),
    };

    log("data-------------->${data}");
    if (data.isNotEmpty) {
      request.fields.addAll(data);
    }

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.toString(),
      ));
    }

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    log("response___________${response.stream}");
    log("response.statusCode___________${response.statusCode}");
    log("response.reasonPhrase___________${response.reasonPhrase}");
    var res;
    if (response.statusCode == 200) {
      res = jsonDecode(await response.stream.bytesToString());
      Get.back();
      await homeController.getStaffDetailApi();
    } else {
      log("err-------------${response.reasonPhrase}");
    }
    return res;
  }

  ///
  ///===========
  static Future onValue(http.Response response) async {
    // log(response.statusCode.toString(), name: "RESPONSE STATUSCODE");
    // log(response.body.toString(), name: "RESPONSE BODY");
    print("RESPONSE BODY:: ${response.body.toString()}");

    final ResponseItem result = ResponseItem(status: false, message: "Something went wrong.");

    dynamic data = json.decode(response.body);
    result.statusCode = response.statusCode;
    if (response.statusCode == 200 || response.statusCode == 201) {
      result.status = true;
      result.data = data;
    } else if (response.statusCode == 400) {
      // showAppSnackBar("Invalid Status");
      log("Invalid Status");
      Get.back();
    } else if (response.statusCode == 401) {
      result.message = data["message"] ?? "";
      showAppSnackBar(result.message.toString());
      print("MESSAGE___401 ${result.message}");
    } else if (response.statusCode == 404) {
      result.message = data["message"] ?? "";
      print("MESSAGE___404 ${result.message}");
    } else if (response.statusCode == 500) {
      result.message = data["message"] ?? "";
      showAppSnackBar(result.message.toString());
      print("MESSAGE___500 ${result.message}");
    } else {
      showAppSnackBar(AppString.serverErrorPleaseTryAgainLater);
      result.message = data["message"] ?? "";
      log("result.message --> ${result.message}");
    }
    return result;
  }

  ///===========
  static onError(error) {
    log("Error caused: $error");
    print("ERROR_CAUSED:: $error");
    String message = "Unsuccessful request";
    if (error is SocketException) {
      message = ResponseException("No internet connection").toString();
    } else if (error is FormatException) {
      // message = ResponseException("Something wrong in response.").toString() +
      //     error.toString();
    }
    log("EEEERRRROOOORRR   ${message}");
    return ResponseItem(data: null, message: message, status: false);
  }
}
