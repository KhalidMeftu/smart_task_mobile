import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Login')),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await authProvider.login(emailController.text, passwordController.text);
                  },
                  child: authProvider.isLoading ? CircularProgressIndicator() : Text('Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
