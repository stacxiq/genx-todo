import 'package:flutter/material.dart';

import './creat_task.dart';
import './custom_text.dart';
import '../../models/task.dart';
import '../../models/date_formatter.dart';
import '../../controllers/task_controller.dart';

class TaskBlock extends StatelessWidget {
  final Task taskData;

  const TaskBlock({this.taskData});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ListTile(
          onTap: () =>
              updateTaskModalBottomSheet(context: context, oldTask: taskData),
          leading: CircleCheckbox(
            value: taskData.isFinished,
            onChanged: (value) {
              TaskController.to
                  .updateTask(taskData.copyWith(isFinished: value));
            },
          ),
          title: CustomText(text: taskData.title, fontSize: 20),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: taskData.body.isEmpty
                      ? 'No description'
                      : taskData.body.length > 20
                          ? taskData.body.substring(0, 20)
                          : taskData.body,
                  fontSize: 15),
              CustomText(
                  text: CustomDateFormatter.format(taskData.dueDate),
                  iprefText: true),
            ],
          ),
          trailing: Container(
            height: 30,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: taskData.priority == TaskPriority.high
                    ? Colors.red
                    : taskData.priority == TaskPriority.medium
                        ? Colors.amber
                        : Colors.green),
            child: Center(
              child: CustomText(
                text: taskData.priority
                    .toString()
                    .replaceAll('TaskPriority.', ''),
                textColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;
  final bool tristate;
  final MaterialTapTargetSize materialTapTargetSize;

  CircleCheckbox({
    Key key,
    @required this.value,
    this.tristate = false,
    @required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).accentColor,
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          )),
      width: 24,
      height: 24,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.transparent,
        ),
        child: Checkbox(
          activeColor: Colors.transparent,
          checkColor: Theme.of(context).accentColor,
          value: value,
          tristate: tristate,
          onChanged: onChanged,
          materialTapTargetSize: materialTapTargetSize,
        ),
      ),
    );
  }
}
