import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meme_editor_mobile/core/constants/constants.dart';
import 'package:meme_editor_mobile/core/error/failures.dart';
import '../models/meme_model.dart';

abstract class MemeRemoteDataSource {
  Future<List<MemeModel>> getMemes();
}

class MemeRemoteDataSourceImpl implements MemeRemoteDataSource {
  final http.Client client;

  MemeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MemeModel>> getMemes() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.memesEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(milliseconds: ApiConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final memesResponse = MemesResponseModel.fromJson(jsonResponse);
        
        if (memesResponse.success) {
          return memesResponse.data.memes.cast<MemeModel>();
        } else {
          throw const ServerFailure('Failed to fetch memes');
        }
      } else {
        throw ServerFailure('Server returned ${response.statusCode}');
      }
    } catch (e) {
      throw ServerFailure('Network error: $e');
    }
  }
}
