import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';

import 'package:talkangels/common/app_button.dart';
import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';

import 'package:talkangels/common/app_dialogbox.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart' as staff;

class CallingScreenController extends GetxController {
  RtcEngine? engine;
  String channelId = "";
  String appId = "";
  String token = "";
  String staffId = "";
  AngleData? selectedAngle;
  Timer? timers;
  Timer? timered;
  int secondCount = 0;
  bool isUserJoined = false;
  bool isLeaveChannel = true;
  Timer? getDetailsTimer;
  Timer? timer;
  MethodChannel? platform;

  staff.HomeController homeController = Get.put(staff.HomeController());
  AudioPlayer player = AudioPlayer();

  setAngle(AngleData value) {
    selectedAngle = value;
    update();
  }

  void openSnackbar() {
    Get.showSnackbar(const GetSnackBar(
      title: 'title',
      message: 'body',
    ));
  }

  Future<void> callerTuneState() async {
    player.onPlayerStateChanged.listen(
      (it) {
        switch (it) {
          case PlayerState.playing:
            print("PLAY_SOUND_VOLUME_STATE-playing--${player.state}");
            break;
          case PlayerState.completed:
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await player.play(AssetSource(AppAssets.callerTuneSound));
              print("PLAY_SOUND_VOLUME_STATE-completed--${player.state}");
            });
            update();
            break;
          case PlayerState.paused:
            print("PLAY_SOUND_VOLUME_STATE-paused--${player.state}");
            break;
          case PlayerState.stopped:
            print("PLAY_SOUND_VOLUME_STATE-stopped--${player.state}");
            break;
          case PlayerState.disposed:
            print("PLAY_SOUND_VOLUME_STATE-disposed--${player.state}");
            break;
          default:
            print("PLAY_SOUND_VOLUME_STATE-default--${player.state}");
            break;
        }
      },
    );
  }

  setCallRecieveOrNot() async {
    await player.play(AssetSource(AppAssets.callerTuneSound));
    await player.setVolume(0.5);
    timered = Timer.periodic(const Duration(seconds: 1), (timer) {});
    timer = Timer(
      const Duration(seconds: 35),
      () async {
        await player.stop();

        if (isUserJoined == true) {
          timer!.cancel();
        } else {
          // rejectCall();
          if (isLeaveChannel == true) {
            leaveChannel();
            Get.back();
          }
        }
      },
    );

    HomeScreenController homeScreenController = Get.find();
    print("TOTAL_BALLANCE   ${homeScreenController.userDetailsResModel.data?.talkAngelWallet!.totalBallance}");
    print("ANGELS_CHARGES   ${selectedAngle!.charges}");

    double walletAmount = (homeScreenController.userDetailsResModel.data?.talkAngelWallet!.totalBallance)! *
        60 /
        (selectedAngle!.charges)!;
    log("TOTAL_SECOND $walletAmount");
    print("TOTAL_SECOND $walletAmount");
    timers = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isUserJoined == true) {
        secondCount = secondCount + 1;
        update();
        log("secondCount--------> ${secondCount}");
        print("secondCount--------> ${secondCount}");

        if (walletAmount <= secondCount) {
          print("REJECT_CALL___555");
          leaveChannel();
          rejectCall();
          Get.back();
          addWalletAmountDialogBox();
        }
      }
    });
  }

  rejectCall() async {
    print(
        "CALL_ANGEL_CONTROLLER----rejectCall!!!! : ${selectedAngle?.id ?? ""}, ${PreferenceManager().getId()}, user}");
    await homeController.rejectCall(selectedAngle?.id ?? "", PreferenceManager().getId() ?? "", 'user');
  }

  setAgoraDetails(
    String channellId,
    String apppId,
    String tokenn,
  ) {
    isUserJoined = false;
    isLeaveChannel = true;
    channelId = channellId;
    appId = apppId;
    token = tokenn;

    setCallRecieveOrNot();
    update();
  }

  bool isJoined = false, isConnect = false, openMicrophone = true, enableSpeakerphone = false, playEffect = false;
  bool enableInEarMonitoring = false;
  double recordingVolume = 100, playbackVolume = 100, inEarMonitoringVolume = 100;
  TextEditingController channelIdController = TextEditingController();
  ChannelProfileType channelProfileType = ChannelProfileType.channelProfileCommunication;
  RtcEngineEventHandler? rtcEngineEventHandler;

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
    platform = MethodChannel(channelId.toString());
    await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine!.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    log("token---token-----------> ${token}");

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
        log("err----->$err  $msg");
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('join----');
        isConnect = true;
        isJoined = true;
        update();
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        isJoined = false;
        if (isLeaveChannel == true) {
          print("REJECT_CALL___666");
          leaveChannel();
          Get.back();
        }

        log('remove----111');
        update();
      },
      onUserOffline: (connection, remoteUid, reason) {
        log('remove----222');
        if (isLeaveChannel == true) {
          print("REJECT_CALL___777");
          leaveChannel();
          Get.back();
        }
      },
      onUserJoined: (connection, remoteUid, elapsed) async {
        log('user join  $remoteUid');
        isUserJoined = true;
        update();
        secondCount = 0;
        print("PLAY_SOUND_STOP________onUserJoined___");
        await player.stop();
        update();
        log('localUid----${connection.localUid}');
      },
    );
    engine!.registerEventHandler(rtcEngineEventHandler!);
    // update();
  }

  @override
  void onClose() {
    // if (isLeaveChannel == true) {
    //   leaveChannel();
    // }

    super.onClose();
  }

  leaveChannel({bool isRejected = false}) async {
    HomeScreenController angelHomeScreenController = Get.put(HomeScreenController());

    TextEditingController ratingController = TextEditingController();

    await engine?.leaveChannel();
    String? rating;

    if (secondCount >= 30 && isUserJoined == true) {
      Get.dialog(
        AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.08),
          contentPadding: EdgeInsets.all(Get.width * 0.05),
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Builder(
            builder: (context) {
              return Container(
                padding: EdgeInsets.zero,
                height: Get.height * 0.5,
                width: Get.width * 0.9,
                child: Column(
                  children: [
                    AppString.pleaseRatingThisCall
                        .regularLeagueSpartan(fontColor: blackColor, fontSize: 24, fontWeight: FontWeight.w800),
                    (Get.height * 0.03).addHSpace(),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (ratingValue) {
                        rating = ratingValue.toString().split('.').first;
                        log("$rating");
                      },
                    ),
                    (Get.height * 0.03).addHSpace(),
                    TextField(
                      maxLines: 6,
                      minLines: 5,
                      onChanged: (value) {},
                      controller: ratingController,
                      style: const TextStyle(
                          color: blackColor,
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'League Spartan'),
                      decoration: InputDecoration(
                        hintText: "Comments",
                        hintStyle: TextStyle(
                            color: blackColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'League Spartan'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: appBarColor),
                        ),
                      ),
                    ),
                    (Get.height * 0.04).addHSpace(),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppButton(
                            height: Get.height * 0.06,
                            color: Colors.transparent,
                            onTap: () {
                              Get.back();
                              log("RATING_SKIP");
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
                              if (rating != null || ratingController.text.isNotEmpty) {
                                /// Post Rating Api
                                angelHomeScreenController.addRatingApi(
                                  "${selectedAngle?.id.toString()}", // null
                                  rating!,
                                  ratingController.text,
                                );
                              } else {
                                showAppSnackBar(AppString.pleaseFilledRequireFields);
                              }
                            },
                            child: angelHomeScreenController.isRatingLoading == true
                                ? const Center(child: CircularProgressIndicator(color: whiteColor))
                                : AppString.submit.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w700),
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
    log("isUserJoined=== $secondCount");
    print("isUserJoined=== $isUserJoined");

    if (secondCount > 0 && isUserJoined == true) {
      isUserJoined = false;
      update();
      getDetailsTimer = Timer(
        const Duration(seconds: 8),
        () async {
          print("USESR_DETAILS_CALL");
          await angelHomeScreenController.userDetailsApi();
          getDetailsTimer?.cancel();
          update();
        },
      );
    } else {
      print("USER_DETAILS");
    }

    await player.stop();
    print("PLAY_SOUND_STOP__________leaveChannel_");

    isJoined = false;
    isConnect = false;
    openMicrophone = true;
    enableSpeakerphone = true;
    playEffect = false;
    enableInEarMonitoring = false;
    recordingVolume = 100;
    playbackVolume = 100;
    inEarMonitoringVolume = 100;
    secondCount = 0;
    isLeaveChannel = false;
    update();

    timered?.cancel();
    timer?.cancel();
    timers?.cancel();
    isRejected = false;

    log("timers--------------timers-------------> ${timers?.isActive}");
    update();
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
    if (enableSpeakerphone == false) {
      print("PLAY_SOUND_MIN___________");
      await player.setVolume(0.3);
      update();
    } else {
      print("PLAY_SOUND_MAX___________");
      await player.setVolume(1.0);
      update();
    }
  }

  switchBlueTooth(bool value) async {
    log("VALUE::  ${value}");

    try {
      await engine!
          .enableInEarMonitoring(enabled: false, includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNone);
      log("ConnectivityResult.bluetooth=====  ${ConnectivityResult}");
    } catch (e) {
      log("EEEEEEEEE   ${e}");
    }
    update();
  }
}
