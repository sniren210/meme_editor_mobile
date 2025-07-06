import 'package:dartz/dartz.dart';
import '../entities/meme.dart';
import '../repositories/meme_repository.dart';
import '../../../../core/error/failures.dart';

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
