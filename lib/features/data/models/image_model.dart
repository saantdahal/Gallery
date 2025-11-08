import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class ImageModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final int width;

  @HiveField(3)
  final int height;

  @HiveField(4)
  final String url;

  @HiveField(5)
  @JsonKey(name: 'download_url')
  final String downloadUrl;

  @HiveField(6)
  @JsonKey(defaultValue: false)
  final bool isFavorite;

  const ImageModel({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
    this.isFavorite = false,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  ImageModel copyWith({
    String? id,
    String? author,
    int? width,
    int? height,
    String? url,
    String? downloadUrl,
    bool? isFavorite,
  }) {
    return ImageModel(
      id: id ?? this.id,
      author: author ?? this.author,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props =>
      [id, author, width, height, url, downloadUrl, isFavorite];
}
