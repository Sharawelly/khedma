import '../../domain/entities/saved_address_entity.dart';

class SavedAddressModel extends SavedAddressEntity {
  const SavedAddressModel({
    required super.id,
    required super.label,
    required super.addressLine,
    required super.latitude,
    required super.longitude,
  });

  factory SavedAddressModel.fromJson(Map<String, dynamic> json) {
    return SavedAddressModel(
      id: json['id'] as String,
      label: json['label'] as String,
      addressLine: json['addresssLine'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'label': label,
    'addresssLine': addressLine,
    'latitude': latitude,
    'longitude': longitude,
  };
}
