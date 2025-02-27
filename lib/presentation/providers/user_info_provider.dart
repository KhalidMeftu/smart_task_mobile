import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/data/implementations/user_information_implementation.dart';
import 'package:smart_mobile_app/domain/entity/responses/prefs.dart';
import '../../domain/entity/responses/login_response.dart';


class UserInfoProvider with ChangeNotifier {
  final UserInformationImplementation _userInfoImplementation;

  UserInfoProvider({required UserInformationImplementation userRepository})
      : _userInfoImplementation = userRepository;

  PreferencesData? _user;
  UserInfoState _state = UserInfoState.idle;
  String? _errorMessage;

  PreferencesData? get user => _user;
  UserInfoState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserInfo() async {
    _state = UserInfoState.loading;
    WidgetsBinding.instance.addPostFrameCallback((_){

      notifyListeners();

    });

    try {
      final fetchedUser = await _userInfoImplementation.getUserInfo();
      if (fetchedUser != null) {
        _user = fetchedUser;
        await saveUserInfos(_user!);
        _state = UserInfoState.success;
        print("User info fetched and saved successfully!");
      } else {
        _state = UserInfoState.error;
        _errorMessage = "Failed to fetch user info.";
        print("Failed to fetch user info.${UserInfoState.error.toString()}");
      }
    } catch (e) {
      _state = UserInfoState.error;
      _errorMessage = "Failed to load user info: $e";
      print("Failed to load user info: $e");
    }

    notifyListeners();
  }
  Future<void> saveUserInfos(PreferencesData userInfo) async {
    _state = UserInfoState.loading;
    notifyListeners();

    try {
      bool success = await _userInfoImplementation.saveUserInfo(userInfo);
      if (success) {
        _user = userInfo;
        _state = UserInfoState.success;
        print("User info saved successfully!");
      } else {
        _state = UserInfoState.error;
        _errorMessage = "Failed to save user info.";
        print("Failed to save user info.");
      }
    } catch (e) {
      _state = UserInfoState.error;
      _errorMessage = "Error saving user info: $e";
      print("Error saving user info: $e");
    }

    notifyListeners();
  }

  // update
  Future<void> updateUserInfo(bool twoFactorAuth, String themeMode, bool notifications) async {
    _state = UserInfoState.loading;
    notifyListeners();

    bool success = await _userInfoImplementation.updateUserPreferencesLocal(
      twoFactorAuth: twoFactorAuth,
      themeMode: themeMode,
      notifications: notifications,
    );

    if (success) {
      await fetchUserInfo();
      _state = UserInfoState.success;
    } else {
     _state = UserInfoState.error;
    }

    notifyListeners();
  }


// logout
}
