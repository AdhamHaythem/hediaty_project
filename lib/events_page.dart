import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'gift_list_page.dart';

class EventsPage extends StatefulWidget {
  final String userId;
  final String ownerId;
  final String? friendusername;
  final bool NavBar;

  const EventsPage(
      {required this.userId,
      required this.ownerId,
      this.friendusername,
      this.NavBar = false,
      Key? key})
      : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();
  List<EventModel> events = [];
  bool isSortedByDate = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final userEvents = await _eventController.fetchUserEvents(widget.ownerId);
    setState(() {
      events = userEvents;
      if (isSortedByDate) {
        events.sort(
            (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
      }
    });
  }

  void _sortEventsByDate() {
    setState(() {
      isSortedByDate = true;
      events.sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    });
  }

  void _addEvent() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Event',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    prefixIcon: Icon(Icons.event),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
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
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(selectedDate!),
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill out all fields!')),
                      );
                      return;
                    }

                    final newEvent = EventModel(
                      id: '',
                      name: nameController.text,
                      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                      location: locationController.text,
                      description: descriptionController.text,
                      ownerId: widget.userId,
                    );

                    await _eventController.addEvent(widget.userId, newEvent);
                    Navigator.pop(context);
                    _loadEvents();
                  },
                  child: Text('Add Event'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editEvent(EventModel event) {
    final nameController = TextEditingController(text: event.name);
    final locationController = TextEditingController(text: event.location);
    final descriptionController =
        TextEditingController(text: event.description);
    DateTime? selectedDate = DateTime.parse(event.date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Event',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    prefixIcon: Icon(Icons.event),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate!,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(selectedDate!),
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill out all fields!')),
                      );
                      return;
                    }

                    final updatedEvent = event.copyWith(
                      name: nameController.text,
                      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                      location: locationController.text,
                      description: descriptionController.text,
                    );

                    await _eventController.updateEvent(
                        widget.userId, updatedEvent);
                    Navigator.pop(context);
                    _loadEvents();
                  },
                  child: Text('Save Changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.NavBar
          ? null
          : AppBar(
              title: Text(
                widget.userId == widget.ownerId
                    ? 'My Events'
                    : "${widget.friendusername}'s Events",
              ),
              backgroundColor: Colors.deepPurpleAccent,
            ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.0),
            if (widget.userId == widget.ownerId)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addEvent,
                      icon: Icon(Icons.add),
                      label: Text('Add Event'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.sort),
                      tooltip: 'Sort by Date',
                      color: Colors.purpleAccent,
                      iconSize: 28,
                      onPressed: _sortEventsByDate,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: events.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No events found. Add your first event!',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: ListTile(
                            leading: Icon(Icons.event,
                                color: Colors.deepPurpleAccent),
                            title: Text(
                              event.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87, // Neutral text color
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${event.date} - ${event.location}',
                                    style: TextStyle(color: Colors.black54)),
                                Text(event.description,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                            trailing: widget.userId == widget.ownerId
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blueAccent),
                                        onPressed: () => _editEvent(event),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () async {
                                          await _eventController.deleteEvent(
                                              widget.ownerId, event.id);
                                          _loadEvents();
                                        },
                                      ),
                                    ],
                                  )
                                : null,
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
            ),
          ],
        ),
      ),
    );
  }
}
