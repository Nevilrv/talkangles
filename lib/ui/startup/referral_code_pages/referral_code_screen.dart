import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_button.dart';

import 'package:talkangels/common/app_textfield.dart';

import 'package:talkangels/ui/startup/referral_code_pages/referral_code_controller.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';

class ReferralCodeScreen extends StatefulWidget {
  const ReferralCodeScreen({Key? key}) : super(key: key);

  @override
  State<ReferralCodeScreen> createState() => _ReferralCodeScreenState();
}

class _ReferralCodeScreenState extends State<ReferralCodeScreen> {
  ReferralCodeController referralCodeController = Get.put(ReferralCodeController());
  TextEditingController referralController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        leadingIcon: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back)),
        titleText: AppString.referralCode,
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: appGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    (h * 0.1).addHSpace(),
                    SizedBox(
                        height: h * 0.18,
                        width: w * 0.36,
                        child: assetImage(AppAssets.referralCodeAnimationAssets, fit: BoxFit.cover)),
                    (h * 0.07).addHSpace(),
                    AppString.haveAReferralCode_.regularLeagueSpartan(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    AppString.referralDescription
                        .regularLeagueSpartan(fontColor: greyFontColor, textAlign: TextAlign.center),
                    (h * 0.03).addHSpace(),
                    AppTextFormField(
                        validator: (text) {
                          if (text == null || text.isEmpty) {}
                          return null;
                        },
                        controller: referralController,
                        labelText: AppString.enterReferralCodeHere),
                    (h * 0.15).addHSpace(),
                    AppButton(
                      color: appColorGreen,
                      onTap: () {
                        if (referralController.text != '') {
                          Get.offAllNamed(Routes.loginScreen, arguments: {
                            "refer_code": referralController.text,
                          });
                        } else {
                          showAppSnackBar(AppString.pleaseEnterReferralCode);
                        }
                      },
                      child: AppString.go.leagueSpartanfs20w600(),
                    ),
                    (h * 0.03).addHSpace(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
