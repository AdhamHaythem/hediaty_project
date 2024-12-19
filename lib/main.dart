import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signin.dart';
import 'signup.dart';
import 'friends_list_page.dart';
import 'events_page.dart';
import 'profile_page.dart';
import 'gift_list_page.dart';
import 'gift_details_page.dart';
import 'my_pledged_gifts_page.dart';

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
      home: SigninPage(), // Default page for authentication
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/signup':
            return MaterialPageRoute(builder: (context) => SignupPage());

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
            return MaterialPageRoute(
              builder: (context) => EventsPage(userId: userId),
            );

          case '/giftDetails':
            final args = settings.arguments as Map<String, dynamic>;
            final gift = args['gift'] as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => GiftDetailsPage(gift: gift),
            );

          case '/myPledgedGifts':
            return MaterialPageRoute(
              builder: (context) => MyPledgedGiftsPage(),
            );

          case '/profile':
            return MaterialPageRoute(
              builder: (context) => ProfilePage(),
            );

          case '/gifts':
            final args = settings.arguments as Map<String, dynamic>;
            final eventId = args['eventId'] as String;
            return MaterialPageRoute(
              builder: (context) => GiftListPage(eventId: eventId),
            );

          default:
            return null; // Return null if no route matches
        }
      },
    );
  }
}
