import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch events for a specific user
  Future<List<EventModel>> fetchUserEvents(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .get();

    return snapshot.docs
        .map((doc) =>
            EventModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Add a new event to the user's subcollection
  Future<void> addEvent(String userId, EventModel event) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .add(event.toMap());
  }

  // Update an event in the user's subcollection
  Future<void> updateEvent(String userId, EventModel event) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(event.id)
        .update(event.toMap());
  }

  // Delete an event from the user's subcollection
  Future<void> deleteEvent(String userId, String eventId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .delete();
  }
}
