import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/common/app_button.dart';
import 'package:talkangels/common/app_textfield.dart';
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

  String referCode = '';
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loginScreenController.isWhatsappInstalled();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<LoginScreenController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(gradient: appGradient),
            child: SingleChildScrollView(
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
                      controller.fillName == true
                          ? Column(
                              children: [
                                AppTextFormField(
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {}
                                    return null;
                                  },
                                  controller: nameController,
                                  labelText: "Please Enter Your Name",
                                  constraints: const BoxConstraints(maxHeight: 55),
                                ),
                                (h * 0.05).addHSpace(),
                                AppButton(
                                  onTap: () async {
                                    if (Get.arguments != null) {
                                      referCode = Get.arguments["refer_code"] ?? '';
                                      log("refer_code=====>>>    ${Get.arguments["refer_code"] ?? ''}");
                                    }

                                    log('nameController===========>>>>${nameController.text}');
                                    if (nameController.text.isNotEmpty) {
                                      /// API signIn
                                      await controller.signIn(
                                        name: nameController.text.trim().toString(),
                                        mNo: controller.number ?? '',
                                        cCode: controller.code ?? '',
                                        fcm: PreferenceManager().getFCMNotificationToken() ?? '',
                                        referCode: referCode,
                                      );
                                    } else {
                                      showAppSnackBar("Please Enter Your Name");
                                    }
                                  },
                                  child: controller.isLoading == true
                                      ? const Center(child: CircularProgressIndicator(color: whiteColor))
                                      : AppString.login.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                              ],
                            )
                          : AppButton(
                              onTap: () async {
                                loginScreenController.isWhatsappInstalled().then((value) async {
                                  if (controller.isWhatsAppIsInstall == true) {
                                    if (Get.arguments != null) {
                                      referCode = Get.arguments["refer_code"] ?? '';
                                      log("refer_code=====>>>    ${Get.arguments["refer_code"] ?? ''}");
                                    }

                                    /// whatsapp login
                                    await controller.startOtpless(referCode);
                                  }
                                });
                              },
                              child: controller.isLoading == true
                                  ? const Center(child: CircularProgressIndicator(color: whiteColor))
                                  : Row(
                                      children: [
                                        svgAssetImage(AppAssets.whatsAppLogo),
                                        (w * 0.05).addWSpace(),
                                        AppString.whatsappInstantLogin.regularLeagueSpartan(fontSize: 18),
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
                      controller.fillName == true ? (h * 0.25).addHSpace() : (h * 0.34).addHSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppString.byClickingIAcceptThe.regularLeagueSpartan(fontWeight: FontWeight.w200),
                          InkWell(
                            onTap: () {},
                            child: AppString.tAndC.regularLeagueSpartan(
                                fontColor: appColorGreen, textDecoration: TextDecoration.underline),
                          ),
                          AppString.and.regularLeagueSpartan(fontWeight: FontWeight.w200),
                          InkWell(
                            onTap: () {},
                            child: AppString.privacyPolicy.regularLeagueSpartan(
                                fontColor: appColorGreen, textDecoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      (h * 0.02).addHSpace(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
