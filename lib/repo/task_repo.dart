import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todolist/models/task.dart';

class DatabaseHelper {
  static Database _db;
  final String taskTable = 'taskTable';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await intDB();
    return _db;
  }

  intDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'mydb.db');
    var myOwnDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return myOwnDB;
  }

  void _onCreate(Database db, int newVersion) async {
    try {
      await db.execute('''CREATE TABLE taskTable (id INTEGER PRIMARY KEY,
      title TEXT,body TEXT,priority INTEGER,created_at  DATETIME)''');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> saveTask(Task task) async {
    try {
      var dbClient = await db;
      int result = await dbClient.insert("$taskTable", task.toMap());
      return result;
    } catch (e) {
      print(e.toString());
    }
  }

  //   Future<int> deleteAll() async {
  //   try {
  //     var dbClient = await db;
  //     return await dbClient.delete(taskTable);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<List> getAllTasks() async {
    try {
      var dbClient = await db;
      var sql = "SELECT * FROM $taskTable ORDER BY priority DESC";
      List result = await dbClient.rawQuery(sql);
      return result.toList();
    } catch (e) {
      print(e.toString());
    }
  }

  getTask(int id) async {
    try {
      var dbClient = await db;
      var sql = "SELECT * FROM $taskTable WHERE id = $id";
      var result = await dbClient.rawQuery(sql);
      if (result.length == 0) return 0;
      return result.first;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> deleteTask(int id) async {
    try {
      var dbClient = await db;
      return await dbClient.delete(taskTable, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
  }

  close() async {
    try {
      var dbClient = await db;
      return await dbClient.close();
    } catch (e) {
      print(e.toString());
    }
  }
}
