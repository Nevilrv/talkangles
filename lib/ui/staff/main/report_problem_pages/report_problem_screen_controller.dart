import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/staff/models/report_problem_res_model.dart';

class ReportProblemScreenController extends GetxController {
  bool isLoading = false;
  StaffReportProblemResModel staffReportProblemResModel = StaffReportProblemResModel();
  TextEditingController textFieldController = TextEditingController();

  sendReportAProblem(String comment) async {
    isLoading = true;
    ResponseItem result = await HomeRepoStaff.postReportAProblemStaffApi(comment);

    if (result.status == true) {
      try {
        staffReportProblemResModel = StaffReportProblemResModel.fromJson(result.data);
        isLoading = false;
        showAppSnackBar("${staffReportProblemResModel.message}");
        update();
      } catch (e) {
        log("e----->$e");
        isLoading = false;
        update();
      }
    } else {
      isLoading = false;
      update();
    }
    return staffReportProblemResModel;
  }
}
