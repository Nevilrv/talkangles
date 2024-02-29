import 'dart:convert';
// import 'dart:developer';
import 'dart:math';

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

  final _otplessFlutterPlugin = Otpless();
  String? phoneNumber;
  String? code;
  String? number;

  /// WhatsApp Login
  Future<void> isWhatsappInstalled() async {
    _otplessFlutterPlugin.isWhatsAppInstalled().then(
      (value) {
        if (!value) {
          showAppSnackBar(AppString.pleaseInstallTheWhatsapp);
        }
      },
    );
  }

  Future<void> startOtpless(String? referCode) async {
    await _otplessFlutterPlugin.hideFabButton();

    _otplessFlutterPlugin.openLoginPage((result) async {
      try {
        if (result['data'] != null) {
          WhatsappLoginResponseModel resData = WhatsappLoginResponseModel.fromJson(result['data']);
          phoneNumber = result['data']["mobile"]["number"];
          if (phoneNumber!.length > 10) {
            code = phoneNumber!.substring(0, 2);
            number = phoneNumber!.substring(2, phoneNumber!.length);
          } else {
            code = '';
            number = phoneNumber;
          }

          /// API signIn
          await signIn(
            name: resData.waName ?? '',
            mNo: number ?? '',
            cCode: code ?? '',
            fcm: PreferenceManager().getFCMNotificationToken() ?? '',
            referCode: referCode,
          );
        }
      } catch (e) {
        // log('----ERROR>>>$e');
      }
    });
  }

  /// API Calling

  RxBool isLoading = false.obs;

  Future<void> signIn({String? name, String? mNo, String? cCode, String? fcm, String? referCode}) async {
    // log("NAME  ${name}");
    // log("MOBILENO  ${mNo}");
    // log("COUNTRYCODE  ${cCode}");
    // log("FCMTOKEN  ${fcm}");

    isLoading.value = true;
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
          isLoading.value = false;
          userRest = UserLoginResponseModel.fromJson(result.data);

          if (userRest.status == 200) {
            PreferenceManager().setLogin(true);
            PreferenceManager().setName(userRest.data?.name ?? '');
            PreferenceManager().setUserName(userRest.data?.userName ?? '');
            PreferenceManager().setNumber(userRest.data?.mobileNumber.toString() ?? '');
            PreferenceManager().setId(userRest.data?.id ?? '');
            PreferenceManager().setToken(userRest.token ?? '');
            PreferenceManager().setUserDetails(jsonEncode(userRest.data));

            PreferenceManager().setRole(userRest.data?.role ?? '');
            print("TOKENNNN:::  ${PreferenceManager().getToken()}");
            // log("userRest.data!.role----->${userRest.data?.role}");
            if (userRest.data!.role == "user") {
              if (referCode == '') {
                // log("==1===homescreen===");
                Get.offAllNamed(Routes.homeScreen);
              } else {
                // log("=2=referred====");
                if (userRest.userType == "old") {
                  ///login
                  // log("=5===already referred===");
                  Get.offAllNamed(Routes.homeScreen);
                } else {
                  ///register
                  ///call post referralCode API
                  // log("=6===add referred===");
                  await referralCodeController.referralCodeApi(referCode!);
                }
              }
            } else {
              Get.offAllNamed(Routes.bottomBarScreen);
            }
            showAppSnackBar(AppString.loginSuccessfully);

            // log("${result.data}", name: "RESULT_DATA");
            print("RESULT_DATA====${result.data}");

            userRest.data;
          } else {
            // print("userRest.message====${userRest.message}");
          }
          update();
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("ERROR  1======>  $e");
      // showAppSnackBar("$e");
    }
    update();
  }
}
