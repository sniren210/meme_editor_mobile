// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme_edit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemeEdit _$MemeEditFromJson(Map<String, dynamic> json) => MemeEdit(
      memeId: json['memeId'] as String,
      textElements: (json['textElements'] as List<dynamic>)
          .map((e) => TextElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      stickerElements: (json['stickerElements'] as List<dynamic>)
          .map((e) => StickerElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MemeEditToJson(MemeEdit instance) => <String, dynamic>{
      'memeId': instance.memeId,
      'textElements': instance.textElements,
      'stickerElements': instance.stickerElements,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

TextElement _$TextElementFromJson(Map<String, dynamic> json) => TextElement(
      id: json['id'] as String,
      text: json['text'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      fontSize: (json['fontSize'] as num).toDouble(),
      color: json['color'] as String,
      fontWeight: json['fontWeight'] as String,
    );

Map<String, dynamic> _$TextElementToJson(TextElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'x': instance.x,
      'y': instance.y,
      'fontSize': instance.fontSize,
      'color': instance.color,
      'fontWeight': instance.fontWeight,
    };

StickerElement _$StickerElementFromJson(Map<String, dynamic> json) =>
    StickerElement(
      id: json['id'] as String,
      stickerType: json['stickerType'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      size: (json['size'] as num).toDouble(),
    );

Map<String, dynamic> _$StickerElementToJson(StickerElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stickerType': instance.stickerType,
      'x': instance.x,
      'y': instance.y,
      'size': instance.size,
    };
