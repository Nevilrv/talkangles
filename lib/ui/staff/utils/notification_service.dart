import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen.dart';
import 'package:talkangels/ui/angels/main/home_pages/person_details_screen.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/call_history_pages/call_history_screen.dart';
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
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('assets/sound/audio_dummy.wav'),
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
      log('message------------->${message}');
      log('message---data---------->${message.data}');
      log('message---notification---------->${message.notification?.body}');
      log('message---messageId---------->${message.messageId}');
      log('message---messageType---------->${message.messageType}');

      log('notification------------->${notification}');
      log('notification---title---------->${notification?.title}');
      log('notification---body---------->${notification?.body}');

      if (message != null) {
        showMsg(notification!);
      }
      // onMsgOpen();

      if (message.data['call_type'] == "reject") {
        if (PreferenceManager().getRole() == 'staff') {
          print('call end--------------staff');
          await FlutterCallkitIncoming.endAllCalls();
        } else {
          CallingScreenController callingScreenController = Get.put(CallingScreenController());
          log('call end--------------angle');
          callingScreenController.leaveChannel(isRejected: true);
          Get.back();
          log("REJECT_CALL___8888888");
        }
      } else if (message.data['call_type'] == "calling") {
        print('calling--------------staff');

        // onMsgOpen();
        FlutterCallkitIncoming.endAllCalls();
        callHandle(message);
        showCallkitIncoming(const Uuid().v4(), message);
      }
    });
  }

  static callHandle(RemoteMessage message) {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
      print("EVENT__callHandle_______  ${event}");

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
          log("PreferenceManager().getRejectCall()_________${PreferenceManager().getRejectCall()}");
          PreferenceManager().setRejectCall(true);
          log("PreferenceManager().getRejectCall()_________${PreferenceManager().getRejectCall()}");

          // if (PreferenceManager().getRejectCall() == true) {
          //   print(
          //       "Notification_Service-callHandle----rejectCall : ${PreferenceManager().getId()}, ${message.data['_id']}, user}");
          //   await homeController.rejectCall(PreferenceManager().getId(), message.data['_id'], 'user');
          //   await homeController.updateCallStatus(AppString.available);
          //   print("updateCallStatus(AppString.available)----1111?}");
          //   print(
          //       "Notification_Service-callHandle---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
          //   await homeController.addCallHistory(message.data['_id'], PreferenceManager().getId(), 'reject', '0');
          //   await FlutterCallkitIncoming.endAllCalls();
          //   print("actionCallDecline----?}");
          // } else {
          //   log("PreferenceManager().getRejectCall()______FALSE");
          // }

          onRejected(message);

          // print(
          //     "Notification_Service-callHandle----rejectCall : ${PreferenceManager().getId()}, ${message.data['_id']}, user}");
          // await homeController.rejectCall(PreferenceManager().getId(), message.data['_id'], 'user');
          // await homeController.updateCallStatus(AppString.available);
          // print("updateCallStatus(AppString.available)----1111?}");
          // print(
          //     "Notification_Service-callHandle---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
          // await homeController.addCallHistory(message.data['_id'], PreferenceManager().getId(), 'reject', '0');
          // await FlutterCallkitIncoming.endAllCalls();
          // print("actionCallDecline----?}");
          // TODO: declined an incoming call
          break;
        case Event.ACTION_CALL_ENDED:
          print("actionCallEnded----?}");
          // TODO: ended an incoming/outgoing call
          break;
        case Event.ACTION_CALL_TIMEOUT:
          print("actionCallTimeout----?}");
          print(
              "Notification_Service-callHandle---rejectCall : ${PreferenceManager().getId()}, ${message.data['_id']}, staff");
          await homeController.rejectCall(PreferenceManager().getId().toString(), message.data['_id'], 'staff');
          await homeController.updateCallStatus(AppString.available);
          print("updateCallStatus(AppString.available)----2222?}");
          print(
              "Notification_Service-callHandle---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
          await homeController.addCallHistory(
              message.data['_id'], PreferenceManager().getId().toString(), 'reject', '0');
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
      print("EVENT__callHandle1_______  ${event}");
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
                    // Future.delayed(const Duration(seconds: 1), () async {
                    await homeController.updateCallStatus(AppString.busy);
                    print("updateCallStatus(AppString.busy)----33?}");
                    // });
                  });
                }
              });
            } else {
              if (homeController.getStaffDetailResModel.data?.activeStatus == AppString.online) {
                await homeController.updateCallStatus(AppString.busy);
                print("updateCallStatus(AppString.busy)----44?}");
              } else {
                await homeController.activeStatusApi(AppString.online).then((result1) async {
                  print("RESULT1___${result1}");
                  // Future.delayed(const Duration(seconds: 1), () async {
                  await homeController.updateCallStatus(AppString.busy);
                  print("updateCallStatus(AppString.busy)----55?}");
                  // });
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
          PreferenceManager().setSetScreen(true);
          print("PreferenceManager-------------->_callHandle1 ${PreferenceManager().getScreen()}");

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
            print("RESULT111==___${result111}");
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
            print("RESULT1!!!___${result1}");
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

  static onRejected(RemoteMessage message) {
    if (PreferenceManager().getRejectCall() == true) {
      log("ON_REJECT___TRUE__${PreferenceManager().getRejectCall()}");
      callDecline(message);
      PreferenceManager().setRejectCall(false);
      log("ON_REJECT___TRUE__AFTER__${PreferenceManager().getRejectCall()}");
    } else {
      log("ON_REJECT___FALSE__${PreferenceManager().getRejectCall()}");
    }
  }

  static Future<void> callDecline(RemoteMessage message) async {
    print(
        "Notification_Service-callHandle----rejectCall : ${PreferenceManager().getId()}, ${message.data['_id']}, staff}");
    await homeController.rejectCall(PreferenceManager().getId(), message.data['_id'], 'staff');
    await homeController.updateCallStatus(AppString.available);
    print("updateCallStatus(AppString.available)----1111?}");
    print(
        "Notification_Service-callHandle---addCallHistory : ${message.data['_id']}, ${PreferenceManager().getId()}, reject, 0");
    await homeController.addCallHistory(message.data['_id'], PreferenceManager().getId(), 'reject', '0');
    await FlutterCallkitIncoming.endAllCalls();
    print("actionCallDecline----?}");
  }

  static Future<void> showCallkitIncoming(String uuid, RemoteMessage message) async {
    var callData = message.data;
    print("callData---messageType> ${message.messageType}");
    print("callData---notification> ${message.notification}");
    print("callData---messageId> ${message.messageId}");
    print("callData---category> ${message.category}");
    print("callData---data> ${message.data}");

    print("callData---1->${callData}");
    print("callData---2->${message.messageType}");
    print("callData---3->${message.notification}");

    final params = CallKitParams(
      id: uuid,
      nameCaller: callData['user_name'],
      appName: 'Angel',
      avatar: 'assets/images/blank_image.jpg',
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
        isShowMissedCallNotification: false,
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
  static void getInitialMsg() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      print("Initial Message 11 :::::::::::: ${message}");
      print("Initial Message 22 :::::::::::: ${message?.data}");
      // var currentCall = await getCurrentCall();
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
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        // print('DATA::n::   ${calls[0]['n']}');
        // print('DATA::extra::   ${calls[0]['extra']}');
        //
        // if (calls[0]['n'] == null) {
        //   print("currentCall[0]['extra']['message']--------------> ${calls[0]['extra']['message']}");
        // } else {
        //   print("currentCall[0]['n']['message']--------------> ${calls[0]['n']['message']}");
        // }
        return calls[0];
      } else {
        return null;
      }
    }
  }

  //calling
  var data = {
    "image": 0,
    "user_name": "460355",
    "agora_token":
        "007eJxTYMg91br3afSimc+vlp+KmnSLt3gKl7enx1UH9UkCRX0xr0wUGAyS0tKSk4yTLM3T0kzSTC2S0gxSzJMTLVIsjZLMkkxTKozvpHY43knlmMbDyMjAyMDCwMgAAkxgkhlMsoBJJQYHx7z01Jx438TSnMzseENzAwtLI0tLQyMzA5N4EzMDY1NTBgYAYQkokQ==",
    "name": "Test22",
    "channelName": "@Angel_Maulik_1708929912604_460355",
    "_id": "65b2246de76ff6572631f384",
    "agora_app_id": "0bffcb3b97ff4f58bf0d7ca8d92b6b5d",
    "mobile_number": "1111111111",
    "call_type": "calling",
  };

  //profile
  /// type: "message",
  /// "angel_id": "65b2246de76ff6572631f384",

  ///show notification msg
  static void showMsg(RemoteNotification notification) {
    print("notification.body ${notification.body}");
    print("notification.title ${notification.title}");
    print("notification.android ${notification.android}");
    print("notification.apple ${notification.apple}");
    print("notification.bodyLocArgs ${notification.bodyLocArgs}");
    print("notification.bodyLocKey ${notification.bodyLocKey}");
    print("notification.titleLocArgs ${notification.titleLocArgs}");
    print("notification.titleLocKey ${notification.titleLocKey}");
    print("notification.web ${notification.web}");

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      '${notification.title}',
      // Missed Call
      // Incoming call
      '${notification.body}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          //'This channel is used for important notifications.',
          // description
          importance: Importance.high,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
        ),
        // iOS: DarwinNotificationDetails(),
      ),
      payload: notification.title,
    );
  }

  ///call when click on notification back
  static void onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log('listen-> ${message.data}');

      // try {
      //   if (PreferenceManager().getRole().toString() == AppString.staff) {
      //     Get.to(const CallHistoryScreen());
      //   } else {
      //     // Get.to(const HomeScreen());
      //     // Get.toNamed(Routes.personDetailScreen, arguments: {
      //     //   "angel_id": "65dd6cb6a84d73f6af596bf6",
      //     // });
      //     log("ANGEL_ID__${message.data["angel_id"]}");
      //     log("ID__${message.data["_id"]}");
      //
      //     ///type: "message",
      //     if (message.data["angel_id"] != null || message.data["angel_id"] != '') {
      //       log("message.data____message__${message.data["angel_id"]}");
      //       Get.toNamed(Routes.personDetailScreen, arguments: {
      //         "angel_id": "${message.data["angel_id"]}",
      //       });
      //     } else if (message.data["_id"] != null || message.data["_id"] != '') {
      //       log("message.data____id__${message.data["_id"]}");
      //       Get.toNamed(Routes.personDetailScreen, arguments: {
      //         "angel_id": "${message.data["_id"]}",
      //       });
      //     } else {
      //       log("message.data____else");
      //       Get.toNamed(Routes.homeScreen);
      //     }
      //   }
      // } catch (e) {
      //   log("ee--------------> ${e}");
      // }

      // showMsg(message.notification!);
      // callHandle(message);
      // showCallkitIncoming( Uuid().v4(),message);
    });
  }
}
