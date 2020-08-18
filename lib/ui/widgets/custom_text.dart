import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

///This custom text is used to unify the text style of the app
class CustomText extends GetWidget<SettingsController> {
  final String text;
  final EdgeInsetsGeometry padding;
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool iprefText;

  CustomText({
    @required this.text,
    this.padding,
    this.textColor,
    this.fontSize,
    this.textAlign,
    this.textDirection,
    this.iprefText = false, //if the text should use the prefrences color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: GetX<SettingsController>(
        builder: (s) {
          String color = controller.prefColor.value;
          return Text(
            text.tr,
            style: TextStyle(
              color: iprefText ? Color(int.parse(color)) : textColor,
              fontSize: fontSize,
              fontFamily: s.locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
            ),
            textAlign: textAlign,
            textDirection: textDirection,
          );
        },
      ),
    );
  }
}
