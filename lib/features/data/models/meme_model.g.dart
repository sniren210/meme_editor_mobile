// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemeModel _$MemeModelFromJson(Map<String, dynamic> json) => MemeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      boxCount: (json['box_count'] as num).toInt(),
    );

Map<String, dynamic> _$MemeModelToJson(MemeModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'box_count': instance.boxCount,
    };

MemesResponseModel _$MemesResponseModelFromJson(Map<String, dynamic> json) =>
    MemesResponseModel(
      success: json['success'] as bool,
      data: MemesDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemesResponseModelToJson(MemesResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

MemesDataModel _$MemesDataModelFromJson(Map<String, dynamic> json) =>
    MemesDataModel(
      memes: (json['memes'] as List<dynamic>)
          .map((e) => MemeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MemesDataModelToJson(MemesDataModel instance) =>
    <String, dynamic>{
      'memes': instance.memes,
    };
