import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/ui/angels/constant/app_assets.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/const/extentions.dart';
import 'app_button.dart';

Future<dynamic> appDialogBox(BuildContext context, {required double w, required double h, bool? barrierDismissible}) {
  return showDialog(
    barrierDismissible: barrierDismissible ?? true,
    context: context,
    builder: (_) => AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
      contentPadding: EdgeInsets.all(w * 0.05),
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.zero,
            height: h * 0.4,
            width: w * 0.9,
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: h * 0.12,
                  width: w * 0.3,
                  child: assetImage(AppAssets.successAnimationAssets, fit: BoxFit.cover),
                ),
                const Spacer(),
                AppString.sucess.regularLeagueSpartan(fontColor: blackColor, fontSize: 24, fontWeight: FontWeight.w800),
                (h * 0.01).addHSpace(),
                AppString.yourSelectedTalktimeRechargeIsDoneSuccessfullyContinueUsingyourFavouriteAppHaveaNiceDay
                    .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15, textAlign: TextAlign.center),
                (h * 0.04).addHSpace(),
                AppButton(
                  onTap: () {
                    Get.back();
                  },
                  color: redFontColor,
                  child: AppString.okayThanks.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future<dynamic> paymentSuccessDialogBox(BuildContext context,
    {required double w, required double h, bool? barrierDismissible, String? message}) {
  return showDialog(
    barrierDismissible: barrierDismissible ?? true,
    context: context,
    builder: (_) => AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
      contentPadding: EdgeInsets.all(w * 0.05),
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.zero,
            height: h * 0.4,
            width: w * 0.9,
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: h * 0.12,
                  width: w * 0.3,
                  child: assetImage(AppAssets.successAnimationAssets, fit: BoxFit.cover),
                ),
                const Spacer(),
                AppString.sucess.regularLeagueSpartan(fontColor: blackColor, fontSize: 24, fontWeight: FontWeight.w800),
                (h * 0.01).addHSpace(),
                AppString.amountSuccessfullyAddedInWalletContinueUsingYourFavouriteAppHaveANiceDay
                    .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15, textAlign: TextAlign.center),
                (h * 0.04).addHSpace(),
                AppButton(
                  onTap: () {
                    Get.back();
                  },
                  color: redFontColor,
                  child: AppString.okayThanks.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future<dynamic> paymentFaildDialogBox(BuildContext context,
    {required double w, required double h, bool? barrierDismissible, String? description}) {
  return showDialog(
    barrierDismissible: barrierDismissible ?? true,
    context: context,
    builder: (_) => AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.08),
      contentPadding: EdgeInsets.all(w * 0.05),
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.zero,
            height: h * 0.4,
            width: w * 0.9,
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                    height: h * 0.12,
                    width: w * 0.3,
                    child: assetImage(AppAssets.exitAnimationAssets, fit: BoxFit.cover)),
                const Spacer(),
                AppString.paymentFaild
                    .regularLeagueSpartan(fontColor: blackColor, fontSize: 24, fontWeight: FontWeight.w800),
                (h * 0.01).addHSpace(),
                description!.regularLeagueSpartan(fontColor: greyFontColor, fontSize: 15, textAlign: TextAlign.center),
                (h * 0.04).addHSpace(),
                AppButton(
                  onTap: () {
                    Get.back();
                  },
                  color: redFontColor,
                  child: AppString.okayThanks.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future addWalletAmountDialogBox() {
  return Get.dialog(
    barrierDismissible: false,
    AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
      contentPadding: EdgeInsets.all(Get.width * 0.05),
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.zero,
            height: Get.height * 0.45,
            width: Get.width * 0.9,
            child: Column(
              children: [
                (Get.height * 0.02).addHSpace(),
                SizedBox(
                    height: Get.height * 0.1,
                    width: Get.width * 0.2,
                    child: assetImage(AppAssets.exitAnimationAssets, fit: BoxFit.cover)),
                (Get.height * 0.03).addHSpace(),
                AppString.yourWalletAmountIsExisted.regularLeagueSpartan(
                    fontColor: blackColor, fontSize: 22, textAlign: TextAlign.center, fontWeight: FontWeight.w900),
                (Get.height * 0.05).addHSpace(),
                AppString.insufficientBalancePleaseRechargeYourAccount
                    .regularLeagueSpartan(fontColor: greyFontColor, fontSize: 18, textAlign: TextAlign.center),
                (Get.height * 0.06).addHSpace(),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        border: Border.all(color: greyFontColor),
                        height: Get.height * 0.06,
                        color: Colors.transparent,
                        onTap: () {
                          Get.back();
                          log("ADD_Wallet_AMOUNT_SKIP");
                        },
                        child: AppString.skip
                            .regularLeagueSpartan(fontColor: blackColor, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                    (Get.width * 0.02).addWSpace(),
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        height: Get.height * 0.06,
                        border: Border.all(color: redFontColor),
                        color: redFontColor,
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.myWalletScreen);
                        },
                        child: AppString.add.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
