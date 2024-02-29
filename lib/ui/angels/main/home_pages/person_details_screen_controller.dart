import 'dart:developer';

import 'package:get/get.dart';
import 'package:talkangels/api/repo/home_repo.dart';
import 'package:talkangels/models/response_item.dart';
import 'package:talkangels/theme/app_layout.dart';
import 'package:talkangels/ui/angels/models/single_angel_res_model.dart';

class PersonDetailsScreenController extends GetxController {
  bool isDetailsLoading = true;
  GetSingleAngelResModel getSingleAngelResModel = GetSingleAngelResModel();

  getSingleAngelData(String angelId) async {
    isDetailsLoading = true;
    ResponseItem result = await HomeRepoAngels.getSingleAngleAPi(angelId);

    if (result.status) {
      try {
        getSingleAngelResModel = GetSingleAngelResModel.fromJson(result.data);
        isDetailsLoading = false;
        update();
      } catch (e) {
        log("e----------   $e");
        isDetailsLoading = false;
        update();
      }
    } else {
      isDetailsLoading = false;
      update();
      showAppSnackBar("${result.message}");
    }
    return getSingleAngelResModel;
  }
}
