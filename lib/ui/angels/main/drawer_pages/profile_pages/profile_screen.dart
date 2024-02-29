import 'package:flutter/material.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';
import 'package:talkangels/ui/angels/constant/app_string.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/const/shared_prefs.dart';
import 'package:talkangels/ui/angels/widgets/app_app_bar.dart';
import 'package:talkangels/ui/angels/widgets/app_show_profile_pic.dart';
import 'package:talkangels/ui/angels/widgets/app_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController(text: "${PreferenceManager().getName() ?? ''}");
  TextEditingController userNameController = TextEditingController(text: "${PreferenceManager().getUserName() ?? ''}");
  TextEditingController phoneNumberController = TextEditingController(text: "${PreferenceManager().getNumber() ?? ''}");

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppAppBar(
        titleText: AppString.myProfile,
        bottom: PreferredSize(
          preferredSize: const Size(300, 50),
          child: 1.0.appDivider(),
        ),
      ),
      body: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(gradient: appGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Column(
                children: [
                  (h * 0.05).addHSpace(),
                  AppShowProfilePic(
                    image: '',
                    radius: w * 0.35,
                    onTap: () {},
                  ),
                  (h * 0.02).addHSpace(),
                  "${(PreferenceManager().getName() ?? '')}"
                      .regularLeagueSpartan(fontSize: 24, fontWeight: FontWeight.w500),
                  "+91 ${(PreferenceManager().getNumber() ?? '')}".regularLeagueSpartan(fontSize: 14),
                  (h * 0.02).addHSpace(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.025),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 20,
                          child: Icon(Icons.person),
                        ),
                        const Spacer(),
                        UnderLineTextFormField(
                          width: w * 0.7,
                          controller: nameController,
                          labelText: "User Name",
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 20,
                          child: Icon(Icons.perm_identity, size: 20),
                        ),
                        const Spacer(),
                        UnderLineTextFormField(
                          width: w * 0.7,
                          controller: userNameController,
                          labelText: "User Id",
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.025),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          backgroundColor: whiteColor,
                          radius: 20,
                          child: Icon(Icons.phone, size: 20),
                        ),
                        const Spacer(),
                        UnderLineTextFormField(
                          width: w * 0.7,
                          controller: phoneNumberController,
                          labelText: "Mobile Number",
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  (h * 0.1).addHSpace(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
