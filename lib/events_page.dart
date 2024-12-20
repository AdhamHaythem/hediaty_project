import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'gift_list_page.dart';

class EventsPage extends StatefulWidget {
  final String userId;
  final String ownerId;

  const EventsPage({required this.userId, required this.ownerId, Key? key})
      : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();
  List<EventModel> events = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final userEvents = await _eventController.fetchUserEvents(widget.ownerId);
    setState(() {
      events = userEvents;
    });
  }

  void _deleteEvent(String eventId) async {
    if (widget.userId != widget.ownerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You cannot delete a friend’s event.')),
      );
      return;
    }

    await _eventController.deleteEvent(widget.ownerId, eventId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event deleted successfully.')),
    );
    _loadEvents();
  }

  void _editEvent(EventModel event) {
    final nameController = TextEditingController(text: event.name);
    final locationController = TextEditingController(text: event.location);
    final descriptionController =
        TextEditingController(text: event.description);
    selectedDate = DateTime.tryParse(event.date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Event Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                          text: selectedDate == null
                              ? ''
                              : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                      decoration: InputDecoration(labelText: 'Date'),
                    ),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedEvent = event.copyWith(
                  name: nameController.text,
                  location: locationController.text,
                  date: selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                      : event.date,
                  description: descriptionController.text,
                );
                await _eventController.updateEvent(
                    widget.ownerId, updatedEvent);
                Navigator.pop(context);
                _loadEvents();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      body: events.isEmpty
          ? Center(
              child: Text('No events found.'),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  child: ListTile(
                    title: Text(event.name),
                    subtitle: Text('${event.date} at ${event.location}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.userId == widget.ownerId)
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editEvent(event),
                          ),
                        if (widget.userId == widget.ownerId)
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEvent(event.id),
                          ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiftListPage(
                            userId: widget.userId,
                            eventId: event.id,
                            ownerId: widget.ownerId,
                          ),
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
