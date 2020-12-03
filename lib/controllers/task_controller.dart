import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../models/task.dart';
import './theme_controller.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();

  final _tasks = <Task>[].obs;
  final _taskLists = <String>['Default'].obs;
  final String _taskTable = 'taskTable';
  final String _taskListsTable = 'taskListsTable';

  List<Task> get tasks => _tasks;
  List<String> get taskLists => _taskLists;
  Database _dbInstance;

  @override
  void onInit() async {
    super.onInit();
    //To make sure the is only one instance of the sqflite db for the entire app
    _dbInstance = await _intDB();
    _tasks.assignAll(await _getAllTasks());
    _getTaskLists();
  }

  Future<Database> _intDB() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'mydb.db');
    var myOwnDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myOwnDB;
  }

  void _onCreate(Database db, int newVersion) async {
    try {
      await db.execute('''CREATE TABLE $_taskTable (id TEXT,
      title TEXT,body TEXT,priority INTEGER,belongsTo TEXT,dueDate DATETIME,createdAt DATETIME, isFinished TEXT)''');
      await db.execute('''CREATE TABLE $_taskListsTable (id INTEGER PRIMARY KEY,
      name TEXT)''');
    } catch (e) {
      print(e.toString());
    }
  }

  ///To creat new task and save it on the local DB
  Future<int> saveTask(Task task) async {
    try {
      _tasks.add(task);
      update(['tasks2', "calendar"]);
      final result = await _dbInstance.insert("$_taskTable", task.toMap());
      return result;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///To Delete a task by Id from the local DB
  Future<void> deleteTask(String id) async {
    try {
      _tasks.removeWhere((t) => t.id == id);
      update(['tasks2', 'calendar']);
      _dbInstance.delete(_taskTable, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
  }

  ///To update new task by Id and save it on the local DB
  Future<void> updateTask(Task task) async {
    try {
      var index = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[index] = task;
      update(['tasks2', 'calendar']);
      var r = await _dbInstance.update(_taskTable, task.toMap(),
          where: "id = ?", whereArgs: [task.id]);
      print(r);
    } catch (e) {
      print(e.toString());
    }
  }

  List<Task> _listofTasksFromMap(Map<int, dynamic> result) {
    var tasks = <Task>[];
    result?.forEach((key, task) {
      tasks.add(Task.fromMap(task));
    });
    return tasks;
  }

  //this func. shouldn't be used outside the class
  Future<List<Task>> _getAllTasks() async {
    try {
      var sql = "SELECT * FROM $_taskTable ORDER BY priority ASC";
      List result = await _dbInstance.rawQuery(sql);
      return _listofTasksFromMap(result.asMap());
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //this func. shouldn't be used outside the class
  Future<void> _getTaskLists() async {
    try {
      var sql = "SELECT * FROM $_taskListsTable";
      List result = await _dbInstance.rawQuery(sql);
      if (result != null && result.isNotEmpty) {
        result.forEach((listM) {
          _taskLists.add(listM['name']);
        });
      } else if (SettingsController.to.firstTime) {
        print(SettingsController.to.firstTime);
        ["Personal", "Work"].forEach((ln) {
          _taskLists.add(ln);
          addNewList(ln);
        });
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///To add a new list to the App and save it to the local DB
  Future<int> addNewList(String listName) async {
    try {
      _taskLists.add(listName);
      update(['tasks']);
      final result =
          await _dbInstance.insert("$_taskListsTable", {"name": listName});
      return result;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///To remove a list and The tasks that belongs to it
  ///from the App and the local DB
  Future<int> removeList(String listName) async {
    try {
      _taskLists.remove(listName);
      _tasks.forEach((t) {
        if (t.belongsTo == listName) deleteTask(t.id);
      });
      update(['tasks']);
      final result = await _dbInstance
          .delete("$_taskListsTable", where: 'name = ?', whereArgs: [listName]);
      return result;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void close() async {
    try {
      await _dbInstance.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
