import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/domain/entity/responses/login_response.dart';
import 'package:smart_mobile_app/domain/entity/responses/prefs.dart';
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
  Future<PreferencesData?> getUserInfo() async {
    final records = await usersInformation.find(await _db);

    print("Userinfo: $records");
    if (records.isNotEmpty) {
      return PreferencesData.fromJson(records.first.value);
    }

    print("No user data found in local DB.");
    return null;
  }

  @override
  Future<bool> saveUserInfo(PreferencesData userInfo) async {

    try {
      final db = await _db;

      final existingRecords = await usersInformation.find(db,
          finder: Finder(filter: Filter.equals('id', userInfo.user.id)));

      if (existingRecords.isNotEmpty) {
        await usersInformation.delete(db,
            finder: Finder(filter: Filter.equals('id',userInfo.user.id)));
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
    final db = await _db;
    var existingRecords = await usersInformation.find(db);
    if (existingRecords.isEmpty) {
      await getUserInfo();
      existingRecords = await usersInformation.find(db);
    }

    if (existingRecords.isEmpty) {
      return false;
    }

    final userData = existingRecords.first;
    final userMap = (userData as RecordSnapshot).value as Map<String, dynamic>;
    final user = userMap['user'];
    final preferences = user['preferences'] ?? {};

    final updatedPreferences = Preferences(
      id: preferences['id'] ?? 0,
      userId: preferences['user_id'] ?? 0,
      twoFactorAuth: twoFactorAuth != null ? (twoFactorAuth ? 1 : 0) : (preferences['two_factor_auth'] ?? 0),
      themeMode: themeMode ?? preferences['theme_mode'] ?? 'light',
      notifications: notifications != null ? (notifications ? 1 : 0) : (preferences['notifications'] ?? 1),
      createdAt: DateTime.tryParse(preferences['created_at'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await usersInformation.record(existingRecords.first.key).put(db, {"user": {...user, "preferences": updatedPreferences.toJson()}});


    return true;
  }


}



