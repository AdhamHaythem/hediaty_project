import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<bool> isUsernameTaken(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  Future<UserModel?> signup(
      String email, String password, String username) async {
    try {
      if (await isUsernameTaken(username)) {
        throw Exception('Username is already taken.');
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
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
      throw e;
    }
    return null;
  }

  Future<void> updateUserField(
      String userId, String field, String value) async {
    try {
      if (field == 'email') {
        User? user = _auth.currentUser;
        if (user != null) {
          await user.updateEmail(value);
        }
      }

      await _firestore.collection('users').doc(userId).update({field: value});
    } catch (e) {
      throw Exception('Failed to update $field: $e');
    }
  }

  Future<bool> updatePassword(
      String userId, String oldPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      final credential = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print('Failed to update password: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        return {
          'username': data?['username'] ?? '',
          'email': data?['email'] ?? '',
        };
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return {'username': '', 'email': ''};
    }
  }

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
