import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './Tasks.dart';
import './calendar.dart';
import './settings.dart';
import '../widgets/custom_text.dart';
import '../../controllers/theme_controller.dart';

class GenxTodo extends StatefulWidget {
  GenxTodo({Key key}) : super(key: key);

  @override
  _GenxTodoState createState() => _GenxTodoState();
}

class _GenxTodoState extends State<GenxTodo> {
  int _currentIndex = 0;
  List<Widget> taps = [
    TasksTap(),
    CalendartTap(),
    SettingsTap(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
        init: SettingsController(),
        builder: (s) {
          Color selectedColor = Color(int.parse(s.prefColor.value));
          return Scaffold(
            body: taps[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: selectedColor,
              iconSize: 35,
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/settings_icon.png',
                    color: _currentIndex == 0
                        ? selectedColor
                        : const Color(0xffC5C3E3),
                  ),
                  title: CustomText(text: 'Tasks'),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/calendar_icon.png',
                    color: _currentIndex == 1
                        ? selectedColor
                        : const Color(0xffC5C3E3),
                  ),
                  title: CustomText(text: 'Calendar'),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/task_icon.png',
                    color: _currentIndex == 2
                        ? selectedColor
                        : const Color(0xffC5C3E3),
                  ),
                  title: CustomText(text: 'Settings'),
                ),
              ],
            ),
          );
        });
  }
}
