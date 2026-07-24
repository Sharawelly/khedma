import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/provider_entities.dart';
import '../../domain/usecases/provider_use_cases.dart';

part 'provider_services_state.dart';

/// Owns the set of services a provider offers.
///
/// Selection is held locally while the sheet is open and only written on save,
/// so toggling several services costs one request rather than one per tap.
class ProviderServicesCubit extends Cubit<ProviderServicesState> {
  ProviderServicesCubit({
    required this.getServices,
    required this.updateServices,
  }) : super(const ProviderServicesInitial());

  final GetProviderServices getServices;
  final UpdateProviderServices updateServices;

  Future<void> load() async {
    emit(const ProviderServicesLoading());
    final result = await getServices();
    result.fold(
      (failure) => emit(ProviderServicesFailure(failure.message ?? '')),
      (services) => emit(ProviderServicesLoaded(services)),
    );
  }

  /// Flips one service in the working copy without touching the server.
  void toggle(String serviceId) {
    final current = state;
    if (current is! ProviderServicesLoaded) {
      return;
    }
    emit(
      ProviderServicesLoaded(
        current.services
            .map(
              (service) => service.serviceId == serviceId
                  ? service.copyWith(isOffered: !service.isOffered)
                  : service,
            )
            .toList(),
        dirty: true,
      ),
    );
  }

  Future<void> save() async {
    final current = state;
    if (current is! ProviderServicesLoaded) {
      return;
    }
    final selected = current.offered.map((s) => s.serviceId).toList();
    emit(const ProviderServicesLoading());
    final result = await updateServices(selected);
    result.fold(
      (failure) => emit(ProviderServicesFailure(failure.message ?? '')),
      // The server echoes the stored set, so the screen shows what was
      // persisted rather than what was optimistically toggled.
      (services) => emit(ProviderServicesSaved(services)),
    );
  }
}
