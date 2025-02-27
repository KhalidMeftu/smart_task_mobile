import '../entity/responses/login_response.dart';

abstract class UserInfoRepository{
  Future<bool> saveUserInfo(User userInfo);
  Future<User?> getUserInfo();
  Future<bool> updateUserInfo(bool tfa, String theme, bool notification);

}