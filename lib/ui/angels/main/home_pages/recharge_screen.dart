import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/constant/app_assets.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/ui/angels/main/home_pages/recharge_screen_controller.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/widgets/app_app_bar.dart';
import 'package:talkangels/ui/angels/widgets/app_button.dart';
import 'package:talkangels/ui/angels/widgets/app_dialogbox.dart';

class AllChargesScreen extends StatefulWidget {
  const AllChargesScreen({super.key});

  @override
  State<AllChargesScreen> createState() => _AllChargesScreenState();
}

class _AllChargesScreenState extends State<AllChargesScreen> {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeScreenController = Get.find();
  RechargeScreenController rechargeScreenController = Get.put(RechargeScreenController());
  int? indexC;
  String? selectedRecharge;
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rechargeScreenController.getAllRecharge();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GetBuilder<HandleNetworkConnection>(
      builder: (networkController) {
        return Scaffold(
          appBar: AppAppBar(
            backGroundColor: appBarColor,
            titleText: AppString.allRecharges,
            titleFontWeight: FontWeight.w900,
            fontSize: 20,
            titleSpacing: w * 0.06,
            bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
          ),
          body: GetBuilder<RechargeScreenController>(
            builder: (controller) {
              return Container(
                height: h,
                width: w,
                decoration: const BoxDecoration(gradient: appGradient),
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        width: w,
                        decoration: const BoxDecoration(color: containerColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                          child: Row(
                            children: [
                              svgAssetImage(AppAssets.percentage),
                              (w * 0.02).addWSpace(),
                              AppString.availableRecharges.regularLeagueSpartan(),
                              "(${controller.getAllRechargeResModel.data?.length ?? '0'})".regularLeagueSpartan(),
                            ],
                          ),
                        ),
                      ),
                      controller.isLoading == true && controller.getAllRechargeResModel.data == null
                          ? const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.white)))
                          : controller.getAllRechargeResModel.status == 200
                              ? controller.getAllRechargeResModel.data!.isEmpty
                                  ? Expanded(
                                      child: Center(
                                          child: AppString.noDataFound.leagueSpartanfs20w600(
                                              fontColor: greyFontColor, fontWeight: FontWeight.w700)))
                                  : Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: controller.getAllRechargeResModel.data?.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
                                                child: Row(
                                                  children: [
                                                    (w * 0.01).addWSpace(),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "₹${controller.getAllRechargeResModel.data?[index].amount ?? ''}",
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                    color: greyFontColor,
                                                                    decoration: TextDecoration.lineThrough,
                                                                    decorationColor: greyFontColor),
                                                              ),
                                                              (w * 0.02).addWSpace(),
                                                              "₹ ${controller.getAllRechargeResModel.data?[index].discountAmount ?? ''}"
                                                                  .regularLeagueSpartan(fontWeight: FontWeight.w900),
                                                            ],
                                                          ),
                                                          (h * 0.01).addHSpace(),
                                                          (controller.getAllRechargeResModel.data?[index].description ??
                                                                  '')
                                                              .regularLeagueSpartan(
                                                                  fontSize: 14, fontColor: greyFontColor),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: AppButton(
                                                        height: h * 0.045,
                                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                                        color: indexC == index ? appColorGreen : Colors.transparent,
                                                        border: Border.all(color: whiteColor.withOpacity(0.5)),
                                                        onTap: () {
                                                          selectedRecharge =
                                                              "${controller.getAllRechargeResModel.data?[index].amount}";
                                                          indexC = index;
                                                          setState(() {});

                                                          showModalBottomSheet<void>(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return Container(
                                                                height: h * 0.53,
                                                                decoration: const BoxDecoration(
                                                                    color: containerColor,
                                                                    borderRadius: BorderRadius.vertical(
                                                                        top: Radius.circular(20))),
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: w * 0.05, vertical: h * 0.025),
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Stack(
                                                                          children: [
                                                                            Container(
                                                                              width: w * 1,
                                                                              height: h * 0.15,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                image: DecorationImage(
                                                                                    image: assetsImage2(AppAssets.girl),
                                                                                    fit: BoxFit.cover),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              right: w * 0.05,
                                                                              top: h * 0.01,
                                                                              child: Row(
                                                                                children: [
                                                                                  AppString.insufficientBalance
                                                                                      .regularLeagueSpartan(
                                                                                          fontWeight: FontWeight.w600),
                                                                                  (w * 0.01).addWSpace(),
                                                                                  svgAssetImage(AppAssets.emoji),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        (h * 0.03).addHSpace(),
                                                                        AppString.addTalkTime.regularLeagueSpartan(),
                                                                        (h * 0.01).addHSpace(),
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              color: whiteColor,
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child: Padding(
                                                                            padding: EdgeInsets.symmetric(
                                                                                horizontal: w * 0.04),
                                                                            child: Row(
                                                                              children: [
                                                                                "₹${controller.getAllRechargeResModel.data?[index].discountAmount ?? ''}.00"
                                                                                    .regularAllertaStencil(
                                                                                        fontColor: blackColor),
                                                                                const Spacer(),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  child: AppString.changeOffer
                                                                                      .regularLeagueSpartan(
                                                                                          fontColor: redFontColor,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        (h * 0.012).addHSpace(),
                                                                        Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.verified,
                                                                              color: greenColor,
                                                                            ),
                                                                            (w * 0.02).addWSpace(),
                                                                            AppString.offerTextFirst
                                                                                .regularLeagueSpartan(
                                                                                    fontColor: appColorGreen,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w700),
                                                                            "${100 - (controller.getAllRechargeResModel.data?[index].discountAmount!)! * 100 / (controller.getAllRechargeResModel.data![index].amount!)}"
                                                                                .regularLeagueSpartan(
                                                                                    fontColor: appColorGreen,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w900),
                                                                            AppString.offerTextLast
                                                                                .regularLeagueSpartan(
                                                                                    fontColor: appColorGreen,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w700),
                                                                          ],
                                                                        ),
                                                                        const Spacer(),
                                                                        AppButton(
                                                                          onTap: () {
                                                                            if (networkController.isResult == false) {
                                                                              var options = {
                                                                                'key': 'rzp_test_EM5urUrcGkdJvm',
                                                                                'amount': 100 *
                                                                                    controller.getAllRechargeResModel
                                                                                        .data![index].discountAmount!,
                                                                                'name': 'Acme Corp.',
                                                                                'description': 'Recharge',
                                                                                'retry': {
                                                                                  'enabled': true,
                                                                                  'max_count': 1
                                                                                },
                                                                                'send_sms_hash': true,
                                                                                'prefill': {
                                                                                  'contact':
                                                                                      "+91 ${PreferenceManager().getNumber().toString()}",
                                                                                  'email': 'test@razorpay.com'
                                                                                },
                                                                                'external': {
                                                                                  'wallets': ['paytm']
                                                                                }
                                                                              };
                                                                              try {
                                                                                Get.back();
                                                                                razorpay.open(options);
                                                                                log("SUCCESS======>>>>>");
                                                                              } catch (e) {
                                                                                log("ERROR==RAZORPAY   $e");
                                                                              }
                                                                            } else {
                                                                              Get.back();
                                                                              showAppSnackBar(
                                                                                  AppString.noInternetConnection);
                                                                            }
                                                                          },
                                                                          child: AppString.add.regularLeagueSpartan(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: indexC == index
                                                            ? AppString.applied.regularLeagueSpartan(
                                                                fontSize: 14, fontWeight: FontWeight.w600)
                                                            : AppString.apply.regularLeagueSpartan(
                                                                fontSize: 14, fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              1.0.appDivider(),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                              : ErrorScreen(
                                  isLoading: controller.isLoading,
                                  onTap: () {
                                    if (networkController.isResult == false) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                                        await rechargeScreenController.getAllRecharge();
                                      });
                                    }
                                  },
                                ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    log("${response.code}", name: "ERRORcode");
    log("${response.message}", name: "ERRORmessage");
    log("${response.error}", name: "ERRORerror");

    paymentFaildDialogBox(context,
        h: MediaQuery.of(context).size.height,
        w: MediaQuery.of(context).size.width,
        barrierDismissible: true,
        description: response.message);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    log(response.data.toString(), name: "SUCCESS");

    ///API calling _Add wallet Amount
    homeScreenController.addMyWalletAmountApi(
      selectedRecharge!,
      response.paymentId.toString(),
    );
    Get.back();
    appDialogBox(
      context,
      h: MediaQuery.of(context).size.height,
      w: MediaQuery.of(context).size.width,
      barrierDismissible: true,
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    log(response.walletName.toString(), name: "EXTERNALWALLET");
    paymentFaildDialogBox(context,
        h: MediaQuery.of(context).size.height,
        w: MediaQuery.of(context).size.width,
        barrierDismissible: true,
        description: response.walletName);
  }
}
