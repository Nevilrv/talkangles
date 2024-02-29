// import 'dart:async';
// import 'dart:developer';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:talkangels/const/shared_prefs.dart';
// import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
//
// class CallingScreenController extends GetxController {
//   RtcEngine? engine;
//   String channelId = "";
//   String appId = "";
//   String token = "";
//   String angleId = "";
//   Timer? timer;
//   int secondCount = 0;
//   bool isLeaveChannel = true;
//
//   setAgoraDetails(String channellId, String apppId, String tokenn, String angleIdd) {
//     isLeaveChannel = true;
//     channelId = channellId;
//     appId = apppId;
//     token = tokenn;
//     angleId = angleIdd;
//     update();
//   }
//
//   bool isJoined = false, isConnect = false, openMicrophone = true, enableSpeakerphone = false, playEffect = false;
//   bool enableInEarMonitoring = false;
//   double recordingVolume = 100, playbackVolume = 100, inEarMonitoringVolume = 100;
//   // TextEditingController channelIdController = TextEditingController();
//   ChannelProfileType channelProfileType = ChannelProfileType.channelProfileLiveBroadcasting;
//   late final RtcEngineEventHandler rtcEngineEventHandler;
//   HomeController homeController = Get.put(HomeController());
//   // Map<int, String> userMap = {};
//   Future<void> initEngine() async {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       await Permission.microphone.request();
//     }
//     engine = createAgoraRtcEngine();
//     await engine!.initialize(RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));
//     await engine!.enableAudio();
//     // await engine!.setEnableSpeakerphone(false);
//     await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     await engine!.setAudioProfile(
//       profile: AudioProfileType.audioProfileDefault,
//       scenario: AudioScenarioType.audioScenarioGameStreaming,
//     );
//     await engine!.joinChannel(
//         token: token,
//         channelId: channelId,
//         uid: 0,
//         options: const ChannelMediaOptions(
//           channelProfile: ChannelProfileType.channelProfileCommunication,
//           clientRoleType: ClientRoleType.clientRoleBroadcaster,
//         ));
//     rtcEngineEventHandler = RtcEngineEventHandler(
//       onError: (ErrorCodeType err, String msg) {
//         log("err----->${err}  $msg");
//       },
//
//       onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//         log('join----');
//         isConnect = true;
//         isJoined = true;
//
//         timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//           secondCount = secondCount + 1;
//           update();
//           log("secondCount--------------> ${secondCount}");
//         });
//         update();
//       },
//       onLeaveChannel: (RtcConnection connection, RtcStats stats) {
//         isJoined = false;
//         timer!.cancel();
//
//         leaveChannel();
//         Get.back();
//         log('remove----');
//         update();
//       },
//       onUserOffline: (connection, remoteUid, reason) {
//         log('remove----222');
//         leaveChannel();
//         Get.back();
//       },
//       // onAudioDeviceVolumeChanged: (deviceType, volume, muted) {
//       //   log("muted----->${muted}");
//       //   log("deviceType----->${deviceType}");
//       //   log("volume----->${volume}");
//       // },
//       onUserJoined: (connection, remoteUid, elapsed) {
//         log('user join${remoteUid}');
//       },
//     );
//
//     engine!.registerEventHandler(rtcEngineEventHandler);
//   }
//
//   @override
//   void onClose() {
//     leaveChannel();
//     super.onClose();
//   }
//
//   leaveChannel() async {
//     // await engine!.release();
//     if (isLeaveChannel == true) {
//       isLeaveChannel = false;
//       await engine!.leaveChannel();
//       log("CALL_STAFF_CONTROLLER----addCallHistory : ${angleId}, ${PreferenceManager().getId()}, outgoing, ${secondCount.toString()}");
//       await homeController.addCallHistory(angleId, PreferenceManager().getId(), "outgoing", secondCount.toString());
//       isJoined = false;
//       isConnect = false;
//       openMicrophone = true;
//       enableSpeakerphone = true;
//       playEffect = false;
//       enableInEarMonitoring = false;
//       recordingVolume = 100;
//       playbackVolume = 100;
//       inEarMonitoringVolume = 100;
//       timer!.cancel();
//       secondCount = 0;
//       update();
//     }
//   }
//
//   switchMicrophone() async {
//     // await  engine.muteLocalAudioStream(!openMicrophone);
//     await engine!.enableLocalAudio(!openMicrophone);
//     openMicrophone = !openMicrophone;
//     update();
//   }
//
//   switchSpeakerphone() async {
//     await engine!.setEnableSpeakerphone(!enableSpeakerphone);
//     enableSpeakerphone = !enableSpeakerphone;
//     update();
//   }
//
//   ///
//   /// extra
//
// // onChangeBluetooth(double value) async {
// // _inEarMonitoringVolume = value;
// // await engine);
// // update();
// // }
// }

/// UPDATED
import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';

class CallingScreenControllerStaff extends GetxController {
  RtcEngine? engine;
  String channelId = "";
  String appId = "";
  String token = "";
  String angleId = "";
  Timer? timer;
  int secondCount = 0;
  bool isLeaveChannel = true;

  setAgoraDetails(String channellId, String apppId, String tokenn, String angleIdd) {
    isLeaveChannel = true;
    channelId = channellId;
    appId = apppId;
    token = tokenn;
    angleId = angleIdd;
    update();
  }

  bool isJoined = false, isConnect = false, openMicrophone = true, enableSpeakerphone = false, playEffect = false;
  bool enableInEarMonitoring = false;
  double recordingVolume = 100, playbackVolume = 100, inEarMonitoringVolume = 100;
  ChannelProfileType channelProfileType = ChannelProfileType.channelProfileLiveBroadcasting;
  RtcEngineEventHandler? rtcEngineEventHandler;
  HomeController homeController = Get.put(HomeController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  Future<void> initEngine() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    engine = createAgoraRtcEngine();
    await engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    await engine!.enableAudio();
    await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine!.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    await engine!.joinChannel(
        token: token,
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
    rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        log("err----->${err}  $msg");
      },

      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        // engine?.registerEventHandler(RtcEngineEventHandler(onUserMuteAudio: (connection, remoteUid, muted) {
        //
        // },));
        log('join----');
        isConnect = true;
        isJoined = true;

        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          secondCount = secondCount + 1;
          update();
          log("secondCount--------------> ${secondCount}");
        });
        update();
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        isJoined = false;
        timer?.cancel();

        leaveChannel();
        Get.back();
        log('remove----');
        update();
      },
      onUserOffline: (connection, remoteUid, reason) {
        log('remove----222');
        leaveChannel();
        Get.back();
      },
      // onAudioDeviceVolumeChanged: (deviceType, volume, muted) {
      //   log("muted----->${muted}");
      //   log("deviceType----->${deviceType}");
      //   log("volume----->${volume}");
      // },
      onUserJoined: (connection, remoteUid, elapsed) {
        log('user join${remoteUid}');
      },
    );

    engine!.registerEventHandler(rtcEngineEventHandler!);
  }

  @override
  void onClose() {
    leaveChannel();
    super.onClose();
  }

  leaveChannel() async {
    // await engine!.release();
    if (isLeaveChannel == true) {
      isLeaveChannel = false;
      print("END__CALLL____");
      FlutterCallkitIncoming.endAllCalls();
      await engine?.leaveChannel();
      await homeController.updateCallStatus(AppString.available);
      print("updateCallStatus(AppString.available)----5?}");
      log("updateCallStatus(AppString.available)----5?}");
      print(
          "CALL_STAFF_CONTROLLER----addCallHistory21212121 : ${angleId}, ${PreferenceManager().getId()}, incoming, ${secondCount.toString()}");
      await homeController
          .addCallHistory(angleId, PreferenceManager().getId().toString(), "incoming", secondCount.toString())
          .then((result) async {
        if (PreferenceManager().getRole().toString() == AppString.staff) {
          print("GET_DETAILS_STAFF");
          await homeController.getStaffDetailApi();
        }
      });
      isJoined = false;
      isConnect = false;
      openMicrophone = true;
      enableSpeakerphone = true;
      playEffect = false;
      enableInEarMonitoring = false;
      recordingVolume = 100;
      playbackVolume = 100;
      inEarMonitoringVolume = 100;
      timer?.cancel();
      secondCount = 0;
      update();
    }
  }

  switchMicrophone() async {
    await engine!.enableLocalAudio(!openMicrophone);
    openMicrophone = !openMicrophone;
    update();
  }

  switchSpeakerphone() async {
    await engine!.setEnableSpeakerphone(!enableSpeakerphone);
    enableSpeakerphone = !enableSpeakerphone;
    update();
  }
}
