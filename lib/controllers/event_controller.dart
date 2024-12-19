import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../models/gift_model.dart';

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

  // Fetch gifts for a specific event
  Future<List<GiftModel>> fetchEventGifts(String userId, String eventId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .get();

    return snapshot.docs
        .map((doc) =>
            GiftModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Add a gift to a specific event
  Future<void> addGift(String userId, String eventId, GiftModel gift) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .add(gift.toMap());
  }

  // Delete a gift from a specific event
  Future<void> deleteGift(String userId, String eventId, String giftId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .delete();
  }
}
