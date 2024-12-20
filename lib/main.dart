import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hedaity_project/signin.dart';
import 'package:hedaity_project/signup.dart';
import 'package:hedaity_project/friends_list_page.dart';
import 'package:hedaity_project/events_page.dart';
import 'package:hedaity_project/gift_list_page.dart';
import 'package:hedaity_project/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SigninPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/signup':
            return MaterialPageRoute(builder: (context) => SignupPage());

          case '/signin':
          case '/':
            return MaterialPageRoute(builder: (context) => SigninPage());

          case '/friends':
            final args = settings.arguments as Map<String, dynamic>;
            final currentUserId = args['userId'] as String;
            return MaterialPageRoute(
              builder: (context) =>
                  FriendsListPage(currentUserId: currentUserId),
            );

          case '/events':
            final args = settings.arguments as Map<String, dynamic>;
            final userId = args['userId'] as String;
            final ownerId = args['ownerId'] as String;
            return MaterialPageRoute(
              builder: (context) =>
                  EventsPage(userId: userId, ownerId: ownerId),
            );

          case '/gifts':
            final args = settings.arguments as Map<String, dynamic>;
            final userId = args['userId'] as String;
            final eventId = args['eventId'] as String;
            final ownerId = args['ownerId'] as String;
            return MaterialPageRoute(
              builder: (context) => GiftListPage(
                userId: userId,
                eventId: eventId,
                ownerId: ownerId,
              ),
            );
          case '/profile':
            final args = settings.arguments as Map<String, dynamic>;
            final userId = args['userId'] as String;
            final username = args['username'] as String;
            final email = args['email'] as String;
            return MaterialPageRoute(
              builder: (context) => ProfilePage(
                userId: userId,
                username: username,
                email: email,
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
