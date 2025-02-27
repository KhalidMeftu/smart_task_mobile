import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_fonts/app_fonts.dart';
import 'package:smart_mobile_app/common/routes/app_routes.dart';
import 'package:smart_mobile_app/common/utils/enums/smart_app_enums.dart';
import 'package:smart_mobile_app/presentation/providers/user_info_provider.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    return AppBar(
      title: FutureBuilder(
        future: userInfoProvider.fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {

            return Text("");
          } else if (userInfoProvider.state == UserInfoState.success &&
              userInfoProvider.user != null) {
            return Text("Welcome, ${userInfoProvider.user!.name}", style: SmartTaskFonts.medium(),);
          } else {
            return Text("Welcome",style: SmartTaskFonts.medium(),);
          }
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, SmartTaskAppRoutes.settingsPage);
          },
        ),
      ],
    );
  }
}
