import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedaity_project/models/event_model.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> addEvent(String userId, EventModel event) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .add(event.toMap());
  }

  Future<void> updateEvent(String userId, EventModel updatedEvent) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(updatedEvent.id)
        .update(updatedEvent.toMap());
  }

  Future<void> deleteEvent(String userId, String eventId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .delete();
  }
}
