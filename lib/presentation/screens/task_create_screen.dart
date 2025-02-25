import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_list_screen.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  _TaskCreateScreenState createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  List<int> selectedUserIds = [];

  void _selectUser(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserListScreen(
          onUserSelected: (userId) {
            setState(() {
              if (!selectedUserIds.contains(userId)) {
                selectedUserIds.add(userId);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
   // final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Create Task')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Task Title')),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: deadlineController, decoration: InputDecoration(labelText: 'Deadline (YYYY-MM-DD)')),
            TextField(controller: colorController, decoration: InputDecoration(labelText: 'Task Color (HEX)')),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectUser(context),
              child: Text('Select Users'),
            ),
            SizedBox(height: 10),
            Text("Selected Users: ${selectedUserIds.join(', ')}"), // ✅ Show selected users
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                /*await taskProvider.createTask(
                  titleController.text,
                  descriptionController.text,
                  deadlineController.text,
                  colorController.text,
                  selectedUserIds, // ✅ Send selected users
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task Created Successfully")));
                Navigator.pop(context);*/
              },
              child: Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
