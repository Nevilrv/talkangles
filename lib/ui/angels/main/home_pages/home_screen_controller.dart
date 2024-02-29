import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talkangels/api/repo/auth_repo.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/controller/handle_network_connections.dart';
import 'package:talkangels/models/angle_call_res_model.dart';
import 'package:talkangels/socket/socket_service.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/models/add_rating_res_model.dart';
import 'package:talkangels/ui/angels/models/add_wallet_ballence_res_model.dart';
import 'package:talkangels/ui/angels/models/angle_list_res_model.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/ui/angels/models/delete_user_res_model.dart';
import 'package:talkangels/ui/angels/models/user_details_res_model.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen_controller.dart';
import 'package:talkangels/const/app_routes.dart';
import 'package:talkangels/ui/angels/widgets/app_dialogbox.dart';
import 'package:talkangels/controller/log_out_res_model.dart';

class HomeScreenController extends GetxController {
  HandleNetworkConnection handleNetworkConnection = Get.put(HandleNetworkConnection());
  CallingScreenController callingScreenController = Get.put(CallingScreenController());

  GetAngleListResModel resModel = GetAngleListResModel();
  bool isLoading = false;

  UserDetailsResponseModel userDetailsResModel = UserDetailsResponseModel();
  bool isUserLoading = true;

  AngleCallResModel angleCallResModel = AngleCallResModel();
  bool isCallLoading = false;

  DeleteAngelsResModel deleteAngelsResModel = DeleteAngelsResModel();
  bool isDelete = false;

  AddRatingResModel addRatingResModel = AddRatingResModel();
  bool isRatingLoading = false;

  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  List searchAngelsList = [];

  AddWalletBallanceResponseModel addWalletBallanceResponseModel = AddWalletBallanceResponseModel();
  bool isAmountLoading = false;

  LogOutResModel logOutResModel = LogOutResModel();
  bool logOutLoading = false;

  AngleData? selectedAngle;
  setAngle(AngleData value) {
    selectedAngle = value;
    update();
  }

  search() {
    if (handleNetworkConnection.isResult == true) {
      searchController.clear();
      update();
    }
  }

  List<AngleData> angleAllData = [];
  homeAngleApi() async {
    isLoading = true;

    ResponseItem item = await HomeRepoAngels.getAngleAPi();
    if (item.status == true) {
      try {
        angleAllData.clear();
        update();
        resModel = GetAngleListResModel.fromJson(item.data);
        resModel.data!.forEach((element) {
          angleAllData.add(element);
        });

        isLoading = false;
        update();
      } catch (e) {
        log("e========error=======>$e");
        isLoading = false;
        update();
      }
    } else {
      isLoading = false;
      update();
    }
    return resModel;
  }

  Future<void> angleListeners() async {
    getSocketAllAngleOn();
  }

  Future<void> getSocketAllAngle() async {
    SocketConnection.socket!.emit(
      'getAllAngels',
      {},
    );
  }

  getSocketAllAngleOn() {
    SocketConnection.socket!.on("getAllAngels", (data) {
      log('updateAllAngels>>> ${data.runtimeType}');
      log('updateAllAngels>>> ${data}');
      angleAllData.clear();

      update();
      GetAngleListResModel resModel = GetAngleListResModel.fromJson(data);
      resModel.data!.forEach((element) {
        angleAllData.add(element);
      });
      update();
      log('GetAngleListResModel>>> ${resModel.data!.length}');
    });
  }

  searchData(String text) {
    searchAngelsList = [];
    if (text.isNotEmpty || text != "") {
      angleAllData.forEach((element) {
        if (element.name.toString().trim().toLowerCase().contains(text.toString().trim().toLowerCase())) {
          searchAngelsList.add(element);
          update();
        }
      });
    }
    log('==============SEARCH_ANGELS_LIST====>>>>>>>>${searchAngelsList}');
  }

  angleCallingApi(String angleId, String userId) async {
    isCallLoading = true;
    update();
    log("angleId---------->$angleId");
    ResponseItem item = await HomeRepoAngels.callApi(angleId, userId);
    // log("item---------->${item.data}");
    if (item.status == true) {
      try {
        angleCallResModel = AngleCallResModel.fromJson(item.data);
        log("angleCallResModel---->${angleCallResModel.data!.agoraInfo!.token}");
        log("angleCallResModel---->${selectedAngle!.id}");

        Get.toNamed(Routes.callingScreen, arguments: {
          "selectedAngle": selectedAngle,
          "angleCallResModel": angleCallResModel,
        });

        isCallLoading = false;
        update();
      } catch (e) {
        log("e----->$e");
        isCallLoading = false;
        update();
      }
    } else {
      if (item.statusCode == 404) {
        ///Angel is now busy. Please try again later
        ///

        if (item.message == "Insufficient balance. Please recharge your account.") {
          /// Add Wallet Amount DialogBox
          addWalletAmountDialogBox();
        } else {
          showAppSnackBar("${item.message}");
        }
        isCallLoading = false;
        update();
      }
      isCallLoading = false;
      update();
    }
    return angleCallResModel;
  }

  /// Get User Detail Api
  userDetailsApi() async {
    isUserLoading = true;

    ResponseItem item = await HomeRepoAngels.getUserDetailsAPi();
    if (item.status == true) {
      try {
        userDetailsResModel = UserDetailsResponseModel.fromJson(item.data);
        isUserLoading = false;
        update();
      } catch (e) {
        log("e===============>$e");
        isUserLoading = false;
        update();
      }
    } else {
      isUserLoading = false;
      update();
    }
    return userDetailsResModel;
  }

  /// Delete Account Api
  deleteAccountApi() async {
    isDelete = true;
    update();
    ResponseItem item = await HomeRepoAngels.deleteAngelApi();
    if (item.status == true) {
      try {
        deleteAngelsResModel = DeleteAngelsResModel.fromJson(item.data);
        isDelete = false;
        Get.offAllNamed(Routes.loginScreen);
        update();
      } catch (e) {
        log("e===============>$e");
        isDelete = false;
        update();
      }
    } else {
      isDelete = false;
      update();
    }
    return deleteAngelsResModel;
  }

  /// Add Rating Api
  addRatingApi(String angelId, String rating, String comment) async {
    isRatingLoading = true;
    update();

    ResponseItem result = await HomeRepoAngels.postRatingApi(angelId, rating, comment);
    if (result.status) {
      try {
        addRatingResModel = AddRatingResModel.fromJson(result.data);
        Get.back();
        isRatingLoading = false;
        update();
      } catch (e) {
        log("e----------   $e");
        isRatingLoading = false;
        update();
      }
    } else {
      isRatingLoading = false;
      update();
      showAppSnackBar("${result.message}");
    }
    return addRatingResModel;
  }

  /// Add Wallet Amount
  addMyWalletAmountApi(String amount, String paymentId) async {
    isAmountLoading = true;
    update();

    ResponseItem item = await HomeRepoAngels.walletApi(amount, paymentId);
    if (item.status == true) {
      try {
        addWalletBallanceResponseModel = AddWalletBallanceResponseModel.fromJson(item.data);
        isAmountLoading = false;
        update();
      } catch (e) {
        log("e----->$e");
        isAmountLoading = false;
        update();
      }
    } else {
      isAmountLoading = false;
      update();
    }
    return addWalletBallanceResponseModel;
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
