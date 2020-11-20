import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './custom_text.dart';
import '../pages/tasks_list_page.dart';
import '../../controllers/task_controller.dart';

class MyListsTab extends StatefulWidget {
  @override
  _MyListsTabState createState() => _MyListsTabState();
}

class _MyListsTabState extends State<MyListsTab> {
  final _listNameController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // var _size = MediaQuery.of(context).size;
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    var _appBarColor = Theme.of(context).appBarTheme.color;

    /*24 is for notification bar on Android*/
    final double itemHeight = ((_height * 0.75) - kToolbarHeight - 24) / 2;
    final double itemWidth = _width / 2;

    Widget _gridItem(String listName,
        {String image = '', IconData icon = Icons.list_alt_outlined}) {
      return Card(
        elevation: 0,
        color: _appBarColor,
        child: InkWell(
          onLongPress: () {
            if (listName != "All Tasks" &&
                listName != "Add List" &&
                listName != "Finished") _showDeleteListDialog(listName);
          },
          onTap: () {
            switch (listName) {
              case 'All Tasks':
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => TasksListPage(selectedList: listName),
                  ),
                );
                break;
              case 'Finished':
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => TasksListPage(selectedList: listName),
                  ),
                );
                break;
              case 'Add List':
                _showAddListDialog();
                break;
              default:
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => TasksListPage(selectedList: listName),
                  ),
                );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              image.isEmpty
                  ? Icon(icon, size: 90)
                  : ImageIcon(AssetImage(image), size: 100),
              CustomText(
                text: listName,
                fontSize: 20,
                iprefText: true,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "My Lists",
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: GetBuilder<TaskController>(
          id: 'tasks',
          builder: (t) {
            return Container(
              margin: EdgeInsets.all(10),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: (itemWidth / itemHeight),
                children: [
                  _gridItem('All Tasks', icon: Icons.list_alt),
                  for (var ln in t.taskLists)
                    if (ln != 'Default')
                      ln == 'Personal' || ln == 'personal'
                          ? _gridItem('Personal', icon: Icons.person_outline)
                          : ln == 'Work' || ln == 'work'
                              ? _gridItem('Work', icon: Icons.work_outline)
                              : _gridItem(ln, icon: Icons.list),
                  _gridItem('Finished', icon: Icons.check_box_outlined),
                  _gridItem('Add List', icon: Icons.add),
                ],
              ),
            );
          }),
    );
  }

  void _showDeleteListDialog(String listName) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: CustomText(text: 'Are you sure?'),
              content:
                  CustomText(text: 'All tasks from the list will be deleted'),
              actions: <Widget>[
                FlatButton(
                    child: CustomText(text: 'CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: CustomText(text: 'SAVE'),
                    onPressed: () {
                      if (_fromKey.currentState.validate()) {
                        TaskController.to.removeList(listName);
                        Navigator.pop(context);
                      }
                    })
              ],
            ));
  }

  void _showAddListDialog() {
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: CustomText(text: 'List Name'),
        content: Form(
          key: _fromKey,
          child: TextFormField(
            autofocus: false,
            controller: _listNameController,
            validator: (value) =>
                value.isEmpty ? 'Please enter the name'.tr : null,
            decoration: InputDecoration(
              hintText: 'eg. Whishlist'.tr,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: CustomText(text: 'CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: CustomText(text: 'SAVE'),
              onPressed: () {
                if (_fromKey.currentState.validate()) {
                  TaskController.to.addNewList(_listNameController.text);
                  Navigator.pop(context);
                }
              })
        ],
      ),
    );
  }
}
