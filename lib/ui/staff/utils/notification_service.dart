import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
import 'package:uuid/uuid.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? timer;
  static HomeController homeController = Get.put(HomeController());
  static RemoteMessage remoteMessage = const RemoteMessage();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(AppAssets.notificationSound),
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  getFCMToken() async {
    String? token = await messaging.getToken();

    PreferenceManager().setFCMNotificationToken(token!);
    log("TOKEN $token");
  }

  /// notification handler..
  static void showMsgHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      RemoteNotification? notification = message!.notification;
      log('message---data---------->${message.data}');
      print('notification------------->$notification');
      print('notification---title---------->${notification?.title}');
      print('notification---body---------->${notification?.body}');

      if (message != null) {
        showMsg(message);
      }
      // showMsg(message);

      log("message.data['type']--------------> ${message.data['call_type']}");

      if (message.data['call_type'] == "reject") {
        if (PreferenceManager().getRole() == 'staff') {
          print('calling--------------staff');
          await FlutterCallkitIncoming.endAllCalls();
        } else {
          print('call end--------------user');
          CallingScreenController callingScreenController = Get.put(CallingScreenController());
          callingScreenController.leaveChannel(isRejected: true);
          Get.back();
        }
      } else if (message.data['call_type'] == "calling") {
        print('calling--------------staff');

        // onMsgOpen();
        FlutterCallkitIncoming.endAllCalls();
        callHandle(message);
        showCallkitIncoming(const Uuid().v4(), message);
      } else if (message.data['type'] == "Message" ||
          message.data['type'] == "Other" ||
          message.data['type'] == "Offer") {
        // showMsg(message);
      }
    });
  }

  static callHandle(RemoteMessage message) {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      print("EVENT__callHandle_______  $event");

      switch (event!.event) {
        case Event.ACTION_CALL_INCOMING:
          print("actionCallIncoming----?}_callHandle");
          await homeController.updateCallStatus(AppString.busy);
          print("updateCallStatus(AppString.busy)----11?}");
          // TODO: received an incoming call
          break;
        case Event.ACTION_CALL_START:
          print("actionCallStart----?}");
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_ACCEPT:
          print("actionCallAccept----?}");
          Get.toNamed(Routes.callingScreenStaff, arguments: {
            "remoteMessage": message.data,
          });

          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_DECLINE:
          await homeController.updateCallStatus(AppString.available);

          print(
              "Notification_Service-callHandle---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
          await homeController.addCallHistory(message.data['_id'], PreferenceManager().getId(), 'reject', '0');
          await homeController.rejectCall(PreferenceManager().getId(), message.data['_id'], 'staff');
          await FlutterCallkitIncoming.endAllCalls();
          print("actionCallDecline----?}");
          // TODO: declined an incoming call
          break;
        case Event.ACTION_CALL_ENDED:
          print("actionCallEnded----?}");
          // TODO: ended an incoming/outgoing call
          break;
        case Event.ACTION_CALL_TIMEOUT:
          await homeController.updateCallStatus(AppString.available);

          print(
              "Notification_Service-callHandle---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
          await homeController.addCallHistory(
              message.data['_id'], PreferenceManager().getId().toString(), 'reject', '0');
          await homeController.rejectCall(PreferenceManager().getId().toString(), message.data['_id'], 'staff');

          await FlutterCallkitIncoming.endAllCalls();
          // TODO: missed an incoming call
          break;
        case Event.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
      }
    });
  }

  static callHandle1(RemoteMessage message) {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      print("EVENT__callHandle1_______  $event");
      switch (event!.event) {
        case Event.ACTION_CALL_INCOMING:
          print("actionCallIncoming----?}_callHandle1");

          Future.delayed(const Duration(seconds: 1), () async {
            if (homeController.getStaffDetailResModel.data == null) {
              await homeController.getStaffDetailApi().then((result) async {
                print("RESULT___$result");
                if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.online) {
                  await homeController.updateCallStatus(AppString.busy);
                  print("updateCallStatus(AppString.busy)----22?}");
                } else {
                  await homeController.activeStatusApi(AppString.online).then((result1) async {
                    print("RESULT1___$result1");
                    await homeController.updateCallStatus(AppString.busy);
                    print("updateCallStatus(AppString.busy)----33?}");
                  });
                }
              });
            } else {
              if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.online) {
                await homeController.updateCallStatus(AppString.busy);
                print("updateCallStatus(AppString.busy)----44?}");
              } else {
                await homeController.activeStatusApi(AppString.online).then((result1) async {
                  print("RESULT1___$result1");
                  await homeController.updateCallStatus(AppString.busy);
                  print("updateCallStatus(AppString.busy)----55?}");
                });
              }
            }
          });

          print("message.data['_id']-1-------------> ${message.data['_id']}");
          print("PreferenceManager().getId()-1-------------> ${PreferenceManager().getId()}");

          // TODO: received an incoming call
          break;
        case Event.ACTION_CALL_START:
          print("actionCallStart----?}_callHandle1");
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_ACCEPT:
          print("actionCallAccept----?}_callHandle1");
          await PreferenceManager().setSetScreen(true);
          log("PreferenceManager-------------->_callHandle1 ${PreferenceManager().getScreen()}");

          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_DECLINE:
          print("actionCallDecline----?}_callHandle1");
          await FlutterCallkitIncoming.endAllCalls();
          print(
              "homeController.getStaffDetailResModel.data?.activeStatus_1   ${homeController.getStaffDetailResModel.data?.activeStatus}");
          print(
              "Notification_Service-callHandle-1----rejectCall : ${PreferenceManager().getId()}, ${message.data['_id']}, staff}");
          await homeController.rejectCall(PreferenceManager().getId(), message.data['_id'], 'staff');

          await homeController.updateCallStatus(AppString.available).then((result111) async {
            print("updateCallStatus(AppString.available)----3333?}");
            print("RESULT111==___$result111");
            await homeController.activeStatusApi(AppString.offline);
          });

          print(
              "Notification_Service-callHandle-1---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
          await homeController.addCallHistory(message.data['_id'], PreferenceManager().getId(), 'reject', '0');
          // TODO: declined an incoming call
          break;
        case Event.ACTION_CALL_ENDED:
          print("actionCallEnded----?}_callHandle1");
          // TODO: ended an incoming/outgoing call
          break;
        case Event.ACTION_CALL_TIMEOUT:
          print("actionCallTimeout----?}_callHandle1");
          print("message.data['_id']-11-------------> ${message.data['_id']}");
          print("PreferenceManager().getId()-11-------------> ${PreferenceManager().getId()}");
          await FlutterCallkitIncoming.endAllCalls();
          await homeController.rejectCall(PreferenceManager().getId(), message.data['_id'], 'staff');

          await homeController.updateCallStatus(AppString.available).then((result1) async {
            print("updateCallStatus(AppString.available)----7777?}");
            print("RESULT1!!!___$result1");
            await homeController.activeStatusApi(AppString.offline);
          });

          print(
              "Notification_Service-callHandle1---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
          await homeController.addCallHistory(message.data['_id'], PreferenceManager().getId(), 'reject', '0');

          // TODO: missed an incoming call
          break;
        case Event.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
      }
    });
  }

  static Future<void> showCallkitIncoming(String uuid, RemoteMessage message) async {
    var callData = message.data;
    print("callData---messageType> ${message.messageType}");
    print("callData---notification> ${message.notification}");
    print("callData---messageId> ${message.messageId}");
    print("callData---category> ${message.category}");
    print("callData---data> ${message.data}");

    print("callData---1->$callData");
    print("callData---2->${message.messageType}");
    print("callData---3->${message.notification}");

    final params = CallKitParams(
      id: uuid,
      nameCaller: callData['user_name'],
      appName: 'Angel',
      avatar: AppAssets.blankProfile,
      handle: 'Incoming Audio Call...',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: <String, dynamic>{'message': message.data},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#28274C',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        // isShowMissedCallNotification: false,
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    // await FlutterCallkitIncoming.startCall(params);
  }

  /// handle notification when app in fore ground..///close app
  static getInitialMsg() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      print("Initial Message 11 :::::::::::: $message");
      print("Initial Message 22 :::::::::::: ${message?.data}");
      checkAndNavigationCallingPage();
      if (message != null) {
        // if (message.data['call_type'] == "calling") {
        //   log("message.data--------------> ${message.data.runtimeType}");
        //
        //   NotificationService.showCallkitIncoming(Uuid().v4(), message);
        // }

        /// ************

        //  FlutterRingtonePlayer.stop();
        // _singleListingMainTrailController.setSlugName(
        //     slugName: '${message.data['slug_name']}');
      }
    });
  }

  static Future<void> checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      print('DATA::n   ${currentCall['n']}');
      print('DATA::extra   ${currentCall['extra']}');
      var data;
      if (currentCall['n'] == null) {
        data = currentCall['extra']['message'];
        print("data--extra--------------> ${currentCall['extra']['message']}");
      } else {
        data = currentCall['n']['message'];
        print("data--n--------------> ${currentCall['n']['message']}");
      }

      Get.toNamed(Routes.callingScreenStaff, arguments: {
        "remoteMessage": Map<String, dynamic>.from(data as Map),
      });
    } else {
      print("DATA::NULL");
    }
  }

  static Future<dynamic> getCurrentCall() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        return calls[0];
      } else {
        return null;
      }
    }
  }

  ///show notification msg
  static void showMsg(RemoteMessage? message) {
    print("message?.data====>>> ${message?.data}");

    flutterLocalNotificationsPlugin.show(
      message!.notification.hashCode,
      '${message.notification?.title}',
      '${message.notification?.body}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
        ),
        // iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  ///call when click on notification back
  static void onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log('listen-> ${message.data}');

      if (message.data['type'] == "Message" || message.data['type'] == "Offer" || message.data['type'] == "Other") {
        log("d--------------> ${message.data['type']}");
        log("angel_id--------------> ${message.data['angel_id']}");
        var angleId = message.data['angel_id'] ?? "";
        if (angleId != "") {
          Get.toNamed(Routes.personDetailScreen, arguments: {
            "angel_id": angleId,
          });
        }
      }
    });
  }
}
