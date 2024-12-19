import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signin Method
  Future<UserModel?> signin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          return UserModel(
            uid: user.uid,
            email: user.email ?? '',
            username: data['username'] ?? 'Unknown',
          );
        }
      }
    } catch (e) {
      print('Signin Error: $e');
    }
    return null;
  }

  // Signup Method
  Future<UserModel?> signup(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Save user details to Firestore
        final userData = {
          'username': username,
          'email': email,
          'friends': [],
          'friendRequests': [],
        };

        await _firestore.collection('users').doc(user.uid).set(userData);

        return UserModel(
          uid: user.uid,
          email: email,
          username: username,
        );
      }
    } catch (e) {
      print('Signup Error: $e');
    }
    return null;
  }

  // Logout Method
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  // Send a friend request by username
  Future<void> sendFriendRequest(
      String currentUserId, String targetUsername) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: targetUsername)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final targetUser = querySnapshot.docs.first;
        final targetUserId = targetUser.id;

        await _firestore.collection('users').doc(targetUserId).update({
          'friendRequests': FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  // Fetch friend requests for the current user
  Future<List<Map<String, dynamic>>> fetchFriendRequests(
      String currentUserId) async {
    final List<Map<String, dynamic>> requests = [];

    try {
      final userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      final friendRequests =
          List<String>.from(userDoc.data()?['friendRequests'] ?? []);

      for (final senderId in friendRequests) {
        final senderDoc =
            await _firestore.collection('users').doc(senderId).get();
        if (senderDoc.exists) {
          requests.add({'id': senderId, 'username': senderDoc['username']});
        }
      }
    } catch (e) {
      print('Error fetching friend requests: $e');
    }

    return requests;
  }

  // Accept or reject a friend request
  Future<void> handleFriendRequest(
      String currentUserId, String senderUserId, bool isAccepted) async {
    try {
      if (isAccepted) {
        await _firestore.collection('users').doc(currentUserId).update({
          'friends': FieldValue.arrayUnion([senderUserId]),
        });

        await _firestore.collection('users').doc(senderUserId).update({
          'friends': FieldValue.arrayUnion([currentUserId]),
        });
      }

      await _firestore.collection('users').doc(currentUserId).update({
        'friendRequests': FieldValue.arrayRemove([senderUserId]),
      });
    } catch (e) {
      print('Error handling friend request: $e');
    }
  }

  // Fetch friends with their events
  Future<List<Map<String, dynamic>>> fetchFriendsWithEvents(
      String currentUserId) async {
    final List<Map<String, dynamic>> friendsWithEvents = [];

    try {
      final userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      final friends = List<String>.from(userDoc.data()?['friends'] ?? []);

      for (final friendId in friends) {
        final friendDoc =
            await _firestore.collection('users').doc(friendId).get();
        if (friendDoc.exists) {
          final eventsSnapshot = await _firestore
              .collection('users')
              .doc(friendId)
              .collection('events')
              .get();

          friendsWithEvents.add({
            'id': friendId,
            'username': friendDoc['username'],
            'upcomingEvents': eventsSnapshot.docs.length,
          });
        }
      }
    } catch (e) {
      print('Error fetching friends with events: $e');
    }

    return friendsWithEvents;
  }
}
