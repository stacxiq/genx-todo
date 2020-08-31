import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:todolist/controllers/theme_controller.dart';

import '../widgets/custom_text.dart';

class TasksTap extends StatefulWidget {
  TasksTap({Key key}) : super(key: key);

  @override
  _TasksTapState createState() => _TasksTapState();
}

class _TasksTapState extends State<TasksTap> {
  double _width, _height;
  Color selectedColor;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return GetX<SettingsController>(
        init: SettingsController(),
        builder: (s) {
          selectedColor = Color(int.parse(s.prefColor.value));
          return Scaffold(
            appBar: AppBar(
              title: CustomText(text: 'All Tasks'),
            ),
            body: _body(),
            floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add, color: Colors.white, size: 24),
                backgroundColor: selectedColor),
          );
        });
  }

  Widget _body() {
    return Container(
      width: _width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Block Title
            blockTitle(),
            // Todo list
            todoList()
          ],
        ),
      ),
    );
  }

  ListView todoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return taskBlock(index);
      },
    );
  }

  Card taskBlock(int index) {
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
        title: CustomText(text: 'Google note', fontSize: 20),
        subtitle:
            CustomText(text: 'description some note text ...', fontSize: 15),
        trailing: Container(
          height: 30,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: index == 1
                ? Colors.red
                : (index != 2) ? Colors.amber : Colors.green,
          ),
          child: Center(
            child: CustomText(text: '$index:00 AM',textColor: Colors.white),
          ),
        ),
      ),
    );
  }

  Container blockTitle() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: 'Today', textColor: selectedColor, fontSize: 22),
          Icon(Icons.add_circle_outline, color: selectedColor, size: 27)
        ],
      ),
    );
  }
}
