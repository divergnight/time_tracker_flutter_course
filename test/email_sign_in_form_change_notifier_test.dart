import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

class MockUser extends Mock implements User {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
          create: (context) => mockAuth,
          child: ChangeNotifierProvider<EmailSignInChangeModel>(
            create: (_) => EmailSignInChangeModel(auth: mockAuth),
            child: Consumer<EmailSignInChangeModel>(
                builder: (_, model, __) => MaterialApp(
                      home: Scaffold(
                        body: EmailSignInFormChangeNotifier(
                            model: model, onSignedIn: onSignedIn),
                      ),
                    )),
          )),
    );
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(MockUser()));
  }

  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any)).thenThrow(
        FirebaseAuthException(code: 'ERROR_WRONG_PASSWORD', message: ''));
  }

  void stubCreateUserWithEmailAndPasswordSucceeds() {
    when(mockAuth.createUserWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(MockUser()));
  }

  void stubCreateUserWithEmailAndPasswordThrows() {
    when(mockAuth.createUserWithEmailAndPassword(any, any)).thenThrow(
        FirebaseAuthException(code: 'INVALID_PASSWORD', message: ''));
  }

  group('sign in', () {
    testWidgets(
        "WHEN user doesn't enter the email and password"
        "AND user taps on the sign-in button"
        "THEN  signInWithEmailAndPassword is not called",
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: (() => signedIn = true));

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets(
        "WHEN user enters a valid email and password"
        "AND user taps on the sign-in button"
        "THEN  signInWithEmailAndPassword is called"
        "AND user signed in", (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: (() => signedIn = true));

      stubSignInWithEmailAndPasswordSucceeds();

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
      expect(signedIn, true);
    });

    testWidgets(
        "WHEN user enters an invalid email and password"
        "AND user taps on the sign-in button"
        "THEN  signInWithEmailAndPassword is called"
        "AND user not signed in", (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: (() => signedIn = true));

      stubSignInWithEmailAndPasswordThrows();

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
      expect(signedIn, false);
    });
  });
  group('register', () {
    testWidgets(
        "AND user taps on the secondary button"
        "THEN form toggles to registration mode", (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.text('Need an account ? Register');
      await tester.tap(registerButton);

      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
    });

    testWidgets(
        "WHEN user taps on the secondary button"
        "AND user enters a valid email and password"
        "AND user taps on the register button"
        "THEN createUserWithEmailAndPassword is called"
        "AND user signed in", (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);
      stubCreateUserWithEmailAndPasswordSucceeds();

      final registerButton = find.text('Need an account ? Register');
      await tester.tap(registerButton);

      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
      await tester.tap(createAccountButton);

      verify(mockAuth.createUserWithEmailAndPassword(
              'email@email.com', 'password'))
          .called(1);
    });

    testWidgets(
        "WHEN user taps on the secondary button"
        "AND user enters an invalid email and password"
        "AND user taps on the register button"
        "THEN createUserWithEmailAndPassword is called"
        "AND user not signed in", (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);
      stubCreateUserWithEmailAndPasswordThrows();

      final registerButton = find.text('Need an account ? Register');
      await tester.tap(registerButton);

      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
      await tester.tap(createAccountButton);

      verify(mockAuth.createUserWithEmailAndPassword(
              'email@email.com', 'password'))
          .called(1);
    });
  });
}
