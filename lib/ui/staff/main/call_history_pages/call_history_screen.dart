import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/ui/staff/main/call_history_pages/call_history_controller.dart';
import 'package:talkangels/ui/staff/models/get_call_history_res_model.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_show_profile_pic.dart';
import 'package:talkangels/ui/staff/utils/notification_service.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> with WidgetsBindingObserver {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  CallHistoryController callHistoryController = Get.put(CallHistoryController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (handleNetworkConnection.isResult == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await callHistoryController.getCallHistoryApi();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        log("PreferenceManager().getScreen()--------------> ${PreferenceManager().getScreen()}");

        NotificationService.getInitialMsg();

        log('call screen--erdrfefe4rf-');
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.hidden:
        print('appLifeCycleState suspending');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return Scaffold(
          appBar: AppAppBar(
            titleText: AppString.callHistory,
            titleSpacing: w * 0.06,
            bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
          ),
          body: GetBuilder<CallHistoryController>(
            builder: (controller) {
              /// Reverse CallHistory Data
              List<CallHistory>? reverseData = controller.formatCallList;

              return RefreshIndicator(
                onRefresh: () {
                  if (handleNetworkConnection.isResult == false) {
                    /// GET CALL HISTORY API
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await controller.getCallHistoryApi();
                    });
                  }
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: Container(
                  height: h,
                  width: w,
                  decoration: const BoxDecoration(gradient: appGradient),
                  child: SafeArea(
                    child: controller.isLoading == true
                        ? const Center(child: CircularProgressIndicator(color: whiteColor))
                        : controller.getCallHistoryResModel.status == 200
                            ? controller.getCallHistoryResModel.data!.isEmpty
                                ? Center(
                                    child: AppString.noDataFound.regularLeagueSpartan(
                                        fontColor: greyFontColor, fontSize: 20, fontWeight: FontWeight.w700))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: reverseData.length,
                                    itemBuilder: (context, index) {
                                      int lastIndex = reverseData[index].history!.length - 1;

                                      DateTime myDateTime =
                                          DateTime.parse("${reverseData[index].history?[lastIndex].date}");

                                      String formattedDate = DateFormat('MMM d').format(myDateTime);
                                      String times = DateFormat.jm().format(DateFormat("hh:mm:ss")
                                          .parse("${reverseData[index].history?[lastIndex].callTime}"));

                                      return InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.moreCallInfoScreen,
                                              arguments: {"call_history": reverseData[index]});
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
                                          child: Row(
                                            children: [
                                              AppShowProfilePic(
                                                  onTap: () {},
                                                  image: reverseData[index].user?.image ?? "",
                                                  borderShow: false),
                                              (w * 0.02).addWSpace(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      (reverseData[index].user?.userName ?? '')
                                                          .regularLeagueSpartan(fontWeight: FontWeight.w700),
                                                      (w * 0.02).addWSpace(),
                                                      reverseData[index].history?[lastIndex].callType == "outgoing"
                                                          ? const CircleAvatar(
                                                              radius: 8,
                                                              backgroundColor: appColorBlue,
                                                              child: Icon(
                                                                Icons.phone_forwarded,
                                                                size: 10,
                                                                color: whiteColor,
                                                              ),
                                                            )
                                                          : reverseData[index].history?[lastIndex].callType ==
                                                                  "incoming"
                                                              ? const CircleAvatar(
                                                                  radius: 8,
                                                                  backgroundColor: appColorGreen,
                                                                  child: Icon(
                                                                    Icons.phone_callback,
                                                                    size: 10,
                                                                    color: whiteColor,
                                                                  ),
                                                                )
                                                              : const CircleAvatar(
                                                                  radius: 8,
                                                                  backgroundColor: redColor,
                                                                  child: Icon(
                                                                    Icons.phone_missed,
                                                                    size: 10,
                                                                    color: whiteColor,
                                                                  ),
                                                                ),
                                                    ],
                                                  ),
                                                  (h * 0.005).addHSpace(),
                                                  SizedBox(
                                                    width: w * 0.65,
                                                    child:
                                                        "$formattedDate •${reverseData[index].history?[lastIndex].callType} call at $times"
                                                            .regularLeagueSpartan(
                                                                fontColor: greyFontColor,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w300,
                                                                textOverflow: TextOverflow.ellipsis),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12,
                                                color: whiteColor.withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return 1.0.appDivider();
                                    },
                                  )
                            : StaffErrorScreen(
                                isLoading: controller.isLoading,
                                onTap: () {
                                  if (networkController.isResult == false) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                                      await callHistoryController.getCallHistoryApi();
                                    });
                                  }
                                },
                              ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
