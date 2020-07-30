import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/localization/demo_localizations.dart';
import 'package:todolist/models/theme_provider.dart';

class CustomText extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry padding;
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool iprefText;

  const CustomText({
    Key key,
    @required this.text,
    this.padding,
    this.textColor,
    this.fontSize,
    this.textAlign,
    this.textDirection,
    this.iprefText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Text(
        DemoLocalizations.of(context).translate(text),
        style: TextStyle(
          color: iprefText
              ? Color(int.parse(themeProvider.prefrencesColor))
              : textColor,
          fontSize: fontSize,
        ),
        textAlign: textAlign,
        textDirection: textDirection,
      ),
    );
  }
}
