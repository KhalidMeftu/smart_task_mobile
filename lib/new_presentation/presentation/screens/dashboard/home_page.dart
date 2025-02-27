import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/routes/app_routes.dart';
import 'package:smart_mobile_app/common/utils/functions/utils_functions.dart';
import 'package:smart_mobile_app/core/services/app_local_storage%20services.dart';
import 'package:smart_mobile_app/dependency_injection.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/common_appbar/smart_task_appbar.dart';
import 'package:smart_mobile_app/new_presentation/presentation/common_widgets/display_tasks_ui.dart';
import 'package:smart_mobile_app/presentation/providers/auth_provider.dart';
import 'package:smart_mobile_app/presentation/providers/tasks_provider.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getToken();
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartTaskAppColors.whiteColor,
      appBar:  CustomAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: SmartTaskAppColors.onboardThirdColor,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

      Expanded(
        child: Consumer<TaskProvider>(
          builder: (context, provider, child) {
            if (provider.tasks.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            final filteredTasks = provider.tasks.where((task) {
              return task.title.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
                  task.description.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  );
            }).toList().reversed.toList();

            return ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final isEditing = provider.editingTasks.containsKey(task.id);
                final editorName = provider.editingTasks[task.id] ?? '';

                return DisplayTasksUI(
                  title: task.title,
                  description: task.description,
                  urgencyLevel: task.status.toString(),
                  deadline: task.endDate.toString(),
                  userInitials: getUserInitials(task.users!),
                  isEditing: isEditing,
                  editorName: editorName,
                );
              },
            );
          },
        ),
      ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SmartTaskAppRoutes.addTask);
        },
        child:
        Icon(Icons.add, size: 30, color: SmartTaskAppColors.primaryColor),
      ),
    );
  }

  Future<void> getToken() async {
    try {
      final token = await getFcmToken();

      if (token == null) {
        if (kDebugMode)
          print("FCM Token is null, skipping update.");
        return;
      }

      if (kDebugMode)
        print("FCM Token: $token");

      final storageService = getIt<SmartLocalStorageServices>();
      final storedFcmToken = await storageService.getData('firebaseToken');

      if (token == storedFcmToken) {
        if (kDebugMode)
          print("FCM Token is already up to date, no API call needed.");
        return;
      }


      final authProvider = getIt<AuthProvider>();
      await authProvider.sendFcmToken(token);
      await storageService.setFirbaseToken(token);

      if (kDebugMode) print("FCM Token updated successfully.");
    } catch (e) {
      if (kDebugMode) print("Error fetching FCM Token: $e");
    }
  }

}
