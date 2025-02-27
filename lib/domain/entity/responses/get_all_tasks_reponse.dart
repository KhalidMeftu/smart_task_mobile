import 'package:meta/meta.dart';
import 'dart:convert';

import 'create_task_response.dart';

GetAllTaskResponse getAllTaskResponseFromJson(String str) =>
    GetAllTaskResponse.fromJson(json.decode(str));

String getAllTaskResponseToJson(GetAllTaskResponse data) =>
    json.encode(data.toJson());

class GetAllTaskResponse {
  final List<Task> tasks;

  GetAllTaskResponse({
    required this.tasks,
  });

  factory GetAllTaskResponse.fromJson(Map<String, dynamic> json) =>
      GetAllTaskResponse(
        tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tasks": List<dynamic>.from(tasks.map((x) => x.toJson())),
      };
}

class Task {
  final int id;
  final String title;
  final String description;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final List<TaskUsers>? users;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.users,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title:json["title"]!,
        description:json["description"]!,
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"]!,
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        users: List<TaskUsers>.from(json["users"].map((x) => TaskUsers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "status": status,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "users": List<dynamic>.from(users!.map((x) => x.toJson()))??[],
      };
}













