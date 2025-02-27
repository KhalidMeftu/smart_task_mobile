import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/domain/entity/responses/login_response.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/common_appbar/smart_task_appbar.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Two-Factor Authentication Toggle
          SwitchListTile(
            title: Text('Two-Factor Authentication'),
            value: _twoFactorAuth == 1, // Convert to bool for Switch
            onChanged: (value) {
              setState(() {
                _twoFactorAuth = value ? 1 : 0; // Convert back to int
              });
            },
          ),

          // Theme Mode Radio Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Theme Mode'),
              RadioListTile<String>(
                title: Text('Light'),
                value: 'light',
                groupValue: _themeMode,
                onChanged: (value) {
                  setState(() {
                    _themeMode = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Dark'),
                value: 'dark',
                groupValue: _themeMode,
                onChanged: (value) {
                  setState(() {
                    _themeMode = value!;
                  });
                },
              ),
            ],
          ),

          // Notifications Toggle
          SwitchListTile(
            title: Text('Notifications'),
            value: _notifications == 1, // Convert to bool for Switch
            onChanged: (value) {
              setState(() {
                _notifications = value ? 1 : 0; // Convert back to int
              });
            },
          ),

          // Update Button
          ElevatedButton(
            onPressed: () {
              /*final updatedUser = User(
                id: widget.user.id,
                name: widget.user.name,
                email: widget.user.email,
                preferences: UserPreferences(
                  id: widget.user.preferences.id,
                  userId: widget.user.preferences.userId,
                  twoFactorAuth: _twoFactorAuth,
                  themeMode: _themeMode,
                  notifications: _notifications,
                  createdAt: widget.user.preferences.createdAt,
                  updatedAt: widget.user.preferences.updatedAt,
                ),
              );*/

              //context.read<UserInfoProvider>().saveUserInfo(updatedUser);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}

