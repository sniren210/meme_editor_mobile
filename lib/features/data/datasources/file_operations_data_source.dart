import 'dart:io';
import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

abstract class FileOperationsDataSource {
  Future<String> saveImageToGallery(String imagePath);
  Future<bool> shareImage(String imagePath);
}

class FileOperationsDataSourceImpl implements FileOperationsDataSource {
  @override
  Future<String> saveImageToGallery(String imagePath) async {
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          throw const PermissionFailure('Storage permission denied');
        }
      }

      // For Android 13+ (API 33+), use photos permission
      if (Platform.isAndroid) {
        var photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted) {
          photosStatus = await Permission.photos.request();
          if (!photosStatus.isGranted) {
            throw const PermissionFailure('Photos permission denied');
          }
        }
      }

      final result = await ImageGallerySaver.saveFile(imagePath);
      
      if (result['isSuccess'] == true) {
        return result['filePath'] ?? imagePath;
      } else {
        throw const ServerFailure('Failed to save image to gallery');
      }
    } catch (e) {
      if (e is PermissionFailure) {
        rethrow;
      }
      throw ServerFailure('Error saving image: $e');
    }
  }

  @override
  Future<bool> shareImage(String imagePath) async {
    try {
      await Share.shareXFiles([XFile(imagePath)], text: 'Check out my meme!');
      return true;
    } catch (e) {
      throw ServerFailure('Error sharing image: $e');
    }
  }
}
