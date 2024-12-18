import 'package:flutter/material.dart';

class FriendsListPage extends StatelessWidget {
  final List<Map<String, dynamic>> friends = [
    {
      'name': 'John Doe',
      'profilePicture': Icons.person,
      'events': 0,
    },
    {
      'name': 'Jane Smith',
      'profilePicture': Icons.person,
      'events': 2,
    },
    {
      'name': 'Emily Johnson',
      'profilePicture': Icons.person,
      'events': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Placeholder for search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Button to Create a New Event or Gift List
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Placeholder for create event/list functionality
              },
              child: Text('Create Your Own Event/List'),
            ),
          ),
          // Friends List
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(friend['profilePicture']),
                    ),
                    title: Text(friend['name']),
                    subtitle: Text(
                      friend['events'] > 0
                          ? 'Upcoming Events: ${friend['events']}'
                          : 'No Upcoming Events',
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to friend's gift list
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Placeholder(), // Replace with friend's gift list page
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button for Adding Friends
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for add friends functionality
        },
        child: Icon(Icons.person_add),
        tooltip: 'Add Friends',
      ),
    );
  }
}
