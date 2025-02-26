import 'dart:convert';

import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/core/network/websocket_service.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_all_tasks_reponse.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_users_response.dart';
import 'package:smart_mobile_app/domain/repository/task_repository.dart';

class TasksImplementation implements TaskRepository {
  final ApiClient apiService;
  final WebSocketService webSocketService;

  TasksImplementation(
      {required this.apiService, required this.webSocketService});

  @override
  Future<void> assignTask(int taskId, List<int> userIds) async {
    await apiService.post('/tasks/$taskId/assign', data: {'user_ids': userIds});
  }

  @override
  Future<void> createTask(String title, String description,
      String? startDate, String? endDate, List<int> userIds) async {
    await apiService.post('/tasks', data: {
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'user_ids': userIds
    });
  }

  @override
  Future<void> deleteTask(int taskId) async {
    await apiService.delete('/tasks/$taskId');
  }

  @override
  Future<List<GetAllTaskResponse>> getTasks() async {
    final response = await apiService.get('/gettasks');
    if (response.data is Map<String, dynamic> &&
        response.data.containsKey('tasks')) {
      final tasksData = response.data['tasks'];
      if (tasksData is List) {
        return [
          GetAllTaskResponse(
            tasks: List<Task>.from(
                tasksData.map((task) => Task.fromJson(task))),
          )
        ];
      } else {
        throw Exception("Tasks data is not a list");
      }
    }

    throw Exception("Unexpected API response format");
  }

  @override
  Future<void> markTaskComplete(int taskId) async {
    await apiService.post('/tasks/$taskId/complete');
  }

  @override
  Future<void> startEditingTask(int taskId, String username) async {
    await apiService.post(
        '/tasks/$taskId/editing', data: {'username': username});
  }

  @override
  Future<void> updateTask(int taskId, String title, String description,
      String? deadline, String? startDate, String? endDate,
      List<int> userIds) async {
    await apiService.post('/tasks/$taskId', data: {
      'title': title,
      'description': description,
      'deadline': deadline,
      'start_date': startDate,
      'end_date': endDate,
      'user_ids': userIds
    });
  }

  @override
  Stream<String> listenToWebSocket() {
    return webSocketService.tasks.map((response) =>
        jsonEncode(response.toJson())).asBroadcastStream();
  }

  @override
  Future<List<GetUsersResponse>> getUsers() async {
    final response = await apiService.get('/users');
    final usersData = response.data;

    if (usersData is List) {
      return usersData.map((user) => GetUsersResponse.fromJson(user)).toList();
    }

    return [];
  }

  @override
  Future<void> updateFirebaseCloudMessaging(String fcmID) async {
    await apiService.post('/update-fcm-token', data: {
     'fcm_token':fcmID,
    });
  }
}
