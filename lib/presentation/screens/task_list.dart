import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _isListening = false; // Prevent multiple WebSocket listeners

  @override
  void initState() {
    super.initState();
/*
    Future.delayed(Duration.zero, () {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasks(); // Fetch tasks once when screen loads

      if (!_isListening) {
        print("Starting WebSocket listener...");
        taskProvider.listenForTaskUpdates(); // Ensure WebSocket listens only once
        _isListening = true;
      }
    });
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    //final taskProvider = Provider.of<TaskProvider>(context);

    /*return Scaffold(
      appBar: AppBar(title: Text("Task List")),
      body: taskProvider.tasks.isEmpty
          ? Center(child: Text("No tasks available"))
          : ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          final taskId = task['id'];
          final isEditing = taskProvider.editingUsers.containsKey(taskId);
          final editingUser = taskProvider.editingUsers[taskId] ?? '';

          return ListTile(
            title: Text(task['title']),
            subtitle: isEditing
                ? Text("$editingUser is editing...",
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold))
                : Text(task['description'] ?? "No description"),
            onTap: () {
              if (!taskProvider.editingUsers.containsKey(taskId)) {
                print("Starting editing for task $taskId...");
                taskProvider.startEditingTask(taskId, "John Doe");
              } else {
                print("Task $taskId is already being edited.");
              }
            },
          );
        },
      ),
    );
    */
  }
}

