import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:smart_mobile_app/domain/entity/responses/login_response.dart';
import 'package:smart_mobile_app/domain/repository/user_data_repository.dart';
import 'package:smart_mobile_app/local_database/database/appdatabase.dart';

class UserInformationImplementation implements UserInfoRepository {
  final AppDatabase _appDatabase;
  static const String userInformation = 'userInfos';

  final usersInformation = intMapStoreFactory.store(userInformation);

  UserInformationImplementation()
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
}
