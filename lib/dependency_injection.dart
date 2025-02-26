import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/data/usecase/task_usecase.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';
import 'package:smart_mobile_app/presentation/providers/tasks_provider.dart';
import 'package:smart_mobile_app/presentation/providers/user_provider.dart';

import 'core/network/api_client.dart';
import 'core/network/websocket_service.dart';
import 'data/implementations/login_implemnetation.dart';
import 'data/implementations/task_implementations.dart';
import 'data/usecase/login_usecase.dart';
import 'data/usecase/websockets_usecase.dart';
import 'domain/repository/AuthRepositories.dart';
import 'domain/repository/task_repository.dart';

final getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: 'http://192.168.8.108:8000/api'));

  getIt.registerLazySingleton<WebSocketService>(() => WebSocketService());
  getIt.registerLazySingleton<AuthRepository>(() => AuthenticationImpl(
    apiService: getIt<ApiClient>(),
    webSocketService: getIt<WebSocketService>(),
  ));

  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));

  getIt.registerLazySingleton<AuthProvider>(() => AuthProvider(getIt<AuthRepository>()));

  getIt.registerLazySingleton<TaskRepository>(() => TasksImplementation(
    apiService: getIt<ApiClient>(),
    webSocketService: getIt<WebSocketService>(),
  ));
  getIt.registerLazySingleton<ListenWebSocket>(() => ListenWebSocket(
    getIt<AuthRepository>(),
    getIt<TaskRepository>(),
  ));
  getIt.registerLazySingleton<TasksImplementation>(() => TasksImplementation(
    apiService: getIt<ApiClient>(),
    webSocketService: getIt<WebSocketService>(),
  ));
  getIt.registerLazySingleton<TaskUseCase>(() => TaskUseCase(getIt<TaskRepository>()));
  getIt.registerLazySingleton<UserProvider>(() => UserProvider(getIt()));

}

