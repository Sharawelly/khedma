part of 'provider_jobs_cubit.dart';

class ProviderJobsSnapshot {
  const ProviderJobsSnapshot({
    this.pendingJobs = const <PendingJobEntity>[],
    this.history = const <BookingHistoryEntity>[],
    this.historyHasNextPage = false,
    this.availabilityStatus = 1,
    this.currentJob,
  });

  final List<PendingJobEntity> pendingJobs;
  final List<BookingHistoryEntity> history;
  final bool historyHasNextPage;
  final int availabilityStatus;
  final AcceptedJobEntity? currentJob;

  bool get isOnline => availabilityStatus == 0;

  ProviderJobsSnapshot copyWith({
    List<PendingJobEntity>? pendingJobs,
    List<BookingHistoryEntity>? history,
    bool? historyHasNextPage,
    int? availabilityStatus,
    AcceptedJobEntity? currentJob,
  }) => ProviderJobsSnapshot(
    pendingJobs: pendingJobs ?? this.pendingJobs,
    history: history ?? this.history,
    historyHasNextPage: historyHasNextPage ?? this.historyHasNextPage,
    availabilityStatus: availabilityStatus ?? this.availabilityStatus,
    currentJob: currentJob ?? this.currentJob,
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
