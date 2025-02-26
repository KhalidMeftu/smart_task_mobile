import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/data/usecase/task_usecase.dart';
import 'package:smart_mobile_app/domain/entity/responses/get_users_response.dart';

class UserProvider extends ChangeNotifier {
  List<GetUsersResponse> _users = [];
  List<int> _selectedUserIds = [];
  UserState _userState = UserState.loading;
  String? _errorMessage;

  List<GetUsersResponse> get users => _users;

  List<int> get selectedUserIds => _selectedUserIds;

  UserState get userState => _userState;

  String? get errorMessage => _errorMessage;

  final TaskUseCase getTasksUseCase;

  UserProvider(this.getTasksUseCase);

  Future<void> getAllUsers() async {
    _userState = UserState.loading;
    notifyListeners();

    try {
      List<GetUsersResponse> responses = await getTasksUseCase.getUsers();
      _users = responses;
      _userState = UserState.loaded;
    } catch (e) {
      _errorMessage = "Error fetching users: $e";
      _userState = UserState.error;
    }
    notifyListeners();
  }

  Future<void> updateFirebaseToken() async {
    _userState = UserState.loading;
    notifyListeners();

    try {
      List<GetUsersResponse> responses = await getTasksUseCase.getUsers();
      _users = responses;
      _userState = UserState.loaded;
    } catch (e) {
      _errorMessage = "Error fetching users: $e";
      _userState = UserState.error;
    }
    notifyListeners();
  }

  void toggleUserSelection(int userId) {
    if (_selectedUserIds.contains(userId)) {
      _selectedUserIds.remove(userId);
    } else {
      _selectedUserIds.add(userId);
    }
    notifyListeners();
  }

  void resetSelectedUsers() {
    _selectedUserIds = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
