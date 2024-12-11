import 'package:flutter/material.dart';

class MyPledgedGiftsPage extends StatefulWidget {
  @override
  _MyPledgedGiftsPageState createState() => _MyPledgedGiftsPageState();
}

class _MyPledgedGiftsPageState extends State<MyPledgedGiftsPage> {
  List<Map<String, dynamic>> pledgedGifts = [
    {
      'name': 'Headphones',
      'friendName': 'John Doe',
      'dueDate': DateTime.now().add(Duration(days: 7)),
      'pledged': true,
      'modifiable': true
    },
    {
      'name': 'Book',
      'friendName': 'Jane Smith',
      'dueDate': DateTime.now().add(Duration(days: 3)),
      'pledged': true,
      'modifiable': false
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pledged Gifts'),
      ),
      body: ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];
          return ListTile(
            title: Text(gift['name']),
            subtitle: Text(
                'For: ${gift['friendName']} • Due: ${gift['dueDate'].toLocal().toString().split(' ')[0]}'),
            trailing: gift['modifiable']
                ? IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editPledgedGift(gift);
                    },
                  )
                : Icon(Icons.lock, color: Colors.grey),
          );
        },
      ),
    );
  }

  void _editPledgedGift(Map<String, dynamic> gift) {
    final nameController = TextEditingController(text: gift['name']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Pledged Gift'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Gift Name'),
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  gift['name'] = nameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }
}
