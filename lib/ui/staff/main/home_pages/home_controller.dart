import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talkangels/api/repo/auth_repo.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/models/reject_call_res_model.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/ui/staff/models/active_status_res_model.dart';
import 'package:talkangels/ui/staff/models/add_call_history_res_model.dart';
import 'package:talkangels/ui/staff/models/call_status_update_res_model.dart';
import 'package:talkangels/ui/staff/models/get_staff_detail_res_model.dart';
import 'package:talkangels/controller/log_out_res_model.dart';
import 'package:talkangels/ui/staff/models/send_withdraw_req_res_model.dart';
import 'package:talkangels/ui/staff/models/update_staff_details_res_model.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  GetStaffDetailResModel getStaffDetailResModel = GetStaffDetailResModel();

  bool isRequestLoading = false;
  SendWithdrawReqResModel sendWithdrawReqResModel = SendWithdrawReqResModel();
  TextEditingController withdrawController = TextEditingController();
  List<dynamic> reviewList = [];

  bool isStatusLoading = false;
  ActiveStatusResModel activeStatusResModel = ActiveStatusResModel();

  bool isAddHistoryLoading = false;
  AddCallHistoryResModel addCallHistoryResModel = AddCallHistoryResModel();

  RejectCallResModel rejectCallResModel = RejectCallResModel();

  bool isUpdateCallStatusLoading = false;
  CallStatusUpdateResModel callStatusUpdateResModel = CallStatusUpdateResModel();

  bool logOutLoading = false;
  LogOutResModel logOutResModel = LogOutResModel();

  bool updateStaffDetailsLoading = false;
  UpdateStaffDetailResModel updateStaffDetailResModel = UpdateStaffDetailResModel();
  TextEditingController bioController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  /// Get Staff Details
  getStaffDetailApi() async {
    isLoading = true;
    update();
    ResponseItem result = await HomeRepoStaff.getStaffDetail();
    // log("result---1-------> ${result.data}");
    reviewList = [];
    if (result.status) {
      try {
        getStaffDetailResModel = GetStaffDetailResModel.fromJson(result.data);

        getStaffDetailResModel.data?.reviews?.forEach((element) {
          element.userReviews?.forEach((element1) {
            reviewList.add(element1);
          });
        });

        reviewList.sort((a, b) => b.date!.compareTo(a.date!));

        isLoading = false;
        update();
      } catch (e) {
        isLoading = false;
        update();
        log("-E----getStaffDetailApi----  $e");
      }
    } else {
      isLoading = false;
      update();
    }
    return getStaffDetailResModel;
  }

  /// Post WithDraw Request

  sendWithdrawRequest(String amount) async {
    isRequestLoading = true;
    update();

    ResponseItem result = await HomeRepoStaff.sendWithdrawRequest(amount);
    // log("result---2-------> ${result.data}");

    if (result.status) {
      try {
        sendWithdrawReqResModel = SendWithdrawReqResModel.fromJson(result.data);

        isRequestLoading = false;
        update();
      } catch (e) {
        isRequestLoading = false;
        update();
        log("-E----sendWithdrawRequest----  $e");
      }
    } else {
      isRequestLoading = false;
      update();
    }
  }

  /// Active status Api
  activeStatusApi(String status) async {
    isStatusLoading = true;
    update();

    ResponseItem item = await HomeRepoStaff.activeStatusUpdate(status);
    print("item---3------->${item.data}");
    if (item.status == true) {
      try {
        activeStatusResModel = ActiveStatusResModel.fromJson(item.data);

        isStatusLoading = false;
        update();
      } catch (e) {
        print("e=====activeStatusApi==========>$e");
        isStatusLoading = false;
        update();
      }
    } else {
      isStatusLoading = false;
      update();
    }
    return activeStatusResModel;
  }

  /// Add Call History Api
  addCallHistory(String angelId, String staffId, String callType, String minutes) async {
    isAddHistoryLoading = true;
    update();

    ResponseItem item = await HomeRepoStaff.addCallHistory(angelId, staffId, callType, minutes);
    log("item---4------->${item.data}");
    if (item.status == true) {
      try {
        addCallHistoryResModel = AddCallHistoryResModel.fromJson(item.data);

        isAddHistoryLoading = false;
        update();
      } catch (e) {
        log("e=======addCallHistory=======>$e");
        isAddHistoryLoading = false;
        update();
      }
    } else {
      isAddHistoryLoading = false;
      update();
    }
    return addCallHistoryResModel;
  }

  ///rejectCall
  rejectCall(String angelId, String userId, String type) async {
    update();
    ResponseItem item = await HomeRepoStaff.callReject(angelId, userId, type);
    log("item---5------->${item.data}");
    if (item.status == true) {
      try {
        rejectCallResModel = RejectCallResModel.fromJson(item.data);

        update();
      } catch (e) {
        log("e=======reject=======>$e");

        update();
      }
    } else {
      update();
    }
    return rejectCallResModel;
  }

  ///call Status Update
  updateCallStatus(String callStatus) async {
    isUpdateCallStatusLoading = true;
    update();

    ResponseItem item = await HomeRepoStaff.updateCallStatus(callStatus);
    log("item---6------->${item.data}");
    print("item---6------->${item.data}");
    if (item.status == true) {
      try {
        callStatusUpdateResModel = CallStatusUpdateResModel.fromJson(item.data);
        isUpdateCallStatusLoading = false;
        update();
      } catch (e) {
        log("e=======ERRORS=======>$e");
        isUpdateCallStatusLoading = false;
        update();
      }
    } else {
      isUpdateCallStatusLoading = false;
      update();
    }
    return callStatusUpdateResModel;
  }

  /// Post Update Staff Details

  updateStaffDetails(
      {String? userName,
      String? name,
      String? gender,
      String? bio,
      String? language,
      String? age,
      String? image,
      String? fileType}) async {
    updateStaffDetailsLoading = true;
    update();

    log("image______________${image}");
    UpdateStaffDetailResModel? result = await HomeRepoStaff.updateStaffDetails(
      age: age,
      language: language,
      bio: bio,
      name: name,
      userName: userName,
      image: image,
      gender: gender,
      fileType: fileType,
    );
    log("result---updateStaffDetails-------> ${result!.data}");

    if (result.success == true) {
      try {
        // updateStaffDetailResModel = UpdateStaffDetailResModel.fromJson(result.data);
        // log("RESULT>DATA---------${result.data}");

        updateStaffDetailsLoading = false;
        update();
      } catch (e) {
        updateStaffDetailsLoading = false;
        update();
        log("-E----sendWithdrawRequest----  $e");
      }
    } else {
      // log("message!!!!!!!!!!!  ${result.statusCode}");
      updateStaffDetailsLoading = false;
      update();
    }
    return UpdateStaffDetailResModel;
  }

  /// LOG-OUT API
  logOut(String mobileNumber) async {
    logOutLoading = true;
    update();

    ResponseItem item = await AuthRepo.logOut(mobileNumber);
    log("item---4------->${item.data}");
    if (item.status == true) {
      try {
        logOutResModel = LogOutResModel.fromJson(item.data);
        logOutLoading = false;
        Get.offAllNamed(Routes.loginScreen);
        update();
      } catch (e) {
        log("e=======logOut=======>$e");
        logOutLoading = false;
        update();
      }
    } else {
      logOutLoading = false;
      update();
    }
    return logOutResModel;
  }
}
