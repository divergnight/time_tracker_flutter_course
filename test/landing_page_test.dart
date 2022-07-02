import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  MockDatabase mockDatabase;
  StreamController<User> onAuthStateChangeController;

  setUp(() {
    mockAuth = MockAuth();
    mockDatabase = MockDatabase();
    onAuthStateChangeController = StreamController<User>();
  });

  tearDown(() {
    onAuthStateChangeController.close();
  });

  Future<void> pumpLandingPage(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: LandingPage(
            databaseBuilder: (_) => mockDatabase,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  void stubOnAuthStateChangeYields(Iterable<User> onAuthStateChanged) {
    onAuthStateChangeController
        .addStream(Stream<User>.fromIterable(onAuthStateChanged));
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangeController.stream;
    });
  }

  testWidgets('stream waiting', (WidgetTester tester) async {
    stubOnAuthStateChangeYields([]);
    await pumpLandingPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('null user', (WidgetTester tester) async {
    stubOnAuthStateChangeYields([null]);
    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (WidgetTester tester) async {
    stubOnAuthStateChangeYields([MockUser.uid('123')]);
    await pumpLandingPage(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });
}
