import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonSnackBarWidget {
  static Future<bool?> commonSnackBar(
      {required String msg, ToastGravity? toastGravity, int? time}) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastGravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: time ?? 1,
        textColor: Colors.white,
        fontSize: 12.0);
  }
}
