import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';

import 'core/network/api_client.dart';
import 'data/usecase/login_usecase.dart';
import 'domain/repository/AuthRepositories.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: 'http://192.168.8.108:8000/api'));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider()); // Register AuthProvider

}