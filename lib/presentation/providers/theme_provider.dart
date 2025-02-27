import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_mobile_app/core/services/app_local_storage%20services.dart';
import 'package:smart_mobile_app/dependency_injection.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  void updateDarkModeFromSystem(BuildContext context) {
    final systemDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    if (_isDarkMode != systemDarkMode) {
      _isDarkMode = systemDarkMode;
      notifyListeners();
    }
  }

  Future<void> loadDarkModeState() async {
    try {
      final storageService = getIt<SmartLocalStorageServices>();
      bool? storedTheme = await storageService.getData('theme');

      if (storedTheme != null) {
        _isDarkMode = storedTheme;
      }
    } catch (e) {
      if (kDebugMode) print('Error loading dark mode state: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    try {
      final storageService = getIt<SmartLocalStorageServices>();
      await storageService.saveTheme(_isDarkMode);
    } catch (e) {
      if (kDebugMode) print('Error saving dark mode state: $e');
    }
  }

  Future<void> setDarkMode(bool darkMode) async {
    try {
      final storageService = getIt<SmartLocalStorageServices>();
      await storageService.saveTheme(darkMode);
    } catch (e) {
      if (kDebugMode) print('Error saving dark mode state: $e');
    }
  }
}
