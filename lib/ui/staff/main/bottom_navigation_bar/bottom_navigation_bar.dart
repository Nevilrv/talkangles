import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/ui/staff/constant/app_color.dart';
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

  bool isActive = true;
  Timer? activeTimer;

  @override
  void initState() {
    super.initState();
    handleNetworkConnection.checkConnectivity();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await callHandle1();
      NotificationService.checkAndNavigationCallingPage();
    });
    if (handleNetworkConnection.isResult == false) {
      /// ACTIVE STATUS API
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        log("=====CONNECT_ONLINE");
        await homeController.getStaffDetailApi().then((result) async {
          await staffActiveStatus();
        });
      });
    } else {
      log("=====DISCONNECT_OFFLINE");
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        setState(() {
          activeTimer?.cancel();
        });
        log('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        setState(() {
          isActive = true;
        });

        if (handleNetworkConnection.isResult == false) {
          homeController.getStaffDetailApi().then((result) {
            if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.offline) {
              print("====APP_LIFECYCLE___ONLINE");
              homeController.activeStatusApi(AppString.online).then((result) async {
                print("RESULT====23>> $result");
                await homeController.getStaffDetailApi();
              });
            } else {
              print("====APP_LIFECYCLE__ ALREAGDY_ONLINE");
            }
          });
        } else {
          log("=====DISCONNECT_ONLINE_STATE_RESUME");
        }

        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        //   // await callHandle1();
        //   NotificationService.checkAndNavigationCallingPage();
        // });

        log('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        setState(() {
          isActive = false;
          activeTimer?.cancel();
        });
        if (handleNetworkConnection.isResult == false) {
          print("=====CONNECT_OFFLINE_STATE_PAUSED");
          homeController.activeStatusApi(AppString.offline);
        } else {
          log("=====DISCONNECT_OFFLINE_STATE_PAUSED");
        }

        log('appLifeCycleState paused');
        break;
      case AppLifecycleState.hidden:
        setState(() {
          isActive = false;
          activeTimer?.cancel();
        });
        log('appLifeCycleState suspending');
        break;
      case AppLifecycleState.detached:
        setState(() {
          isActive = false;
          activeTimer?.cancel();
        });
        log('appLifeCycleState detached');
        break;
    }
  }

  staffActiveStatus() {
    if (handleNetworkConnection.isResult == false) {
      log(".....Yes_NETWORK");
      activeTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (homeController.getStaffDetailResModel.data != null) {
          if (isActive == true) {
            if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.offline) {
              log("=====ACTIVE_STATUS_UPDATED");
              homeController.activeStatusApi(AppString.online).then((result) async {
                print("RESULT===1=>> $result");
                await homeController.getStaffDetailApi();
              });
              setState(() {
                isActive = false;
                activeTimer?.cancel();
              });
            } else {
              log("=====ACTIVE_STATUS_ALREADY_UPDATED");
            }
          }
          activeTimer?.cancel();
        }
      });
    } else {
      log(".....NO_NETWORK");
    }

    // activeTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
    //   if (handleNetworkConnection.isResult == false) {
    //     log(".....Yes_NETWORK");
    //     if (homeController.getStaffDetailResModel.data?.activeStatus != null && isActive == true) {
    //       log(".....IS_ACTIVE=TRUE");
    //       log("controller.getStaffDetailResModel.data?.activeStatus=    ${homeController.getStaffDetailResModel.data?.activeStatus}");
    //
    //       homeController.getStaffDetailApi();
    //       log("controller.getStaffDetailResModel.data?.activeStatus=========    ${homeController.getStaffDetailResModel.data?.activeStatus}");
    //
    //       if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.offline) {
    //         log("=====ACTIVE_STATUS_UPDATED");
    //         homeController.activeStatusApi(AppString.online);
    //         setState(() {
    //           isActive = false;
    //           activeTimer?.cancel();
    //         });
    //       } else {
    //         log("=====ACTIVE_STATUS_ALREADY_UPDATED");
    //       }
    //     } else {
    //       log(".....IS_ACTIVE=FALSE");
    //       log("controller.getStaffDetailResModel.data?.activeStatus===    ${homeController.getStaffDetailResModel.data?.activeStatus}");
    //     }
    //   } else {
    //     log(".....NO_NETWORK");
    //   }
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    activeTimer?.cancel();
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
              setState(() {
                isActive = false;
                activeTimer?.cancel();
              });

              print("=====CONNECT_OFFLINE_APP-KILL");
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await homeController.activeStatusApi(AppString.offline);
              });
            } else {
              print("=====DISCONNECT_OFFLINE_APP-KILL");
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
