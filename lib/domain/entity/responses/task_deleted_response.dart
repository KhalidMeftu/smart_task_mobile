import 'dart:convert';

TaskDeletedResponse taskDeletedResponseFromJson(String str) => TaskDeletedResponse.fromJson(json.decode(str));

String taskDeletedResponseToJson(TaskDeletedResponse data) => json.encode(data.toJson());

class TaskDeletedResponse {
  final String message;

  TaskDeletedResponse({
    required this.message,
  });

  factory TaskDeletedResponse.fromJson(Map<String, dynamic> json) => TaskDeletedResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
