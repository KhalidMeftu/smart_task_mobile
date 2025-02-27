import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/domain/entity/responses/login_response.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/common_appbar/smart_task_appbar.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/presentation/providers/theme_provider.dart';
import 'package:smart_mobile_app/presentation/providers/user_info_provider.dart';


class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartTaskAppColors.whiteColor,
      appBar:  CustomAppBar(),
      body: Consumer<UserInfoProvider>(
        builder: (context, provider, child) {
          print("User Info");
          print(provider.user!.preferences!.notifications);
          if (provider.state == UserInfoState.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.state == UserInfoState.error) {
            return Center(child: Text(provider.errorMessage ?? 'An error occurred'));
          }

          if (provider.user == null) {
            return Center(child: Text('No user data found'));
          }

          return _UserInfoForm(user: provider.user!);
        },
      ),
    );
  }
}

class _UserInfoForm extends StatefulWidget {
  final User user;

  const _UserInfoForm({required this.user});

  @override
  __UserInfoFormState createState() => __UserInfoFormState();
}

class __UserInfoFormState extends State<_UserInfoForm> {
  late int _twoFactorAuth;
  late String _themeMode;
  late int _notifications;

  @override
  void initState() {
    super.initState();
    _twoFactorAuth = widget.user.preferences!.twoFactorAuth;
    _themeMode = widget.user.preferences!.themeMode;
    _notifications = widget.user.preferences!.notifications;
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_themeMode == 'dark') {
        themeProvider.setDarkMode(true);
      } else {
        themeProvider.setDarkMode(false);
      }
    });
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 10,
        children: [
          SwitchListTile(
            title: Text('Two-Factor Authentication'),
            value: _twoFactorAuth == 1,
            onChanged: (value) {
              setState(() {
                _twoFactorAuth = value ? 1 : 0;
              });
            },
          ),


          // Notifications Toggle
          SwitchListTile(
            title: Text('Notifications'),
            value: _notifications == 1,
            onChanged: (value) {
              setState(() {
                _notifications = value ? 1 : 0;
              });
            },
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Consumer<ThemeProvider>(
                builder: (context, darkModeProvider, child) {

                  return GestureDetector(
                    onTap: () {
                      darkModeProvider.toggleDarkMode();
                    },
                    child: Icon(
                      darkModeProvider.isDarkMode
                          ? Icons.wb_sunny
                          : Icons.nights_stay,
                      color: SmartTaskAppColors.primaryColor,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onTap:  () => updateUserInfo(userInfoProvider),
              text: "Update",
              bgColor: SmartTaskAppColors.buttonBackGroundColor,
            ),
          )
        ],
      ),
    );
  }

  updateUserInfo(UserInfoProvider userInfoProvider) {
    userInfoProvider.updateUserInfo(_twoFactorAuth==1?true:false,_themeMode,_notifications==1?true:false);
    userInfoProvider.fetchUserInfo();
  }
}

