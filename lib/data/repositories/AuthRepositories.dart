import '../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<String> login(String email, String password) async {
    final response = await _apiClient.post('/login', data: {'email': email, 'password': password});
    final token = response.data['token'];
    await _apiClient.setAuthToken(token);
    return token;
  }

  Future<String> register(String name, String email, String password) async {
    final response = await _apiClient.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });
    final token = response.data['token'];
    await _apiClient.setAuthToken(token);
    return token;
  }

  Future<void> sendFcmToken(String fcmToken) async {
    try {
      await _apiClient.post('/update-fcm-token', data: {'fcm_token': fcmToken});
    } catch (e) {
      print("Failed to send FCM token: $e");
    }
  }
}
