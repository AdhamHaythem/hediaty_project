import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedaity_project/models/user_model.dart';
import 'package:hedaity_project/db_helper.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DBHelper dbHelper = DBHelper();

  void _logError(String methodName, dynamic error) {
    print('[$methodName] Error: $error');
  }

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
      _logError('signin', e);
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
      _logError('isUsernameTaken', e);
      return false;
    }
  }

  Future<bool> isEmailTaken(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      _logError('isEmailTaken', e);
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
      _logError('signup', e);
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
      _logError('updateUserField', e);
      throw Exception('Failed to update $field: $e');
    }
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      _logError('updatePassword', e);
      throw Exception('Failed to update password: $e');
    }
  }

  Future<void> updateEmail(String oldPassword, String newEmail) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(newEmail);
      print('Email updated successfully');
    } catch (e) {
      _logError('updateEmail', e);
      throw Exception('Failed to update email: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logError('logout', e);
      throw Exception('Failed to log out: $e');
    }
  }

  Future<void> deleteUserAccount(String password) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();

      print('Account deleted successfully');
    } catch (e) {
      _logError('deleteUserAccount', e);
      throw Exception('Failed to delete user account: $e');
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
      } else {
        throw Exception('Target user not found');
      }
    } catch (e) {
      _logError('sendFriendRequest', e);
      throw Exception('Error sending friend request: $e');
    }
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
      _logError('handleFriendRequest', e);
      throw Exception('Error handling friend request: $e');
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
      _logError('fetchFriendsWithEvents', e);
      throw Exception('Error fetching friends with events: $e');
    }

    return friendsWithEvents;
  }

  Future<void> removeFriend(String currentUserId, String friendId) async {
    try {
      await _firestore.collection('users').doc(currentUserId).update({
        'friends': FieldValue.arrayRemove([friendId]),
      });

      await _firestore.collection('users').doc(friendId).update({
        'friends': FieldValue.arrayRemove([currentUserId]),
      });

      print('Friend removed successfully.');
    } catch (e) {
      _logError('removeFriend', e);
      throw Exception('Failed to remove friend: $e');
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
          requests.add({
            'id': senderId,
            'username': senderDoc['username'],
          });
        }
      }
    } catch (e) {
      _logError('fetchFriendRequests', e);
      throw Exception('Error fetching friend requests: $e');
    }

    return requests;
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        return {
          'username': data?['username'] ?? '',
          'email': data?['email'] ?? '',
          'friends': List<String>.from(data?['friends'] ?? []),
          'friendRequests': List<String>.from(data?['friendRequests'] ?? []),
        };
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      _logError('fetchUserDetails', e);
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<void> saveUser(UserModel user) async {
    await dbHelper.insert('users', user.toMap());
  }

  Future<List<UserModel>> fetchUsers() async {
    final users = await dbHelper.queryAll('users');
    return users.map((data) => UserModel.fromMap(data)).toList();
  }

  Future<void> deleteUser(String userId) async {
    await dbHelper.delete('users', 'id = ?', [userId]);
  }
}
