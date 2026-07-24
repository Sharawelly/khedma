import 'package:equatable/equatable.dart';

class SavedAddressEntity extends Equatable {
  const SavedAddressEntity({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String label;
  final String addressLine;
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => <Object?>[
    id,
    label,
    addressLine,
    latitude,
    longitude,
  ];
}
