import 'package:flutter/material.dart';
import '../../core/network/websocket_service.dart';
import '../../data/usecase/domain/task_usecase.dart';

import 'package:flutter/material.dart';
import '../../data/usecase/domain/task_usecase.dart';
import '../../core/network/websocket_service.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TaskProvider with ChangeNotifier {
  final TaskUseCase _taskUseCase;
  final WebSocketService _webSocketService;
  List<dynamic> _tasks = [];
  Map<int, String> editingUsers = {};

  TaskProvider(this._taskUseCase, this._webSocketService) {
    listenForTaskUpdates();
  }

  List<dynamic> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await _taskUseCase.getTasks();
    notifyListeners();
  }

  Future<void> createTask(String title, String description, String? deadline, String? color, List<int> userIds) async {
    await _taskUseCase.createTask(title, description, deadline, color, userIds);
    fetchTasks();
  }

  Future<void> updateTask(int taskId, String title, String description, String? deadline, String? color) async {
    await _taskUseCase.updateTask(taskId, title, description, deadline, color);
    fetchTasks();
    notifyListeners();

  }

  Future<void> deleteTask(int taskId) async {
    await _taskUseCase.deleteTask(taskId);
    fetchTasks();
  }

  Future<void> assignTask(int taskId, List<int> userIds) async {
    await _taskUseCase.assignTask(taskId, userIds);
  }

  Future<void> markTaskComplete(int taskId) async {
    await _taskUseCase.markTaskComplete(taskId);
    fetchTasks();
  }

  void listenForTaskUpdates() {
    print("Listening for task updates...");
    _webSocketService.listen().listen((message) {
      print("Received WebSocket message: $message");

      final data = jsonDecode(message);

      if (data['event'] == 'task.deleted') {
        int deletedTaskId = data['data']['taskId'];
        print("Task deleted: $deletedTaskId");

        _tasks.removeWhere((task) => task['id'] == deletedTaskId);
        notifyListeners();
      }

      if (data['event'] == 'task.editing') {
        int taskId = data['data']['taskId'];
        String username = data['data']['username'];
        print("$username is editing task $taskId");

        editingUsers[taskId] = username;
        notifyListeners();

        Future.delayed(Duration(seconds: 10), () {
          editingUsers.remove(taskId);
          notifyListeners();
        });
      }
    }, onError: (error) {
      print("WebSocket Error: $error");
    });
  }

  Future<void> startEditingTask(int taskId, String username) async {
    await _taskUseCase.startEditingTask(taskId, username);
  }
}
