import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/call_staff_conroller.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
import 'package:talkangels/ui/staff/utils/notification_service.dart';
import 'bottom_bar_controller.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> with WidgetsBindingObserver {
  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  BottomBarController bottomBarController = Get.put(BottomBarController());
  HomeController homeController = Get.put(HomeController());
  CallingScreenControllerStaff callingScreenControllerStaff = Get.put(CallingScreenControllerStaff());
  @override
  void initState() {
    super.initState();
    handleNetworkConnection.checkConnectivity();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      NotificationService.checkAndNavigationCallingPage();
    });
    if (handleNetworkConnection.isResult == false) {
      /// ACTIVE STATUS API
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await homeController.getStaffDetailApi();
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        log('appLifeCycleState inactive');
        break;

      case AppLifecycleState.resumed:
        // WidgetsBinding.instance.addPostFrameCallback((_) async {
        //   await homeController.getStaffDetailApi();
        // });
        if (handleNetworkConnection.isResult == false) {
          await homeController.getStaffDetailApi().then((result) {
            if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.offline) {
              homeController.activeStatusApi(AppString.online).then((result) async {
                await homeController.getStaffDetailApi();
              });
            }
          });
        }

        log('appLifeCycleState resumed');
        break;

      case AppLifecycleState.paused:
        print('AppLifecycleState.paused==========BOTTOMBAR=>>>>${AppLifecycleState.paused}');
        if (handleNetworkConnection.isResult == false) {
          if (callingScreenControllerStaff.isLeaveChannel == true) {
            callingScreenControllerStaff.leaveChannel();
          }
          homeController.activeStatusApi(AppString.offline);
        }
        log('appLifeCycleState paused');
        break;

      case AppLifecycleState.hidden:
        log('appLifeCycleState suspending');
        break;

      case AppLifecycleState.detached:
        log('appLifeCycleState detached');
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("${PreferenceManager().getId()}", name: "USERID");
    log("${PreferenceManager().getToken()}", name: "TOKEN");
    log("${PreferenceManager().getLogin()}", name: "LOGIN");
    log("${PreferenceManager().getName()}", name: "NAME");
    log("${PreferenceManager().getNumber()}", name: "NUMBER");
    log("${PreferenceManager().getFCMNotificationToken()}", name: "FCMNOTIFICATIONTOKEN");
    log("${jsonDecode(PreferenceManager().getUserDetails())}", name: "DECODE====GETUSERDETAILS");

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.selectedPage != 0) {
              controller.selectedPage = 0;
              Get.toNamed(Routes.bottomBarScreen);
              controller.update();
              return false;
            }

            /// Active Status Api
            if (handleNetworkConnection.isResult == false) {
              print("=====CONNECT_OFFLINE_APP-KILL");
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await homeController.activeStatusApi(AppString.offline);
              });
            }
            return true;
          },
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: bottomBarbColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.selectedPage,
              onTap: (value) {
                controller.setSelectedPage(value);
              },
              unselectedItemColor: bottomBarIconsColor,
              selectedItemColor: appColorBlue,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: "Call History"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
              ],
            ),
            body: Container(
              height: h,
              width: w,
              decoration: const BoxDecoration(gradient: appGradient),
              child: SafeArea(
                child: controller.screens[controller.selectedPage],
              ),
            ),
          ),
        );
      },
    );
  }
}
