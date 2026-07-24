part of 'provider_services_cubit.dart';

sealed class ProviderServicesState extends Equatable {
  const ProviderServicesState();

  @override
  List<Object?> get props => <Object?>[];
}

class ProviderServicesInitial extends ProviderServicesState {
  const ProviderServicesInitial();
}

class ProviderServicesLoading extends ProviderServicesState {
  const ProviderServicesLoading();
}

class ProviderServicesFailure extends ProviderServicesState {
  const ProviderServicesFailure(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class ProviderServicesLoaded extends ProviderServicesState {
  const ProviderServicesLoaded(this.services, {this.dirty = false});

  /// The whole active catalogue, each flagged with whether it is offered.
  final List<ProviderServiceEntity> services;

  /// True once the working copy differs from what the server holds.
  final bool dirty;

  List<ProviderServiceEntity> get offered =>
      services.where((service) => service.isOffered).toList();

  @override
  List<Object?> get props => <Object?>[services, dirty];
}

/// Emitted after a successful write so the UI can confirm and close.
class ProviderServicesSaved extends ProviderServicesLoaded {
  const ProviderServicesSaved(super.services);
}
