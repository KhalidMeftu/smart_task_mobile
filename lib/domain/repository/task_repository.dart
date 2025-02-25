import '../../core/network/api_client.dart';

class TaskRepository {
  final ApiClient _apiClient;

  TaskRepository(this._apiClient);

  Future<List<dynamic>> getTasks() async {
    final response = await _apiClient.get('/gettasks');

    if (response.data is Map<String, dynamic> && response.data.containsKey('tasks')) {
      return List<dynamic>.from(response.data['tasks']); // ✅ Extract only relevant tasks
    }

    throw Exception("Unexpected API response format");
  }


  Future<void> createTask(String title, String description, String? deadline,
      String? startDate,
      String?endDate,
      List<int> userIds) async {
    await _apiClient.post('/tasks', data: {
      'title': title,
      'description': description,
      'deadline': deadline,
      'start_date': startDate,
      'end_date': endDate,
      'user_ids':userIds

    });
  }

  Future<void> updateTask(int taskId,String title, String description, String? deadline,
      String? startDate,
      String?endDate,
      List<int> userIds) async {
    await _apiClient.post('/tasks/$taskId', data: {
      'title': title,
      'description': description,
      'deadline': deadline,
      'start_date': startDate,
      'end_date': endDate,
      'user_ids':userIds
    });
  }

  Future<void> deleteTask(int taskId) async {
    await _apiClient.delete('/tasks/$taskId');
  }

  Future<void> assignTask(int taskId, List<int> userIds) async {
    await _apiClient.post('/tasks/$taskId/assign', data: {'user_ids': userIds});
  }

  Future<void> markTaskComplete(int taskId) async {
    await _apiClient.post('/tasks/$taskId/complete');
  }
  Future<void> startEditingTask(int taskId, String username) async {
    await _apiClient.post('/tasks/$taskId/editing', data: {
      'username': username,
    });
  }
}
