import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/core/services/app_local_storage%20services.dart';
import 'package:smart_mobile_app/dependency_injection.dart';

class AuthTokenProvider with ChangeNotifier {
  final ApiClient _apiClient = GetIt.I<ApiClient>();
  String? _token;
  bool _isLoading = true;
  bool _isOnBoardLoaded = false;

  String? get token => _token;

  bool get isLoading => _isLoading;

  bool get isOnBoardLoaded => _isOnBoardLoaded;

  AuthTokenProvider() {
    _checkAuthToken();
    getIsOBoardingShown();
  }

  Future<void> _checkAuthToken() async {
    if (kDebugMode) {
      print("Checking token");
    }
    _token = await _apiClient.getAuthToken();
    print(_token);
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> saveOBoardingShown() async {
    try {
      final storageService = getIt<SmartLocalStorageServices>();
      await storageService.setFirstTimeVisit();
    } catch (e) {}
  }

  Future<bool> getIsOBoardingShown() async {
    try {
      final storageService = getIt<SmartLocalStorageServices>();
      _isOnBoardLoaded = await storageService.getData('isFirstRun');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return _isOnBoardLoaded;
    } catch (e) {
      return false;
    }
  }

}
