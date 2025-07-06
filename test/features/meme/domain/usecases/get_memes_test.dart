import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/repositories/meme_repository.dart';
import 'package:meme_editor_mobile/features/domain/usecases/get_memes.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockMemeRepository extends Mock implements MemeRepository {}

void main() {
  late GetMemesUseCase useCase;
  late MockMemeRepository mockRepository;

  setUp(() {
    mockRepository = MockMemeRepository();
    useCase = GetMemesUseCase(mockRepository);
  });

  group('GetMemesUseCase', () {
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

    test('should return memes from repository when in online mode', () async {
      // Arrange
      when(() => mockRepository.isOfflineMode())
          .thenAnswer((_) async => const Right(false));
      when(() => mockRepository.getMemes())
          .thenAnswer((_) async => const Right(tMemes));
      when(() => mockRepository.cacheMemes(any()))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tMemes));
      verify(() => mockRepository.isOfflineMode()).called(1);
      verify(() => mockRepository.getMemes()).called(1);
      verify(() => mockRepository.cacheMemes(tMemes)).called(1);
    });

    test('should return cached memes when in offline mode', () async {
      // Arrange
      when(() => mockRepository.isOfflineMode())
          .thenAnswer((_) async => const Right(true));
      when(() => mockRepository.getCachedMemes())
          .thenAnswer((_) async => const Right(tMemes));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tMemes));
      verify(() => mockRepository.isOfflineMode()).called(1);
      verify(() => mockRepository.getCachedMemes()).called(1);
      verifyNever(() => mockRepository.getMemes());
    });

    test('should return cached memes when network call fails in online mode', () async {
      // Arrange
      when(() => mockRepository.isOfflineMode())
          .thenAnswer((_) async => const Right(false));
      when(() => mockRepository.getMemes())
          .thenAnswer((_) async => const Left(NetworkFailure('No internet')));
      when(() => mockRepository.getCachedMemes())
          .thenAnswer((_) async => const Right(tMemes));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tMemes));
      verify(() => mockRepository.isOfflineMode()).called(1);
      verify(() => mockRepository.getMemes()).called(1);
      verify(() => mockRepository.getCachedMemes()).called(1);
    });

    test('should return failure when offline mode check fails', () async {
      // Arrange
      const tFailure = CacheFailure('Cache error');
      when(() => mockRepository.isOfflineMode())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.isOfflineMode()).called(1);
      verifyNever(() => mockRepository.getMemes());
      verifyNever(() => mockRepository.getCachedMemes());
    });
  });
}
