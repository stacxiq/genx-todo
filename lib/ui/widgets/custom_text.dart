import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/theme_controller.dart';

///This custom text is used to unify the text style of the app
class CustomText extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool iprefText;
  final FontWeight fontWeight;

  const CustomText({
    @required this.text,
    this.padding,
    this.textColor,
    this.fontSize,
    this.textAlign,
    this.textDirection,
    this.fontWeight,
    this.iprefText = false, //if the text should use the prefrences color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: GetX<SettingsController>(
        builder: (s) {
          final prefColor = Color(int.parse(s.prefColor.value));
          return Text(
            text.tr,
            style: TextStyle(
              color: iprefText ? prefColor : textColor,
              fontSize: fontSize,
              fontFamily: s.locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
              fontWeight: fontWeight,
            ),
            textAlign: textAlign,
            textDirection: textDirection,
          );
        },
      ),
    );
  }
}
