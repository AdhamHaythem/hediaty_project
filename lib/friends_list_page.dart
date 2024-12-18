import 'package:flutter/material.dart';

class FriendsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('John Doe'),
              subtitle: Text('No Upcoming Events'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Jane Smith'),
              subtitle: Text('Upcoming Events: 1'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.person_add),
      ),
    );
  }
}
