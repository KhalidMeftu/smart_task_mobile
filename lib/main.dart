import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/presentation/providers/authentication_token_provider.dart';
import 'package:smart_mobile_app/presentation/screens/home_screen.dart';
import 'common/routes/app_routes.dart';
import 'dependency_injection.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => AuthTokenProvider()),

        // ChangeNotifierProvider(create: (_) => getIt<TaskProvider>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthTokenProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Smart Task App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: authProvider.token != null
                ? SmartTaskAppRoutes.homePage
                : SmartTaskAppRoutes.loginPage,
          );
        });
  }
}
