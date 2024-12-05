import 'package:flutter/material.dart';

class FriendsListPage extends StatelessWidget {
  final List<Map<String, String>> friends = [
    {'name': 'John Doe', 'profilePic': 'assets/profile_placeholder.png'},
    {'name': 'Jane Smith', 'profilePic': 'assets/profile_placeholder.png'},
    {'name': 'Alex Brown', 'profilePic': 'assets/profile_placeholder.png'},
    // Add more friends here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(friend['profilePic']!),
            ),
            title: Text(friend['name']!),
            trailing: IconButton(
              icon: Icon(Icons.message, color: Colors.blue),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Messaging ${friend['name']}'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            onTap: () {
              // Navigate to friend's profile or gift list page (if implemented)
            },
          );
        },
      ),
    );
  }
}
