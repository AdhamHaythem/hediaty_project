import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gift_model.dart';

class GiftController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch gifts for a specific event
  Future<List<GiftModel>> fetchGiftsForEvent(
      String ownerId, String eventId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(ownerId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .get();

    List<GiftModel> gifts = [];
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      String? pledgedByName;

      // Fetch username if pledgedBy is present
      if (data['pledgedBy'] != null) {
        final userDoc =
            await _firestore.collection('users').doc(data['pledgedBy']).get();
        pledgedByName = userDoc.data()?['username'];
      }

      gifts.add(
          GiftModel.fromMap(doc.id, {...data, 'pledgedByName': pledgedByName}));
    }

    return gifts;
  }

  // Add a new gift
  Future<void> addGift(String ownerId, String eventId, GiftModel gift) async {
    await _firestore
        .collection('users')
        .doc(ownerId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .add(gift.toMap());
  }

  // Update the status of a gift
  Future<void> updateGiftStatus(String ownerId, String eventId, String giftId,
      String status, String? pledgedBy) async {
    await _firestore
        .collection('users')
        .doc(ownerId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .update({'status': status, 'pledgedBy': pledgedBy});
  }

  // Update an existing gift
  Future<void> updateGift(
      String ownerId, String eventId, GiftModel updatedGift) async {
    await _firestore
        .collection('users')
        .doc(ownerId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(updatedGift.id)
        .update(updatedGift.toMap());
  }

  // Delete a gift
  Future<void> deleteGift(String ownerId, String eventId, String giftId) async {
    await _firestore
        .collection('users')
        .doc(ownerId)
        .collection('events')
        .doc(eventId)
        .collection('gifts')
        .doc(giftId)
        .delete();
  }
}
