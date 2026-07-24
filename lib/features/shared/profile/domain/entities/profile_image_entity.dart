import 'package:equatable/equatable.dart';

class ProfileImageEntity extends Equatable {
  const ProfileImageEntity({required this.id, required this.imageUrl});

  final String id;
  final String imageUrl;

  @override
  List<Object?> get props => <Object?>[id, imageUrl];
}
