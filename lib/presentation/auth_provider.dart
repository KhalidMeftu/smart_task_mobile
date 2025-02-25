import 'package:flutter/material.dart';
import 'package:smart_mobile_app/core/notifications/fcm_services.dart';
import 'package:smart_mobile_app/data/usecase/login_usecase.dart';
import 'package:smart_mobile_app/data/usecase/register_usecase.dart';
import '../../core/network/websocket_service.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final FCMService _fcmService;
  final WebSocketService _webSocketService;
  bool _isLoading = false;
  String? _token;

  AuthProvider(this._loginUseCase, this._registerUseCase, this._fcmService, this._webSocketService);

  bool get isLoading => _isLoading;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _loginUseCase.execute(email, password);

      String? fcmToken = await _fcmService.getToken();
      if (fcmToken != null) {
        await _loginUseCase.sendFcmToken(fcmToken);
      }

      _webSocketService.connect(_token!);

    } catch (e) {
      _token = null;
      print("Login Failed: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _registerUseCase.execute(name, email, password);

      String? fcmToken = await _fcmService.getToken();
      if (fcmToken != null) {
        await _loginUseCase.sendFcmToken(fcmToken);
      }

      _webSocketService.connect(_token!);

    } catch (e) {
      _token = null;
      print("Registration Failed: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
