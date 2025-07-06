import 'package:dartz/dartz.dart';
import '../entities/meme_edit.dart';
import '../repositories/meme_repository.dart';
import '../../../../core/error/failures.dart';

class SaveMemeEditUseCase {
  final MemeRepository repository;

  SaveMemeEditUseCase(this.repository);

  Future<Either<Failure, MemeEdit>> call(MemeEdit memeEdit) async {
    return await repository.saveMemeEdit(memeEdit);
  }
}

class GetMemeEditUseCase {
  final MemeRepository repository;

  GetMemeEditUseCase(this.repository);

  Future<Either<Failure, MemeEdit?>> call(String memeId) async {
    return await repository.getMemeEdit(memeId);
  }
}

class SaveImageToGalleryUseCase {
  final MemeRepository repository;

  SaveImageToGalleryUseCase(this.repository);

  Future<Either<Failure, String>> call(String imagePath) async {
    return await repository.saveImageToGallery(imagePath);
  }
}

class ShareImageUseCase {
  final MemeRepository repository;

  ShareImageUseCase(this.repository);

  Future<Either<Failure, bool>> call(String imagePath) async {
    return await repository.shareImage(imagePath);
  }
}

class ToggleOfflineModeUseCase {
  final MemeRepository repository;

  ToggleOfflineModeUseCase(this.repository);

  Future<Either<Failure, bool>> call(bool isOffline) async {
    return await repository.setOfflineMode(isOffline);
  }
}
