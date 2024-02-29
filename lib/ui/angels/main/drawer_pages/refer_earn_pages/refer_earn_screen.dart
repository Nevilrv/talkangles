import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_assets.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/share_profile_details_service.dart';
import 'package:talkangels/ui/angels/widgets/app_app_bar.dart';
import 'package:talkangels/ui/angels/widgets/app_button.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  String referCode = Get.arguments["referCode"];
  String? url;
  HandleNetworkConnection handleNetworkConnection = Get.find();

  @override
  void initState() {
    super.initState();
    handleNetworkConnection.checkConnectivity();

    if (handleNetworkConnection.isResult == false) {
      if (referCode != '') {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          url = await DynamicLinkService().createShareAppLink(referCode: referCode);
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        titleText: AppString.referEarn,
        action: [
          const Icon(Icons.help_outline),
          (w * 0.045).addWSpace(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(300, 50),
          child: 1.0.appDivider(),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: appGradient),
        child: referCode == '' || url == null
            ? const Center(child: CircularProgressIndicator(color: whiteColor))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Column(
                      children: [
                        SizedBox(
                            height: h * 0.2,
                            width: w * 0.4,
                            child: assetImage(AppAssets.referEarnAnimationAssets, fit: BoxFit.cover)),
                        AppString.together
                            .regularLeagueSpartan(fontColor: yellowColor, fontSize: 25, fontWeight: FontWeight.w900),
                        AppString.weAreGoingFurther.regularLeagueSpartan(),
                        (h * 0.005).addHSpace(),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(text: referCode));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: 3),
                            decoration: BoxDecoration(
                                color: yellowColor.withOpacity(0.06), borderRadius: BorderRadius.circular(15)),
                            child: (referCode).regularLeagueSpartan(fontColor: redFontColor),
                          ),
                        ),
                        (h * 0.045).addHSpace(),
                        AppString.shareThisLinkWithYourFriendAndAfterTheyInstallBothOfYouwillGet50CashRewards
                            .regularLeagueSpartan(textAlign: TextAlign.center),
                        (h * 0.025).addHSpace(),
                        InkWell(
                          onTap: () async {
                            if (url != '') {
                              await Clipboard.setData(ClipboardData(text: url.toString()));
                            }
                          },
                          child: Container(
                            height: h * 0.07,
                            width: w,
                            padding: EdgeInsets.all(w * 0.03),
                            decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: (url ?? '').regularLeagueSpartan(
                                      fontColor: whiteColor.withOpacity(0.5),
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: w * 0.09,
                                  child: const Icon(Icons.copy, color: appColorGreen, size: 28),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (h * 0.025).addHSpace(),
                        AppString.toUnderstandHowReferralWorksViewInvitationRules
                            .regularLeagueSpartan(textAlign: TextAlign.center),
                        (h * 0.025).addHSpace(),
                        SizedBox(
                          width: w * 0.5,
                          child: 1.0.appDivider(color: appColorGreen),
                        ),
                        Container(
                          height: h * 0.13,
                          width: w,
                          decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.copy, color: whiteColor),
                                  (h * 0.009).addHSpace(),
                                  AppString.copyLink
                                      .regularLeagueSpartan(fontSize: 11, fontColor: whiteColor.withOpacity(0.5)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.verified_outlined, color: whiteColor),
                                  (h * 0.009).addHSpace(),
                                  AppString.friendsRegisteredSuccessfully.regularLeagueSpartan(
                                      textAlign: TextAlign.center,
                                      fontSize: 11,
                                      fontColor: whiteColor.withOpacity(0.5)),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  assetImage(AppAssets.moneyBagIcon, color: whiteColor, height: 20, width: 20),
                                  (h * 0.009).addHSpace(),
                                  AppString.earnCashRewards.regularLeagueSpartan(
                                      textAlign: TextAlign.center,
                                      fontSize: 11,
                                      fontColor: whiteColor.withOpacity(0.5)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        (h * 0.04).addHSpace(),
                        AppButton(
                          onTap: () {
                            if (url != '') {
                              Share.share("$url");
                            } else {
                              showAppSnackBar(AppString.pleaseTryAgainLater);
                            }
                          },
                          child: AppString.referNow.regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        (h * 0.03).addHSpace(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
