
import 'package:smart_mobile_app/data/repositories/task_repository.dart';

class TaskUseCase {
  final TaskRepository _taskRepository;

  TaskUseCase(this._taskRepository);

  Future<List<dynamic>> getTasks() {
    return _taskRepository.getTasks();
  }

  Future<void> createTask(String title, String description, String? deadline, String? color, List<int> userIds) {
    return _taskRepository.createTask(title, description, deadline, color,userIds);
  }

  Future<void> updateTask(int taskId, String title, String description, String? deadline, String? color) {
    return _taskRepository.updateTask(taskId, title, description, deadline, color);
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
