import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meme_edit.g.dart';

@JsonSerializable()
class MemeEdit extends Equatable {
  final String memeId;
  final List<TextElement> textElements;
  final List<StickerElement> stickerElements;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MemeEdit({
    required this.memeId,
    required this.textElements,
    required this.stickerElements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemeEdit.fromJson(Map<String, dynamic> json) => _$MemeEditFromJson(json);
  Map<String, dynamic> toJson() => _$MemeEditToJson(this);

  MemeEdit copyWith({
    String? memeId,
    List<TextElement>? textElements,
    List<StickerElement>? stickerElements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MemeEdit(
      memeId: memeId ?? this.memeId,
      textElements: textElements ?? this.textElements,
      stickerElements: stickerElements ?? this.stickerElements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [memeId, textElements, stickerElements, createdAt, updatedAt];
}

@JsonSerializable()
class TextElement extends Equatable {
  final String id;
  final String text;
  final double x;
  final double y;
  final double fontSize;
  final String color;
  final String fontWeight;

  const TextElement({
    required this.id,
    required this.text,
    required this.x,
    required this.y,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  factory TextElement.fromJson(Map<String, dynamic> json) => _$TextElementFromJson(json);
  Map<String, dynamic> toJson() => _$TextElementToJson(this);

  TextElement copyWith({
    String? id,
    String? text,
    double? x,
    double? y,
    double? fontSize,
    String? color,
    String? fontWeight,
  }) {
    return TextElement(
      id: id ?? this.id,
      text: text ?? this.text,
      x: x ?? this.x,
      y: y ?? this.y,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }

  @override
  List<Object> get props => [id, text, x, y, fontSize, color, fontWeight];
}

@JsonSerializable()
class StickerElement extends Equatable {
  final String id;
  final String stickerType;
  final double x;
  final double y;
  final double size;

  const StickerElement({
    required this.id,
    required this.stickerType,
    required this.x,
    required this.y,
    required this.size,
  });

  factory StickerElement.fromJson(Map<String, dynamic> json) => _$StickerElementFromJson(json);
  Map<String, dynamic> toJson() => _$StickerElementToJson(this);

  StickerElement copyWith({
    String? id,
    String? stickerType,
    double? x,
    double? y,
    double? size,
  }) {
    return StickerElement(
      id: id ?? this.id,
      stickerType: stickerType ?? this.stickerType,
      x: x ?? this.x,
      y: y ?? this.y,
      size: size ?? this.size,
    );
  }

  @override
  List<Object> get props => [id, stickerType, x, y, size];
}
