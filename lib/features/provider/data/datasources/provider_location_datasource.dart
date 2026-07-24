import 'package:geolocator/geolocator.dart';

import '/core/error/exceptions.dart';
import '../../domain/entities/provider_entities.dart';

abstract class ProviderLocationDataSource {
  Future<ProviderCoordinatesEntity> getCurrentPosition();
  Stream<ProviderCoordinatesEntity> watchPosition();
}

class ProviderLocationDataSourceImpl implements ProviderLocationDataSource {
  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  @override
  Future<ProviderCoordinatesEntity> getCurrentPosition() async {
    try {
      await _ensurePermission();
      final position = await Geolocator.getCurrentPosition(
        locationSettings: _settings,
      );
      return _coordinates(position);
    } on LocationServiceDisabledException {
      throw const ServerException(
        message: 'provider_location_services_required',
      );
    } on PermissionDeniedException {
      throw const ServerException(
        message: 'provider_location_permission_required',
      );
    }
  }

  @override
  Stream<ProviderCoordinatesEntity> watchPosition() async* {
    try {
      await _ensurePermission();
      yield* Geolocator.getPositionStream(
        locationSettings: _settings,
      ).map(_coordinates);
    } on LocationServiceDisabledException {
      throw const ServerException(
        message: 'provider_location_services_required',
      );
    } on PermissionDeniedException {
      throw const ServerException(
        message: 'provider_location_permission_required',
      );
    }
  }

  Future<void> _ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const ServerException(
        message: 'provider_location_services_required',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const ServerException(
        message: 'provider_location_permission_required',
      );
    }
  }

  ProviderCoordinatesEntity _coordinates(Position position) =>
      ProviderCoordinatesEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        headingDegrees: position.heading.isFinite ? position.heading : null,
      );
}
