import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/reponsive/responsive_screen.dart';

import 'components/sign_up_screen.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: SmartTaskAppColors.whiteColor,
        body: SingleChildScrollView(
          child: Responsive(
            mobile: SignUpScreen(),
          ),
        ),
      ),
    );
  }
}
