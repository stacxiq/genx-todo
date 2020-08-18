import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class CalendartTap extends StatefulWidget {
  CalendartTap({Key key}) : super(key: key);

  @override
  _CalendartTapState createState() => _CalendartTapState();
}

class _CalendartTapState extends State<CalendartTap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: CustomText(text: 'Date Time'),
      ),
    );
  }
}
