import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/data/implementations/login_implemnetation.dart';
import 'package:smart_mobile_app/data/usecase/login_usecase.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/domain/repository/AuthRepositories.dart';
import 'package:smart_mobile_app/presentation/providers/user_info_provider.dart';
class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  String? _token;
  bool _isLoading = false;
  String? _error;

  LogoutState _logoutState = LogoutState.idle;
  String? _logoutError;
  AuthProvider(this._authRepository);

  LogoutState get logoutState => _logoutState;
  String? get logoutError => _logoutError;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _token = await _authRepository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return _token;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _token = await _authRepository.register(name, email, password);
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
      await _authRepository.sendFcmToken(fcmToken);
    } catch (e) {
      print("Failed to send FCM token: $e");
    }
  }
  Future<void> logoutUser() async {
    _logoutState = LogoutState.loading;
    notifyListeners();

    try {
      final response = await _authRepository.logoutUser();
      if (response.statusCode == 200) {
        _logoutState = LogoutState.success;
      } else {
        _logoutState = LogoutState.error;
        _error = "Logout failed with status code: ${response.statusCode}";
      }
    } catch (e) {
      _logoutState = LogoutState.error;
      _error = e.toString();
    }

    notifyListeners();
  }


}