import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'gift_details_page.dart';

class GiftListPage extends StatefulWidget {
  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  final _database = FirebaseDatabase.instance.ref('gifts');

  void _addGift() {
    final newGiftRef = _database.push();
    newGiftRef.set({
      'id': newGiftRef.key,
      'name': 'New Gift',
      'status': 'available',
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pledged':
        return Colors.green.shade200;
      case 'purchased':
        return Colors.red.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gift List'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _database.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              (snapshot.data!.snapshot.value as Map?) == null) {
            return Center(child: Text('No gifts available.'));
          }

          final gifts = (snapshot.data!.snapshot.value as Map)
              .values
              .toList()
              .cast<Map>();

          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              final statusColor = _getStatusColor(gift['status']);

              return Card(
                color: statusColor,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(gift['name']),
                  subtitle: Text('Status: ${gift['status']}'),
                  trailing: DropdownButton<String>(
                    value: gift['status'],
                    items: ['available', 'pledged', 'purchased']
                        .map((status) => DropdownMenuItem(
                            value: status, child: Text(status.toUpperCase())))
                        .toList(),
                    onChanged: (newStatus) {
                      _database.child(gift['id']).update({'status': newStatus});
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftDetailsPage(gift: gift),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGift,
        child: Icon(Icons.add),
      ),
    );
  }
}
