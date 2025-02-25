import 'dart:async';
import 'package:web_socket_channel/io.dart';

import 'dart:async';
import 'package:web_socket_channel/io.dart';

import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final StreamController<String> _controller = StreamController.broadcast();
  bool _isConnected = false;
  String? _token;

  void connect(String token) {
    _token = token;
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    print("connecting websockets");
    print(_isConnected);
    if (_isConnected) return;
    try {
      print("Connecting to WebSocket...");
      _channel = IOWebSocketChannel.connect('ws://192.168.8.126:6001/app/local?token=$_token');
      _isConnected = true;

      _subscription = _channel!.stream.listen(
            (message) {
          print("WebSocket message received: $message");
          _controller.add(message);
        },
        onError: (error) {
          print("WebSocket error: $error");
          _isConnected = false;
          _reconnect();
        },
        onDone: () {
          print("WebSocket connection closed.");
          _isConnected = false;
          _reconnect();
        },
      );
    } catch (e) {
      print("WebSocket connection failed: $e");
      _isConnected = false;
      _reconnect();
    }
  }

  Stream<String> listen() {
    return _controller.stream;
  }

  void sendMessage(String message) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(message);
    } else {
      print("WebSocket is not connected. Unable to send message.");
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
  }

  void _reconnect() {
    Future.delayed(Duration(seconds: 3), () {
      print("Reconnecting WebSocket...");
      _initializeWebSocket();
    });
  }
}
