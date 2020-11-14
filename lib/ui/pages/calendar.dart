import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/controllers/theme_controller.dart';

import '../widgets/custom_text.dart';

class CalendartTap extends StatefulWidget {
  CalendartTap({Key key}) : super(key: key);

  @override
  _CalendartTapState createState() => _CalendartTapState();
}

class _CalendartTapState extends State<CalendartTap> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _textController;
  TextEditingController _desController;
  SharedPreferences prefs;
  TimeOfDay _selectedTime;
  String times = '';
  int priority = 1;
  Locale locale;
  Color selectedColor;
  String value;

  List<String> priorities = ["First", "Second", "Third", "Forth"];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _textController = TextEditingController();
    _desController = TextEditingController();
    _selectedEvents = [];
    _selectedTime = TimeOfDay.now();
    initPreferences();
  }

  initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  _selectDate() async {
    final TimeOfDay picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
        init: SettingsController(),
        builder: (s) {
          selectedColor = Color(int.parse(s.prefColor.value));
          locale = s.locale;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: CustomText(text: 'Calendar'),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  calendar(selectedColor),
                  ListView.builder(
                    itemCount: _selectedEvents.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return taskBlock(
                          title: _selectedEvents[index]["title"],
                          description: _selectedEvents[index]["description"],
                          time: _selectedEvents[index]["time"],
                          pri: _selectedEvents[index]["priority"]);
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _showAddDialog,
              backgroundColor: selectedColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        });
  }

  Card taskBlock({String title, String description, String time, int pri}) {
    Color color;
    switch (pri) {
      case 0:
        color = Color(0xFFC02F1D);
        break;
      case 1:
        color = Color(0xFFFF6D00);
        break;
      case 2:
        color = Color(0xFF76DC58);
        break;
      default:
        color = Color(0xFF76DC58);
        break;
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2000),
              border: Border.all(color: selectedColor)),
        ),
        title: CustomText(text: title.toString(), fontSize: 20),
        subtitle: CustomText(text: description, fontSize: 15),
        trailing: Container(
          height: 30,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color,
          ),
          child: Center(
            child: CustomText(text: time, textColor: Colors.white),
          ),
        ),
      ),
    );
  }

  TableCalendar calendar(Color selectedColor) {
    return TableCalendar(
      locale: locale.toString(),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(
            color: selectedColor,
            fontFamily: locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
          ),
          weekdayStyle: TextStyle().copyWith(
            color: Colors.black87.withOpacity(.5),
            fontFamily: locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
          )),
      calendarStyle: CalendarStyle(
        canEventMarkersOverflow: true,
        highlightToday: true,
        markersColor: selectedColor,
        todayColor: selectedColor,
        weekendStyle: TextStyle(color: selectedColor),
        outsideWeekendStyle: TextStyle(color: selectedColor.withOpacity(.5)),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
      ),
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(Positioned(
              bottom: 8,
              child: _buildEventsMarkerNum(date, events),
            ));
          }
          return children;
        },
      ),
      events: _events,
      onDaySelected: (date, events, holidays) {
        setState(() {
          _selectedEvents = events;
        });
      },
      calendarController: _calendarController,
    );
  }

  Widget _buildEventsMarkerNum(date, events) {
    return Center(
      child: Text(
        '${events.length}',
        style: TextStyle().copyWith(
          fontSize: 10.0,
        ),
      ),
    );
  }

  _showAddDialog() {
    showMaterialModalBottomSheet(
        context: context,
        expand: true,
        bounce: true,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  taskTextField(_textController, 1, "Title"),
                  SizedBox(height: 10),
                  taskTextField(_desController, 6, "Notes"),
                  dropDownField(),
                  actionButton('Choose date', _selectDate),
                  actionButton('Done', _saveDate),
                ],
              ),
            ),
          );
        });
  }

  FlatButton actionButton(text, function) =>
      FlatButton(onPressed: function, child: CustomText(text: text));

  void _saveDate() {
    setState(() {
      times = _selectedTime.format(context);
      if (_textController.text.isEmpty) return;
      if (_events[_calendarController.selectedDay] != null) {
        _events[_calendarController.selectedDay].add({
          "title": _textController.text,
          "description": _desController.text,
          "time": times,
          "priority": priority
        });
      } else {
        _events[_calendarController.selectedDay] = [
          {
            "title": _textController.text,
            "description": _desController.text,
            "time": times,
            "priority": priority
          }
        ];
      }
      prefs.setString("events", json.encode(encodeMap(_events)));
      _textController.clear();
      _desController.clear();
      times = '';
      Navigator.pop(context);
    });
  }

  Container taskTextField(
      TextEditingController controller, int maxLines, String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontSize: 18),
        autofocus: true,
        cursorColor: selectedColor,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: selectedColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: selectedColor),
            ),
            hintText: "${text.tr}"),
      ),
    );
  }

  Widget dropDownField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: CustomText(text: "Priority"),
          value: value,
          isExpanded: true,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
              priority = priorities.indexOf(newValue);
            });
          },
          items: priorities.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(text: value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
