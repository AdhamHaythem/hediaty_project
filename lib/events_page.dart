import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'gift_list_page.dart';

class EventsPage extends StatefulWidget {
  final String userId;

  const EventsPage({required this.userId, Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final userEvents = await _eventController.fetchUserEvents(widget.userId);
    setState(() {
      events = userEvents;
    });
  }

  void _addEvent() {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Name', nameController),
                _buildTextField('Date (YYYY-MM-DD)', dateController),
                _buildTextField('Location', locationController),
                _buildTextField('Description', descriptionController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () async {
                final newEvent = EventModel(
                  id: '',
                  name: nameController.text,
                  date: dateController.text,
                  location: locationController.text,
                  description: descriptionController.text,
                );

                await _eventController.addEvent(widget.userId, newEvent);
                Navigator.pop(context);
                _loadEvents();
              },
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

  void _editEvent(EventModel event) {
    final nameController = TextEditingController(text: event.name);
    final dateController = TextEditingController(text: event.date);
    final locationController = TextEditingController(text: event.location);
    final descriptionController =
        TextEditingController(text: event.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Name', nameController),
                _buildTextField('Date', dateController),
                _buildTextField('Location', locationController),
                _buildTextField('Description', descriptionController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () async {
                final updatedEvent = EventModel(
                  id: event.id,
                  name: nameController.text,
                  date: dateController.text,
                  location: locationController.text,
                  description: descriptionController.text,
                );

                await _eventController.updateEvent(widget.userId, updatedEvent);
                Navigator.pop(context);
                _loadEvents();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addEvent,
          ),
        ],
      ),
      body: events.isEmpty
          ? Center(child: Text('No events found.'))
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  child: ListTile(
                    title: Text(event.name),
                    subtitle: Text('${event.date} at ${event.location}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiftListPage(eventId: event.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
