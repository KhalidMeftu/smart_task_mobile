import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/custom_uis/custom_divider.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/domain/entity/responses/prefs.dart';
import 'package:smart_mobile_app/presentation/providers/theme_provider.dart';
import 'package:smart_mobile_app/presentation/providers/user_info_provider.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/common_appbar/smart_task_appbar.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/custom_button/custom_button.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/logout_button.dart';
import 'package:smart_mobile_app/presentation/widgets/screens/two_factor/enable_two_fa_screen.dart';


class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartTaskAppColors.whiteColor,
      appBar:  CustomAppBar(isSettingsPage: true),
      body: Consumer<UserInfoProvider>(
        builder: (context, provider, child) {
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
  final PreferencesData user;

  const _UserInfoForm({required this.user});

  @override
  __UserInfoFormState createState() => __UserInfoFormState();
}

class __UserInfoFormState extends State<_UserInfoForm> {
  late int _twoFactorAuth;
  late String _themeMode;
  late int _notifications;

  late String _initialThemeMode;
  late int _initialNotifications;

  // Only theme and notifications now determine _hasChanges:
  bool get _hasChanges =>
      _themeMode != _initialThemeMode ||
          _notifications != _initialNotifications;

  @override
  void initState() {
    super.initState();
    _twoFactorAuth = widget.user.user.preferences!.twoFactorAuth;
    _themeMode = widget.user.user.preferences!.themeMode;
    _notifications = widget.user.user.preferences!.notifications;

    _initialThemeMode = _themeMode;
    _initialNotifications = _notifications;
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
    Provider.of<UserInfoProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider.setDarkMode(_themeMode == 'dark');
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Two-Factor Authentication'),
            value: _twoFactorAuth == 1,
            onChanged: (value) async {
              setState(() {
                _twoFactorAuth = value ? 1 : 0;
              });
              // Immediately update 2FA without needing the Update button:
              await userInfoProvider.updateUserInfo(
                _twoFactorAuth == 1,
                _themeMode,
                _notifications == 1,
              );
              await userInfoProvider.fetchUserInfo();
            },
          ),
          CustomDivider(),

          SwitchListTile(
            title: const Text('Notifications'),
            value: _notifications == 1,
            onChanged: (value) {
              setState(() {
                _notifications = value ? 1 : 0;
                print("Notification Value Updated: $_notifications");
              });
              if (_notifications == 1) {
                print("Navigating to Enable2FAScreen");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Enable2FAScreen()),
                );
              }
            },
          ),
          CustomDivider(),

          // Dark mode toggle
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Consumer<ThemeProvider>(
                builder: (context, darkModeProvider, child) {
                  return GestureDetector(
                    onTap: () {
                      darkModeProvider.toggleDarkMode();
                      setState(() {
                        _themeMode =
                        darkModeProvider.isDarkMode ? 'dark' : 'light';
                      });
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
          CustomDivider(),

          Align(
            alignment: Alignment.centerRight,
              child: LogoutButton()),
          CustomDivider(),

          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                onTap: () => updateUserInfo(userInfoProvider),
                text: "Update",
                bgColor: SmartTaskAppColors.buttonBackGroundColor,
              ),
            ),
        ],
      ),
    );
  }

  void updateUserInfo(UserInfoProvider userInfoProvider) async {
    await userInfoProvider.updateUserInfo(
      _twoFactorAuth == 1,
      _themeMode,
      _notifications == 1,
    );
    await userInfoProvider.fetchUserInfo();
    setState(() {
      _initialThemeMode = _themeMode;
      _initialNotifications = _notifications;
    });
  }
}


