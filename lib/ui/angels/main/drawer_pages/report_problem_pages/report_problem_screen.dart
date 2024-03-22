import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/ui/angels/main/drawer_pages/report_problem_pages/report_a_problem_screen_controller.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/common/app_button.dart';

class ReportAProblemScreen extends StatefulWidget {
  const ReportAProblemScreen({Key? key}) : super(key: key);

  @override
  State<ReportAProblemScreen> createState() => _ReportAProblemScreenState();
}

class _ReportAProblemScreenState extends State<ReportAProblemScreen> {
  HandleNetworkConnection handleNetworkConnection = Get.find();
  ReportAProblemScreenController reportAProblemScreenController = Get.put(ReportAProblemScreenController());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    reportAProblemScreenController.textFieldController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        titleText: AppString.reportAProblem,
        bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
      ),
      body: GetBuilder<ReportAProblemScreenController>(
        builder: (controller) {
          return Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(gradient: appGradient),
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    (h * 0.05).addHSpace(),
                    TextFormField(
                      maxLines: 10,
                      minLines: 10,
                      onChanged: (value) {},
                      controller: controller.textFieldController,
                      style: const TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'League Spartan'),
                      decoration: InputDecoration(
                        hintText: AppString.enterYourProblem,
                        hintStyle: const TextStyle(
                            color: greyFontColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'League Spartan'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: appBarColor),
                        ),
                      ),
                      validator: (value) {
                        if (controller.textFieldController.text.isEmpty) {
                          return AppString.pleaseEnterYourProblem;
                        }
                        return null;
                      },
                    ),
                    (h * 0.1).addHSpace(),
                    AppButton(
                      color: appColorGreen,
                      onTap: () {
                        if (handleNetworkConnection.isResult == false) {
                          if (_formKey.currentState!.validate()) {
                            ///  Post Report A Problem Api
                            reportAProblemScreenController
                                .sendReportAProblem(controller.textFieldController.text.toString());
                          }
                        } else {
                          showAppSnackBar(AppString.noInternetConnection);
                        }
                      },
                      child: controller.isLoading == true
                          ? const Center(child: CircularProgressIndicator(color: whiteColor))
                          : AppString.submit.regularLeagueSpartan(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
