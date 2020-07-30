import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/theme_provider.dart';
import 'package:todolist/ui/pages/Tasks.dart';
import 'package:todolist/ui/pages/calendar.dart';
import 'package:todolist/ui/pages/settings.dart';
import 'package:todolist/ui/widgets/custom_text.dart';

class GenixTodo extends StatefulWidget {
  GenixTodo({Key key}) : super(key: key);

  @override
  _GenixTodoState createState() => _GenixTodoState();
}

class _GenixTodoState extends State<GenixTodo> {
  int _currentIndex = 0;
  List<Widget> taps = [
    TasksTap(),
    CalendartTap(),
    SettingsTap(),
  ];
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Color selectedColor = Color(int.parse(themeProvider.prefrencesColor));
    return Scaffold(
      body: taps[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: selectedColor,
        // unselectedItemColor: const Color(0xffC5C3E3),
        // iconSize: 35,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/settings_icon.png',
              color: _currentIndex == 0 ? selectedColor : null,
            ),
            title: CustomText(text: 'Tasks'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/calendar_icon.png',
              color: _currentIndex == 1 ? selectedColor : null,
            ),
            title: CustomText(text: 'Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/task_icon.png',
              color: _currentIndex == 2 ? selectedColor : null,
            ),
            title: CustomText(text: 'Settings'),
          ),
        ],
      ),
    );
  }
}
