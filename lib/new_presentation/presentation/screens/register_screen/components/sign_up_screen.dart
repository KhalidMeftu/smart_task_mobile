import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_paddings/app_paddings.dart';
import 'package:smart_mobile_app/common/routes/app_routes.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_image_viewer/custom_image_view.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_textfield/custom_text_field.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: SmartTaskPaddings.s16, right: SmartTaskPaddings.s16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CustomImageView(
            imagePath: 'assets/images/login_signup_header_image.png',
          ),

          Center(
            child: Text(
              "Smart Task Management",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: SmartTaskFonts.medium().copyWith(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: SmartTaskPaddings.s16,
              children: [
                CustomTextField(
                  required: true,
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  required: true,
                  hintText: 'Password',
                  controller: passwordController,
                  isPassword: true,
                ),
                CustomTextField(
                  required: true,
                  hintText: 'Repeat Password',
                  controller: repeatPasswordController,
                  isPassword: true,
                ),
                CustomButton(
                  onTap: () {},
                  text: "Register",
                  bgColor: SmartTaskAppColors.buttonBackGroundColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Do you Have Account ? ",
                      style: SmartTaskFonts.medium().copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: SmartTaskAppColors.primaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, SmartTaskAppRoutes.loginPage);
                      },
                      child: Text(
                        "Login",
                        style: SmartTaskFonts.medium().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: SmartTaskAppColors.primaryColor),
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
