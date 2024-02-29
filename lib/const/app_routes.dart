import 'package:get/get.dart';
import 'package:talkangels/ui/angels/main/drawer_pages/my_wallet_pages/my_wallet_screen.dart';
import 'package:talkangels/ui/angels/main/drawer_pages/profile_pages/profile_screen.dart';
import 'package:talkangels/ui/angels/main/drawer_pages/refer_earn_pages/refer_earn_screen.dart';
import 'package:talkangels/ui/angels/main/drawer_pages/report_problem_pages/report_problem_screen.dart';
import 'package:talkangels/ui/angels/main/home_pages/calling_screen.dart';
import 'package:talkangels/ui/angels/main/home_pages/home_screen.dart';
import 'package:talkangels/ui/angels/main/home_pages/person_details_screen.dart';
import 'package:talkangels/ui/angels/main/home_pages/recharge_screen.dart';
import 'package:talkangels/ui/splash_screen.dart';
import 'package:talkangels/ui/staff/main/my_profile_pages/update_profile_screen.dart';

import 'package:talkangels/ui/startup/login_screen.dart';
import 'package:talkangels/ui/startup/referral_code_pages/referral_code_screen.dart';

import 'package:talkangels/ui/staff/main/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:talkangels/ui/staff/main/call_history_pages/call_history_screen.dart';
import 'package:talkangels/ui/staff/main/call_history_pages/more_call_info_screen.dart';
import 'package:talkangels/ui/staff/main/my_profile_pages/profile_details_screen.dart';
import 'package:talkangels/ui/staff/main/setting_pages/setting_screen.dart';
import 'package:talkangels/ui/staff/main/report_problem_pages/report_problem_screen.dart';
import 'package:talkangels/ui/staff/main/calling_pages/calling_screen.dart' as staff;
import 'package:talkangels/ui/staff/main/home_pages/home_screen.dart' as staff;

class Routes {
  static String splashScreen = "/";
  static String loginScreen = "/loginScreen";
  static String referralCodeScreen = "/referralCodeScreen";
  static String homeScreen = "/homeScreen";
  static String personDetailScreen = "/personDetailScreen";
  static String profileScreen = "/profileScreen";
  static String myWalletScreen = "/myWalletScreen";
  static String referEarnScreen = "/referEarnScreen";
  static String callingScreen = "/callingScreen";
  static String allChargesScreen = "/allChargesScreen";
  static String reportAProblemScreen = "/reportAProblemScreen";

  ///staff routes

  static String homeScreenStaff = "/homeScreen";
  static String profileDetailsScreen = "/profileDetailsScreen";
  static String callingScreenStaff = "/callingScreen1";
  static String callHistoryScreen = "/callHistoryScreen";
  static String moreCallInfoScreen = "/moreCallInfoScreen";
  static String bottomBarScreen = "/bottomBarScreen";
  static String settingScreen = "/settingScreen";
  static String reportProblemScreen = "/reportProblemScreen";
  static String editProfileScreen = "/editProfileScreen";

  ///
  ///
  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: referralCodeScreen, page: () => const ReferralCodeScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: personDetailScreen, page: () => const PersonDetailScreen()),
    GetPage(name: profileScreen, page: () => const ProfileScreen()),
    GetPage(name: myWalletScreen, page: () => const MyWalletScreen()),
    GetPage(name: referEarnScreen, page: () => const ReferEarnScreen()),
    GetPage(name: callingScreen, page: () => const CallingScreen()),
    GetPage(name: allChargesScreen, page: () => const AllChargesScreen()),
    GetPage(name: reportAProblemScreen, page: () => const ReportAProblemScreen()),

    ///staff

    GetPage(name: homeScreenStaff, page: () => const staff.HomeScreen()),
    GetPage(name: profileDetailsScreen, page: () => const ProfileDetailsScreen()),
    GetPage(name: callingScreenStaff, page: () => const staff.CallingScreen()),
    GetPage(name: callHistoryScreen, page: () => const CallHistoryScreen()),
    GetPage(name: moreCallInfoScreen, page: () => const MoreCallInfoScreen()),
    GetPage(name: bottomBarScreen, page: () => const BottomBarScreen()),
    GetPage(name: settingScreen, page: () => const SettingScreen()),
    GetPage(name: reportProblemScreen, page: () => const ReportProblemScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
  ];
}
