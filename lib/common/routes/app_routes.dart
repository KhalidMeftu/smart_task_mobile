import 'package:flutter/material.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/dashboard/home_page.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/login_screen/login_page.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/onboading_screen/onboarding_page.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/register_screen/signup_page.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/settings/user_settings.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/tasks/addtask/add_task.dart';

class SmartTaskAppRoutes {
  static const String onBoarding = '/onboardingRoute';
  static const String homePage = '/homePageRoute';
  static const String loginPage = '/loginPageRoute';
  static const String signUpPage = '/registerPageRoute';
  static const String settingsPage = '/settingsPageRoute';
  static const String tasksPage = '/tasksPageRoute';
  static const String addTask = '/addTasks'; //AddTask
}

class RouteGenerator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SmartTaskAppRoutes.onBoarding:
        return _fadeRoute(OnboardingScreen(), routeSettings);
      case SmartTaskAppRoutes.loginPage:
        return _fadeRoute(const LoginPage(), routeSettings);
      case SmartTaskAppRoutes.signUpPage:
        return _slideRoute(SignupPage(), routeSettings);
      case SmartTaskAppRoutes.addTask:
        return _slideRoute(AddTask(), routeSettings);
      case SmartTaskAppRoutes.homePage:
        return _slideRoute(HomePage(), routeSettings);
      case SmartTaskAppRoutes.settingsPage:
        return _slideRoute(UserInfoScreen(), routeSettings);
      default:
        return _fadeRoute(const LoginPage(), routeSettings);
    }
  }

  /// Route is not found, show error
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: const Center(
                child: Text("No Route"),
              ),
            ));
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
