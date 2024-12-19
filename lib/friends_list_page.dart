import 'package:flutter/material.dart';
import 'controllers/user_controller.dart';
import 'signin.dart';
import 'events_page.dart';

class FriendsListPage extends StatelessWidget {
  final String currentUserId;
  final UserController _userController = UserController();

  FriendsListPage({required this.currentUserId});

  final List<Map<String, dynamic>> friends = [
    {'id': 'friend1', 'name': 'John Doe', 'profilePicture': Icons.person},
    {'id': 'friend2', 'name': 'Jane Smith', 'profilePicture': Icons.person},
    {'id': 'friend3', 'name': 'Emily Johnson', 'profilePicture': Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await _userController.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SigninPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventsPage(userId: currentUserId),
                  ),
                );
              },
              child: Text(
                'View or Create My Events',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: friends.isEmpty
                ? Center(
                    child: Text(
                      'No friends found. Add some friends to get started!',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(friend['profilePicture']),
                          ),
                          title: Text(
                            friend['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Tap to view events'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventsPage(userId: friend['id']),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Add friends functionality coming soon!')),
          );
        },
        child: Icon(Icons.person_add),
        tooltip: 'Add Friends',
      ),
    );
  }
}
