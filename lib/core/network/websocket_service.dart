import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  final String _webSocketUrl = 'ws://192.168.8.126:6001/app/local';

  /// Channels that require user ID
  List<String> channels = [
    "task.create.user.",
    "tasksstatusupdate.user.",
    "usertasks.update",
    "userdelete.",
    "useredit."
  ];

  /// Initialize WebSocket connection
  Future<void> connect() async {
    _token = await _getAuthToken();
    _userId = await _getUserId(); // Get user ID from secure storage

    if (_token != null && _userId != null) {
      _initializeWebSocket();
    } else {
      if (kDebugMode) {
        print("WebSocketService: Missing token or user ID. Connection aborted.");
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

      // Subscribe to user-specific channels
      _subscribeToChannels(_channel, channels, _userId!);

      _subscription = _channel!.stream.listen(
            (message) {
          if (kDebugMode) {
            print("WebSocket message received: $message");
          }
          _controller.add(message);
        },
        onError: (error) {
          if (kDebugMode) {
            print("WebSocket error: $error");
          }
          _handleDisconnect();
        },
        onDone: () {
          if (kDebugMode) {
            print("WebSocket connection closed.");
          }
          _handleDisconnect();
        },
      );
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

  /// disconnect cleanly
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _isConnected = false;
    if (kDebugMode) {
      print("WebSocketService: Disconnected.");
    }
  }

  /// Subscribe to user-specific channels
  void _subscribeToChannels(IOWebSocketChannel? channel, List<String> channelNames, String userId) {
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
