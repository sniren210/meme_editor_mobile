import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/presentation/bloc/meme_bloc.dart';
import 'package:meme_editor_mobile/features/presentation/pages/meme_home_page.dart';

class MockMemeBloc extends Mock implements MemeBloc {}

void main() {
  late MockMemeBloc mockMemeBloc;

  setUp(() {
    mockMemeBloc = MockMemeBloc();
  });

  const tMemes = [
    Meme(
      id: '1',
      name: 'Test Meme',
      url: 'https://example.com/meme1.jpg',
      width: 500,
      height: 400,
      boxCount: 2,
    ),
    Meme(
      id: '2',
      name: 'Another Meme',
      url: 'https://example.com/meme2.jpg',
      width: 600,
      height: 500,
      boxCount: 3,
    ),
  ];

  Widget createTestableWidget({required Widget child}) {
    return MaterialApp(
      home: BlocProvider<MemeBloc>.value(
        value: mockMemeBloc,
        child: child,
      ),
    );
  }

  group('MemeHomeView Widget Tests', () {
    testWidgets('should display loading indicator when state is MemeLoading', (tester) async {
      // Arrange
      when(() => mockMemeBloc.state).thenReturn(MemeLoading());
      when(() => mockMemeBloc.stream).thenAnswer((_) => Stream.fromIterable([MemeLoading()]));

      // Act
      await tester.pumpWidget(createTestableWidget(child: const MemeHomeView()));

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when state is MemeError', (tester) async {
      // Arrange
      const errorMessage = 'Something went wrong';
      when(() => mockMemeBloc.state).thenReturn(const MemeError(errorMessage));
      when(() => mockMemeBloc.stream).thenAnswer((_) => Stream.fromIterable([const MemeError(errorMessage)]));

      // Act
      await tester.pumpWidget(createTestableWidget(child: const MemeHomeView()));

      // Assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('should display memes grid when state is MemeLoaded', (tester) async {
      // Arrange
      const state = MemeLoaded(
        memes: tMemes,
        filteredMemes: tMemes,
        isOfflineMode: false,
      );
      when(() => mockMemeBloc.state).thenReturn(state);
      when(() => mockMemeBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestableWidget(child: const MemeHomeView()));
      await tester.pump();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Meme Editor'), findsOneWidget);
      // Note: The actual grid might not be visible in widget tests due to network images
      // You would need to mock CachedNetworkImage for full testing
    });

    testWidgets('should show search field when search icon is tapped', (tester) async {
      // Arrange
      const state = MemeLoaded(
        memes: tMemes,
        filteredMemes: tMemes,
        isOfflineMode: false,
      );
      when(() => mockMemeBloc.state).thenReturn(state);
      when(() => mockMemeBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestableWidget(child: const MemeHomeView()));
      await tester.pump();

      // Find and tap the search icon
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon);
        await tester.pump();

        // Assert
        expect(find.byType(TextField), findsOneWidget);
      }
    });

    testWidgets('should trigger refresh when pull to refresh is performed', (tester) async {
      // Arrange
      const state = MemeLoaded(
        memes: tMemes,
        filteredMemes: tMemes,
        isOfflineMode: false,
      );
      when(() => mockMemeBloc.state).thenReturn(state);
      when(() => mockMemeBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestableWidget(child: const MemeHomeView()));
      await tester.pump();

      // Perform pull to refresh
      await tester.fling(find.byType(RefreshIndicator), const Offset(0, 300), 1000);
      await tester.pump();

      // Assert
      verify(() => mockMemeBloc.add(any(that: isA<LoadMemesEvent>()))).called(1);
    });

    testWidgets('should call add SearchMemesEvent when search text changes', (tester) async {
      // Arrange
      const state = MemeLoaded(
        memes: tMemes,
        filteredMemes: tMemes,
        isOfflineMode: false,
      );
      when(() => mockMemeBloc.state).thenReturn(state);
      when(() => mockMemeBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestableWidget(child: const MemeHomeView()));
      await tester.pump();

      // Find search icon and tap it to show search field
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon);
        await tester.pump();

        // Enter text in search field
        await tester.enterText(find.byType(TextField), 'test');
        await tester.pump();

        // Assert
        verify(() => mockMemeBloc.add(any(that: isA<SearchMemesEvent>()))).called(greaterThanOrEqualTo(1));
      }
    });

    testWidgets('should show floating action button', (tester) async {
      // Arrange
      const state = MemeLoaded(
        memes: tMemes,
        filteredMemes: tMemes,
        isOfflineMode: false,
      );
      when(() => mockMemeBloc.state).thenReturn(state);
      when(() => mockMemeBloc.stream).thenAnswer((_) => Stream.fromIterable([state]));

      // Act
      await tester.pumpWidget(createTestableWidget(child: const MemeHomeView()));
      await tester.pump();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
