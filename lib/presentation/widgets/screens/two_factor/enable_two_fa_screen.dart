import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_strings/app_strings.dart';
import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/common_appbar/smart_task_appbar.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/two_factor/two_factor_page.dart';

class Enable2FAScreen extends StatefulWidget {
  const Enable2FAScreen({super.key});

  @override
  _Enable2FAScreenState createState() => _Enable2FAScreenState();
}

class _Enable2FAScreenState extends State<Enable2FAScreen> {
  String? qrCode;
  String? secretKey;
  bool isLoading = false;
  String? userID;

  @override
  void initState() {
    super.initState();
    _enable2FA();
  }

  Future<void> _enable2FA() async {
    setState(() => isLoading = true);

    final apiService = GetIt.I<ApiClient>();
    userID= await apiService.getUserID();

    try {
      final response = await apiService.post('/enable-2fa');

      if (response.statusCode == 200) {
        setState(() {
          qrCode = response.data['google2fa_qr'];
          secretKey = response.data['google2fa_secret'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(SmartStrings.failedToLoad2FA)),
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
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : qrCode == null
              ?  Text("Failed to generate QR Code", style: SmartTaskFonts.medium().copyWith(color:SmartTaskAppColors.redColor))
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                "Scan this QR Code in Google Authenticator",
                textAlign: TextAlign.center,
                 style: SmartTaskFonts.medium(),
              ),
              const SizedBox(height: 10),
              Image.memory(
                Uri.parse(qrCode!).data!.contentAsBytes(),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 10),
              const Text("Or manually enter this secret key:"),
              SelectableText(
                secretKey!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),


              CustomButton(
                onTap: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TwoFactorVerificationScreen(userId: userID!),
                  ),
                ),
                text: "Continue to Verification",
                bgColor: SmartTaskAppColors.buttonBackGroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
