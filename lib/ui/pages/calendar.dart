import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/task.dart';
import '../widgets/custom_text.dart';
import '../../ui/widgets/task_block.dart';
import '../../ui/widgets/creat_task.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/theme_controller.dart';

class CalendartTap extends StatefulWidget {
  CalendartTap({Key key}) : super(key: key);

  @override
  _CalendartTapState createState() => _CalendartTapState();
}

class _CalendartTapState extends State<CalendartTap> {
  CalendarController _calendarController;
  Map<DateTime, List<Task>> _events;
  List<Task> _selectedEvents;
  Locale locale;
  Color selectedColor;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedColor = Color(int.parse(SettingsController.to.prefColor.value));
    locale = SettingsController.to.locale;
    return GetBuilder<TaskController>(
        id: 'calendar',
        builder: (tc) {
          _selectedEvents = [];
          _events = {};
          tc.tasks.forEach((t) {
            if (t.dueDate != null) {
              if (selectedDate.day == t.dueDate.day &&
                  selectedDate.month == t.dueDate.month &&
                  selectedDate.year == t.dueDate.year) {
                _selectedEvents.add(t);
              }
              _events.update(t.dueDate, (value) {
                return value..add(t);
              }, ifAbsent: () => [t]);
            }
          });

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
                      return TaskBlock(taskData: _selectedEvents[index]);
                    },
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => updateTaskModalBottomSheet(context: context),
              backgroundColor: selectedColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        });
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
        todayColor: selectedColor.withOpacity(0.3),
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
        selectedDate = date;
        setState(() {
          events.isNotEmpty
              ? _selectedEvents = events as List<Task>
              : _selectedEvents = [];
        });
      },
      calendarController: _calendarController,
    );
  }

  Widget _buildEventsMarkerNum(date, events) {
    return Center(
      child: Text(
        '.',
        style: TextStyle().copyWith(
          fontSize: 30.0,
        ),
      ),
    );
  }
}
