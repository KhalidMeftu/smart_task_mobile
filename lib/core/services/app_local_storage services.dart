import 'package:shared_preferences/shared_preferences.dart';

class SmartLocalStorageServices {
  static SmartLocalStorageServices? _instance;
  static SharedPreferences? _preferences;

  static Future<SmartLocalStorageServices> getinstance() async {
    _instance ??= SmartLocalStorageServices();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance!;
  }

  Future<bool> _saveData(String key, dynamic value) {
    if (value is String) {
      return _preferences!.setString(key, value);
    }
    if (value is bool) {
      return _preferences!.setBool(key, value);
    }
    if (value is int) {
      return _preferences!.setInt(key, value);
    }
    if (value is double) {
      return _preferences!.setDouble(key, value);
    }
    if (value is List<String>) {
      return _preferences!.setStringList(key, value);
    }

    throw Exception('Unsupported value type');
  }

  Future<bool> deleteData(String key) {
    return _preferences!.remove(key);
  }

  /// save is user first time
  Future<void> setFirstTimeVisit() async {
    /// check if before
    bool isFirstRun = getData('isFirstRun') ?? true;
    if (isFirstRun) {
      _saveData('isFirstRun', false);
    }
  }

  Future<void> saveTheme(bool theme) async {
    final success = await _saveData('theme', theme);
    if (success) {
    } else {
    }
  }

  /// get data
  dynamic getData(String key) {
    var value = _preferences!.get(key);
    return value;
  }
}