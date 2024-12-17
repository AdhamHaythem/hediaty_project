import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';
import 'friends_list_page.dart';
import 'events_page.dart';
import 'gift_list_page.dart';
import 'gift_details_page.dart';
import 'package:hediaty_project/profile_page.dart';
import 'my_pledged_gifts_page.dart';

void main() {
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SigninPage(),
      routes: {
        '/signin': (context) => SigninPage(),
        '/signup': (context) => SignupPage(),
        '/friends': (context) => FriendsListPage(),
        '/events': (context) => EventsPage(),
        '/giftList': (context) => GiftListPage(eventName: 'Example Event'),
        '/profile': (context) => ProfilePage(),
        '/myPledgedGifts': (context) => MyPledgedGiftsPage(),
        '/GiftDetails': (context) => GiftDetailsPage(),
        // For GiftDetailsPage, you can push using MaterialPageRoute directly
        // or define a route that takes arguments if needed.
      },
    );
  }
}
