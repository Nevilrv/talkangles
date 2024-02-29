import 'dart:developer';

import 'package:get/get.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/ui/staff/models/get_call_history_res_model.dart';

class CallHistoryController extends GetxController {
  bool isLoading = true;
  List<CallHistory> formatCallList = [];
  List<CallHistory> formatCallListData = [];

  GetCallHistoryResModel getCallHistoryResModel = GetCallHistoryResModel();

  getCallHistoryApi() async {
    isLoading = true;
    update();

    ResponseItem result = await HomeRepoStaff.getCallHistory();
    // log("result---5------>${result.data}");

    formatCallList = [];
    if (result.status) {
      try {
        getCallHistoryResModel = GetCallHistoryResModel.fromJson(result.data);

        getCallHistoryResModel.data?.forEach((element) {
          formatCallList.add(element);
        });

        formatCallList.forEach((element) {
          element.history?.sort((a, b) {
            return a.date!.compareTo(b.date!);
          });
        });

        formatCallList.sort((a, b) {
          return b.history!.last.date!.compareTo(a.history!.last.date!);
        });

        isLoading = false;
        update();
      } catch (e) {
        isLoading = false;
        update();
        log("-E----getCallHistoryApi------   $e");
      }
    } else {
      isLoading = false;
      update();
    }
    return getCallHistoryResModel;
  }
}
