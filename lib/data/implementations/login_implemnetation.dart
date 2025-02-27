import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/core/network/websocket_service.dart';
import 'package:smart_mobile_app/domain/entity/responses/login_response.dart';
import 'package:smart_mobile_app/domain/entity/responses/prefs.dart';
import 'package:smart_mobile_app/domain/repository/AuthRepositories.dart';
import 'package:smart_mobile_app/presentation/providers/user_info_provider.dart';

class AuthenticationImpl implements AuthRepository {
  final ApiClient apiService;
  final WebSocketService webSocketService;
  final UserInfoProvider userProvider;

  AuthenticationImpl({required this.apiService, required this.webSocketService, required this.userProvider});

  @override
  Future<String> login(String email, String password) async {
    final response = await apiService.post('/login', data: {'email': email, 'password': password});
    final token = response.data['token'];
    final loginData = PreferencesData.fromJson(response.data);
     await userProvider.saveUserInfos(loginData);
     await apiService.setAuthToken(token);
     await apiService.setUserID(loginData.user.id.toString());
    return token;
  }

  @override
  Future<String> register(String name, String email, String password) async {
    final response = await apiService.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });
    final token = response.data['token'];
    await apiService.setAuthToken(token);
    return token;
  }

  @override
  Future<void> sendFcmToken(String fcmToken) async {
    try {
      await apiService.post('/update-fcm-token', data: {'fcm_token': fcmToken});
    } catch (e) {
      print("Failed to send FCM token: $e");
    }
  }
}