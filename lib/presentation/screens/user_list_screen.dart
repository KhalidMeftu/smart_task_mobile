import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';

class UserListScreen extends StatefulWidget {
  final Function(int) onUserSelected;

  UserListScreen({required this.onUserSelected});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await _apiClient.get('/users'); // ✅ Uses `ApiClient`
      setState(() {
        users = List<Map<String, dynamic>>.from(response.data);
      });
    } catch (e) {
      print("Error fetching users: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to fetch users")));
    }
  }

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
              widget.onUserSelected(users[index]['id']);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
