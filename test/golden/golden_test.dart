import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/splash_screen.dart';

void main() {
  group('Golden Tests', () {
    testWidgets('SplashScreen should match golden', (tester) async {
      bool callbackCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(
            onAnimationComplete: () {
              callbackCalled = true;
            },
          ),
        ),
      );

      await tester.pump();
      await expectLater(
        find.byType(SplashScreen),
        matchesGoldenFile('splash_screen.png'),
      );

      // Use the callback variable to avoid lint warning
      expect(callbackCalled, isFalse);
    });

    testWidgets('Error state should match golden', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('error_state.png'),
      );
    });

    testWidgets('Loading state should match golden', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading memes...'),
                ],
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('loading_state.png'),
      );
    });
  });
}
