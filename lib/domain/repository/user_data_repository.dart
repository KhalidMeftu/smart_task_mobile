import 'package:smart_mobile_app/domain/entity/responses/prefs.dart';

import '../entity/responses/login_response.dart';

abstract class UserInfoRepository{
  Future<bool> saveUserInfo(PreferencesData userInfo);
  Future<PreferencesData?> getUserInfo();
  Future<bool> updateUserInfo(bool tfa, String theme, bool notification);

}