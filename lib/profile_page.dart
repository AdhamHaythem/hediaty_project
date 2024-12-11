import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController =
      TextEditingController(text: 'User Name');
  TextEditingController emailController =
      TextEditingController(text: 'user@example.com');
  bool notificationsEnabled = true;

  List<Map<String, dynamic>> userEvents = [
    {
      'name': 'My Birthday Party',
      'gifts': [
        {'name': 'Watch', 'category': 'Accessory', 'pledged': false},
        {'name': 'Book', 'category': 'Reading', 'pledged': true},
      ]
    },
    {
      'name': 'Anniversary Celebration',
      'gifts': [
        {'name': 'Flowers', 'category': 'Decoration', 'pledged': false}
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/myPledgedGifts');
            },
            child: Text(
              'My Pledged Gifts',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text('Personal Information',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() {
                notificationsEnabled = val;
              });
            },
          ),
          SizedBox(height: 20),
          Text('My Created Events',
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...userEvents.map((event) {
            return ExpansionTile(
              title: Text(event['name']),
              children: [
                ...event['gifts'].map<Widget>((gift) {
                  return ListTile(
                    title: Text(gift['name']),
                    subtitle: Text(gift['category']),
                    trailing: gift['pledged']
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.circle_outlined, color: Colors.grey),
                  );
                }).toList()
              ],
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save profile changes logic
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile Updated')),
          );
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
