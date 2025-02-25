// To parse this JSON data, do
//
//     final createTaskResponse = createTaskResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreateTaskResponse createTaskResponseFromJson(String str) => CreateTaskResponse.fromJson(json.decode(str));

String createTaskResponseToJson(CreateTaskResponse data) => json.encode(data.toJson());

class CreateTaskResponse {
  final String message;
  final Task task;

  CreateTaskResponse({
    required this.message,
    required this.task,
  });

  factory CreateTaskResponse.fromJson(Map<String, dynamic> json) => CreateTaskResponse(
    message: json["message"],
    task: Task.fromJson(json["task"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "task": task.toJson(),
  };
}

class Task {
  final String title;
  final String description;
  final DateTime deadline;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int createdBy;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;
  final List<User> users;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.users,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json["title"],
    description: json["description"],
    deadline: DateTime.parse(json["deadline"]),
    status: json["status"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    createdBy: json["created_by"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "deadline": "${deadline.year.toString().padLeft(4, '0')}-${deadline.month.toString().padLeft(2, '0')}-${deadline.day.toString().padLeft(2, '0')}",
    "status": status,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "created_by": createdBy,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  final int id;
  final String name;
  final String email;
  final dynamic emailVerifiedAt;
  final dynamic google2FaSecret;
  final dynamic fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Pivot pivot;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.google2FaSecret,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    google2FaSecret: json["google2fa_secret"],
    fcmToken: json["fcm_token"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "google2fa_secret": google2FaSecret,
    "fcm_token": fcmToken,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "pivot": pivot.toJson(),
  };
}

class Pivot {
  final int taskId;
  final int userId;

  Pivot({
    required this.taskId,
    required this.userId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    taskId: json["task_id"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "user_id": userId,
  };
}
