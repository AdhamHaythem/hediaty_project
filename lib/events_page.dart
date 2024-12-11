import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Map<String, dynamic>> events = [
    {
      'name': 'Birthday Party',
      'category': 'Personal',
      'status': 'Upcoming',
    },
    {
      'name': 'Conference',
      'category': 'Work',
      'status': 'Current',
    },
    {
      'name': 'Past Meetup',
      'category': 'Social',
      'status': 'Past',
    },
  ];

  String selectedSort = 'name';

  @override
  Widget build(BuildContext context) {
    final sortedEvents = List<Map<String, dynamic>>.from(events);
    sortedEvents.sort((a, b) => a[selectedSort].compareTo(b[selectedSort]));

    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedSort = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              PopupMenuItem(value: 'category', child: Text('Sort by Category')),
              PopupMenuItem(value: 'status', child: Text('Sort by Status')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sortedEvents.length,
        itemBuilder: (context, index) {
          final event = sortedEvents[index];
          return ListTile(
            title: Text(event['name']),
            subtitle: Text('${event['category']} • ${event['status']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _editEvent(event);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      events.remove(event);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addEvent() {
    _showEventDialog(isEdit: false);
  }

  void _editEvent(Map<String, dynamic> event) {
    _showEventDialog(isEdit: true, currentEvent: event);
  }

  void _showEventDialog(
      {required bool isEdit, Map<String, dynamic>? currentEvent}) {
    final nameController =
        TextEditingController(text: currentEvent?['name'] ?? '');
    final categoryController =
        TextEditingController(text: currentEvent?['category'] ?? '');
    final statusController =
        TextEditingController(text: currentEvent?['status'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Event' : 'Add Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(
                      labelText: 'Status (Upcoming/Current/Past)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(isEdit ? 'Save' : 'Add'),
              onPressed: () {
                setState(() {
                  if (isEdit && currentEvent != null) {
                    currentEvent['name'] = nameController.text;
                    currentEvent['category'] = categoryController.text;
                    currentEvent['status'] = statusController.text;
                  } else {
                    events.add({
                      'name': nameController.text,
                      'category': categoryController.text,
                      'status': statusController.text,
                    });
                  }
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
