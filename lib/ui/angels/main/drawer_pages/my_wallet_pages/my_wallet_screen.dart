import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:talkangels/common/app_textfield.dart';

import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_assets.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen_controller.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_button.dart';

import '../../../../../common/app_dialogbox.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  HomeScreenController homeScreenController = Get.find();
  TextEditingController textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  @override
  void dispose() {
    razorpay.clear();
    textFieldController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        titleText: AppString.myWallet,
        action: [
          const Icon(Icons.help_outline),
          (w * 0.045).addWSpace(),
        ],
        bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
      ),
      body: GetBuilder<HandleNetworkConnection>(
        builder: (networkController) {
          return GetBuilder<HomeScreenController>(
            builder: (controller) {
              return Container(
                height: h,
                width: w,
                decoration: const BoxDecoration(gradient: appGradient),
                child: controller.isUserLoading == true
                    ? const Center(child: CircularProgressIndicator(color: whiteColor))
                    : SafeArea(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                            child: Column(
                              children: [
                                (h * 0.02).addHSpace(),
                                Container(
                                  width: w,
                                  decoration:
                                      BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: EdgeInsets.all(w * 0.04),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppString.exploreTheFeaturesOfTALKANGELWallet.regularLeagueSpartan(
                                            fontColor: yellowColor, fontWeight: FontWeight.w600, fontSize: 13),
                                        (h * 0.01).addHSpace(),
                                        Row(
                                          children: [
                                            SizedBox(
                                                height: w * 0.3,
                                                width: w * 0.3,
                                                child: assetImage(AppAssets.walletAnimationAssets, fit: BoxFit.cover)),
                                            (w * 0.04).addWSpace(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.verified, color: whiteColor, size: 18),
                                                    (w * 0.02).addWSpace(),
                                                    AppString.safetyOfPaymentTransfer.regularLeagueSpartan(fontSize: 12)
                                                  ],
                                                ),
                                                (h * 0.01).addHSpace(),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.verified, color: whiteColor, size: 18),
                                                    (w * 0.02).addWSpace(),
                                                    AppString.payInJustOneClick.regularLeagueSpartan(fontSize: 12)
                                                  ],
                                                ),
                                                (h * 0.01).addHSpace(),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.verified, color: whiteColor, size: 18),
                                                    (w * 0.02).addWSpace(),
                                                    AppString.payInJustOneClick.regularLeagueSpartan(fontSize: 12)
                                                  ],
                                                ),
                                                (h * 0.01).addHSpace(),
                                                AppButton(
                                                  height: 35,
                                                  width: 135,
                                                  onTap: () {},
                                                  color: redFontColor,
                                                  child: AppString.getStartedNow
                                                      .regularLeagueSpartan(fontSize: 11, fontWeight: FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                (h * 0.02).addHSpace(),
                                Container(
                                  width: w,
                                  decoration:
                                      BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                      padding: EdgeInsets.all(w * 0.04),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.account_balance_wallet_outlined,
                                              color: whiteColor, size: 20),
                                          (w * 0.02).addWSpace(),
                                          AppString.talkAngelWalletBallance
                                              .regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w700),
                                          const Spacer(),
                                          (controller.userDetailsResModel.data?.talkAngelWallet?.totalBallance
                                                      ?.toStringAsFixed(1) ??
                                                  '0')
                                              .regularLeagueSpartan(
                                                  fontSize: 16, fontWeight: FontWeight.w700, fontColor: appColorGreen),
                                        ],
                                      )),
                                ),
                                (h * 0.02).addHSpace(),
                                Container(
                                  width: w,
                                  decoration:
                                      BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: EdgeInsets.all(w * 0.04),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.add_card, color: whiteColor, size: 20),
                                              (w * 0.02).addWSpace(),
                                              AppString.addMoneyTo.regularLeagueSpartan(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              AppString.talkAngelWallet.regularLeagueSpartan(
                                                  fontSize: 14, fontWeight: FontWeight.w600, fontColor: appColorGreen),
                                            ],
                                          ),
                                          (h * 0.01).addHSpace(),
                                          UnderLineTextFormField(
                                            controller: textFieldController,
                                            labelText: AppString.enterAmount,
                                            height: 55,
                                            keyboardType: TextInputType.number,
                                            validator: (text) {
                                              const pattern = r'^[0-9]+$';
                                              final regex = RegExp(pattern);

                                              if (text == null || text.isEmpty) {
                                                return AppString.pleaseEnterAmount;
                                              } else if (!regex.hasMatch(text)) {
                                                return AppString.pleaseEnterValidNumbers;
                                              } else if (int.parse(text) <= 0) {
                                                return AppString.pleaseEnterValidAmount;
                                              }
                                              return null;
                                            },
                                          ),
                                          (h * 0.04).addHSpace(),
                                          AppButton(
                                            onTap: () {
                                              if (networkController.isResult == false) {
                                                if (_formKey.currentState!.validate()) {
                                                  /// Payment Method

                                                  try {
                                                    var options = {
                                                      'key': 'rzp_test_EM5urUrcGkdJvm',
                                                      'amount': 100 * double.parse(textFieldController.text),
                                                      'name': 'Acme Corp.',
                                                      'description': 'Fine T-Shirt',
                                                      'retry': {'enabled': true, 'max_count': 1},
                                                      'send_sms_hash': true,
                                                      'prefill': {
                                                        'contact': "+91 ${PreferenceManager().getNumber().toString()}",
                                                        'email': 'test@razorpay.com'
                                                      },
                                                      'external': {
                                                        'wallets': ['paytm']
                                                      }
                                                    };
                                                    razorpay.open(options);

                                                    log("SUCCESS======>>>>>");
                                                  } catch (e) {
                                                    log("ERROR==RAZORPAY   $e");
                                                  }
                                                }
                                              } else {
                                                showAppSnackBar(AppString.noInternetConnection);
                                              }
                                            },
                                            child: controller.isAmountLoading == true
                                                ? const Center(child: CircularProgressIndicator(color: whiteColor))
                                                : AppString.proceed
                                                    .regularLeagueSpartan(fontSize: 20, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                (h * 0.02).addHSpace(),
                              ],
                            ),
                          ),
                        ),
                      ),
              );
            },
          );
        },
      ),
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
    // setState(() {
    //   walletBallance = walletBallance + int.parse(textFieldController.text);
    // });

    ///API calling
    homeScreenController
        .addMyWalletAmountApi(textFieldController.text, response.paymentId.toString())
        .then((result) async {
      await homeScreenController.userDetailsApi();
    });

    log(response.data.toString(), name: "SUCCESS");

    paymentSuccessDialogBox(
      context,
      h: MediaQuery.of(context).size.height,
      w: MediaQuery.of(context).size.width,
      barrierDismissible: true,
    );
    setState(() {
      textFieldController.clear();
    });
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
