import 'package:flutter/material.dart';
import 'package:todolist/ui/widgets/custom_text.dart';

class TasksTap extends StatefulWidget {
  TasksTap({Key key}) : super(key: key);

  @override
  _TasksTapState createState() => _TasksTapState();
}

class _TasksTapState extends State<TasksTap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: CustomText(text: 'All Tasks'),
      ),
    );
  }
}
