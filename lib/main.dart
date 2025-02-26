import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/presentation/providers/authentication_token_provider.dart';
import 'package:smart_mobile_app/presentation/providers/tasks_provider.dart';
import 'package:smart_mobile_app/presentation/providers/user_provider.dart';
import 'common/routes/app_routes.dart';
import 'common/utils/functions/utils_functions.dart';
import 'data/usecase/task_usecase.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'new_presentation/presentation/screens/auth_wrapper.dart';
import 'presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  setupLocator();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => AuthTokenProvider()),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(
            getTasksUseCase: getIt<TaskUseCase>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
      onGenerateRoute: RouteGenerator.getRoute,
    );
  }
}
