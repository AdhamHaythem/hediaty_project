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
  int _currentIndex = 0;
  String _appBarTitle = 'Friends List';
  String username = "";
  String email = "";

  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _loadFriendsAndRequests();
    setState(() {
      _pages = [
        _buildFriendsList(),
        EventsPage(
            userId: widget.currentUserId,
            ownerId: widget.currentUserId,
            NavBar: true),
        ProfilePage(
          userId: widget.currentUserId,
          username: username,
          email: email,
        ),
      ];
    });
  }

  Future<void> _loadUserData() async {
    try {
      final userData =
          await _userController.fetchUserDetails(widget.currentUserId);
      setState(() {
        username = userData['username'] ?? "Your Username";
        email = userData['email'] ?? "your-email@example.com";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _loadFriendsAndRequests() async {
    try {
      final fetchedFriends =
          await _userController.fetchFriendsWithEvents(widget.currentUserId);
      final fetchedRequests =
          await _userController.fetchFriendRequests(widget.currentUserId);

      setState(() {
        friends = fetchedFriends;
        friendRequests = fetchedRequests;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load friends: $e')),
      );
    }
  }

  void _sendFriendRequest() async {
    final username = searchController.text.trim();
    if (username.isNotEmpty) {
      try {
        await _userController.sendFriendRequest(widget.currentUserId, username);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend request sent to $username!')),
        );
        searchController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username.')),
      );
    }
  }

  void _handleRequest(String senderUserId, bool isAccepted) async {
    try {
      await _userController.handleFriendRequest(
          widget.currentUserId, senderUserId, isAccepted);
      _loadFriendsAndRequests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to handle request: $e')),
      );
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _appBarTitle = index == 0
          ? 'Friends List'
          : index == 1
              ? 'My Events'
              : 'Profile';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: _pages == null
          ? Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: _pages!,
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
          if (friends.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(friend['username']),
                      subtitle:
                          Text('${friend['upcomingEvents']} Upcoming Events'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventsPage(
                              userId: widget.currentUserId,
                              ownerId: friend['id'],
                              friendusername: friend['username'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
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
    );
  }
}
