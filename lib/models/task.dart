
import 'dart:convert';

Task taskFromMap(String str) => Task.fromMap(json.decode(str));

String taskToMap(Task data) => json.encode(data.toMap());

class Task {
  Task({
    this.id,
    this.title,
    this.body,
    this.priority,
    this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final int priority;
  final DateTime createdAt;

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        body:json["body"],
        priority:json["priority"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
        "priority": priority,
        "created_at": createdAt.toIso8601String(),
      };
}