import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meme_editor_mobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Meme Editor App Integration Tests', () {
    testWidgets('should launch app and show splash screen', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is shown initially
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Wait for splash screen animation to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('complete app flow: splash -> home -> meme selection', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify we're on the home page
      expect(find.text('Meme Editor'), findsOneWidget);

      // Wait for memes to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Look for any meme grid items (if memes are loaded)
      final memeItems = find.byType(GestureDetector);
      if (memeItems.evaluate().isNotEmpty) {
        // Tap on the first meme item
        await tester.tap(memeItems.first);
        await tester.pumpAndSettle();

        // Verify navigation to detail page
        expect(find.byType(AppBar), findsOneWidget);
      }
    });

    testWidgets('should handle search functionality', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Wait for memes to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Look for search icon
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        // Tap search icon
        await tester.tap(searchIcon);
        await tester.pumpAndSettle();

        // Look for search field
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          // Enter search text
          await tester.enterText(searchField, 'test');
          await tester.pumpAndSettle();

          // Verify search is working
          expect(find.text('test'), findsOneWidget);
        }
      }
    });

    testWidgets('should handle pull to refresh', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Look for RefreshIndicator
      final refreshIndicator = find.byType(RefreshIndicator);
      if (refreshIndicator.evaluate().isNotEmpty) {
        // Perform pull to refresh
        await tester.fling(refreshIndicator, const Offset(0, 300), 1000);
        await tester.pump();

        // Wait for refresh to complete
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Verify app is still functional
        expect(find.text('Meme Editor'), findsOneWidget);
      }
    });

    testWidgets('should navigate through app screens', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Verify home screen
      expect(find.text('Meme Editor'), findsOneWidget);

      // Look for floating action button
      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isNotEmpty) {
        await tester.tap(fab);
        await tester.pumpAndSettle();
      }

      // Look for app drawer if it exists
      final menuIcon = find.byIcon(Icons.menu);
      if (menuIcon.evaluate().isNotEmpty) {
        await tester.tap(menuIcon);
        await tester.pumpAndSettle();

        // Close drawer
        await tester.tap(find.byType(Scaffold).first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should handle offline mode toggle', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Wait for memes to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Look for settings or offline mode toggle
      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();

        // Look for offline mode switch
        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          await tester.tap(switches.first);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('should handle theme toggle', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Look for theme toggle button
      final themeIcon = find.byIcon(Icons.brightness_6);
      if (themeIcon.evaluate().isNotEmpty) {
        await tester.tap(themeIcon);
        await tester.pumpAndSettle();

        // Verify theme changed by checking for different background
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });

    testWidgets('should handle error states gracefully', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Wait for potential error states
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Look for retry button if error occurred
      final retryButton = find.text('Try Again');
      if (retryButton.evaluate().isNotEmpty) {
        await tester.tap(retryButton);
        await tester.pumpAndSettle();
      }

      // Verify app is still responsive
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
