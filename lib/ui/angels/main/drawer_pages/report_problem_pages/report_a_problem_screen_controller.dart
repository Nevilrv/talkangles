import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/models/report_a_problem_res_model.dart';

class ReportAProblemScreenController extends GetxController {
  bool isLoading = false;
  ReportAProblemResModel reportAProblemResModel = ReportAProblemResModel();
  TextEditingController textFieldController = TextEditingController();

  sendReportAProblem(String comment) async {
    isLoading = true;
    update();
    ResponseItem result = await HomeRepoAngels.postReportAProblemApi(comment);

    if (result.status == true) {
      try {
        reportAProblemResModel = ReportAProblemResModel.fromJson(result.data);
        isLoading = false;
        Get.back();
        showAppSnackBar("${reportAProblemResModel.message}");
        update();
      } catch (e) {
        log("e----->$e");
        isLoading = false;
        update();
      }
    } else {
      showAppSnackBar("${reportAProblemResModel.message}");
      isLoading = false;
      update();
    }
    return reportAProblemResModel;
  }
}
