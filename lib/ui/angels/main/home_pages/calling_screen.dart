// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:simple_ripple_animation/simple_ripple_animation.dart';
// import 'package:talkangels/const/extentions.dart';
// import 'package:talkangels/models/angle_call_res_model.dart';
// import 'package:talkangels/ui/angels/constant/app_assets.dart';
// import 'package:talkangels/ui/angels/constant/app_color.dart';
// import 'package:talkangels/ui/angels/constant/app_string.dart';
// import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
// import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
// import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';
// import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';
//
// class CallingScreen extends StatefulWidget {
//   const CallingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CallingScreen> createState() => _CallingScreenState();
// }
//
// class _CallingScreenState extends State<CallingScreen> {
//   AngleData selectedAngle = Get.arguments["selectedAngle"];
//   AngleCallResModel angleCallResModel = Get.arguments["angleCallResModel"];
//   HomeScreenController homeController = Get.find();
//   HomeController homeController1 = Get.put(HomeController());
//   CallingScreenController callingScreenController = Get.find();
//   bool isMute = false;
//   bool isBluetooth = false;
//   bool isHold = false;
//   bool isVolume = false;
//   bool isDialer = true;
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       callingScreenController.setAngle(selectedAngle);
//       // callingScreenController.setAgoraDetails(
//       //     "temp1",
//       //     "bacece0ceaf6421092ae5550d0c5cb79",
//       //     "007eJxTYJCcUHpwxwHVf5E6Mifbyxj/rd1he+Li5R1nRAKrmcw9wy8oMCQlJqcmpxokpyammZkYGRpYGiWmmpqaGqQYJJsmJ5lbmh1ekNoQyMjQJ/aamZEBAkF8VoaS1NwCQwYGAL9BINA=");
//       callingScreenController.setAgoraDetails(
//         angleCallResModel.data?.agoraInfo!.channelName ?? '',
//         angleCallResModel.data?.agoraInfo!.token!.appId ?? '',
//         angleCallResModel.data?.agoraInfo!.token!.agoraToken ?? '',
//       );
//       callingScreenController.initEngine();
//     });
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     if (callingScreenController.isLeaveChannel == true) {
//       callingScreenController.leaveChannel();
//     }
//
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return GetBuilder<CallingScreenController>(
//       builder: (controller) {
//         return Scaffold(
//           body: Container(
//             height: h,
//             width: w,
//             decoration: const BoxDecoration(gradient: appGradient),
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: w * 0.04),
//                 child: Column(
//                   children: [
//                     const Spacer(),
//                     (h * 0.04).addHSpace(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.call, color: whiteColor, size: 14),
//                         (w * 0.015).addWSpace(),
//                         formatDurationInHhMmSs(Duration(seconds: controller.secondCount)).regularLeagueSpartan(),
//                       ],
//                     ),
//                     (h * 0.05).addHSpace(),
//                     ("${homeController.selectedAngle?.name!}")
//                         .regularLeagueSpartan(fontSize: 34, fontWeight: FontWeight.w800),
//                     AppString.calling.regularLeagueSpartan(fontSize: 14),
//                     const Spacer(),
//                     RippleAnimation(
//                         color: callingAnimationColor.withOpacity(0.04),
//                         delay: const Duration(milliseconds: 30),
//                         repeat: true,
//                         minRadius: 56,
//                         ripplesCount: 6,
//                         duration: const Duration(milliseconds: 6 * 300),
//                         child: homeController.selectedAngle!.image == ""
//                             ? const CircleAvatar(
//                                 minRadius: 75, maxRadius: 75, backgroundImage: AssetImage(AppAssets.blankProfile))
//                             : CircleAvatar(
//                                 minRadius: 75,
//                                 maxRadius: 75,
//                                 backgroundImage: NetworkImage(homeController.selectedAngle!.image!))),
//                     const Spacer(),
//                     (h * 0.06).addHSpace(),
//                     Container(
//                       height: h * 0.17,
//                       width: w,
//                       decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(10)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               controller.switchMicrophone();
//                             },
//                             child: Container(
//                               height: h,
//                               width: w * 0.29,
//                               color: Colors.transparent,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   svgAssetImage(AppAssets.muteIcon,
//                                       color: controller.openMicrophone ? whiteColor.withOpacity(0.5) : whiteColor,
//                                       height: h * 0.045),
//                                   (h * 0.01).addHSpace(),
//                                   AppString.mute.regularLeagueSpartan(
//                                       fontColor: controller.openMicrophone ? whiteColor.withOpacity(0.5) : whiteColor,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               controller.switchBlueTooth(isBluetooth);
//                               setState(() {
//                                 isBluetooth = !isBluetooth;
//                               });
//                             },
//                             child: Container(
//                               height: h,
//                               width: w * 0.29,
//                               color: Colors.transparent,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   svgAssetImage(AppAssets.bluetoothIcon,
//                                       color: isBluetooth ? whiteColor : whiteColor.withOpacity(0.5), height: h * 0.045),
//                                   (h * 0.01).addHSpace(),
//                                   AppString.bluetooth.regularLeagueSpartan(
//                                       fontColor: isBluetooth ? whiteColor : whiteColor.withOpacity(0.5),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               controller.switchSpeakerphone();
//                             },
//                             child: Container(
//                               height: h * 0.1,
//                               width: w * 0.25,
//                               color: Colors.transparent,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 // mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                     child: svgAssetImage(
//                                       AppAssets.volumeIcon,
//                                       color: controller.enableSpeakerphone ? whiteColor : whiteColor.withOpacity(0.5),
//                                     ),
//                                   ),
//                                   (h * 0.01).addHSpace(),
//                                   AppString.speaker.regularLeagueSpartan(
//                                       fontColor:
//                                           controller.enableSpeakerphone ? whiteColor : whiteColor.withOpacity(0.5),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // GestureDetector(
//                           //   onTap: () {
//                           //     setState(() {
//                           //       isHold = !isHold;
//                           //     });
//                           //   },
//                           //   child: Container(
//                           //     height: h,
//                           //     width: w * 0.29,
//                           //     color: Colors.transparent,
//                           //     child: Column(
//                           //       mainAxisAlignment: MainAxisAlignment.center,
//                           //       children: [
//                           //         svgAssetImage(AppAssets.holdIcon,
//                           //             color: isHold ? whiteColor : whiteColor.withOpacity(0.5), height: h * 0.045),
//                           //         (h * 0.01).addHSpace(),
//                           //         AppString.hold.regularLeagueSpartan(
//                           //             fontColor: isHold ? whiteColor : whiteColor.withOpacity(0.5),
//                           //             fontSize: 14,
//                           //             fontWeight: FontWeight.w600),
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),
//                     (h * 0.06).addHSpace(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         // GestureDetector(
//                         //   onTap: () {
//                         //     controller.switchSpeakerphone();
//                         //   },
//                         //   child: Container(
//                         //     height: h * 0.1,
//                         //     width: w * 0.25,
//                         //     color: Colors.transparent,
//                         //     child: Center(
//                         //       child: svgAssetImage(
//                         //         AppAssets.volumeIcon,
//                         //         color: controller.enableSpeakerphone ? whiteColor : whiteColor.withOpacity(0.5),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ),
//                         GestureDetector(
//                           onTap: () async {
//                             if (callingScreenController.isLeaveChannel == true) {
//                               controller.leaveChannel();
//                             }
//
//                             Get.back();
//                           },
//                           child: const CircleAvatar(
//                             radius: 33,
//                             backgroundColor: redFontColor,
//                             child: Icon(Icons.call_end, color: whiteColor, size: 28),
//                           ),
//                         ),
//                         // GestureDetector(
//                         //   onTap: () {
//                         //     setState(() {
//                         //       isDialer = !isDialer;
//                         //     });
//                         //   },
//                         //   child: Container(
//                         //     height: h * 0.1,
//                         //     width: w * 0.25,
//                         //     color: Colors.transparent,
//                         //     child: Center(
//                         //         child: svgAssetImage(
//                         //       AppAssets.gridIcon,
//                         //       color: isDialer ? whiteColor : whiteColor.withOpacity(0.5),
//                         //     )),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                     (h * 0.07).addHSpace(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   String formatDurationInHhMmSs(Duration duration) {
//     final HH = (duration.inHours).toString().padLeft(2, '0');
//     final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
//     final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
//     if (HH == "00") {
//       return '$mm:$ss';
//     } else {
//       return '$HH:$mm:$ss';
//     }
//   }
// }

/// UPDATED
///
import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/models/angle_call_res_model.dart';
import 'package:talkangels/ui/angels/constant/app_assets.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_controller.dart';

class CallingScreen extends StatefulWidget {
  const CallingScreen({Key? key}) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  AngleData selectedAngle = Get.arguments["selectedAngle"];
  AngleCallResModel angleCallResModel = Get.arguments["angleCallResModel"];
  HomeScreenController angelsHomeController = Get.find();
  HomeController homeController1 = Get.put(HomeController());
  CallingScreenController callingScreenController = Get.put(CallingScreenController());
  bool isBluetooth = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await setupAudioSession();
      callingScreenController.setAngle(selectedAngle);
      callingScreenController.setAgoraDetails(
        angleCallResModel.data?.agoraInfo!.channelName ?? '',
        angleCallResModel.data?.agoraInfo!.token!.appId ?? '',
        angleCallResModel.data?.agoraInfo!.token!.agoraToken ?? '',
      );
      callingScreenController.initEngine();

      callingScreenController.callerTuneState();
    });

    // TODO: implement initState
    super.initState();
  }

  Future<void> setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    await session.setActive(true);
  }

  @override
  void dispose() {
    if (callingScreenController.isLeaveChannel == true) {
      print("REJECT_CALL___333");
      callingScreenController.leaveChannel();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        setState(() {
          log(" callingScreenController.timers--------------> ${callingScreenController.timers!.isActive}");
          callingScreenController.timers!.cancel();
        });
      }
      callingScreenController.player;
      print("PLAY_SOUND_DISPOSE___________");
    });

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<CallingScreenController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(gradient: appGradient),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  children: [
                    const Spacer(),
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
                    ("${angelsHomeController.selectedAngle?.userName!}")
                        .regularLeagueSpartan(fontSize: 34, fontWeight: FontWeight.w800),
                    AppString.calling.regularLeagueSpartan(fontSize: 14),
                    const Spacer(),
                    RippleAnimation(
                        color: callingAnimationColor.withOpacity(0.04),
                        delay: const Duration(milliseconds: 30),
                        repeat: true,
                        minRadius: 56,
                        ripplesCount: 6,
                        duration: const Duration(milliseconds: 6 * 300),
                        child: angelsHomeController.selectedAngle!.image == ""
                            ? const CircleAvatar(
                                minRadius: 75, maxRadius: 75, backgroundImage: AssetImage(AppAssets.blankProfile))
                            : CircleAvatar(
                                minRadius: 75,
                                maxRadius: 75,
                                backgroundImage: NetworkImage(angelsHomeController.selectedAngle!.image!))),
                    const Spacer(),
                    (h * 0.06).addHSpace(),
                    Container(
                      height: h * 0.17,
                      width: w,
                      decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(10)),
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

                          /// BLUETOOTH
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       isBluetooth = !isBluetooth;
                          //     });
                          //     controller.switchBlueTooth(isBluetooth);
                          //     print("isBluetooth--------------> ${isBluetooth}");
                          //   },
                          //   child: Container(
                          //     height: h,
                          //     width: w * 0.29,
                          //     color: Colors.transparent,
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         svgAssetImage(AppAssets.bluetoothIcon,
                          //             color: isBluetooth ? whiteColor : whiteColor.withOpacity(0.5), height: h * 0.045),
                          //         (h * 0.01).addHSpace(),
                          //         AppString.bluetooth.regularLeagueSpartan(
                          //             fontColor: isBluetooth ? whiteColor : whiteColor.withOpacity(0.5),
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w600),
                          //       ],
                          //     ),
                          //   ),
                          // ),

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (callingScreenController.isLeaveChannel == true) {
                              print("REJECT_CALL___444");
                              controller.leaveChannel();
                            }
                            if (callingScreenController.isUserJoined == false) {
                              callingScreenController.rejectCall();
                            }
                            Get.back();
                          },
                          child: const CircleAvatar(
                            radius: 33,
                            backgroundColor: redFontColor,
                            child: Icon(Icons.call_end, color: whiteColor, size: 28),
                          ),
                        ),
                      ],
                    ),
                    (h * 0.07).addHSpace(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
