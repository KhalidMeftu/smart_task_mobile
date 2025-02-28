import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/data/usecase/task_usecase.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';
import 'package:smart_mobile_app/presentation/providers/authentication_token_provider.dart';
import 'package:smart_mobile_app/presentation/providers/user_info_provider.dart';
import 'package:smart_mobile_app/presentation/providers/user_provider.dart';
import 'core/network/api_client.dart';
import 'core/network/websocket_service.dart';
import 'core/services/app_local_storage services.dart';
import 'data/implementations/login_implemnetation.dart';
import 'data/implementations/task_implementations.dart';
import 'data/implementations/user_information_implementation.dart';
import 'data/usecase/login_usecase.dart';
import 'data/usecase/websockets_usecase.dart';
import 'domain/repository/AuthRepositories.dart';
import 'domain/repository/task_repository.dart';
import 'local_database/database/appdatabase.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(baseUrl: ""));

  getIt.registerLazySingleton<WebSocketService>(() => WebSocketService());
  getIt.registerLazySingleton(() => AppDatabase.instance);
  var instance = await SmartLocalStorageServices.getinstance();
  getIt.registerLazySingleton<SmartLocalStorageServices>(() => instance);
  getIt.registerLazySingleton<AuthTokenProvider>(() => AuthTokenProvider());
  getIt.registerLazySingleton<UserInformationImplementation>(() => UserInformationImplementation(getIt<ApiClient>()));
  getIt.registerFactory<UserInfoProvider>(
          () => UserInfoProvider(userRepository: getIt<UserInformationImplementation>()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthenticationImpl(
        apiService: getIt<ApiClient>(),
        webSocketService: getIt<WebSocketService>(),
        userProvider: getIt<UserInfoProvider>(),
  ));


  getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()));

  getIt.registerLazySingleton<AuthProvider>(
      () => AuthProvider(getIt<AuthRepository>()));

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
  getIt.registerLazySingleton<TaskUseCase>(
      () => TaskUseCase(getIt<TaskRepository>()));
  getIt.registerLazySingleton<UserProvider>(() => UserProvider(getIt()));
  //

}
