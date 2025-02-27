import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/domain/entity/responses/login_response.dart';
import 'package:smart_mobile_app/domain/repository/user_data_repository.dart';
import 'package:smart_mobile_app/local_database/database/appdatabase.dart';

class UserInformationImplementation implements UserInfoRepository {
  final ApiClient apiService;
  final AppDatabase _appDatabase;
  static const String userInformation = 'userInfos';

  final usersInformation = intMapStoreFactory.store(userInformation);

  UserInformationImplementation(this.apiService)
      : _appDatabase = GetIt.instance<AppDatabase>();

  Future<Database> get _db async => await _appDatabase.database;

  @override
  Future<User?> getUserInfo() async {
    try {
      final records = await usersInformation.find(await _db);
      if (records.isNotEmpty) {
        return User.fromJson(records.first.value);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user info: $e");
      }
      return null;
    }
  }

  @override
  Future<bool> saveUserInfo(User userInfo) async {
    print("Saving user info");
    print( userInfo.id);
    // Saving user info
    // I/flutter (16229): 2
    try {
      final db = await _db;

      final existingRecords = await usersInformation.find(db,
          finder: Finder(filter: Filter.equals('id', userInfo.id)));

      if (existingRecords.isNotEmpty) {
        await usersInformation.delete(db,
            finder: Finder(filter: Filter.equals('id', userInfo.id)));
      }
      final userData = userInfo.toJson();
      await usersInformation.add(db, userData);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      return false;
    }
  }

  @override
  Future<bool> updateUserInfo(bool tfa, String theme,
      bool notifications) async {
    try {
      final response = await apiService.post('/user/preferences', data: {
        'two_factor_auth': tfa,
        'theme_mode': theme,
        'notifications': notifications,
      });

      if (response.statusCode == 200) {
        updateUserPreferencesLocal(twoFactorAuth: tfa,themeMode: theme,notifications: notifications);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user info: $e');
      }
      return false;
    }
  }

  Future<bool> updateUserPreferencesLocal({
    bool? twoFactorAuth,
    String? themeMode,
    bool? notifications,
  }) async {
    try {
      final db = await _db;
      final existingRecords = await usersInformation.find(db);

      if (existingRecords.isEmpty) {
        print("No user data found in local DB.");
        return false;
      }

      final userData = existingRecords.first;
      final user = User.fromJson(userData.value);
      final prefs = user.preferences ?? Preferences(
        id: 0,
        userId: user.id,
        twoFactorAuth: 0,
        themeMode: 'light',
        notifications: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedPreferences = Preferences(
        id: prefs.id,
        userId: prefs.userId,
        twoFactorAuth: twoFactorAuth != null ? (twoFactorAuth ? 1 : 0) : prefs.twoFactorAuth,
        themeMode: themeMode ?? prefs.themeMode,
        notifications: notifications != null ? (notifications ? 1 : 0) : prefs.notifications,
        createdAt: prefs.createdAt,
        updatedAt: DateTime.now(),
      );

      await usersInformation.update(
        db,
        {
          ...user.toJson(),
          "preferences": updatedPreferences.toJson(),
        },
      );

      print("User preferences updated successfully!");
      getUserInfo();
      return true;
    } catch (e) {
      print("Error updating user preferences: $e");
      return false;
    }
  }


}
