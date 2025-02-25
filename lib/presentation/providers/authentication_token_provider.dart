import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/core/network/api_client.dart';

class AuthTokenProvider with ChangeNotifier {
  final ApiClient _apiClient = GetIt.I<ApiClient>();
  String? _token;
  String? get token => _token;

  AuthTokenProvider() {
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    _token = await _apiClient.getAuthToken();
    print("Notifying Listners");
    print(_token);
    print(token);
    notifyListeners();
  }
}
