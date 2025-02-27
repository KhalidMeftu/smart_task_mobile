import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/data/usecase/task_usecase.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_all_tasks_reponse.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_users_response.dart';
import 'package:web_socket_channel/io.dart';

class TaskProvider with ChangeNotifier {
  final TaskUseCase getTasksUseCase;
  late IOWebSocketChannel _channel;
  final List<Task> _tasks = [];
  final List<GetUsersResponse> _newUsers = [];
  Map<int, String> _editingTasks = {};
  Map<int, String> get editingTasks => _editingTasks;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _token;
  String? _userId;
  final String _webSocketUrl = 'ws://192.168.8.108:6001/app/my-local-key';

  List<Task> get tasks => _tasks;
  List<GetUsersResponse> get newUsers => _newUsers;
  List<String> channels = [
    "task.create.user.",
    "tasksstatusupdate.user.",
    "usertasks.update",
    "userdelete.",
    "useredit.",
    "task.created",
  ];
  TaskState _taskState = TaskState.idle;
  TaskState get taskState => _taskState;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  TaskProvider({required this.getTasksUseCase}) {
    _fetchTasks();
    _connectWebSocket();
  }

  Future<void> _fetchTasks() async {
    try {
      List<GetAllTaskResponse> responses = await getTasksUseCase.getTasks();
      _tasks.addAll(responses.expand((response) => response.tasks));
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching tasks: $e");
      }
    }
  }


  Future<void> addNewTask(
      String title, String description,
      String? startDate, String? endDate, List<int> userIds) async {
    try {
      _taskState = TaskState.loading;
      notifyListeners();

      await getTasksUseCase.createTask(title, description, startDate, endDate, userIds);

      _taskState = TaskState.success;
      notifyListeners();
    } catch (e) {
      _taskState = TaskState.error;
      _errorMessage = "Error adding task: $e";
      notifyListeners();
    }
  }

  Future<String?> _getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  /// getUserID
  Future<String?> _getUserId() async {
    return await _secureStorage.read(key: 'user_id');
  }

  Future<void> _connectWebSocket() async {
    _token = await _getAuthToken();
    _userId = await _getUserId();
    _channel = IOWebSocketChannel.connect('$_webSocketUrl?token=$_token');
    _subscribeToChannels(_channel, channels, _userId!);
    _channel.stream.listen(
          (message) {
        if (kDebugMode) {
          print("Received WebSocket message: $message");
        }

        try {
          final Map<String, dynamic> decodedMessage = jsonDecode(message);

          if (!decodedMessage.containsKey('event') || decodedMessage['event'] == null) {
            if (kDebugMode) {
              print("Ignoring non-event message: $decodedMessage");
            }
            return;
          }

          final String event = decodedMessage['event'];
          if (kDebugMode) {
            print("Event received: $event");
          }

          if (!decodedMessage.containsKey('data') || decodedMessage['data'] == null) {
            if (kDebugMode) {
              print("Warning: Received event '$event' without 'data' field.");
            }
            return;
          }

          dynamic rawData = decodedMessage['data'];

          if (rawData is String) {
            rawData = jsonDecode(rawData);
          }

          if (event == 'task.created') {
            if (rawData.containsKey('task')) {
              final task = Task.fromJson(rawData['task']);
              _tasks.add(task);
              notifyListeners();
            } else {
              if (kDebugMode) {
                print("'task.created' event received but no 'task' field found.");
              }
            }
          } else if (event == 'task.editing') {
            final int? taskId = rawData['taskId'];
            final String? username = rawData['username'];

            if (taskId != null && username != null) {
              _editingTasks[taskId] = username;
              notifyListeners();
              /// remove editing status after 10 sec
              Future.delayed(Duration(seconds: 10), () {
                _editingTasks.remove(taskId);
                notifyListeners();
              });
              if (kDebugMode) {
                print("'$username' is editing task with ID: $taskId");
              }
            } else {
              if (kDebugMode) {
                print("missing 'taskId' or 'username' in 'task.editing' event.");
              }
            }
          } else {
            if (kDebugMode) {
              print("Unhandled event: $event");
            }
          }
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print("WebSocket Error: $e");
          }
          if (kDebugMode) {
            print(stackTrace);
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print("WebSocket error: $error");
        }
      },
      onDone: () {
        if (kDebugMode) {
          print("WebSocket disconnected");
        }
      },
    );


  }

  void _subscribeToChannels(
      IOWebSocketChannel? channel, List<String> channelNames, String userId) {
    if (channel == null) return;

    for (var channelName in channelNames) {
      String fullChannelName = "$channelName$userId";
      channel.sink.add(jsonEncode({
        "event": "pusher:subscribe",
        "data": {"channel": fullChannelName}
      }));

      if (kDebugMode) {
        print("Subscribed to: $fullChannelName");
      }
    }
  }
}
