import 'package:flutter/material.dart';
import 'events_page.dart';
import 'profile_page.dart';
import '../controllers/user_controller.dart';

class FriendsListPage extends StatefulWidget {
  final String currentUserId;

  FriendsListPage({required this.currentUserId});

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  final TextEditingController searchController = TextEditingController();
  final UserController _userController = UserController();

  List<Map<String, dynamic>> friends = [];
  List<Map<String, dynamic>> friendRequests = [];

  @override
  void initState() {
    super.initState();
    _loadFriendsAndRequests();
  }

  Future<void> _loadFriendsAndRequests() async {
    final fetchedFriends =
        await _userController.fetchFriendsWithEvents(widget.currentUserId);
    final fetchedRequests =
        await _userController.fetchFriendRequests(widget.currentUserId);

    setState(() {
      friends = fetchedFriends;
      friendRequests = fetchedRequests;
    });
  }

  void _sendFriendRequest() async {
    final username = searchController.text.trim();
    if (username.isNotEmpty) {
      await _userController.sendFriendRequest(widget.currentUserId, username);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request sent to $username!')),
      );
      searchController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username.')),
      );
    }
  }

  void _handleRequest(String senderUserId, bool isAccepted) async {
    await _userController.handleFriendRequest(
        widget.currentUserId, senderUserId, isAccepted);
    _loadFriendsAndRequests();
  }

  void _navigateToEvents(String userId, String ownerId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventsPage(userId: userId, ownerId: ownerId),
      ),
    );
  }

  void _navigateToMyEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventsPage(
            userId: widget.currentUserId, ownerId: widget.currentUserId),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _userController.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Friend Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Add Friend by Username',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.person_add),
                          onPressed: _sendFriendRequest,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // View or Create My Events Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _navigateToMyEvents,
                child: Text(
                  'View or Create My Events',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Friend Requests Section
            if (friendRequests.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Friend Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: friendRequests.length,
                    itemBuilder: (context, index) {
                      final request = friendRequests[index];
                      return Card(
                        child: ListTile(
                          title: Text(request['username']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () =>
                                    _handleRequest(request['id'], true),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    _handleRequest(request['id'], false),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 32, thickness: 1),
                ],
              ),

            // Friends List Section
            if (friends.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Friends',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(friend['username']),
                              subtitle: Text(
                                  '${friend['upcomingEvents']} Upcoming Events'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                _navigateToEvents(
                                  widget.currentUserId,
                                  friend['id'], // Friend's ID as ownerId
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            // Empty State
            if (friends.isEmpty && friendRequests.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Friends Yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start adding friends to share events!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
