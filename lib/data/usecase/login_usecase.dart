
import 'package:smart_mobile_app/data/repositories/AuthRepositories.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<String> execute(String email, String password) {
    return _authRepository.login(email, password);
  }

  Future<void> sendFcmToken(String fcmToken) {
    return _authRepository.sendFcmToken(fcmToken);
  }
}
