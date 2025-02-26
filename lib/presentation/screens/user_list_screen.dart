import 'package:flutter/material.dart';

class UserListScreen extends StatelessWidget {
  final Function(int) onUserSelected;

  UserListScreen({super.key, required this.onUserSelected});

  List<Map<String, dynamic>> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select User')),
      body: users.isEmpty
          ? Center(child: Text("No users available"))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['name']),
                  subtitle: Text(users[index]['email']),
                  onTap: () {
                    onUserSelected(users[index]['id']);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}
