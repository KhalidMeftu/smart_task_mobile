import 'package:flutter/material.dart';
import 'package:smart_mobile_app/data/usecase/login_usecase.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/domain/repository/AuthRepositories.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase _loginUseCase = getIt<LoginUseCase>();
  String? _token;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _token = await _loginUseCase.execute(email, password);
      _isLoading = false;
      notifyListeners();
      return true; // Login successful
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false; // Login failed
    }
  }


  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _token = await getIt<AuthRepository>().register(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> sendFcmToken(String fcmToken) async {
    try {
      await _loginUseCase.sendFcmToken(fcmToken);
    } catch (e) {
      print("Failed to send FCM token: $e");
    }
  }
}