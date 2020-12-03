import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/task.dart';
import '../widgets/custom_text.dart';
import '../../models/date_formatter.dart';
import '../../ui/widgets/creat_task.dart';
import '../../ui/widgets/task_block.dart';
import '../../controllers/task_controller.dart';

class TasksListPage extends StatefulWidget {
  final String selectedList;

  const TasksListPage({@required this.selectedList});

  @override
  _TasksListPageState createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  double _width, _height;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return GetBuilder<TaskController>(
        id: 'tasks2',
        builder: (tc) {
          // ignore: omit_local_variable_types
          List<Task> today = [],
              tomorrow = [],
              later = [],
              noDate = [],
              //selectedTasks
              sTasks = tc.tasks.where((t) {
                if (widget.selectedList == "Finished") {
                  return t.isFinished;
                } else if (widget.selectedList == "All Tasks") {
                  return !t.isFinished;
                }

                return t.belongsTo == widget.selectedList && !t.isFinished;
              }).toList();

          if (sTasks.isNotEmpty) {
            sTasks.forEach((ti) {
              if (ti.dueDate == null) {
                noDate.add(ti);
              } else if (CustomDateFormatter.format(ti.dueDate)
                  .contains('Today')) {
                today.add(ti);
              } else if (CustomDateFormatter.format(ti.dueDate)
                  .contains('Tomorrow')) {
                tomorrow.add(ti);
              } else {
                later.add(ti);
              }
            });
          }

          Widget _checkIfEmpty({Widget child}) {
            return sTasks.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: _height * 0.4),
                    alignment: Alignment.center,
                    child: const CustomText(
                      text: 'There is no tasks here yet',
                      fontSize: 18,
                    ),
                  )
                : child;
          }

          Widget _body() {
            return Container(
              width: _width,
              child: SingleChildScrollView(
                child: _checkIfEmpty(
                  child: widget.selectedList == 'Finished'
                      ? todoList(sTasks, "")
                      : Column(
                          children: [
                            todoList(today, "Today"),
                            todoList(tomorrow, "Tomorrow"),
                            todoList(later, "Later"),
                            todoList(noDate, "No Date"),
                            //in order to be no task under floatingActionButton i added sizedbox
                            const SizedBox(height: 60),
                          ],
                        ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: CustomText(text: widget.selectedList),
            ),
            body: _body(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                updateTaskModalBottomSheet(context: context);
              },
              child: const Icon(Icons.add, color: Colors.white, size: 24),
              backgroundColor: Theme.of(context).accentColor,
            ),
          );
        });
  }

  Widget todoList(List<Task> tasks, String titleBlock) {
    return tasks.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleBlock.isEmpty
                  ? const SizedBox(height: 10)
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: CustomText(
                          text: titleBlock, iprefText: true, fontSize: 22)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskBlock(taskData: tasks[index], key: UniqueKey());
                },
              ),
            ],
          );
  }
}
