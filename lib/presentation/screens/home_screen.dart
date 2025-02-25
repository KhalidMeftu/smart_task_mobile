import 'package:flutter/material.dart';
import 'package:smart_mobile_app/presentation/screens/task_list.dart';
import 'task_create_screen.dart';
import 'user_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskCreateScreen()),
                );
              },
              child: Text("Create Task"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListScreen()),
                );
              },
              child: Text("View Tasks"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListScreen(
                    onUserSelected: (userId) {
                      print("Selected User ID: $userId");
                    },
                  )),
                );
              },
              child: Text("View Users"),
            ),
          ],
        ),
      ),
    );
  }
}
