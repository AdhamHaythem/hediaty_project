import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hedaity_project/signin.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("App Flow Test", () {
    testWidgets("App Flow Test", (tester) async {
      await Firebase.initializeApp();

      // Step 1: Launch the Signin Page
      await tester.pumpWidget(MaterialApp(home: SigninPage()));
      await tester.enterText(
          find.byType(TextFormField).at(0), "adhamhaythem@hotmail.com");
      await tester.enterText(find.byType(TextFormField).at(1), "Cullrud@2");
      await tester.tap(find.widgetWithText(ElevatedButton, "Signin"));
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Step 2: Verify the Home Page is Loaded
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Step 3: Navigate to Events Page
      debugPrint('Navigating to Events Page...');
      await tester.tap(find.byIcon(Icons.event));
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 4: Wait for Events Page to Load
      await tester.runAsync(() async {
        await Future.delayed(Duration(seconds: 2));
        await tester.pumpAndSettle();
      });

      // Verify Events Page Content
      expect(find.text("My Events"), findsAny);
      expect(find.byType(ListTile), findsWidgets);

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 5: Log Out
      await tester.tap(find.widgetWithText(ElevatedButton, "Log Out"));

      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.widgetWithText(TextButton, "Log Out"));

      await tester.pumpAndSettle(Duration(seconds: 2));

      // Step 6: Verify Return to Signin Page
      expect(find.widgetWithText(ElevatedButton, "Signin"), findsOneWidget);
    });
  });
}
