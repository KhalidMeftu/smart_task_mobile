
import 'package:smart_mobile_app/domain/repository/task_repository.dart';

class TaskUseCase {
  final TaskRepository _taskRepository;

  TaskUseCase(this._taskRepository);

  Future<List<dynamic>> getTasks() {
    return _taskRepository.getTasks();
  }

  Future<void> createTask(String title, String description, String? deadline,
      String? startDate,
      String?endDate,
      List<int> userIds) {
    return _taskRepository.createTask(title, description, deadline, startDate,endDate,userIds);
  }

  Future<void> updateTask(int taskId,String title, String description, String? deadline,
      String? startDate,
      String?endDate,
      List<int> userIds) {
    return _taskRepository.updateTask(taskId, title, description, deadline, startDate, endDate,userIds);
  }

  Future<void> deleteTask(int taskId) {
    return _taskRepository.deleteTask(taskId);
  }

  Future<void> assignTask(int taskId, List<int> userIds) {
    return _taskRepository.assignTask(taskId, userIds);
  }

  Future<void> markTaskComplete(int taskId) {
    return _taskRepository.markTaskComplete(taskId);
  }

  Future<void> startEditingTask(int taskId, String username) async {
    await _taskRepository.startEditingTask(taskId, username);
  }
}
