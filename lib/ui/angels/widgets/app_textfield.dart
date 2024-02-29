import 'package:flutter/material.dart';
import 'package:talkangels/ui/angels/constant/app_color.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AppTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: textFieldColor),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        style:
            const TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'League Spartan'),
        decoration: InputDecoration(
          hintText: labelText ?? "",
          hintStyle: TextStyle(
              color: whiteColor.withOpacity(0.20),
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'League Spartan'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          constraints: const BoxConstraints(
            maxHeight: 50,
          ),
        ),
      ),
    );
  }
}

class SearchTextFormField extends StatelessWidget {
  TextEditingController? controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  Widget? prefixIcon;
  double? fontSize;
  Color? fillColor;
  Color? color;
  BorderRadiusGeometry? borderRadius;
  bool? enabled;
  Color? hintColor;
  FontWeight? hintFontWeight;
  bool? readOnly;

  SearchTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.fontSize,
    this.fillColor,
    this.color,
    this.borderRadius,
    this.enabled,
    this.hintColor,
    this.hintFontWeight,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: borderRadius ?? BorderRadius.circular(5)),
      child: TextFormField(
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        enabled: enabled,
        controller: controller,
        validator: validator,
        textAlign: TextAlign.start,
        style:
            const TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'League Spartan'),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: labelText ?? "",
          fillColor: fillColor,
          hintStyle: TextStyle(
              color: hintColor ?? whiteColor.withOpacity(0.20),
              fontSize: fontSize ?? 14,
              fontWeight: hintFontWeight ?? FontWeight.w300,
              fontFamily: 'League Spartan'),
          constraints: const BoxConstraints(maxHeight: 45),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: textFieldBorderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: textFieldBorderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(color: textFieldBorderColor, width: 1),
          ),
        ),
      ),
    );
  }
}

class UnderLineTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final double? width;
  final double? height;
  final bool? readOnly;
  final TextInputType? keyboardType;

  const UnderLineTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.width,
    this.height,
    this.readOnly,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width ?? w,
      child: TextFormField(
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType ?? TextInputType.text,
        style:
            const TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'League Spartan'),
        decoration: InputDecoration(
          hintText: hintText ?? "",
          hintStyle: TextStyle(
              color: whiteColor.withOpacity(0.20),
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: 'League Spartan'),
          labelText: labelText ?? "",
          labelStyle: TextStyle(
              color: whiteColor.withOpacity(0.40),
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: 'League Spartan'),
          // constraints: BoxConstraints(maxHeight: height ?? 45),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor, width: 1),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor, width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor, width: 1),
          ),
        ),
      ),
    );
  }
}
