import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/signin.dart';
import '../lib/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("end_to_end", () {
    testWidgets("login", (tester) async {
      await Firebase.initializeApp();
      //await dataBaseInit();
      await tester.pumpWidget(MaterialApp(home: SigninPage()));
      await tester.enterText(
          find.byType(TextFormField).at(0), "adhamhaythem@hotmail.com");
      await tester.enterText(find.byType(TextFormField).at(1), "Cullrud@2");
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(Duration(seconds: 2));
      expect(find.byIcon(Icons.person_add_alt_1), findsOneWidget);
      await tester.enterText(find.byType(TextField), "a");
      await tester.pump(Duration(seconds: 5));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(Duration(seconds: 5));
      expect(find.byType(Card), findsOneWidget);
      // await tester.tap(find.byIcon(Icons.person_add_alt_1));
      // await tester.pumpAndSettle(Duration(seconds: 2));
      // await tester.enterText(find.byType(TextFormField), "d@gmail.com");
      // await tester.pump(Duration(seconds: 2));
      // await tester.tap(find.text("ADD"));
      // await tester.pumpAndSettle();
      // await tester.pumpAndSettle();
      // await tester.pumpAndSettle();
      // expect(find.byType(Card), findsNWidgets(4));
    });
  });
}
