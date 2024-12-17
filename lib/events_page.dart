import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Map<String, dynamic>> events = [
    {'name': 'Birthday Party', 'category': 'Personal', 'status': 'Upcoming'},
    {'name': 'Conference', 'category': 'Work', 'status': 'Current'},
    {'name': 'Past Meetup', 'category': 'Social', 'status': 'Past'},
  ];

  String selectedSort = 'name';

  @override
  Widget build(BuildContext context) {
    final sortedEvents = List<Map<String, dynamic>>.from(events);
    sortedEvents.sort((a, b) => a[selectedSort].compareTo(b[selectedSort]));

    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => selectedSort = value),
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
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.event, color: Colors.blueAccent),
              title: Text(event['name'],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${event['category']} • ${event['status']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editEvent(event)),
                  IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteEvent(event)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEvent,
        icon: Icon(Icons.add),
        label: Text('Add Event'),
      ),
    );
  }

  void _addEvent() => _showEventDialog(isEdit: false);

  void _editEvent(Map<String, dynamic> event) =>
      _showEventDialog(isEdit: true, currentEvent: event);

  void _deleteEvent(Map<String, dynamic> event) {
    setState(() => events.remove(event));
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
                _buildTextField('Name', nameController),
                _buildTextField('Category', categoryController),
                _buildTextField('Status', statusController),
              ],
            ),
          ),
          actions: [
            TextButton(
                child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
            ElevatedButton(
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
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
