import 'package:dartz/dartz.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/repositories/meme_repository.dart';

class GetMemesUseCase {
  final MemeRepository repository;

  GetMemesUseCase(this.repository);

  Future<Either<Failure, List<Meme>>> call() async {
    final isOfflineResult = await repository.isOfflineMode();
    
    return isOfflineResult.fold(
      (failure) => Left(failure),
      (isOffline) async {
        if (isOffline) {
          return await repository.getCachedMemes();
        } else {
          final result = await repository.getMemes();
          return result.fold(
            (failure) async {
              // If network fails, try to get cached memes
              return await repository.getCachedMemes();
            },
            (memes) async {
              // Cache the fetched memes
              await repository.cacheMemes(memes);
              return Right(memes);
            },
          );
        }
      },
    );
  }
}
