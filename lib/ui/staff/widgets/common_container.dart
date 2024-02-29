import 'package:flutter/material.dart';
import 'package:talkangels/const/extentions.dart';
import 'package:talkangels/ui/staff/constant/app_color.dart';

class CommonContainer extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final String bottomChild;
  final String title;
  final String subTitle;
  final IconData icon;

  const CommonContainer({
    super.key,
    this.color,
    this.width,
    this.height,
    required this.bottomChild,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: height ?? 50,
      width: width ?? 50,
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
      decoration: BoxDecoration(
          color: color ?? containerColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.regularLeagueSpartan(
                      fontSize: 12, fontColor: appColorBlue),
                  subTitle.regularLeagueSpartan(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ],
              ),
              const Spacer(),
              Container(
                height: h * 0.035,
                width: w * 0.07,
                decoration: BoxDecoration(
                  color: textFieldColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: whiteColor,
                  size: 17,
                ),
              ),
            ],
          ),
          const Spacer(),
          bottomChild.regularLeagueSpartan(
              fontColor: yellowColor,
              fontSize: 26,
              fontWeight: FontWeight.w600,
              textOverflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
