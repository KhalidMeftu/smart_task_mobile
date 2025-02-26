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
  final Status status;
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
        status: statusValues.map[json["status"]]!,
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        users: List<TaskUsers>.from(json["users"].map((x) => TaskUsers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": titleValues.reverse[title],
        "description": descriptionValues.reverse[description],
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "status": statusValues.reverse[status],
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "users": List<dynamic>.from(users!.map((x) => x.toJson()))??[],
      };
}

enum Description { DESCRIPTION }

final descriptionValues = EnumValues({"description": Description.DESCRIPTION});

enum Status { PENDING }

final statusValues = EnumValues({"pending": Status.PENDING});

enum Title { TEST_TASK }

final titleValues = EnumValues({"test Task": Title.TEST_TASK});

class User {
  final int id;
  final Name name;
  final Email email;
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
        name: nameValues.map[json["name"]]!,
        email: emailValues.map[json["email"]]!,
        emailVerifiedAt: json["email_verified_at"],
        google2FaSecret: json["google2fa_secret"],
        fcmToken: json["fcm_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
        "email": emailValues.reverse[email],
        "email_verified_at": emailVerifiedAt,
        "google2fa_secret": google2FaSecret,
        "fcm_token": fcmToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot.toJson(),
      };
}

enum Email { JOHN_EXAMPLE_COM }

final emailValues = EnumValues({"john@example.com": Email.JOHN_EXAMPLE_COM});

enum Name { JOHN_DOE }

final nameValues = EnumValues({"John Doe": Name.JOHN_DOE});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
