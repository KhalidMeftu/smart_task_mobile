import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_colors/app_colors.dart';
import 'package:smart_mobile_app/common/app_ui_configs/app_strings/app_strings.dart';
import 'package:smart_mobile_app/common/routes/app_routes.dart';
import 'package:smart_mobile_app/common/utils/functions/utils_functions.dart';
import 'package:smart_mobile_app/presentation/providers/tasks_provider.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/common_appbar/smart_task_appbar.dart';
import 'package:smart_mobile_app/presentation/widgets/common_widgets/display_tasks_ui.dart';
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
      appBar:  CustomAppBar(isSettingsPage: false,),
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
                hintText: SmartStrings.searchTasks,
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


}
