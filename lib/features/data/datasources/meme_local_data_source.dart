import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:meme_editor_mobile/core/constants/constants.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';
import 'package:meme_editor_mobile/features/data/models/meme_model.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MemeLocalDataSource {
  Future<List<MemeModel>> getCachedMemes();
  Future<void> cacheMemes(List<MemeModel> memes);
  Future<void> saveMemeEdit(MemeEdit memeEdit);
  Future<MemeEdit?> getMemeEdit(String memeId);
  Future<List<MemeEdit>> getAllMemeEdits();
  Future<void> deleteMemeEdit(String memeId);
  Future<bool> isOfflineMode();
  Future<void> setOfflineMode(bool isOffline);
}

class MemeLocalDataSourceImpl implements MemeLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Box<String> memeEditBox;

  MemeLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.memeEditBox,
  });

  @override
  Future<List<MemeModel>> getCachedMemes() async {
    try {
      final jsonString = sharedPreferences.getString(StorageKeys.memes);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => MemeModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheFailure('Failed to get cached memes: $e');
    }
  }

  @override
  Future<void> cacheMemes(List<MemeModel> memes) async {
    try {
      final jsonString = json.encode(memes.map((meme) => meme.toJson()).toList());
      await sharedPreferences.setString(StorageKeys.memes, jsonString);
    } catch (e) {
      throw CacheFailure('Failed to cache memes: $e');
    }
  }

  @override
  Future<void> saveMemeEdit(MemeEdit memeEdit) async {
    try {
      final jsonString = json.encode(memeEdit.toJson());
      await memeEditBox.put(memeEdit.memeId, jsonString);
    } catch (e) {
      throw CacheFailure('Failed to save meme edit: $e');
    }
  }

  @override
  Future<MemeEdit?> getMemeEdit(String memeId) async {
    try {
      final jsonString = memeEditBox.get(memeId);
      if (jsonString != null) {
        final jsonMap = json.decode(jsonString);
        return MemeEdit.fromJson(jsonMap);
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get meme edit: $e');
    }
  }

  @override
  Future<List<MemeEdit>> getAllMemeEdits() async {
    try {
      final List<MemeEdit> edits = [];
      for (final key in memeEditBox.keys) {
        final jsonString = memeEditBox.get(key);
        if (jsonString != null) {
          final jsonMap = json.decode(jsonString);
          edits.add(MemeEdit.fromJson(jsonMap));
        }
      }
      return edits;
    } catch (e) {
      throw CacheFailure('Failed to get all meme edits: $e');
    }
  }

  @override
  Future<void> deleteMemeEdit(String memeId) async {
    try {
      await memeEditBox.delete(memeId);
    } catch (e) {
      throw CacheFailure('Failed to delete meme edit: $e');
    }
  }

  @override
  Future<bool> isOfflineMode() async {
    return sharedPreferences.getBool(StorageKeys.offlineMode) ?? false;
  }

  @override
  Future<void> setOfflineMode(bool isOffline) async {
    await sharedPreferences.setBool(StorageKeys.offlineMode, isOffline);
  }
}
