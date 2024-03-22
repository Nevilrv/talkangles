import 'package:flutter/material.dart';
import 'package:talkangels/const/app_color.dart';

extension SizedExtension on double {
  addHSpace() {
    return SizedBox(height: this);
  }

  addWSpace() {
    return SizedBox(width: this);
  }
}

hideKeyBoard(BuildContext context) {
  return FocusScope.of(context).unfocus();
}

extension AppDivider on double {
  Widget appDivider({Color? color}) {
    return Divider(
      thickness: this,
      height: 0,
      color: color ?? whiteColor.withOpacity(0.15),
    );
  }
}

extension AllertaStencil on String {
  Widget regularAllertaStencil({
    Color? fontColor,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? whiteColor,
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w400,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'Allerta Stencil'),
      textAlign: textAlign,
    );
  }
}

extension LeagueSpartan on String {
  Widget regularLeagueSpartan({
    Color? fontColor,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    Color? decorationColor,
    double? height,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? whiteColor,
          fontSize: fontSize ?? 16,
          height: height ?? 1.2,
          fontWeight: fontWeight ?? FontWeight.w400,
          decorationColor: decorationColor ?? appColorGreen,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'League Spartan'),
      textAlign: textAlign,
    );
  }

  Widget leagueSpartanfs20w600({
    Color? fontColor,
    double? fontSize,
    FontWeight? fontWeight,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    Color? decorationColor,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? whiteColor,
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w600,
          decorationColor: decorationColor ?? appColorGreen,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'League Spartan'),
      textAlign: textAlign,
    );
  }
}
