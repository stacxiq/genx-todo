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
  const CalendartTap({Key key}) : super(key: key);

  @override
  _CalendartTapState createState() => _CalendartTapState();
}

class _CalendartTapState extends State<CalendartTap> {
  CalendarController _calendarController;
  Map<DateTime, List<Task>> _events;
  List<Task> _selectedEvents;
  Locale _locale;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _locale = SettingsController.to.locale;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
        id: 'calendar',
        builder: (tc) {
          //I'm re-initializing _selectedEvents and _events every time the state changes
          //because when the the user opens the tab for the first time the tasks in
          //that day desn't appear for whatever reason and also the same thing happens
          //when the user add a new task frm this tab and when the user tab on the same day muliple times
          //the value of the task in that day get dublicated so I have to do that
          //If you have a solu pls go ahead 😚💓
          _selectedEvents = [];
          _events = {};
          tc.tasks.forEach((t) {
            if (t.dueDate != null) {
              if (selectedDate.day == t.dueDate.day &&
                  selectedDate.month == t.dueDate.month &&
                  selectedDate.year == t.dueDate.year &&
                  !t.isFinished) {
                _selectedEvents.add(t);
              }
              if (!t.isFinished)
                _events.update(t.dueDate, (value) {
                  return value..add(t);
                }, ifAbsent: () => [t]);
            }
          });

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const CustomText(text: 'Calendar'),
            ),
            body: SingleChildScrollView(
              physics:
                  BouncingScrollPhysics(), //I don't know what this is. Ask fahad
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  calendar(),
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
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        });
  }

  TableCalendar calendar() {
    final selectedColor = Theme.of(context).accentColor;
    return TableCalendar(
      daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(
            color: Theme.of(context).accentColor,
            fontFamily: _locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
          ),
          weekdayStyle: TextStyle(
            color: Colors.black87.withOpacity(.5),
            fontFamily: _locale.languageCode == 'ar' ? 'Cairo' : 'OpenSans',
          )),
      calendarStyle: CalendarStyle(
        canEventMarkersOverflow: true,
        highlightToday: true,
        markersColor: selectedColor,
        todayColor: selectedColor.withOpacity(0.3),
        weekendStyle: TextStyle(color: selectedColor),
        outsideWeekendStyle: TextStyle(color: selectedColor.withOpacity(.5)),
      ),
      headerStyle: const HeaderStyle(centerHeaderTitle: true),
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(Positioned(
              bottom: 8,
              child: _buildEventsMarkerDot(),
            ));
          }
          return children;
        },
      ),
      events: _events,
      onDaySelected: (date, events, holidays) {
        selectedDate = date;
        setState(() {}); //don't delete this bcz it's nesseary
      },
      calendarController: _calendarController,
    );
  }

  ///To indicate that there is some events on that day
  Widget _buildEventsMarkerDot() {
    return Center(
      child: const Text(
        '.',
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }
}
