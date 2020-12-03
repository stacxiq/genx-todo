import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import './custom_text.dart';
import '../../models/task.dart';
import '../../controllers/task_controller.dart';

///This func. is used to create or update a task form the ui side
void updateTaskModalBottomSheet(
    {@required BuildContext context, Task oldTask}) {
  final _formKey = GlobalKey<FormState>();
  Task newTask;
  final tc = TaskController.to;

  if (oldTask != null) {
    newTask = oldTask;
  } else {
    newTask = Task(
      id: Uuid().v4(),
      title: '',
      body: '',
      priority: TaskPriority.low,
      dueDate: null,
      createdAt: DateTime.now(),
      belongsTo: 'Default',
      isFinished: false,
    );
  }

  Future _selectDate(StateSetter modalSetState) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: newTask.dueDate ?? DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      modalSetState(() {
        newTask = newTask.copyWith(dueDate: picked);
      });
    }
  }

  showMaterialModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF232B3E).withOpacity(0),
      builder: (bc) {
        final _height = MediaQuery.of(context).size.height;

        ///I used [StatefulBuilder]because in normal setstate
        ///the modal sheet doesn't update its state. So insted use [modalSetState((){})]
        return StatefulBuilder(builder: (context, modalSetState) {
          return Container(
            height: _height <= 750 ? _height * 0.88 : _height * 0.8,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Column(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFCFDADF),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: oldTask != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                                text: 'Task Details', fontSize: 25),
                            FlatButton(
                                child: const CustomText(text: 'Delete'),
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                onPressed: () async {
                                  await tc.deleteTask(newTask.id);
                                  Navigator.pop(context);
                                }),
                          ],
                        )
                      : const CustomText(text: "Creat New Task", fontSize: 25),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      BottomCard(
                        child: TextFormField(
                          initialValue: newTask.title,
                          autofocus: false,
                          onChanged: (value) =>
                              newTask = newTask.copyWith(title: value),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title'.tr;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Task name".tr,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      BottomCard(
                        child: TextFormField(
                          initialValue: newTask.body,
                          autofocus: false,
                          onChanged: (value) =>
                              newTask = newTask.copyWith(body: value),
                          maxLines: 3,
                          decoration: InputDecoration(
                              hintText: "Task note".tr,
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            //Modal sheet to select the priority
                            showModalBottomSheet(
                              context: context,
                              backgroundColor:
                                  const Color(0xFF232B3E).withOpacity(0),
                              builder: (context) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      )),
                                  height: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const CustomText(
                                        text: 'Priority',
                                        fontSize: 30,
                                        textAlign: TextAlign.center,
                                      ),
                                      for (var p in TaskPriority.values)
                                        FlatButton(
                                          color: newTask.priority == p
                                              ? Theme.of(context).hoverColor
                                              : null,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            modalSetState(
                                              () => newTask =
                                                  newTask.copyWith(priority: p),
                                            );
                                          },
                                          child: CustomText(
                                            text: describeEnum(p),
                                            fontSize: 20,
                                            iprefText: true,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/priority_icon.png',
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  const SizedBox(height: 10),
                                  const CustomText(
                                      text: "Priority", fontSize: 15),
                                  CustomText(
                                    text: describeEnum(newTask.priority),
                                    fontSize: 13,
                                    iprefText: true,
                                  )
                                ],
                              ),
                            ),
                          )),
                      InkWell(
                        onTap: () {
                          _selectDate(modalSetState);
                        },
                        child: Card(
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/date_and_time_icon.png',
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                const SizedBox(height: 10),
                                const CustomText(
                                    text: "Due date", fontSize: 15),
                                CustomText(
                                  text: newTask.dueDate != null
                                      ? DateFormat.yMd().format(newTask.dueDate)
                                      : 'none'.tr,
                                  fontSize: 13,
                                  iprefText: true,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //To select the time in hour (the default is 12:00 AM)
                if (newTask.dueDate != null)
                  FlatButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(DateFormat.jm().format(newTask.dueDate)),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime:
                            TimeOfDay(hour: newTask.dueDate.hour, minute: 0),
                      );
                      if (picked != null) {
                        modalSetState(() {
                          newTask = newTask.copyWith(
                              dueDate: newTask.dueDate.copywith(
                                  hour: picked.hour, minute: picked.minute));
                        });
                      }
                    },
                  ),
                DropdownButton<String>(
                  value: newTask.belongsTo,
                  items: tc.taskLists
                      .map<DropdownMenuItem<String>>((tl) => DropdownMenuItem(
                            value: tl,
                            child: CustomText(text: tl),
                          ))
                      .toList(),
                  onChanged: (value) {
                    modalSetState(
                        () => newTask = newTask.copyWith(belongsTo: value));
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        if (oldTask != null && oldTask == newTask) {
                          Navigator.of(context).pop();
                          return;
                        } else if (oldTask == null) {
                          tc.saveTask(newTask);
                          Navigator.of(context).pop();
                          return;
                        }

                        tc.updateTask(newTask);
                        Navigator.of(context).pop();
                      },
                      color: Theme.of(context).accentColor,
                      child: CustomText(
                          text:
                              oldTask != null ? "Save Changes" : "Create Task",
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      });
}

//to add a card theme to the textFeild
class BottomCard extends StatelessWidget {
  final Widget child;

  const BottomCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
