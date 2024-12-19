import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signin.dart';
import 'signup.dart';
import 'friends_list_page.dart';
import 'gift_list_page.dart';
import 'gift_details_page.dart';
import 'events_page.dart';
import 'profile_page.dart';
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
      home: SigninPage(),
      routes: {
        '/signup': (context) => SignupPage(),
        '/friends': (context) => FriendsListPage(),
        '/gifts': (context) => GiftListPage(),
        '/giftDetails': (context) => GiftDetailsPage(gift: {}),
        '/events': (context) => EventListPage(),
        '/profile': (context) => ProfilePage(),
        '/myPledgedGifts': (context) => MyPledgedGiftsPage(),
      },
    );
  }
}
