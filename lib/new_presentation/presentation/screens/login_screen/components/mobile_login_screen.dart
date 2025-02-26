import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_paddings/app_paddings.dart';
import 'package:smart_mobile_app/common/routes/app_routes.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_image_viewer/custom_image_view.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_textfield/custom_text_field.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final authProvider = getIt<AuthProvider>();
      bool success = await authProvider.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() => isLoading = false);

      if (success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, SmartTaskAppRoutes.homePage);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SmartTaskPaddings.s16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 50),
          CustomImageView(
              imagePath: 'assets/images/login_signup_header_image.png'),
          Center(
            child: Text(
              "Smart Task Management",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: SmartTaskFonts.medium().copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  required: true,
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: SmartTaskPaddings.s16),
                  child: CustomTextField(
                    required: true,
                    hintText: 'Password',
                    controller: passwordController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: SmartTaskPaddings.s16),
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onTap: _login,
                        text: "Login",
                        bgColor: SmartTaskAppColors.buttonBackGroundColor,
                      ),
                const SizedBox(height: SmartTaskPaddings.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don’t have an Account? ",
                      style: TextStyle(color: SmartTaskAppColors.primaryColor),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, SmartTaskAppRoutes.signUpPage),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: SmartTaskAppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
