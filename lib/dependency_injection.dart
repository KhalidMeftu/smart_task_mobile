import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/presentation/providers/task_providers.dart';
import 'core/network/api_client.dart';
import 'core/network/websocket_service.dart';
import 'core/notifications/fcm_services.dart';
import 'data/repositories/AuthRepositories.dart';
import 'data/repositories/task_repository.dart';
import 'data/usecase/domain/task_usecase.dart';
import 'data/usecase/login_usecase.dart';
import 'data/usecase/register_usecase.dart';
import 'presentation/providers/auth_provider.dart';

final getIt = GetIt.instance;

void setupLocator() {
  if (!GetIt.I.isRegistered<ApiClient>()) {
    getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  }

  if (!GetIt.I.isRegistered<WebSocketService>()) {
    getIt.registerLazySingleton<WebSocketService>(() => WebSocketService());
  }

  if (!GetIt.I.isRegistered<FCMService>()) {
    getIt.registerLazySingleton<FCMService>(() => FCMService());
  }

  if (!GetIt.I.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt<ApiClient>()));
  }

  if (!GetIt.I.isRegistered<TaskRepository>()) {
    getIt.registerLazySingleton<TaskRepository>(() => TaskRepository(getIt<ApiClient>()));
  }

  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  }

  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRepository>()));
  }

  if (!GetIt.I.isRegistered<TaskUseCase>()) {
    getIt.registerLazySingleton<TaskUseCase>(() => TaskUseCase(getIt<TaskRepository>()));
  }

  if (!GetIt.I.isRegistered<AuthProvider>()) {
    getIt.registerLazySingleton<AuthProvider>(() => AuthProvider(
        getIt<LoginUseCase>(), getIt<RegisterUseCase>(), getIt<FCMService>(), getIt<WebSocketService>()));
  }

  if (!GetIt.I.isRegistered<TaskProvider>()) {
    getIt.registerLazySingleton<TaskProvider>(() => TaskProvider(getIt<TaskUseCase>(), getIt<WebSocketService>()));
  }
}
