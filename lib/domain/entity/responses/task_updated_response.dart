// To parse this JSON data, do
//
//     final taskUpdateResponse = taskUpdateResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TaskUpdateResponse taskUpdateResponseFromJson(String str) => TaskUpdateResponse.fromJson(json.decode(str));

String taskUpdateResponseToJson(TaskUpdateResponse data) => json.encode(data.toJson());

class TaskUpdateResponse {
  final String title;
  final String description;
  final DateTime deadline;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> userIds;

  TaskUpdateResponse({
    required this.title,
    required this.description,
    required this.deadline,
    required this.startDate,
    required this.endDate,
    required this.userIds,
  });

  factory TaskUpdateResponse.fromJson(Map<String, dynamic> json) => TaskUpdateResponse(
    title: json["title"],
    description: json["description"],
    deadline: DateTime.parse(json["deadline"]),
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    userIds: List<int>.from(json["user_ids"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "deadline": "${deadline.year.toString().padLeft(4, '0')}-${deadline.month.toString().padLeft(2, '0')}-${deadline.day.toString().padLeft(2, '0')}",
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "user_ids": List<dynamic>.from(userIds.map((x) => x)),
  };
}
