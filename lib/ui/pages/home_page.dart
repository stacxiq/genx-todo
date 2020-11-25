import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import './calendar.dart';
import './settings.dart';
import './Pomodoro.dart';
import './my_lists_tab.dart';
import '../../controllers/theme_controller.dart';

class GenxTodo extends StatefulWidget {
  GenxTodo({Key key}) : super(key: key);

  @override
  _GenxTodoState createState() => _GenxTodoState();
}

class _GenxTodoState extends State<GenxTodo> {
  int _currentIndex = 0;
  List<Widget> taps = [
    const MyListsTab(),
    const CalendartTap(),
    const Pomodoro(),
    const SettingsTap(),
  ];

  List<BottomNav> _items = [
    const BottomNav('Tasks', LineAwesomeIcons.check_square),
    const BottomNav('Calendar', LineAwesomeIcons.calendar_check),
    const BottomNav('Pomodoro', LineAwesomeIcons.stopwatch),
    const BottomNav('Settings', LineAwesomeIcons.horizontal_sliders),
  ];

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
        // init: SettingsController(),
        builder: (s) {
      Color selectedColor = Color(int.parse(s.prefColor.value));
      return Scaffold(
        body: taps[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            elevation: 2,
            selectedItemColor: selectedColor,
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle: TextStyle(
              fontSize: 13,
              fontFamily: s.locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
            ),
            selectedLabelStyle: TextStyle(
              fontSize: 15,
              fontFamily: s.locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
            ),
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            items: _items
                .map((item) => BottomNavigationBarItem(
                      icon: Icon(item.icon, size: 30),
                      label: item.name.tr,
                    ))
                .toList()),
      );
    });
  }
}

class BottomNav {
  final String name;
  final IconData icon;

  const BottomNav(this.name, this.icon);
}
