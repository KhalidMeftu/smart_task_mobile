import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/new_presentation/presentation/screens/tasks/addtask/add_task.dart';
import 'package:smart_mobile_app/presentation/providers/authentication_token_provider.dart';

import 'login_screen/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthTokenProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.token != null) {
          return AddTask();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
