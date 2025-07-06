import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meme.g.dart';

@JsonSerializable()
class Meme extends Equatable {
  final String id;
  final String name;
  final String url;
  final int width;
  final int height;
  @JsonKey(name: 'box_count')
  final int boxCount;

  const Meme({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
  });

  factory Meme.fromJson(Map<String, dynamic> json) => _$MemeFromJson(json);
  Map<String, dynamic> toJson() => _$MemeToJson(this);

  @override
  List<Object> get props => [id, name, url, width, height, boxCount];
}

@JsonSerializable()
class MemesResponse extends Equatable {
  final bool success;
  final MemesData data;

  const MemesResponse({
    required this.success,
    required this.data,
  });

  factory MemesResponse.fromJson(Map<String, dynamic> json) => _$MemesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MemesResponseToJson(this);

  @override
  List<Object> get props => [success, data];
}

@JsonSerializable()
class MemesData extends Equatable {
  final List<Meme> memes;

  const MemesData({
    required this.memes,
  });

  factory MemesData.fromJson(Map<String, dynamic> json) => _$MemesDataFromJson(json);
  Map<String, dynamic> toJson() => _$MemesDataToJson(this);

  @override
  List<Object> get props => [memes];
}
