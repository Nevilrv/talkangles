import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:talkangels/api/repo/auth_repo.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/ui/angels/models/user_login_res_model.dart';
import 'package:talkangels/models/whatsapp_login_res_model.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/startup/referral_code_pages/referral_code_controller.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';

class LoginScreenController extends GetxController {
  ReferralCodeController referralCodeController = Get.put(ReferralCodeController());
  UserLoginResponseModel userRest = UserLoginResponseModel();
  WhatsappLoginResponseModel resData = WhatsappLoginResponseModel();

  final _otplessFlutterPlugin = Otpless();
  String? phoneNumber;
  String? code;
  String? number;
  bool isLoading = false;
  bool fillName = false;
  bool isWhatsAppIsInstall = false;

  var extra = {
    "method": "get",
    "params": {
      "cid": "METB48YS2X3DECCEFC5C6C28NFI00XUP",
      "appId": "S2H09ICR959ARMY2J6NH",
    }
  };

  /// WhatsApp Login
  Future<void> isWhatsappInstalled() async {
    _otplessFlutterPlugin.isWhatsAppInstalled().then(
      (value) {
        log('value===========>>>>${value}');
        isWhatsAppIsInstall = value;
        update();

        if (!value) {
          showAppSnackBar(AppString.pleaseInstallTheWhatsapp);
        }
      },
    );
  }

  Future<WhatsappLoginResponseModel> startOtpless(String? referCode) async {
    await _otplessFlutterPlugin.hideFabButton();

    await _otplessFlutterPlugin.openLoginPage((result) async {
      try {
        if (result['data'] != null) {
          resData = WhatsappLoginResponseModel.fromJson(result['data']);

          log('result===========>>>>${result}');
          phoneNumber = result['data']["mobile"]["number"];
          if (phoneNumber!.length > 10) {
            code = phoneNumber!.substring(0, 2);
            number = phoneNumber!.substring(2, phoneNumber!.length);
          } else {
            code = '';
            number = phoneNumber;
          }

          if (resData.mobile?.name != null) {
            fillName = false;
            update();

            /// API signIn
            await signIn(
              name: resData.mobile?.name ?? '',
              mNo: number ?? '',
              cCode: code ?? '',
              fcm: PreferenceManager().getFCMNotificationToken() ?? '',
              referCode: referCode,
            );
          } else {
            fillName = true;
            update();
          }
        }
      } catch (e) {
        log('----ERROR>>>$e');
      }
    }, jsonObject: extra);
    return resData;
  }

  /// API Calling

  Future<void> signIn({String? name, String? mNo, String? cCode, String? fcm, String? referCode}) async {
    isLoading = true;
    update();

    ResponseItem result = ResponseItem(message: AppString.somethingWentWrong);
    result = await AuthRepo.userLogin(
      name.toString(),
      mNo.toString(),
      cCode.toString(),
      fcm.toString(),
    );

    try {
      if (result.status) {
        if (result.data != null) {
          userRest = UserLoginResponseModel.fromJson(result.data);

          if (userRest.status == 200) {
            isLoading = false;
            update();
            PreferenceManager().setLogin(true);
            PreferenceManager().setName(userRest.data?.name ?? '');
            PreferenceManager().setUserName(userRest.data?.userName ?? '');
            PreferenceManager().setNumber(userRest.data?.mobileNumber.toString() ?? '');
            PreferenceManager().setId(userRest.data?.id ?? '');
            PreferenceManager().setToken(userRest.token ?? '');
            PreferenceManager().setUserDetails(jsonEncode(userRest.data));
            PreferenceManager().setRole(userRest.data?.role ?? '');

            if (userRest.data!.role == "user") {
              if (referCode == '') {
                Get.offAllNamed(Routes.homeScreen);
              } else {
                if (userRest.userType == "old") {
                  ///login
                  Get.offAllNamed(Routes.homeScreen);
                } else {
                  ///register
                  ///call post referralCode API
                  await referralCodeController.referralCodeApi(referCode!);
                }
              }
            } else {
              Get.offAllNamed(Routes.bottomBarScreen);
            }
            showAppSnackBar(AppString.loginSuccessfully);
            print("RESULT_DATA====${result.data}");

            userRest.data;
          } else {
            isLoading = false;
            update();
            // print("userRest.message====${userRest.message}");
          }
        }
      } else {
        isLoading = false;
        update();
      }
    } catch (e) {
      isLoading = false;
      update();
      print("ERROR  1======>  $e");
    }
  }
}
