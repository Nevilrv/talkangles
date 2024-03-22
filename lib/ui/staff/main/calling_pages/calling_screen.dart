import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/call_staff_conroller.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({Key? key}) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  Map<String, dynamic> message = Get.arguments["remoteMessage"] as Map<String, dynamic>;
  CallingScreenControllerStaff callingScreenController = Get.put(CallingScreenControllerStaff());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await setupAudioSession();
      callingScreenController.setAgoraDetails(
          message['channelName'], message['agora_app_id'], message['agora_token'], message['_id']);
      callingScreenController.initEngine();
    });
    super.initState();
  }

  Future<void> setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    await session.setActive(true);
  }

  @override
  void dispose() {
    callingScreenController.leaveChannel();
    callingScreenController.secondCountTimer?.cancel();
    callingScreenController.rtcEngineEventHandler;
    callingScreenController.update();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("message_callscreen_staff=======   ${message}");
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GetBuilder<CallingScreenControllerStaff>(
        builder: (controller) {
          return Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(gradient: appGradient),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  children: [
                    (h * 0.04).addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.call, color: whiteColor, size: 14),
                        (w * 0.015).addWSpace(),
                        formatDurationInHhMmSs(Duration(seconds: controller.secondCount)).regularLeagueSpartan(),
                      ],
                    ),
                    (h * 0.05).addHSpace(),
                    message['user_name'].toString().regularLeagueSpartan(fontSize: 34, fontWeight: FontWeight.w800),
                    AppString.ongoingCall.regularLeagueSpartan(fontSize: 14),
                    const Spacer(),
                    RippleAnimation(
                        color: callingAnimationColor.withOpacity(0.04),
                        delay: const Duration(milliseconds: 30),
                        repeat: true,
                        minRadius: 56,
                        ripplesCount: 6,
                        duration: const Duration(milliseconds: 6 * 300),
                        child: message['image'] == "" || message['image'] == "0"
                            ? const CircleAvatar(
                                minRadius: 75, maxRadius: 75, backgroundImage: AssetImage(AppAssets.blankProfile))
                            : CircleAvatar(
                                minRadius: 75, maxRadius: 75, backgroundImage: NetworkImage(message['image']))),
                    const Spacer(),
                    (h * 0.03).addHSpace(),
                    Container(
                      height: h * 0.17,
                      width: w,
                      decoration: BoxDecoration(color: callingColor, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// MUTE
                          GestureDetector(
                            onTap: () {
                              controller.switchMicrophone();
                            },
                            child: Container(
                              height: h,
                              width: w * 0.29,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  svgAssetImage(AppAssets.muteIcon,
                                      color: controller.openMicrophone ? whiteColor.withOpacity(0.5) : whiteColor,
                                      height: h * 0.045),
                                  (h * 0.01).addHSpace(),
                                  AppString.mute.regularLeagueSpartan(
                                      fontColor: controller.openMicrophone ? whiteColor.withOpacity(0.5) : whiteColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ),
                          ),

                          /// SPEAKER
                          GestureDetector(
                            onTap: () {
                              controller.switchSpeakerphone();
                            },
                            child: Container(
                              height: h * 0.1,
                              width: w * 0.25,
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: svgAssetImage(
                                      AppAssets.volumeIcon,
                                      color: controller.enableSpeakerphone ? whiteColor : whiteColor.withOpacity(0.5),
                                    ),
                                  ),
                                  (h * 0.01).addHSpace(),
                                  AppString.speaker.regularLeagueSpartan(
                                      fontColor:
                                          controller.enableSpeakerphone ? whiteColor : whiteColor.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (h * 0.06).addHSpace(),
                    GestureDetector(
                      onTap: () async {
                        await FlutterCallkitIncoming.endAllCalls();
                        controller.leaveChannel();
                        Get.back();
                      },
                      child: const CircleAvatar(
                        radius: 33,
                        backgroundColor: redColor,
                        child: Icon(Icons.call_end, color: whiteColor, size: 28),
                      ),
                    ),
                    (h * 0.07).addHSpace(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String formatDurationInHhMmSs(Duration duration) {
    final HH = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    if (HH == "00") {
      return '$mm:$ss';
    } else {
      return '$HH:$mm:$ss';
    }
  }
}
