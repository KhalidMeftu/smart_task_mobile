import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_all_tasks_reponse.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final StreamController<String> _controller = StreamController.broadcast();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isConnected = false;
  bool _isReconnecting = false;
  String? _token;
  String? _userId;
  final String _webSocketUrl = 'ws://192.168.8.108:6001/app/my-local-key';

  /// Channels that require user ID
  List<String> channels = [
    "task.create.user.",
    "tasksstatusupdate.user.",
    "usertasks.update",
    "userdelete.",
    "useredit.",
  ];

  /// Initialize WebSocket connection
  Future<void> connect() async {
    _token = await _getAuthToken();
    _userId = await _getUserId();

    if (_token != null && _userId != null) {
      _initializeWebSocket();
    } else {
      if (kDebugMode) {
        print(
            "WebSocketService: Missing token or user ID. Connection aborted.");
      }
      // todo Handle logout or redirect to login
    }
  }

  ///get auth token
  Future<String?> _getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  /// getUserID
  Future<String?> _getUserId() async {
    return await _secureStorage.read(key: 'user_id');
  }

  /// Initializes WebSocket connection
  void _initializeWebSocket() {
    if (_isConnected || _isReconnecting) return;

    try {
      if (kDebugMode) {
        print("WebSocketService: Connecting...");
      }
      _channel = IOWebSocketChannel.connect('$_webSocketUrl?token=$_token');
      _isConnected = true;
    } catch (e) {
      if (kDebugMode) {
        print("WebSocketService: Connection failed - $e");
      }
      _handleDisconnect();
    }
  }

  ///disconnection and triggers reconnect
  void _handleDisconnect() {
    _isConnected = false;
    _channel?.sink.close(status.goingAway);
    _subscription?.cancel();
    if (!_isReconnecting) {
      _reconnect();
    }
  }

  /// exponential backoff for reconnection
  void _reconnect() {
    _isReconnecting = true;
    Future.delayed(const Duration(seconds: 3), () async {
      if (kDebugMode) {
        print("WebSocketService: Reconnecting...");
      }
      _token = await _getAuthToken();
      _userId = await _getUserId();
      if (_token != null && _userId != null) {
        _initializeWebSocket();
      }
      _isReconnecting = false;
    });
  }

  /// listen webSocket messages
  Stream<String> listen() => _controller.stream;

  /// send message
  void sendMessage(String message) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(message);
    } else {
      if (kDebugMode) {
        print("WebSocketService: Not connected. Message not sent.");
      }
    }
  }

  Stream<GetAllTaskResponse> get tasks {
    print("WebSockets tasks");
    print(_channel == null);

    if (_channel == null) {
      return const Stream.empty();
    }

    return _channel!.stream.map((message) {
      print(message.toString());
      //  try {
      final jsonData = jsonDecode(message);

      if (jsonData is Map<String, dynamic> && jsonData.containsKey('tasks')) {
        return GetAllTaskResponse.fromJson(
            jsonData); // Convert to GetAllTaskResponse
      } else {
        throw Exception("Invalid JSON structure");
      }
      //  } catch (e) {
      //  print("Error parsing WebSocket message: $e");
      //   throw Exception("Invalid WebSocket data");
      //}
    });
  }

  /// disconnect cleanly
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
    if (kDebugMode) {
      print("WebSocketService: Disconnected.");
    }
  }
}
