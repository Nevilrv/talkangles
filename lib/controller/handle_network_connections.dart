import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HandleNetworkConnection extends GetxController {
  bool isResult = false;
  late ConnectivityResult result;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  void changeBool(bool value) {
    isResult = value;
    update();
  }

  void changeResult(var value) {
    result = value;
    update();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    changeResult(result);

    if (result == ConnectivityResult.none || result == ConnectivityResult.bluetooth) {
      // log("RESULT----$result");
      changeBool(true);
      // log("ISRESULT----$isResult");
    } else {
      changeBool(false);
    }
  }

  Future<void> checkConnectivity() async {
    await initConnectivity().then((value) async {
      connectivitySubscription = connectivity.onConnectivityChanged.listen(updateConnectionStatus);
      log("NETWORK_CONNECTION---$isResult");
    });
  }
}
