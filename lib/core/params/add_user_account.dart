import 'package:equatable/equatable.dart';

class AddAccountParams extends Equatable {
  final int? id;
  final String? link; // Change this to an int if required by the backend

  const AddAccountParams({this.id, this.link});

  @override
  List<Object?> get props => [id, link];

  Map<String, dynamic> toJson() => {
    'social_media_id': id,
    'link': link,
  };
}