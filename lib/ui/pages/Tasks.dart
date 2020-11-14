
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:todolist/controllers/theme_controller.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/repo/task_repo.dart';
import '../widgets/custom_text.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';  //for date format
class TasksTap extends StatefulWidget {
  TasksTap({Key key}) : super(key: key);

  @override
  _TasksTapState createState() => _TasksTapState();
}

class _TasksTapState extends State<TasksTap> {
  double _width, _height;
  Color selectedColor;

  var selectedProirity = 1;

  DateTime selectedDate = DateTime.now();
    TextEditingController _dateController = TextEditingController();

  DatabaseHelper taskDataBase = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
   TextEditingController contentController = TextEditingController();

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
                onPressed: () {
                  _settingModalBottomSheet(context);
                },
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
            blockTitle(),
             todoListToday() ,
             blockTitleTomorrow(),
            todoListTomorrow(),
            blockTitleOther(),
            todoListother()
          ],
        ),
      ),
    );
  }

   todoListToday() {
    return FutureBuilder(
      future: taskDataBase.getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return DateFormat.yMd().format(DateTime.parse(snapshot.data[index]["created_at"])) == DateFormat.yMd().format(DateTime.now()) ?taskBlock(snapshot.data[index]) : SizedBox();
            },
          );
        }
        return Center(child: CircularProgressIndicator(),);
         
      },
    );
  }
     todoListTomorrow() {
    return FutureBuilder(
      future: taskDataBase.getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final now = DateTime.now();
              print("${snapshot.data[index]["created_at"]}");
              print("${DateTime.now().difference(DateTime.parse(snapshot.data[index]["created_at"])).inDays}");
              return DateFormat.yMd().format(DateTime.parse(snapshot.data[index]["created_at"])) == DateFormat.yMd().format(DateTime(now.year, now.month, now.day + 1)) ?taskBlock(snapshot.data[index]) : SizedBox();
            },
          );
        } 
        return Center(child: CircularProgressIndicator(),);
         
      },
    );
  }



       todoListother() {
    return FutureBuilder(
      future: taskDataBase.getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final now = DateTime.now();
              print("${snapshot.data[index]["created_at"]}");
              print("${DateTime.now().difference(DateTime.parse(snapshot.data[index]["created_at"])).inDays}");
              return ! (DateFormat.yMd().format(DateTime.parse(snapshot.data[index]["created_at"])) == DateFormat.yMd().format(DateTime(now.year, now.month, now.day + 1)))   && 
                     ! (DateFormat.yMd().format(DateTime.parse(snapshot.data[index]["created_at"])) == DateFormat.yMd().format(DateTime.now()))?taskBlock(snapshot.data[index]) : SizedBox();
            },
          );
        } 
        return Center(child: CircularProgressIndicator(),);
         
      },
    );
  }

  Card taskBlock(data) {

    var time = DateTime.parse(data["created_at"]);
   
    print(data["priority"].toString());
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
       onTap: () => showMaterialModalBottomSheet(
                              
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context,s) => Container(
                                
                               color: Theme.of(context).scaffoldBackgroundColor,
                                child: Wrap(
                                  children: [
                                    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data["title"],
                        style: TextStyle(fontSize: 25),
                      ),
                      IconButton(icon: Icon(Icons.close_rounded,color: Colors.red), onPressed: (){

                        taskDataBase.deleteTask(data["id"]);
                        
                        setState(() {
                          taskDataBase.getAllTasks();
                        });

                        Navigator.pop(context);



                      })
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        data["body"],
                        style: TextStyle(fontSize: 18,color: Colors.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "${DateFormat.yMd().format(DateTime.parse(data["created_at"]))}",
                    style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.5)),
                  ),
                ),
                                  ],
                                ),

                              ),
                            ),
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2000),
              border: Border.all(color: selectedColor)),
        ),
        title: CustomText(text: data["title"], fontSize: 20),
        subtitle:
            CustomText(text: data["body"].toString().substring(0,1), fontSize: 15),
        trailing: Container(
          height: 30,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: data["priority"] == 3
                ? Colors.red
                : data["priority"] == 2
                    ? Colors.amber
                    : data["priority"] == 1?Colors.green:Colors.green
          ),
          child: Center(
            child: CustomText(text: '${DateFormat.j().format(time)}', textColor: Colors.white),
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

    Container blockTitleTomorrow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: 'Tomorrow', textColor: selectedColor, fontSize: 22),
          Icon(Icons.add_circle_outline, color: selectedColor, size: 27)
        ],
      ),
    );
  }

  Container blockTitleOther() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: 'Other', textColor: selectedColor, fontSize: 22),
          Icon(Icons.add_circle_outline, color: selectedColor, size: 27)
        ],
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().add_Hms().format(selectedDate);
      });
  }

  void _settingModalBottomSheet(context) {
    showMaterialModalBottomSheet(
      
        context: context,
        builder: (BuildContext bc,s) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: new Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Creat New Task",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                BottomCard(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          controller:titleController,
                      decoration: InputDecoration(
                          hintText: "Task name", border: InputBorder.none),
                    ))
                  ],
                ),
                BottomCard(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          controller: contentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                          hintText: "Task note", border: InputBorder.none),
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: <Widget>[
                                      OutlineButton(
                                        highlightedBorderColor: Colors.red,
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            selectedProirity = 3;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "high",
                                          style: TextStyle(),
                                        ),
                                      ),
                                      OutlineButton(
                                        highlightedBorderColor: Colors.green,
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            selectedProirity = 2;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "medium",
                                          style: TextStyle(),
                                        ),
                                      ),
                                      OutlineButton(
                                        highlightedBorderColor: Colors.green,
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 2),
                                        color: Colors.green,
                                        onPressed: () {
                                          setState(() {
                                            selectedProirity = 1;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "low",
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ],
                                    title: Text(
                                      "priority",
                                      style: TextStyle(),
                                    ),
                                    content: Text("choose priority of task"),
                                  );
                                });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlutterLogo(
                                    size: 50,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  
                                       Text("priority")
                                     
                                ],
                              ),
                            ),
                          )),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlutterLogo(
                                  size: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Date-Time")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () {
                        taskDataBase.saveTask(Task(
                          title: titleController.text,
                          body: contentController.text,
                          createdAt: selectedDate,
                          priority: selectedProirity
                        ));
                        setState(() {
                          taskDataBase.getAllTasks();
                        });

                        titleController.clear();
                        contentController.clear();
                        
                        Navigator.pop(context);
                      },
                      color: Colors.green,
                      child: Text(
                        "Create Tesk",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class BottomCard extends StatelessWidget {
  final List<Widget> children;

  BottomCard({
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }
}
