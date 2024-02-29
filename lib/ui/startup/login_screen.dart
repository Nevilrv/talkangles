import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/constant/app_assets.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/angels/widgets/app_button.dart';
import 'package:talkangels/ui/startup/login_screen_controller.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  LoginScreenController loginScreenController = Get.put(LoginScreenController());

  String? phoneNumber;
  String? code;
  String? number;
  String referCode = '';

  @override
  void initState() {
    super.initState();
    loginScreenController.isWhatsappInstalled();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: appGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Column(
              children: [
                (h * 0.09).addHSpace(),
                svgAssetImage(AppAssets.appLogo, height: w * 0.25, width: w * 0.25),
                AppString.talkToPeopleWithSimilar
                    .regularLeagueSpartan(fontWeight: FontWeight.w300, fontSize: 18)
                    .paddingOnly(top: h * 0.01),
                AppString.experiences.regularLeagueSpartan(fontSize: 22, fontWeight: FontWeight.w600),
                (h * 0.15).addHSpace(),
                AppButton(
                  onTap: () async {
                    if (Get.arguments != null) {
                      referCode = Get.arguments["refer_code"] ?? '';
                      log("refer_code=====>>>    ${Get.arguments["refer_code"] ?? ''}");
                    }

                    /// whatsapp login
                    await loginScreenController.startOtpless(referCode);

                    ///
                    /// API signIn _USER
                    // await loginScreenController.signIn(
                    //     name: "Demo User",
                    //     mNo: "9876543210",
                    //     cCode: "91",
                    //     fcm: PreferenceManager().getFCMNotificationToken() ?? '',
                    //     referCode: referCode);

                    ///
                    /// API signIn _USER
                    // await loginScreenController.signIn(
                    //     name: "maulikvekariya",
                    //     mNo: "9510624635",
                    //     cCode: "91",
                    //     fcm: PreferenceManager().getFCMNotificationToken() ?? '',
                    //     referCode: referCode);

                    /// API signIn _STAFF
                    // await loginScreenController.signIn(
                    //     name: "Demo test",
                    //     mNo: "1234567890",
                    //     cCode: "91",
                    //     fcm: PreferenceManager().getFCMNotificationToken() ?? '',
                    //     referCode: referCode);
                  },
                  child: Row(
                    children: [
                      svgAssetImage(AppAssets.whatsAppLogo),
                      (w * 0.05).addWSpace(),
                      AppString.whatsappInstantLogin.regularLeagueSpartan(),
                    ],
                  ),
                ),
                (h * 0.02).addHSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppString.haveA.regularLeagueSpartan(fontWeight: FontWeight.w200),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.referralCodeScreen);
                      },
                      child: AppString.referralCode_.regularLeagueSpartan(fontColor: appColorGreen),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppString.byClickingIAcceptThe.regularLeagueSpartan(fontWeight: FontWeight.w200),
                    InkWell(
                      onTap: () {},
                      child: AppString.tAndC
                          .regularLeagueSpartan(fontColor: appColorGreen, textDecoration: TextDecoration.underline),
                    ),
                    AppString.and.regularLeagueSpartan(fontWeight: FontWeight.w200),
                    InkWell(
                      onTap: () {},
                      child: AppString.privacyPolicy
                          .regularLeagueSpartan(fontColor: appColorGreen, textDecoration: TextDecoration.underline),
                    ),
                  ],
                ),
                (h * 0.02).addHSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Loading Circular
  onLoading(double h, double w) {
    Future.delayed(const Duration(seconds: 4), () {
      Get.offAllNamed(Routes.homeScreen);
    });
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: Builder(
          builder: (context) {
            return SizedBox(
              height: h,
              width: w,
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: whiteColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: svgAssetImage(AppAssets.appLogo,
                                color: appColorGreen, height: w * 0.25, width: w * 0.25),
                          ),
                        ),
                        Positioned(
                          left: -120,
                          right: -120,
                          bottom: -120,
                          top: -120,
                          child: SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Lottie.asset(AppAssets.animationLoading, height: 200, width: 200, fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      height: h * 0.06,
                      width: w * 0.65,
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      decoration: BoxDecoration(color: logInButtonColor, borderRadius: BorderRadius.circular(60)),
                      child: Center(
                        child: AppString.accessingYourAccountHoldTight
                            .regularLeagueSpartan(fontSize: 14, textOverflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
