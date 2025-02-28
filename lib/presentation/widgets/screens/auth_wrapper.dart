import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/core/network/websocket_service.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/presentation/providers/authentication_token_provider.dart';
import 'dashboard/home_page.dart';
import 'login_screen/login_page.dart';
import 'onboading_screen/onboarding_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthTokenProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final WebSocketService _webSocketService = getIt<WebSocketService>();
        _webSocketService.connect();

        if (authProvider.token != null) {
          return HomePage();
        }

        if (!authProvider.isOnBoardLoaded) {
          return OnboardingScreen();
        }

        return LoginPage();
      },
    );

  }
}