// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meme _$MemeFromJson(Map<String, dynamic> json) => Meme(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      boxCount: (json['box_count'] as num).toInt(),
    );

Map<String, dynamic> _$MemeToJson(Meme instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'box_count': instance.boxCount,
    };

MemesResponse _$MemesResponseFromJson(Map<String, dynamic> json) =>
    MemesResponse(
      success: json['success'] as bool,
      data: MemesData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemesResponseToJson(MemesResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

MemesData _$MemesDataFromJson(Map<String, dynamic> json) => MemesData(
      memes: (json['memes'] as List<dynamic>)
          .map((e) => Meme.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MemesDataToJson(MemesData instance) => <String, dynamic>{
      'memes': instance.memes,
    };
