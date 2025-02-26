import 'package:smart_mobile_app/domain/entity/responses/get_all_tasks_reponse.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_users_response.dart';

import '../../core/network/api_client.dart';


abstract class TaskRepository {
  final ApiClient _apiClient;

  TaskRepository(this._apiClient);

  Future<List<GetAllTaskResponse>> getTasks();

  Future<void> createTask(String title, String description,
      String? startDate, String? endDate, List<int> userIds);

  Future<void> updateTask(int taskId, String title, String description,
      String? deadline, String? startDate, String? endDate, List<int> userIds);

  Future<void> deleteTask(int taskId);

  Future<void> assignTask(int taskId, List<int> userIds);

  Future<void> markTaskComplete(int taskId);

  Future<void> startEditingTask(int taskId, String username);

  Stream<String> listenToWebSocket();

  Future<List<GetUsersResponse>> getUsers();


  Future<void> updateFirebaseCloudMessaging(String fcmID);
}