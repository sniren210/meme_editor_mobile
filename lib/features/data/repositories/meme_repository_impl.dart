import 'package:dartz/dartz.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:meme_editor_mobile/core/network/network_info.dart';
import 'package:meme_editor_mobile/features/data/datasources/file_operations_data_source.dart';
import 'package:meme_editor_mobile/features/data/datasources/meme_local_data_source.dart';
import 'package:meme_editor_mobile/features/data/datasources/meme_remote_data_source.dart';
import 'package:meme_editor_mobile/features/data/models/meme_model.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';
import 'package:meme_editor_mobile/features/domain/repositories/meme_repository.dart';

class MemeRepositoryImpl implements MemeRepository {
  final MemeRemoteDataSource remoteDataSource;
  final MemeLocalDataSource localDataSource;
  final FileOperationsDataSource fileOperationsDataSource;
  final NetworkInfo networkInfo;

  MemeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.fileOperationsDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Meme>>> getMemes() async {
    try {
      if (await networkInfo.isConnected) {
        final memes = await remoteDataSource.getMemes();
        return Right(memes);
      } else {
        return const Left(NetworkFailure('No internet connection'));
      }
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Meme>>> getCachedMemes() async {
    try {
      final memes = await localDataSource.getCachedMemes();
      return Right(memes);
    } on CacheFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> cacheMemes(List<Meme> memes) async {
    try {
      final memeModels = memes.map((meme) => MemeModel.fromEntity(meme)).toList();
      await localDataSource.cacheMemes(memeModels);
      return const Right(true);
    } on CacheFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, MemeEdit>> saveMemeEdit(MemeEdit memeEdit) async {
    try {
      await localDataSource.saveMemeEdit(memeEdit);
      return Right(memeEdit);
    } on CacheFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, MemeEdit?>> getMemeEdit(String memeId) async {
    try {
      final memeEdit = await localDataSource.getMemeEdit(memeId);
      return Right(memeEdit);
    } on CacheFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MemeEdit>>> getAllMemeEdits() async {
    try {
      final edits = await localDataSource.getAllMemeEdits();
      return Right(edits);
    } on CacheFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMemeEdit(String memeId) async {
    try {
      await localDataSource.deleteMemeEdit(memeId);
      return const Right(true);
    } on CacheFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> saveImageToGallery(String imagePath) async {
    try {
      final savedPath = await fileOperationsDataSource.saveImageToGallery(imagePath);
      return Right(savedPath);
    } on PermissionFailure catch (failure) {
      return Left(failure);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> shareImage(String imagePath) async {
    try {
      final success = await fileOperationsDataSource.shareImage(imagePath);
      return Right(success);
    } on ServerFailure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isOfflineMode() async {
    try {
      final isOffline = await localDataSource.isOfflineMode();
      return Right(isOffline);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> setOfflineMode(bool isOffline) async {
    try {
      await localDataSource.setOfflineMode(isOffline);
      return Right(isOffline);
    } catch (e) {
      return Left(CacheFailure('Unexpected cache error: $e'));
    }
  }
}
