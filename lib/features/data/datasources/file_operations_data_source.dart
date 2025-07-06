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
  
  /// Helper method to request storage permissions based on platform and Android version
  Future<bool> _requestStoragePermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), request photos permission
      var photosPermission = await Permission.photos.status;
      if (!photosPermission.isGranted) {
        photosPermission = await Permission.photos.request();
        if (!photosPermission.isGranted) {
          return false;
        }
      }
      
      // For older Android versions, also check storage permission
      var storagePermission = await Permission.storage.status;
      if (!storagePermission.isGranted) {
        storagePermission = await Permission.storage.request();
        // Storage permission might be denied on newer Android versions, that's okay
      }
      
    } else if (Platform.isIOS) {
      // For iOS, request photos permission
      var photosPermission = await Permission.photos.status;
      if (!photosPermission.isGranted) {
        photosPermission = await Permission.photos.request();
        if (!photosPermission.isGranted) {
          return false;
        }
      }
    }
    
    return true;
  }
  @override
  Future<String> saveImageToGallery(String imagePath) async {
    try {
      // Check if file exists
      final file = File(imagePath);
      if (!await file.exists()) {
        throw const ServerFailure('Image file does not exist');
      }

      // Request appropriate permissions
      final hasPermissions = await _requestStoragePermissions();
      if (!hasPermissions) {
        throw const PermissionFailure('Storage/Photos permission denied');
      }

      // Save the image to gallery
      final result = await ImageGallerySaver.saveFile(imagePath);
      
      // Check if the result is successful
      if (result != null && result['isSuccess'] == true) {
        return result['filePath'] ?? imagePath;
      } else {
        // Try alternative method if first attempt fails
        final bytes = await file.readAsBytes();
        final alternativeResult = await ImageGallerySaver.saveImage(
          bytes,
          quality: 100,
          name: "meme_${DateTime.now().millisecondsSinceEpoch}",
        );
        
        if (alternativeResult != null && alternativeResult['isSuccess'] == true) {
          return alternativeResult['filePath'] ?? imagePath;
        } else {
          throw const ServerFailure('Failed to save image to gallery');
        }
      }
    } catch (e) {
      if (e is PermissionFailure || e is ServerFailure) {
        rethrow;
      }
      throw ServerFailure('Error saving image: ${e.toString()}');
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
