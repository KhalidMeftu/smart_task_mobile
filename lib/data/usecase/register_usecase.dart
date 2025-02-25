
import 'package:smart_mobile_app/data/repositories/AuthRepositories.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<String> execute(String name, String email, String password) {
    return _authRepository.register(name, email, password);
  }
}
