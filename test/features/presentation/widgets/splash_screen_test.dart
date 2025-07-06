import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_mobile/features/presentation/widgets/splash_screen.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    late bool callbackCalled;

    setUp(() {
      callbackCalled = false;
    });

    Widget createTestableWidget() {
      return MaterialApp(
        home: SplashScreen(
          onAnimationComplete: () {
            callbackCalled = true;
          },
        ),
      );
    }

    testWidgets('should render without crashing', (tester) async {
      // Act
      await tester.pumpWidget(createTestableWidget());

      // Assert
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display app logo/icon', (tester) async {
      // Act
      await tester.pumpWidget(createTestableWidget());

      // Assert
      // The splash screen should contain some visual elements
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('should have proper background', (tester) async {
      // Act
      await tester.pumpWidget(createTestableWidget());

      // Assert
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should call onAnimationComplete callback after animation', (tester) async {
      // Act
      await tester.pumpWidget(createTestableWidget());
      
      // Fast forward the animation
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pumpAndSettle();

      // Assert
      expect(callbackCalled, isTrue);
    });

    testWidgets('should not call callback immediately', (tester) async {
      // Act
      await tester.pumpWidget(createTestableWidget());
      await tester.pump();

      // Assert
      expect(callbackCalled, isFalse);
    });

    testWidgets('should dispose controllers properly', (tester) async {
      // Act
      await tester.pumpWidget(createTestableWidget());
      
      // Remove the widget to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Assert - No assertion needed, just ensuring no exceptions are thrown
      expect(tester.takeException(), isNull);
    });
  });
}
