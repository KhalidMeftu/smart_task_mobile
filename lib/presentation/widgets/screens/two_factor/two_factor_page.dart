import 'package:flutter/material.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_strings/app_strings.dart';
import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/domain/entity/responses/prefs.dart';
import 'package:smart_mobile_app/presentation/providers/user_info_provider.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/common_appbar/smart_task_appbar.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/dashboard/home_page.dart';


class TwoFactorVerificationScreen extends StatefulWidget {
  final String userId;
  const TwoFactorVerificationScreen({super.key, required this.userId});

  @override
  _TwoFactorVerificationScreenState createState() => _TwoFactorVerificationScreenState();
}

class _TwoFactorVerificationScreenState extends State<TwoFactorVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;

  void _verify2FA() async {
    setState(() => isLoading = true);

    final apiService = getIt<ApiClient>();
    final userProvider = getIt<UserInfoProvider>();

    try {
      final response = await apiService.post('/verify-2fa', data: {
        'user_id': widget.userId,
        'code': _codeController.text.trim(),
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await apiService.setAuthToken(token);

        final userData = PreferencesData.fromJson(response.data);
        await userProvider.saveUserInfos(userData);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(SmartStrings.invalid2FACode)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${SmartStrings.errorText}${e.toString()}")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartTaskAppColors.whiteColor,
      appBar:  CustomAppBar(isSettingsPage: false,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Center(child: Text(SmartStrings.enterSixDigitCode,maxLines: 2,
               overflow: TextOverflow.ellipsis, style: SmartTaskFonts.medium(),)),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: SmartStrings.twoFactorCode,
              ),
            ),
            const SizedBox(height: 20),

            CustomButton(
              onTap: () => isLoading ? null : _verify2FA,
              text: SmartStrings.verify,
              bgColor: SmartTaskAppColors.buttonBackGroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
