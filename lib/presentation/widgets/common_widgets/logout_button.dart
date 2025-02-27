import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/core/network/api_client.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/login_screen/login_page.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if(authProvider.logoutState ==LogoutState.success)
          {

            getIt<ApiClient>().clearAuthToken();
            WidgetsBinding.instance.addPostFrameCallback((_){

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            });

          }

        return ElevatedButton.icon(
          onPressed: authProvider.logoutState == LogoutState.loading
              ? null
              : () => authProvider.logoutUser(),
          icon: authProvider.logoutState == LogoutState.loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: SmartTaskAppColors.primaryColor,
                  ),
                )
              : Icon(Icons.exit_to_app, size: 20),
          label: Text("Logout"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
