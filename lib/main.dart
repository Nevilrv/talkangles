import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/utils/notification_service.dart';
import 'package:uuid/uuid.dart';

///background notification handler..
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background message ${message.data}');
  if (message.data['call_type'] == "reject") {
    if (PreferenceManager().getRole() == 'staff') {
      FlutterCallkitIncoming.endAllCalls();
    } else {
      CallingScreenController callingScreenController = Get.put(CallingScreenController());
      print("REJECT_CALL___3");
      // callingScreenController.rejectCall();
      callingScreenController.leaveChannel();
    }
    log("reject--------------> ");
  } else if (message.data['call_type'] == "calling") {
    log("message.data--------------> ${message.data.runtimeType}");

    FlutterCallkitIncoming.endAllCalls();

    NotificationService.showCallkitIncoming(Uuid().v4(), message);
    NotificationService.callHandle1(message);
  }
  RemoteNotification? notification = message.notification;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  handleNetworkConnection.initConnectivity();
  handleNetworkConnection.checkConnectivity();

  NotificationService().requestPermissions();

  NotificationService().getFCMToken();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService.flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(NotificationService().channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationService.showMsgHandler();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  try {
    log("NOTIFICATION_OPEN____");
    NotificationService.onMsgOpen();
  } catch (e) {
    log("ERERRRRR___$e");
  }
  NotificationService.flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
    log('notificationResponse----- ${notificationResponse.payload}');
    var d = jsonDecode(notificationResponse.payload!);
    log("d--------------> ${d}");
    if (notificationResponse.payload!.isNotEmpty) {
      if (d["call_type"] == "calling") {
        Get.toNamed(Routes.bottomBarScreen);
      } else if (d["call_type"] == "reject") {
        if (PreferenceManager().getRole().toString() == AppString.staff) {
          Get.toNamed(Routes.callHistoryScreen);
        } else {
          Get.toNamed(Routes.personDetailScreen, arguments: {
            "angel_id": "${d["_id"]}",
          });
        }
      } else if (d['type'] == "Message" || d['type'] == "Offer" || d['type'] == "Other") {
        var angleId = d['angel_id'] ?? "";
        if (angleId != "") {
          Get.toNamed(Routes.personDetailScreen, arguments: {"angel_id": angleId});
        }
      } else {
        if (PreferenceManager().getRole().toString() == AppString.staff) {
          Get.toNamed(Routes.bottomBarScreen);
        } else {
          Get.toNamed(Routes.homeScreen);
        }
      }
    } else {
      if (PreferenceManager().getRole().toString() == AppString.staff) {
        Get.toNamed(Routes.bottomBarScreen);
      } else {
        Get.toNamed(Routes.homeScreen);
      }
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      smartManagement: SmartManagement.full,
      debugShowCheckedModeBanner: false,
      title: 'Talk Angels',
      initialBinding: ControllerBindings(),
      initialRoute: Routes.splashScreen,
      getPages: Routes.routes,
    );
  }
}

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
    Get.lazyPut(() => HandleNetworkConnection());
  }
}
