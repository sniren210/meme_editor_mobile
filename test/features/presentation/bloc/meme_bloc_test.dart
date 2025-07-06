import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/usecases/get_memes.dart';
import 'package:meme_editor_mobile/features/domain/usecases/meme_operations.dart';
import 'package:meme_editor_mobile/features/presentation/bloc/meme_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockGetMemesUseCase extends Mock implements GetMemesUseCase {}
class MockToggleOfflineModeUseCase extends Mock implements ToggleOfflineModeUseCase {}

void main() {
  late MemeBloc bloc;
  late MockGetMemesUseCase mockGetMemesUseCase;
  late MockToggleOfflineModeUseCase mockToggleOfflineModeUseCase;

  setUp(() {
    mockGetMemesUseCase = MockGetMemesUseCase();
    mockToggleOfflineModeUseCase = MockToggleOfflineModeUseCase();
    bloc = MemeBloc(
      getMemesUseCase: mockGetMemesUseCase,
      toggleOfflineModeUseCase: mockToggleOfflineModeUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('MemeBloc', () {
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

    test('initial state should be MemeInitial', () {
      expect(bloc.state, equals(MemeInitial()));
    });

    group('LoadMemesEvent', () {
      blocTest<MemeBloc, MemeState>(
        'should emit [MemeLoading, MemeLoaded] when data is gotten successfully',
        build: () {
          when(() => mockGetMemesUseCase())
              .thenAnswer((_) async => const Right(tMemes));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadMemesEvent()),
        expect: () => [
          MemeLoading(),
          const MemeLoaded(
            memes: tMemes,
            filteredMemes: tMemes,
            isOfflineMode: false,
          ),
        ],
        verify: (_) {
          verify(() => mockGetMemesUseCase()).called(1);
        },
      );

      blocTest<MemeBloc, MemeState>(
        'should emit [MemeLoading, MemeError] when getting data fails',
        build: () {
          when(() => mockGetMemesUseCase())
              .thenAnswer((_) async => const Left(NetworkFailure('Network error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadMemesEvent()),
        expect: () => [
          MemeLoading(),
          const MemeError('Network error'),
        ],
        verify: (_) {
          verify(() => mockGetMemesUseCase()).called(1);
        },
      );
    });

    group('SearchMemesEvent', () {
      blocTest<MemeBloc, MemeState>(
        'should filter memes based on search query',
        build: () => bloc,
        seed: () => const MemeLoaded(
          memes: tMemes,
          filteredMemes: tMemes,
          isOfflineMode: false,
        ),
        act: (bloc) => bloc.add(const SearchMemesEvent('Test')),
        expect: () => [
          const MemeLoaded(
            memes: tMemes,
            filteredMemes: [
              Meme(
                id: '1',
                name: 'Test Meme',
                url: 'https://example.com/meme1.jpg',
                width: 500,
                height: 400,
                boxCount: 2,
              ),
            ],
            isOfflineMode: false,
            searchQuery: 'Test',
          ),
        ],
      );

      blocTest<MemeBloc, MemeState>(
        'should show all memes when search query is empty',
        build: () => bloc,
        seed: () => const MemeLoaded(
          memes: tMemes,
          filteredMemes: [
            Meme(
              id: '1',
              name: 'Test Meme',
              url: 'https://example.com/meme1.jpg',
              width: 500,
              height: 400,
              boxCount: 2,
            ),
          ],
          isOfflineMode: false,
          searchQuery: 'Test',
        ),
        act: (bloc) => bloc.add(const SearchMemesEvent('')),
        expect: () => [
          const MemeLoaded(
            memes: tMemes,
            filteredMemes: tMemes,
            isOfflineMode: false,
            searchQuery: '',
          ),
        ],
      );
    });

    group('ToggleOfflineModeEvent', () {
      blocTest<MemeBloc, MemeState>(
        'should update offline mode successfully',
        build: () {
          when(() => mockToggleOfflineModeUseCase(true))
              .thenAnswer((_) async => const Right(true));
          return bloc;
        },
        seed: () => const MemeLoaded(
          memes: tMemes,
          filteredMemes: tMemes,
          isOfflineMode: false,
        ),
        act: (bloc) => bloc.add(const ToggleOfflineModeEvent(true)),
        expect: () => [
          const MemeLoaded(
            memes: tMemes,
            filteredMemes: tMemes,
            isOfflineMode: true,
          ),
        ],
        verify: (_) {
          verify(() => mockToggleOfflineModeUseCase(true)).called(1);
        },
      );

      blocTest<MemeBloc, MemeState>(
        'should emit error when toggle offline mode fails',
        build: () {
          when(() => mockToggleOfflineModeUseCase(true))
              .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const ToggleOfflineModeEvent(true)),
        expect: () => [
          const MemeError('Cache error'),
        ],
        verify: (_) {
          verify(() => mockToggleOfflineModeUseCase(true)).called(1);
        },
      );
    });

    group('RefreshMemesEvent', () {
      blocTest<MemeBloc, MemeState>(
        'should refresh memes and maintain search state',
        build: () {
          when(() => mockGetMemesUseCase())
              .thenAnswer((_) async => const Right(tMemes));
          return bloc;
        },
        seed: () => const MemeLoaded(
          memes: [],
          filteredMemes: [],
          isOfflineMode: false,
          searchQuery: 'Test',
        ),
        act: (bloc) => bloc.add(RefreshMemesEvent()),
        expect: () => [
          const MemeLoaded(
            memes: tMemes,
            filteredMemes: [
              Meme(
                id: '1',
                name: 'Test Meme',
                url: 'https://example.com/meme1.jpg',
                width: 500,
                height: 400,
                boxCount: 2,
              ),
            ],
            isOfflineMode: false,
            searchQuery: 'Test',
          ),
        ],
        verify: (_) {
          verify(() => mockGetMemesUseCase()).called(1);
        },
      );
    });
  });
}
