import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:talkangels/controller/share_profile_details_service.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/staff/utils/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  onInit() {
    print("PreferenceManager-------------0-> ${PreferenceManager().getScreen()}");
    log("PreferenceManager-------------0-> ${PreferenceManager().getScreen()}");

    Future.delayed(const Duration(seconds: 1)).then((value) async {
      print("PreferenceManager-------------CONDITION-> ${PreferenceManager().getScreen() == true}");
      log("PreferenceManager-------------CONDITION-> ${PreferenceManager().getScreen() == true}");
      if (PreferenceManager().getScreen() == true) {
        print('::::::::::::::::::::: On INIT TRUE PART ::::::::::::::::::::');

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await DynamicLinkService().handleDynamicLinks();
        });

        if (PreferenceManager().getLogin() == true) {
          print("PreferenceManager().getRole()=1>  ${PreferenceManager().getRole()}");
          if (PreferenceManager().getRole() == "user") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAllNamed(Routes.homeScreen);
            });
          } else {
            print("userRest.data!.role----dss->${PreferenceManager().getRole()}");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAllNamed(Routes.bottomBarScreen);
            });
            await PreferenceManager().setSetScreen(false);

            NotificationService.getInitialMsg();

            print("PreferenceManager-------------1-> ${PreferenceManager().getScreen()}");
            log("PreferenceManager-------------1-> ${PreferenceManager().getScreen()}");
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(Routes.loginScreen);
          });
        }
      } else {
        print('::::::::::::::::::::: On INIT FALSE PART ::::::::::::::::::::');

        await PreferenceManager().setSetScreen(false);
        print("PreferenceManager-------------2-> ${PreferenceManager().getScreen()}");
        log("PreferenceManager-------------2-> ${PreferenceManager().getScreen()}");
        Future.delayed(const Duration(seconds: 6), () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await DynamicLinkService().handleDynamicLinks();
          });

          if (PreferenceManager().getLogin() == true) {
            print("PreferenceManager().getRole()=>  ${PreferenceManager().getRole()}");
            if (PreferenceManager().getRole() == "user") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.homeScreen);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.bottomBarScreen);
              });
            }
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.offAllNamed(Routes.loginScreen);
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    onInit();
    super.initState();
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
        child: PreferenceManager().getRole().toString() == AppString.staff
            ? SafeArea(
                child: Column(
                  children: [
                    (h * 0.09).addHSpace(),
                    svgAssetImage(AppAssets.appLogo, height: w * 0.20, width: w * 0.20),
                    AppString.talkAngels.regularAllertaStencil(
                      fontSize: 32,
                    ),
                    AppString.anonymousChatCall.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w300),
                    (h * 0.13).addHSpace(),
                    RippleAnimation(
                      color: appColorBlue.withOpacity(0.04),
                      delay: const Duration(milliseconds: 30),
                      repeat: true,
                      minRadius: 50,
                      ripplesCount: 6,
                      duration: const Duration(milliseconds: 6 * 300),
                      child: SizedBox(
                        height: h * 0.4,
                        width: w * 0.8,
                        child: assetImage(AppAssets.splashScreenAnimationAssets, fit: BoxFit.cover),
                      ),
                    ),
                    AppString.bringingYouToaZonOfOpenMindedness.regularLeagueSpartan(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        textAlign: TextAlign.center,
                        fontColor: appColorBlue),
                  ],
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    (h * 0.09).addHSpace(),
                    svgAssetImage(AppAssets.appLogo, height: w * 0.25, width: w * 0.25),
                    AppString.talkAngels.regularAllertaStencil(fontSize: 32),
                    AppString.anonymousChatCall.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w300),
                    (h * 0.17).addHSpace(),
                    RippleAnimation(
                        color: appColorGreen.withOpacity(0.04),
                        delay: const Duration(milliseconds: 30),
                        repeat: true,
                        minRadius: 54,
                        ripplesCount: 6,
                        duration: const Duration(milliseconds: 6 * 300),
                        child: SizedBox(
                            height: h * 0.3,
                            width: w * 0.6,
                            child: Lottie.asset(AppAssets.animationIncomingCall, fit: BoxFit.fill))),
                    AppString.bringingYouToaZonOfOpenMindedness.regularLeagueSpartan(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        textAlign: TextAlign.center,
                        fontColor: appColorGreen),
                  ],
                ),
              ),
      ),
    );
  }
}
