part of 'provider_jobs_cubit.dart';

class ProviderJobsSnapshot {
  const ProviderJobsSnapshot({
    this.pendingJobs = const <PendingJobEntity>[],
    this.history = const <BookingHistoryEntity>[],
    this.historyHasNextPage = false,
    this.availabilityStatus = 1,
    this.currentJob,
    this.workingLatitude,
    this.workingLongitude,
    this.livePosition,
    this.route,
  });

  final List<PendingJobEntity> pendingJobs;
  final List<BookingHistoryEntity> history;
  final bool historyHasNextPage;
  final int availabilityStatus;
  final AcceptedJobEntity? currentJob;

  /// The point this provider is available at. Dispatch matches customers
  /// against it, so going online without one would put them in the pool with no
  /// position and they would never be offered anything.
  final double? workingLatitude;
  final double? workingLongitude;

  /// Latest device fix while travelling, so the tracking map can move the
  /// provider's marker without opening a second GPS subscription.
  final ProviderCoordinatesEntity? livePosition;

  /// The drive to the current job, refreshed as the provider moves.
  final BookingRouteEntity? route;

  bool get isOnline => availabilityStatus == 0;

  bool get hasWorkingLocation =>
      workingLatitude != null && workingLongitude != null;

  ProviderJobsSnapshot copyWith({
    List<PendingJobEntity>? pendingJobs,
    List<BookingHistoryEntity>? history,
    bool? historyHasNextPage,
    int? availabilityStatus,
    AcceptedJobEntity? currentJob,
    double? workingLatitude,
    double? workingLongitude,
    ProviderCoordinatesEntity? livePosition,
    BookingRouteEntity? route,
  }) => ProviderJobsSnapshot(
    pendingJobs: pendingJobs ?? this.pendingJobs,
    history: history ?? this.history,
    historyHasNextPage: historyHasNextPage ?? this.historyHasNextPage,
    availabilityStatus: availabilityStatus ?? this.availabilityStatus,
    currentJob: currentJob ?? this.currentJob,
    workingLatitude: workingLatitude ?? this.workingLatitude,
    workingLongitude: workingLongitude ?? this.workingLongitude,
    livePosition: livePosition ?? this.livePosition,
    route: route ?? this.route,
  );
}

sealed class ProviderJobsState extends Equatable {
  const ProviderJobsState(this.snapshot);
  final ProviderJobsSnapshot snapshot;

  @override
  List<Object?> get props => <Object?>[
    snapshot.pendingJobs,
    snapshot.history,
    snapshot.historyHasNextPage,
    snapshot.availabilityStatus,
    snapshot.currentJob,
    snapshot.livePosition,
    snapshot.route,
  ];
}

class ProviderJobsInitial extends ProviderJobsState {
  const ProviderJobsInitial() : super(const ProviderJobsSnapshot());
}

class ProviderJobsLoading extends ProviderJobsState {
  const ProviderJobsLoading(super.snapshot);
}

class ProviderJobsSuccess extends ProviderJobsState {
  const ProviderJobsSuccess(super.snapshot, {this.messageKey});
  final String? messageKey;

  @override
  List<Object?> get props => <Object?>[...super.props, messageKey];
}

class ProviderJobsFailure extends ProviderJobsState {
  const ProviderJobsFailure(super.snapshot, this.messageKey);
  final String messageKey;

  @override
  List<Object?> get props => <Object?>[...super.props, messageKey];
}
