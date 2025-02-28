import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_paddings/app_paddings.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_resources/app_resources.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_strings/app_strings.dart';
import 'package:smart_mobile_app/common/routes/app_routes.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_image_viewer/custom_image_view.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_textfield/custom_text_field.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != repeatPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(SmartStrings.passwordNotMatching)),
        );
        return;
      }

      setState(() => isLoading = true);

      final authProvider = getIt<AuthProvider>();
      bool success = await authProvider.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() => isLoading = false);

      if (success) {
        Navigator.pushReplacementNamed(context, SmartTaskAppRoutes.homePage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(SmartStrings.registartionFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SmartTaskPaddings.s16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          CustomImageView(imagePath: SmartTaskAssets.loginSignUpImage),
          Center(
            child: Text(
              SmartStrings.smartText,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  required: true,
                  hintText: 'Full Name',
                  controller: nameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: SmartTaskPaddings.s16),
                CustomTextField(
                  required: true,
                  hintText: SmartStrings.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: SmartTaskPaddings.s16),
                CustomTextField(
                  required: true,
                  hintText: SmartStrings.password,
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: SmartTaskPaddings.s16),
                CustomTextField(
                  required: true,
                  hintText: SmartStrings.repeatPassword,
                  controller: repeatPasswordController,
                  isPassword: true,
                ),
                const SizedBox(height: SmartTaskPaddings.s16),
                CustomButton(
                  onTap: isLoading ? null : _register,
                  text: isLoading ? SmartStrings.registering : SmartStrings.register,
                  bgColor: SmartTaskAppColors.buttonBackGroundColor,
                ),
                const SizedBox(height: SmartTaskPaddings.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      SmartStrings.alreadyHaveAccount,
                      style: SmartTaskFonts.medium().copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: SmartTaskAppColors.primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SmartTaskAppRoutes.loginPage);
                      },
                      child: Text(
                       SmartStrings.login,
                        style: SmartTaskFonts.medium().copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SmartTaskAppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

