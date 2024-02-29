import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/ui/staff/constant/app_color.dart';
import 'package:talkangels/ui/staff/constant/app_assets.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/widgets/app_button.dart';

showAppSnackBar(
  String tittle,
) {
  return Get.showSnackbar(
    GetSnackBar(
      messageText: Text(tittle, textAlign: TextAlign.center, style: const TextStyle(color: whiteColor)),
      borderRadius: 10,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      shouldIconPulse: false,
      backgroundColor: greyFontColor,
      duration: const Duration(seconds: 3),
    ),
  );
}

errorScreen({String? title}) {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
      child: Column(
        children: [
          (Get.height * 0.10).addHSpace(),
          SizedBox(
              height: Get.height * 0.3,
              width: Get.width * 0.6,
              child: assetImage(AppAssets.somethingWentWrongAnimationAssets, fit: BoxFit.cover)),
          (Get.height * 0.05).addHSpace(),
          (title ?? '').leagueSpartanfs20w600(fontSize: 24, fontColor: redColor),
          (Get.height * 0.17).addHSpace(),
        ],
      ),
    ),
  );
}

class ErrorScreen extends StatelessWidget {
  ErrorScreen({
    Key? key,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);
  final void Function() onTap;
  final bool? isLoading;

  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  void dispose() {
    connectivitySubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      width: w,
      decoration: const BoxDecoration(gradient: appGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                (h * 0.1).addHSpace(),
                SizedBox(
                    height: h * 0.3,
                    width: w * 0.6,
                    child: assetImage(AppAssets.somethingWentWrongAnimationAssets, fit: BoxFit.cover)),
                (h * 0.05).addHSpace(),
                AppString.somethingWentWrong.leagueSpartanfs20w600(fontSize: 24),
                (h * 0.02).addHSpace(),
                AppString.checkYourConnectionThenRefreshThePage
                    .regularLeagueSpartan(fontColor: greyFontColor, textAlign: TextAlign.center),
                (h * 0.13).addHSpace(),
                AppButton(
                  onTap: onTap,
                  color: redColor,
                  child: isLoading == true
                      ? const Center(child: CircularProgressIndicator(color: whiteColor))
                      : AppString.refresh.leagueSpartanfs20w600(),
                ),
                (h * 0.05).addHSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StaffErrorScreen extends StatefulWidget {
  const StaffErrorScreen({Key? key, required this.onTap, this.isLoading = true}) : super(key: key);
  final void Function() onTap;
  final bool? isLoading;

  @override
  State<StaffErrorScreen> createState() => _StaffErrorScreenState();
}

class _StaffErrorScreenState extends State<StaffErrorScreen> {
  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());

  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void dispose() {
    super.dispose();
    connectivitySubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      width: w,
      decoration: const BoxDecoration(gradient: appGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
            child: Column(
              children: [
                (h * 0.1).addHSpace(),
                SizedBox(
                    height: h * 0.3,
                    width: w * 0.6,
                    child: assetImage(AppAssets.somethingWentWrongAnimationAssets, fit: BoxFit.cover)),
                (h * 0.05).addHSpace(),
                AppString.somethingWentWrong.leagueSpartanfs20w600(fontSize: 24),
                (h * 0.02).addHSpace(),
                AppString.checkYourConnectionThenRefreshThePage
                    .regularLeagueSpartan(fontColor: greyFontColor, textAlign: TextAlign.center),
                (h * 0.1).addHSpace(),
                AppButton(
                  onTap: widget.onTap,
                  color: redColor,
                  child: widget.isLoading == true
                      ? const Center(child: CircularProgressIndicator(color: whiteColor))
                      : AppString.refresh.leagueSpartanfs20w600(),
                ),
                (h * 0.05).addHSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
