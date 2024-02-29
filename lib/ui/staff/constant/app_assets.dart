import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  static const imagePath = "assets/images/";

  static const whatsAppLogo = "${imagePath}whatsapp_logo.svg";
  // static const menuBar = "${imagePath}menubar.svg";
  static const myProfileIcon = "${imagePath}my_profile_icon.svg";
  static const myWalletIcon = "${imagePath}my_wallet_icon.svg";
  static const reportProblemIcon = "${imagePath}report_problem_icon.svg";
  static const logOutIcon = "${imagePath}log_out_icon.svg";
  static const muteIcon = "${imagePath}mute_icon.svg";
  static const bluetoothIcon = "${imagePath}bluetooth_icon.svg";
  static const holdIcon = "${imagePath}hold_icon.svg";
  static const volumeIcon = "${imagePath}volume_icon.svg";
  static const gridIcon = "${imagePath}grid_icon.svg";
  static const blankProfile = "${imagePath}blank_image.jpg";

  /// ANIMATION
  static const animationPath = "assets/lottie/";

  static const splashScreenAnimationAssets =
      "${animationPath}SplashScreen_animation.gif";
  static const verificationSuccessfulAnimationAssets =
      "${animationPath}VerificationSuccessful_animation.gif";
  static const somethingWentWrongAnimationAssets =
      "${animationPath}SomethingWentWrong_animation.gif";
  static const sureAnimationAssets = "${animationPath}Sure_animation.gif";
  static const exitAnimationAssets = "${animationPath}Exit_animation.gif";
}

Widget svgAssetImage(String image,
    {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    image,
    height: height,
    width: width,
    color: color,
    allowDrawingOutsideViewBox: false,
  );
}

SvgPicture svgSAssetsImage2(String image,
    {double? height, double? width, Color? color}) {
  return SvgPicture.asset(image);
}

Widget assetImage(String image,
    {double? height, double? width, Color? color, BoxFit? fit}) {
  return Image.asset(
    image,
    height: height,
    width: width,
    color: color,
    fit: fit,
  );
}
