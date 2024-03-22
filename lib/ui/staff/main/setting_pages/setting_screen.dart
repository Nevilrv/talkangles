import 'package:flutter/material.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/app_color.dart';
import 'package:talkangels/ui/staff/constant/app_string.dart';
import 'package:talkangels/common/app_app_bar.dart';
import 'package:talkangels/ui/staff/utils/notification_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        NotificationService.getInitialMsg();

        print('call screen--erdrfefe4rf-');
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.hidden:
        print('appLifeCycleState suspending');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        backGroundColor: appBarColor,
        titleText: AppString.setting,
        titleFontWeight: FontWeight.w900,
        titleSpacing: w * 0.06,
        fontSize: 20,
        bottom: PreferredSize(preferredSize: const Size(300, 50), child: 1.0.appDivider()),
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: appGradient),
        child: SafeArea(
          child: Center(
            child: InkWell(
              onTap: () {},
              child: const Text(
                "Coming soon!",
                style: TextStyle(color: whiteColor, fontSize: 25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
