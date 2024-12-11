import 'package:flutter/material.dart';

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final List<Map<String, dynamic>> friends = [
    {
      'name': 'John Doe',
      'profilePic': 'assets/profile_placeholder.png',
      'upcomingEvents': 1
    },
    {
      'name': 'Jane Smith',
      'profilePic': 'assets/profile_placeholder.png',
      'upcomingEvents': 0
    },
    {
      'name': 'Alex Brown',
      'profilePic': 'assets/profile_placeholder.png',
      'upcomingEvents': 2
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredFriends = friends.where((friend) {
      final name = friend['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

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
                Navigator.pushNamed(context, '/events');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search friends...',
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                final eventCount = friend['upcomingEvents'] as int;
                final eventText = eventCount > 0
                    ? 'Upcoming Events: $eventCount'
                    : 'No Upcoming Events';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(friend['profilePic']!),
                  ),
                  title: Text(friend['name']!),
                  subtitle: Text(eventText),
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
                    // Navigate to gift list page for this friend’s events
                    Navigator.pushNamed(context, '/giftList');
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          // Add friends logic
        },
      ),
    );
  }
}
