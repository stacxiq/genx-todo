import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './creat_task.dart';
import './custom_text.dart';
import '../../models/task.dart';
import '../../models/date_formatter.dart';
import '../../controllers/task_controller.dart';

class TaskBlock extends StatefulWidget {
  final Task taskData;

  const TaskBlock({
    Key key,
    this.taskData,
  }) : super(key: key);

  @override
  _TaskBlockState createState() => _TaskBlockState();
}

class _TaskBlockState extends State<TaskBlock>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      key: widget.key,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: ListTile(
          onTap: () => updateTaskModalBottomSheet(
              context: context, oldTask: widget.taskData),
          leading: CircleCheckbox(
            value: widget.taskData.isFinished,
            onChanged: (value) async {
              await _controller.forward();
              TaskController.to
                  .updateTask(widget.taskData.copyWith(isFinished: value));
            },
          ),
          title: CustomText(text: widget.taskData.title, fontSize: 20),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: widget.taskData.body.isEmpty
                      ? 'No description'
                      : widget.taskData.body.length > 20
                          ? widget.taskData.body.substring(0, 20)
                          : widget.taskData.body,
                  fontSize: 15),
              CustomText(
                  text: CustomDateFormatter.format(widget.taskData.dueDate),
                  iprefText: true),
            ],
          ),
          trailing: Container(
            height: 30,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: widget.taskData.priority == TaskPriority.high
                    ? Colors.red
                    : widget.taskData.priority == TaskPriority.medium
                        ? Colors.amber
                        : Colors.green),
            child: Center(
              child: CustomText(
                text: describeEnum(widget.taskData.priority),
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
          borderRadius: const BorderRadius.all(Radius.circular(20))),
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
