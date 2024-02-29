import 'package:get/get.dart';
import 'package:talkangels/ui/staff/main/call_history_pages/call_history_screen.dart';
import 'package:talkangels/ui/staff/main/my_profile_pages/profile_details_screen.dart';
import 'package:talkangels/ui/staff/main/home_pages/home_screen.dart';
import 'package:talkangels/ui/staff/main/setting_pages/setting_screen.dart';

class BottomBarController extends GetxController {
  int selectedPage = 0;

  setSelectedPage(int value) {
    selectedPage = value;
    update();
  }

  List screens = [
    const HomeScreen(),
    const CallHistoryScreen(),
    const ProfileDetailsScreen(),
    const SettingScreen(),
  ];
}
