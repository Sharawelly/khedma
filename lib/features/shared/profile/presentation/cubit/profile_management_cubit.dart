import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/profile_image_entity.dart';
import '../../domain/entities/saved_address_entity.dart';
import '../../domain/usecases/params/profile_params.dart';
import '../../domain/usecases/profile_use_cases.dart';

part 'profile_management_state.dart';

sealed class ProfileCommand {
  const ProfileCommand();
}

class LoadAddresses extends ProfileCommand {
  const LoadAddresses();
}

class CaptureCurrentAddress extends ProfileCommand {
  const CaptureCurrentAddress(this.label);
  final String label;
}

/// Saves a point the user chose on the map. Unlike [CaptureCurrentAddress] this
/// does no GPS or geocoding of its own - the picker already resolved both, and
/// re-deriving them here would overwrite the exact point the user confirmed.
class SavePickedAddress extends ProfileCommand {
  const SavePickedAddress({
    required this.label,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final String addressLine;
  final double latitude;
  final double longitude;
}

class RemoveAddress extends ProfileCommand {
  const RemoveAddress(this.id);
  final String id;
}

class SaveProfile extends ProfileCommand {
  const SaveProfile(this.params);
  final UpdateProfileParams params;
}

class SavePassword extends ProfileCommand {
  const SavePassword(this.params);
  final ChangePasswordParams params;
}

class LoadProviderMedia extends ProfileCommand {
  const LoadProviderMedia();
}

class UploadProviderMedia extends ProfileCommand {
  const UploadProviderMedia({required this.files, required this.certificate});
  final List<File> files;
  final bool certificate;
}

class RemoveProviderMedia extends ProfileCommand {
  const RemoveProviderMedia({required this.id, required this.certificate});
  final String id;
  final bool certificate;
}

class ProfileManagementCubit extends Cubit<ProfileManagementState> {
  ProfileManagementCubit({
    required this.updateProfile,
    required this.changePassword,
    required this.getAddresses,
    required this.addAddress,
    required this.deleteAddress,
    required this.getCertificates,
    required this.addCertificates,
    required this.deleteCertificate,
    required this.getPortfolio,
    required this.addPortfolio,
    required this.deletePortfolioImage,
  }) : super(const ProfileManagementInitial());

  final UpdateProfile updateProfile;
  final ChangePassword changePassword;
  final GetAddresses getAddresses;
  final AddAddress addAddress;
  final DeleteAddress deleteAddress;
  final GetCertificates getCertificates;
  final AddCertificates addCertificates;
  final DeleteCertificate deleteCertificate;
  final GetPortfolio getPortfolio;
  final AddPortfolio addPortfolio;
  final DeletePortfolioImage deletePortfolioImage;

  Future<void> execute(ProfileCommand command) async {
    emit(const ProfileManagementLoading());
    if (command is LoadAddresses) {
      await _loadAddresses();
    } else if (command is CaptureCurrentAddress) {
      await _captureAddress(command.label);
    } else if (command is SavePickedAddress) {
      await _createAddress(
        AddAddressParams(
          label: command.label,
          addressLine: command.addressLine,
          latitude: command.latitude,
          longitude: command.longitude,
        ),
      );
    } else if (command is RemoveAddress) {
      await _removeAddress(command.id);
    } else if (command is SaveProfile) {
      await _saveProfile(command.params);
    } else if (command is SavePassword) {
      await _savePassword(command.params);
    } else if (command is LoadProviderMedia) {
      await _loadMedia();
    } else if (command is UploadProviderMedia) {
      await _uploadMedia(command);
    } else if (command is RemoveProviderMedia) {
      await _removeMedia(command);
    }
  }

  Future<void> _loadAddresses() async {
    final response = await getAddresses();
    response.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (addresses) => emit(ProfileAddressesSuccess(addresses)),
    );
  }

  Future<void> _createAddress(AddAddressParams params) async {
    final response = await addAddress(params);
    response.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (_) => _loadAddresses(),
    );
  }

  Future<void> _captureAddress(String label) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      emit(const ProfileManagementFailure('location_services_disabled'));
      return;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      emit(const ProfileManagementFailure('location_permission_denied'));
      return;
    }
    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final addressLine = _addressLine(placemarks);
      await _createAddress(
        AddAddressParams(
          label: label,
          addressLine: addressLine,
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } on PlatformException {
      emit(const ProfileManagementFailure('location_lookup_failed'));
    }
  }

  String _addressLine(List<Placemark> placemarks) {
    if (placemarks.isEmpty) {
      return '';
    }
    final place = placemarks.first;
    return <String?>[
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.country,
    ].whereType<String>().where((part) => part.isNotEmpty).join(', ');
  }

  Future<void> _removeAddress(String id) async {
    final response = await deleteAddress(id);
    response.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (_) => _loadAddresses(),
    );
  }

  Future<void> _saveProfile(UpdateProfileParams params) async {
    final response = await updateProfile(params);
    response.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (_) => emit(const ProfileSaved()),
    );
  }

  Future<void> _savePassword(ChangePasswordParams params) async {
    final response = await changePassword(params);
    response.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (_) => emit(const PasswordSaved()),
    );
  }

  Future<void> _loadMedia() async {
    final certificatesResponse = await getCertificates();
    final portfolioResponse = await getPortfolio();
    certificatesResponse.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (certificates) => portfolioResponse.fold(
        (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
        (portfolio) => emit(ProfileMediaSuccess(certificates, portfolio)),
      ),
    );
  }

  Future<void> _uploadMedia(UploadProviderMedia command) async {
    final response = command.certificate
        ? await addCertificates(command.files)
        : await addPortfolio(command.files);
    response.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (_) => _loadMedia(),
    );
  }

  Future<void> _removeMedia(RemoveProviderMedia command) async {
    final response = command.certificate
        ? await deleteCertificate(command.id)
        : await deletePortfolioImage(command.id);
    response.fold(
      (failure) => emit(ProfileManagementFailure(failure.message ?? '')),
      (_) => _loadMedia(),
    );
  }
}
