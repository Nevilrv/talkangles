import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppAssets {
  static const imagePath = "assets/images/";

  static const appLogo = "${imagePath}img_app_logo.svg";
  static const whatsAppLogo = "${imagePath}whatsapp_logo.svg";
  // static const menuBar = "${imagePath}menubar.svg";
  static const myProfileIcon = "${imagePath}my_profile_icon.svg";
  static const myWalletIcon = "${imagePath}my_wallet_icon.svg";
  static const referEarnIcon = "${imagePath}refer_earn_icon.svg";
  static const reportProblemIcon = "${imagePath}report_problem_icon.svg";
  static const deleteAccountIcon = "${imagePath}delete_account_icon.svg";
  static const logOutIcon = "${imagePath}log_out_icon.svg";
  static const percentage = "${imagePath}persentage.svg";
  static const emoji = "${imagePath}emoji.svg";
  static const girl = "${imagePath}girl.png";
  static const muteIcon = "${imagePath}mute_icon.svg";
  static const bluetoothIcon = "${imagePath}bluetooth_icon.svg";
  static const holdIcon = "${imagePath}hold_icon.svg";
  static const volumeIcon = "${imagePath}volume_icon.svg";
  static const gridIcon = "${imagePath}grid_icon.svg";
  static const moneyBagIcon = "${imagePath}money_bag.png";
  static const blankProfile = "${imagePath}blank_image.jpg";

  /// Sounds
  static const soundPath = "assets/audios/";

  static const notificationSound = "${soundPath}audio_dummy.wav";

  /// ANIMATION
  static const animationPath = "assets/lottie/";
  static const animationIncomingCall = "${animationPath}Animation.json";
  static const animationLoading = "${animationPath}Animation_loading.json";
  static const referralCodeAnimationAssets = "${animationPath}Referral_Code_animation.gif";
  static const successAnimationAssets = "${animationPath}Success_animation.gif";
  static const walletAnimationAssets = "${animationPath}Wallet_animation.gif";
  static const referEarnAnimationAssets = "${animationPath}Refer_Earn_animation.gif";
  static const exitAnimationAssets = "${animationPath}Exit_animation.gif";
  static const sureAnimationAssets = "${animationPath}Sure_animation.gif";

  static const somethingWentWrongAnimationAssets = "${animationPath}SomethingWentWrong_animation.gif";
}

Widget svgAssetImage(String image, {double? height, double? width, Color? color}) {
  return SvgPicture.asset(
    image,
    height: height,
    width: width,
    color: color,
    allowDrawingOutsideViewBox: false,
  );
}

Widget assetImage(String image, {double? height, double? width, Color? color, BoxFit? fit}) {
  return Image.asset(
    image,
    height: height,
    width: width,
    color: color,
    fit: fit,
  );
}

AssetImage assetsImage2(String image, {double? height, double? width, Color? color}) {
  return AssetImage(image);
}
