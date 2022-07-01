import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sing_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful(),
          ),
        ),
      ),
    );
  }

  group('sign in', () {
    testWidgets(
        "WHEN user doesn't enter the email and password"
        "AND user taps on the sign-in button"
        "THEN  signInWithEmailAndPassword is not called",
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      verify(
          mockAuth.signInWithEmailAndPassword('email@email.com', 'password'));
    });

    testWidgets(
        "WHEN user enters the email and password"
        "AND user taps on the sign-in button"
        "THEN  signInWithEmailAndPassword is called",
        (WidgetTester tester) async {});
  });
}
