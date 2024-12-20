import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gift_model.dart';

class GiftController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch gifts for a specific event
  Future<List<GiftModel>> fetchGiftsForEvent(
      String userId, String eventId) async {
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

  // Update the status of a gift (e.g., mark as pledged)
  Future<void> updateGiftStatus(
      String userId, String eventId, String giftId, String newStatus) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .update({'status': newStatus});
  }

  // Update an existing gift
  Future<void> updateGift(
      String userId, String eventId, GiftModel updatedGift) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(updatedGift.id)
        .update(updatedGift.toMap());
  }

  // Delete a gift
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
