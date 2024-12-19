import 'package:flutter/material.dart';
import 'events_page.dart';

class FriendsListPage extends StatelessWidget {
  final String currentUserId;

  FriendsListPage({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to Profile Page
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text('Create Your Own Event/List'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventsPage(userId: currentUserId),
                  ),
                );
              },
            ),
          ),
          // Add list of friends and events here dynamically
        ],
      ),
    );
  }
}
