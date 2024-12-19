import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gift_model.dart';

class GiftController {
  final _firestore = FirebaseFirestore.instance;

  Future<List<GiftModel>> fetchGiftsForEvent(String eventId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('gifts')
        .where('eventId', isEqualTo: eventId)
        .get();

    return snapshot.docs
        .map((doc) =>
            GiftModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addGift(GiftModel gift) async {
    await _firestore.collection('gifts').add(gift.toMap());
  }

  Future<void> updateGift(GiftModel gift) async {
    await _firestore.collection('gifts').doc(gift.id).update(gift.toMap());
  }

  Future<void> deleteGift(String giftId) async {
    await _firestore.collection('gifts').doc(giftId).delete();
  }
}
