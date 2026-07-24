import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/error/failures.dart';
import '/core/realtime/realtime_events.dart';
import '/core/realtime/realtime_service.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/customer_use_cases.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '../../domain/entities/provider_entities.dart';
import '../../domain/usecases/params/provider_params.dart';
import '../../domain/usecases/provider_use_cases.dart';

part 'provider_jobs_state.dart';

enum ProviderJobsAction {
  recover,
  loadMoreHistory,
  accept,
  reject,
  availability,
  enRoute,
  arrived,
  inProgress,
  complete,
  clearSession,
}

class ProviderJobsCommand {
  const ProviderJobsCommand._(
    this.action, {
    this.bookingId,
    this.online,
    this.eta,
  });

  const ProviderJobsCommand.recover() : this._(ProviderJobsAction.recover);
  const ProviderJobsCommand.loadMoreHistory()
    : this._(ProviderJobsAction.loadMoreHistory);
  const ProviderJobsCommand.accept(String bookingId)
    : this._(ProviderJobsAction.accept, bookingId: bookingId);
  const ProviderJobsCommand.reject(String bookingId)
    : this._(ProviderJobsAction.reject, bookingId: bookingId);
  const ProviderJobsCommand.availability(bool online)
    : this._(ProviderJobsAction.availability, online: online);
  const ProviderJobsCommand.enRoute(String bookingId, {int? eta})
    : this._(ProviderJobsAction.enRoute, bookingId: bookingId, eta: eta);
  const ProviderJobsCommand.arrived(String bookingId)
    : this._(ProviderJobsAction.arrived, bookingId: bookingId);
  const ProviderJobsCommand.inProgress(String bookingId)
    : this._(ProviderJobsAction.inProgress, bookingId: bookingId);
  const ProviderJobsCommand.complete(String bookingId)
    : this._(ProviderJobsAction.complete, bookingId: bookingId);
  const ProviderJobsCommand.clearSession()
    : this._(ProviderJobsAction.clearSession);

  final ProviderJobsAction action;
  final String? bookingId;
  final bool? online;
  final int? eta;
}

class ProviderJobsCubit extends Cubit<ProviderJobsState>
    with WidgetsBindingObserver {
  ProviderJobsCubit({
    required this.getPendingJobs,
    required this.getBookingHistory,
    required this.getBooking,
    required this.acceptJob,
    required this.rejectJob,
    required this.completeJob,
    required this.markEnRoute,
    required this.markArrived,
    required this.markInProgress,
    required this.updateAvailability,
    required this.getCurrentPosition,
    required this.watchPosition,
    required this.publishLocation,
    required this.realtimeService,
  }) : super(const ProviderJobsInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _subscribeToRealtime();
  }

  final GetPendingJobs getPendingJobs;
  final GetBookingHistory getBookingHistory;
  final GetBooking getBooking;
  final AcceptProviderJob acceptJob;
  final RejectProviderJob rejectJob;
  final CompleteProviderJob completeJob;
  final MarkProviderJobEnRoute markEnRoute;
  final MarkProviderJobArrived markArrived;
  final MarkProviderJobInProgress markInProgress;
  final UpdateProviderAvailability updateAvailability;
  final GetProviderCurrentPosition getCurrentPosition;
  final WatchProviderPosition watchPosition;
  final PublishProviderLocation publishLocation;
  final RealtimeService realtimeService;

  Timer? _countdown;
  Timer? _jobStatusPoll;
  final Map<String, DateTime> _offerDeadlines = <String, DateTime>{};
  StreamSubscription<Either<Failure, ProviderCoordinatesEntity>>?
  _positionSubscription;
  final List<StreamSubscription<Object?>> _realtimeSubscriptions =
      <StreamSubscription<Object?>>[];
  final Set<String> _dismissedOfferIds = <String>{};
  int _historyPage = 1;
  bool _loadingMoreHistory = false;

  Future<void> execute(ProviderJobsCommand command) async {
    switch (command.action) {
      case ProviderJobsAction.recover:
        await _recover();
        break;
      case ProviderJobsAction.loadMoreHistory:
        await _loadMoreHistory();
        break;
      case ProviderJobsAction.accept:
        await _accept(command.bookingId!);
        break;
      case ProviderJobsAction.reject:
        await _reject(command.bookingId!);
        break;
      case ProviderJobsAction.availability:
        await _setAvailability(command.online!);
        break;
      case ProviderJobsAction.enRoute:
        await _transition(
          command.bookingId!,
          ProviderJobStage.accepted,
          ProviderJobStage.enRoute,
          () => markEnRoute(
            ProviderJobActionParams(command.bookingId!, eta: command.eta),
          ),
        );
        break;
      case ProviderJobsAction.arrived:
        await _transition(
          command.bookingId!,
          ProviderJobStage.enRoute,
          ProviderJobStage.arrived,
          () => markArrived(command.bookingId!),
        );
        break;
      case ProviderJobsAction.inProgress:
        await _transition(
          command.bookingId!,
          ProviderJobStage.arrived,
          ProviderJobStage.inProgress,
          () => markInProgress(command.bookingId!),
        );
        break;
      case ProviderJobsAction.complete:
        await _transition(
          command.bookingId!,
          ProviderJobStage.inProgress,
          ProviderJobStage.completed,
          () => completeJob(command.bookingId!),
        );
        break;
      case ProviderJobsAction.clearSession:
        await _clearSession();
        break;
    }
  }

  Future<void> _recover() async {
    final snapshot = state.snapshot;
    emit(ProviderJobsLoading(snapshot));
    final pendingResult = await getPendingJobs();
    final historyResult = await getBookingHistory(const BookingHistoryQuery());
    Failure? failure;
    final pending = pendingResult.fold((error) {
      failure = error;
      return snapshot.pendingJobs;
    }, (value) => value);
    var historyHasNextPage = snapshot.historyHasNextPage;
    final history = historyResult.fold(
      (error) {
        failure ??= error;
        return snapshot.history;
      },
      (page) {
        _historyPage = page.pagination.page ?? 1;
        historyHasNextPage = page.pagination.hasNextPage ?? false;
        return page.items;
      },
    );
    final next = snapshot.copyWith(
      pendingJobs: _mergeOffers(state.snapshot.pendingJobs, pending),
      history: history,
      historyHasNextPage: historyHasNextPage,
    );
    if (failure != null) {
      emit(ProviderJobsFailure(next, _message(failure!)));
      return;
    }
    emit(ProviderJobsSuccess(next));
    _synchronizeDeadlines(next.pendingJobs);
    _startCountdown();
  }

  Future<void> _loadMoreHistory() async {
    if (_loadingMoreHistory || !state.snapshot.historyHasNextPage) {
      return;
    }
    _loadingMoreHistory = true;
    final requestedPage = _historyPage + 1;
    final response = await getBookingHistory(
      BookingHistoryQuery(page: requestedPage),
    );
    response.fold(
      (failure) => emit(ProviderJobsFailure(state.snapshot, _message(failure))),
      (page) {
        _historyPage = page.pagination.page ?? requestedPage;
        emit(
          ProviderJobsSuccess(
            state.snapshot.copyWith(
              history: <BookingHistoryEntity>[
                ...state.snapshot.history,
                ...page.items,
              ],
              historyHasNextPage: page.pagination.hasNextPage ?? false,
            ),
          ),
        );
      },
    );
    _loadingMoreHistory = false;
  }

  void _subscribeToRealtime() {
    _realtimeSubscriptions
      ..add(realtimeService.jobDispatched.listen(_addOffer))
      ..add(realtimeService.jobDismissed.listen(_dismissOffer))
      ..add(
        realtimeService.connected
            .where((event) => event.hub == RealtimeHub.booking)
            .listen((_) => unawaited(_recoverPendingOffers())),
      );
  }

  void _addOffer(PendingJobEntity offer) {
    _dismissedOfferIds.remove(offer.bookingId);
    _offerDeadlines[offer.bookingId] = offer.expiresAt;
    emit(
      ProviderJobsSuccess(
        state.snapshot.copyWith(
          pendingJobs: _mergeOffers(
            state.snapshot.pendingJobs,
            <PendingJobEntity>[offer],
          ),
        ),
      ),
    );
    _startCountdown();
  }

  void _dismissOffer(JobOfferDismissed dismissal) {
    _dismissedOfferIds.add(dismissal.bookingId);
    _offerDeadlines.remove(dismissal.bookingId);
    emit(
      ProviderJobsSuccess(
        state.snapshot.copyWith(
          pendingJobs: _withoutOffer(dismissal.bookingId),
        ),
        messageKey: dismissal.kind == JobOfferDismissalKind.cancelled
            ? dismissal.reason ?? 'provider_job_cancelled'
            : null,
      ),
    );
  }

  Future<void> _recoverPendingOffers() async {
    final response = await getPendingJobs();
    response.fold((_) {}, (offers) {
      final merged = _mergeOffers(state.snapshot.pendingJobs, offers);
      _synchronizeDeadlines(merged);
      emit(ProviderJobsSuccess(state.snapshot.copyWith(pendingJobs: merged)));
      _startCountdown();
    });
  }

  List<PendingJobEntity> _mergeOffers(
    List<PendingJobEntity> current,
    List<PendingJobEntity> incoming,
  ) {
    final byBookingId = <String, PendingJobEntity>{
      for (final offer in current)
        if (!_dismissedOfferIds.contains(offer.bookingId))
          offer.bookingId: offer,
      for (final offer in incoming)
        if (!_dismissedOfferIds.contains(offer.bookingId))
          offer.bookingId: offer,
    };
    return byBookingId.values.toList();
  }

  void _synchronizeDeadlines(List<PendingJobEntity> offers) {
    final bookingIds = offers.map((offer) => offer.bookingId).toSet();
    _offerDeadlines.removeWhere(
      (bookingId, _) => !bookingIds.contains(bookingId),
    );
    for (final offer in offers) {
      _offerDeadlines[offer.bookingId] = offer.expiresAt;
    }
  }

  Future<void> _accept(String bookingId) async {
    emit(ProviderJobsLoading(state.snapshot));
    final result = await acceptJob(bookingId);
    result.fold(
      (failure) {
        final jobs = failure is ConflictFailure
            ? _withoutOffer(bookingId)
            : state.snapshot.pendingJobs;
        emit(
          ProviderJobsFailure(
            state.snapshot.copyWith(pendingJobs: jobs),
            failure is ConflictFailure
                ? 'provider_job_already_taken'
                : _message(failure),
          ),
        );
      },
      (job) {
        emit(
          ProviderJobsSuccess(
            state.snapshot.copyWith(
              pendingJobs: _withoutOffer(bookingId),
              currentJob: job,
            ),
          ),
        );
      },
    );
  }

  Future<void> _reject(String bookingId) async {
    emit(ProviderJobsLoading(state.snapshot));
    final result = await rejectJob(bookingId);
    result.fold(
      (failure) => emit(ProviderJobsFailure(state.snapshot, _message(failure))),
      (_) => emit(
        ProviderJobsSuccess(
          state.snapshot.copyWith(pendingJobs: _withoutOffer(bookingId)),
        ),
      ),
    );
  }

  Future<void> _setAvailability(bool online) async {
    emit(ProviderJobsLoading(state.snapshot));
    ProviderCoordinatesEntity? coordinates;
    if (online) {
      final locationResult = await getCurrentPosition();
      final failure = locationResult.fold<Failure?>((error) => error, (value) {
        coordinates = value;
        return null;
      });
      if (failure != null) {
        emit(ProviderJobsFailure(state.snapshot, _message(failure)));
        return;
      }
    }
    final result = await updateAvailability(
      ProviderAvailabilityParams(
        status: online ? 0 : 1,
        latitude: coordinates?.latitude,
        longitude: coordinates?.longitude,
      ),
    );
    result.fold(
      (failure) => emit(ProviderJobsFailure(state.snapshot, _message(failure))),
      (availability) => emit(
        ProviderJobsSuccess(
          state.snapshot.copyWith(availabilityStatus: availability.status),
          messageKey: online ? 'provider_now_online' : 'provider_now_offline',
        ),
      ),
    );
  }

  Future<void> _transition(
    String bookingId,
    ProviderJobStage expected,
    ProviderJobStage next,
    Future<Either<Failure, Unit>> Function() request,
  ) async {
    final current = state.snapshot.currentJob;
    if (current == null ||
        current.bookingId != bookingId ||
        current.stage != expected) {
      emit(
        ProviderJobsFailure(
          state.snapshot,
          'provider_job_action_not_available',
        ),
      );
      return;
    }
    emit(ProviderJobsLoading(state.snapshot));
    final result = await request();
    await result.fold(
      (failure) async {
        emit(ProviderJobsFailure(state.snapshot, _message(failure)));
      },
      (_) async {
        final updated = current.copyWith(stage: next);
        emit(
          ProviderJobsSuccess(
            state.snapshot.copyWith(currentJob: updated),
            messageKey: 'provider_job_status_updated',
          ),
        );
        if (next == ProviderJobStage.enRoute) {
          await _startPublishing();
        } else if (next == ProviderJobStage.arrived ||
            next == ProviderJobStage.completed) {
          await _stopPublishing();
        }
      },
    );
  }

  void _startCountdown() {
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (_) {
      final jobs = state.snapshot.pendingJobs
          .map((job) => job.copyWith(secondsRemaining: _remaining(job)))
          .where((job) => job.secondsRemaining > 0)
          .toList();
      if (jobs.length != state.snapshot.pendingJobs.length || jobs.isNotEmpty) {
        final updated = state.snapshot.copyWith(pendingJobs: jobs);
        if (state is ProviderJobsLoading) {
          emit(ProviderJobsLoading(updated));
        } else {
          emit(ProviderJobsSuccess(updated));
        }
      }
      if (jobs.isEmpty) {
        _countdown?.cancel();
      }
    });
  }

  int _remaining(PendingJobEntity job) {
    final deadline = _offerDeadlines[job.bookingId];
    if (deadline == null) {
      return job.secondsRemaining - 1;
    }
    final milliseconds = deadline.difference(DateTime.now()).inMilliseconds;
    return milliseconds <= 0 ? 0 : (milliseconds + 999) ~/ 1000;
  }

  Future<void> _startPublishing() async {
    await _stopPublishing();
    unawaited(_checkActiveJobStatus());
    _jobStatusPoll = Timer.periodic(
      const Duration(seconds: 30),
      (_) => unawaited(_checkActiveJobStatus()),
    );
    _positionSubscription = watchPosition().listen(
      (locationUpdate) {
        locationUpdate.fold(
          (failure) {
            emit(ProviderJobsFailure(state.snapshot, _message(failure)));
            unawaited(_stopPublishing());
          },
          (coordinates) {
            unawaited(_publishCoordinates(coordinates));
          },
        );
      },
      onError: (Object _) {
        emit(
          ProviderJobsFailure(
            state.snapshot,
            'provider_location_publish_failed',
          ),
        );
        unawaited(_stopPublishing());
      },
    );
  }

  Future<void> _publishCoordinates(
    ProviderCoordinatesEntity coordinates,
  ) async {
    final locationUpdate = await publishLocation(
      ProviderLocationParams(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        headingDegrees: coordinates.headingDegrees,
      ),
    );
    locationUpdate.fold((failure) {
      emit(ProviderJobsFailure(state.snapshot, _message(failure)));
      unawaited(_stopPublishing());
    }, (_) {});
  }

  Future<void> _stopPublishing() async {
    _jobStatusPoll?.cancel();
    _jobStatusPoll = null;
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<void> _checkActiveJobStatus() async {
    final current = state.snapshot.currentJob;
    if (current == null || current.stage != ProviderJobStage.enRoute) {
      return;
    }
    final bookingResult = await getBooking(current.bookingId);
    await bookingResult.fold(
      (failure) async {
        emit(ProviderJobsFailure(state.snapshot, _message(failure)));
      },
      (booking) async {
        final terminalStage = _terminalStage(booking);
        if (terminalStage == null) {
          return;
        }
        emit(
          ProviderJobsSuccess(
            state.snapshot.copyWith(
              currentJob: current.copyWith(stage: terminalStage),
            ),
            messageKey: terminalStage == ProviderJobStage.cancelled
                ? 'provider_job_cancelled'
                : 'provider_job_status_updated',
          ),
        );
        await _stopPublishing();
      },
    );
  }

  ProviderJobStage? _terminalStage(BookingEntity booking) {
    if (booking.cancelledAt != null) {
      return ProviderJobStage.cancelled;
    }
    if (booking.completedAt != null) {
      return ProviderJobStage.completed;
    }
    return null;
  }

  Future<void> _clearSession() async {
    await _stopPublishing();
    _countdown?.cancel();
    _offerDeadlines.clear();
    _dismissedOfferIds.clear();
    emit(const ProviderJobsInitial());
  }

  List<PendingJobEntity> _withoutOffer(String bookingId) => state
      .snapshot
      .pendingJobs
      .where((job) => job.bookingId != bookingId)
      .toList();

  String _message(Failure failure) => failure.message?.isNotEmpty == true
      ? failure.message!
      : 'provider_request_failed';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      unawaited(_stopPublishing());
    } else if (this.state.snapshot.currentJob?.stage ==
        ProviderJobStage.enRoute) {
      unawaited(_startPublishing());
    }
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    _countdown?.cancel();
    for (final subscription in _realtimeSubscriptions) {
      await subscription.cancel();
    }
    await _stopPublishing();
    return super.close();
  }
}
