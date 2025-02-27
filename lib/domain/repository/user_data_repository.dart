import '../entity/responses/login_response.dart';

abstract class UserInfoRepository{
  Future<bool> saveUserInfo(User userInfo);
  Future<User?> getUserInfo();
}