import '../../domain/entities/profile_image_entity.dart';

class ProfileImageModel extends ProfileImageEntity {
  const ProfileImageModel({required super.id, required super.imageUrl});

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) {
    return ProfileImageModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'imageUrl': imageUrl,
  };
}
