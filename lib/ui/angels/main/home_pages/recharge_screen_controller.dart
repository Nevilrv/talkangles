import 'dart:developer';

import 'package:get/get.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/ui/angels/models/all_recharge_res_model.dart';
import 'package:talkangels/models/response_item.dart';

class RechargeScreenController extends GetxController {
  GetAllRechargeResModel getAllRechargeResModel = GetAllRechargeResModel();
  bool isLoading = false;
  getAllRecharge() async {
    isLoading = true;
    update();

    ResponseItem item = await HomeRepoAngels.getAllRechargesApi();
    if (item.status == true) {
      try {
        getAllRechargeResModel = GetAllRechargeResModel.fromJson(item.data);
        isLoading = false;
        update();
      } catch (e) {
        log("e----------   $e");
        isLoading = false;
        update();
      }
    } else {
      isLoading = false;
      update();
    }
    return getAllRechargeResModel;
  }
}
