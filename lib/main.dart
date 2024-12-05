import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';
import 'friends_list_page.dart';

void main() {
  runApp(HedieatyApp());
}

class HedieatyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SigninPage(), // Start with Signin Page
      routes: {
        '/signin': (context) => SigninPage(),
        '/signup': (context) => SignupPage(),
        '/friends': (context) => FriendsListPage(),
      },
    );
  }
}
