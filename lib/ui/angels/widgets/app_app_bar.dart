import 'package:flutter/material.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  Widget? leadingIcon;
  double? leadingWidth;
  final List<Widget>? action;
  double? appBarHeight;
  Color? backGroundColor;
  ShapeBorder? shapeBorder;
  PreferredSizeWidget? bottom;
  double? toolBarHeight;
  FontWeight? titleFontWeight;
  double? titleSpacing;
  double? fontSize;
  Widget? flexibleSpace;

  AppAppBar({
    Key? key,
    this.titleText,
    this.action,
    this.leadingIcon,
    this.leadingWidth,
    this.appBarHeight,
    this.backGroundColor,
    this.shapeBorder,
    this.bottom,
    this.toolBarHeight,
    this.titleFontWeight,
    this.titleSpacing,
    this.fontSize,
    this.flexibleSpace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleText ?? "",
        style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 20,
            fontWeight: titleFontWeight ?? FontWeight.w600,
            fontFamily: 'League Spartan'),
      ),
      backgroundColor: backGroundColor ?? appBarColor,
      actions: action,
      shape: shapeBorder,
      toolbarHeight: toolBarHeight,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: leadingIcon,
      leadingWidth: leadingWidth ?? 56,
      titleSpacing: titleSpacing ?? -3,
      elevation: 0,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? 60);
}
