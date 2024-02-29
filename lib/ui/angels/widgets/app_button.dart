import 'package:flutter/material.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textColor;
  final double? fontSize;
  final Widget? child;
  EdgeInsetsGeometry? padding;
  BoxBorder? border;

  AppButton({
    super.key,
    required this.onTap,
    this.color,
    this.width,
    this.textColor,
    this.height,
    this.fontSize,
    this.padding,
    this.child,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        height: height ?? 55,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            color: color ?? appColorGreen,
            border: border,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
