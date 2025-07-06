import 'package:json_annotation/json_annotation.dart';
import 'package:meme_editor_mobile/features/domain/entities/meme.dart';

part 'meme_model.g.dart';

@JsonSerializable()
class MemeModel extends Meme {
  const MemeModel({
    required super.id,
    required super.name,
    required super.url,
    required super.width,
    required super.height,
    required super.boxCount,
  });

  factory MemeModel.fromJson(Map<String, dynamic> json) => _$MemeModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MemeModelToJson(this);

  factory MemeModel.fromEntity(Meme meme) {
    return MemeModel(
      id: meme.id,
      name: meme.name,
      url: meme.url,
      width: meme.width,
      height: meme.height,
      boxCount: meme.boxCount,
    );
  }
}

@JsonSerializable()
class MemesResponseModel extends MemesResponse {
  const MemesResponseModel({
    required super.success,
    required MemesDataModel super.data,
  });

  factory MemesResponseModel.fromJson(Map<String, dynamic> json) => _$MemesResponseModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MemesResponseModelToJson(this);
}

@JsonSerializable()
class MemesDataModel extends MemesData {
  const MemesDataModel({
    required List<MemeModel> memes,
  }) : super(memes: memes);

  factory MemesDataModel.fromJson(Map<String, dynamic> json) => _$MemesDataModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MemesDataModelToJson(this);
}
