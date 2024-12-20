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
  String username = "";
  String email = "";
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _loadFriendsAndRequests();
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
      _showErrorDialog('Failed to load user data: $e');
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
      _showErrorDialog('Failed to load friends: $e');
    }
  }

  void _handleRequest(String senderUserId, bool isAccepted) async {
    try {
      await _userController.handleFriendRequest(
          widget.currentUserId, senderUserId, isAccepted);
      await _loadFriendsAndRequests();
    } catch (e) {
      _showErrorDialog('Failed to handle request: $e');
    }
  }

  void _sendFriendRequest() async {
    final username = searchController.text.trim();
    if (username.isEmpty) {
      _showErrorDialog('Please enter a username.');
      return;
    }

    if (friends.any((friend) => friend['username'] == username)) {
      _showErrorDialog('$username is already your friend.');
      return;
    }
    if (friendRequests.any((request) => request['username'] == username)) {
      _showErrorDialog('Friend request to $username is already pending.');
      return;
    }

    try {
      await _userController.sendFriendRequest(widget.currentUserId, username);
      _showSuccessDialog('Friend request sent to $username!');
      searchController.clear();
      await _loadFriendsAndRequests();
    } catch (e) {
      _showErrorDialog('Failed to send request: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildFriendsList(),
          EventsPage(
            userId: widget.currentUserId,
            ownerId: widget.currentUserId,
            NavBar: true,
          ),
          ProfilePage(
            userId: widget.currentUserId,
            username: username,
            email: email,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurpleAccent,
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

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Friends List';
      case 1:
        return 'My Events';
      case 2:
        return 'Profile';
      default:
        return 'App';
    }
  }

  Widget _buildFriendsList() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ListView(
            children: [
              if (friendRequests.isNotEmpty) _buildFriendRequestsSection(),
              if (friends.isNotEmpty) _buildFriendsListSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search Friends',
            prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
            suffixIcon: IconButton(
              icon: Icon(Icons.person_add, color: Colors.deepPurple),
              onPressed: _sendFriendRequest,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Friend Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: friendRequests.length,
          itemBuilder: (context, index) {
            final request = friendRequests[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(request['username']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _handleRequest(request['id'], true),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _handleRequest(request['id'], false),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFriendsListSection() {
    return Column(
      children: [
        if (friendRequests.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              thickness: 1.0,
              color: Colors.grey,
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Text(
                    friend['username'][0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(friend['username']),
                subtitle: Text('${friend['upcomingEvents']} Upcoming Events'),
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
      ],
    );
  }
}
