import 'package:dartz/dartz.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';

abstract class MemeRepository {
  Future<Either<Failure, List<Meme>>> getMemes();
  Future<Either<Failure, List<Meme>>> getCachedMemes();
  Future<Either<Failure, bool>> cacheMemes(List<Meme> memes);
  
  Future<Either<Failure, MemeEdit>> saveMemeEdit(MemeEdit memeEdit);
  Future<Either<Failure, MemeEdit?>> getMemeEdit(String memeId);
  Future<Either<Failure, List<MemeEdit>>> getAllMemeEdits();
  Future<Either<Failure, bool>> deleteMemeEdit(String memeId);
  
  Future<Either<Failure, String>> saveImageToGallery(String imagePath);
  Future<Either<Failure, bool>> shareImage(String imagePath);
  
  Future<Either<Failure, bool>> isOfflineMode();
  Future<Either<Failure, bool>> setOfflineMode(bool isOffline);
}
