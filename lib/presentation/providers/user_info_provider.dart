import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/data/implementations/user_information_implementation.dart';
import '../../domain/entity/responses/login_response.dart';


class UserInfoProvider with ChangeNotifier {
  final UserInformationImplementation _userInfoImplementation;

  UserInfoProvider({required UserInformationImplementation userRepository})
      : _userInfoImplementation = userRepository;

  User? _user;
  UserInfoState _state = UserInfoState.idle;
  String? _errorMessage;

  User? get user => _user;
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
        saveUserInfos(_user!);
        _state = UserInfoState.success;
      } else {
        _state = UserInfoState.error;
        _errorMessage = "Failed to fetch user info.";
      }
    } catch (e) {
      _state = UserInfoState.error;
      _errorMessage = "Failed to load user info: $e";
    }

    notifyListeners();
  }

  Future<void> saveUserInfos(User userInfo) async {
    _state = UserInfoState.loading;
    notifyListeners();

    try {
      bool success = await _userInfoImplementation.saveUserInfo(userInfo);
      if (success) {
        _user = userInfo;
        _state = UserInfoState.success;
      } else {
        _state = UserInfoState.error;
        _errorMessage = "Failed to save user info.";
      }
    } catch (e) {
      _state = UserInfoState.error;
      _errorMessage = "Error saving user info: $e";
    }

    notifyListeners();
  }

  // update
  Future<void> updateUserInfo(bool twfaStatus, String theme, bool notification) async {
    _state = UserInfoState.loading;
    try {
      bool success = await _userInfoImplementation.updateUserInfo(twfaStatus, theme, notification);
      if (success) {
        _state = UserInfoState.success;
        fetchUserInfo();

      } else {
        _state = UserInfoState.error;
        _errorMessage = "Failed update user info.";
      }
    } catch (e) {
      _state = UserInfoState.error;
      _errorMessage = "Error saving user info: $e";
    }

  }

  // logout
}
