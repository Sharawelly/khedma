import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/error/failures.dart';
import '/core/realtime/realtime_events.dart';
import '/core/realtime/realtime_service.dart';
import '/features/auth/domain/entities/profile_entity.dart';
import '/features/auth/domain/usecases/get_profile_use_case.dart';
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
  setWorkingLocation,
  enRoute,
  arrived,
  inProgress,
  complete,
  loadRoute,
  clearSession,
}

class ProviderJobsCommand {
  const ProviderJobsCommand._(
    this.action, {
    this.bookingId,
    this.online,
    this.eta,
    this.latitude,
    this.longitude,
  });

  const ProviderJobsCommand.recover() : this._(ProviderJobsAction.recover);
  const ProviderJobsCommand.loadMoreHistory()
    : this._(ProviderJobsAction.loadMoreHistory);
  const ProviderJobsCommand.accept(String bookingId)
    : this._(ProviderJobsAction.accept, bookingId: bookingId);
  const ProviderJobsCommand.reject(String bookingId)
    : this._(ProviderJobsAction.reject, bookingId: bookingId);

  /// Coordinates are optional: pass them when the provider confirmed a point on
  /// the map, omit them to fall back to a raw device fix.
  const ProviderJobsCommand.availability(
    bool online, {
    double? latitude,
    double? longitude,
  }) : this._(
         ProviderJobsAction.availability,
         online: online,
         latitude: latitude,
         longitude: longitude,
       );

  /// Reassigns where the provider works, without changing whether they are
  /// online.
  const ProviderJobsCommand.setWorkingLocation({
    required double latitude,
    required double longitude,
  }) : this._(
         ProviderJobsAction.setWorkingLocation,
         latitude: latitude,
         longitude: longitude,
       );
  const ProviderJobsCommand.enRoute(String bookingId, {int? eta})
    : this._(ProviderJobsAction.enRoute, bookingId: bookingId, eta: eta);
  const ProviderJobsCommand.arrived(String bookingId)
    : this._(ProviderJobsAction.arrived, bookingId: bookingId);
  const ProviderJobsCommand.inProgress(String bookingId)
    : this._(ProviderJobsAction.inProgress, bookingId: bookingId);
  const ProviderJobsCommand.complete(String bookingId)
    : this._(ProviderJobsAction.complete, bookingId: bookingId);
  /// Fetches the drive to the job for the tracking map.
  const ProviderJobsCommand.loadRoute(String bookingId)
    : this._(ProviderJobsAction.loadRoute, bookingId: bookingId);
  const ProviderJobsCommand.clearSession()
    : this._(ProviderJobsAction.clearSession);

  final ProviderJobsAction action;
  final String? bookingId;
  final bool? online;
  final int? eta;
  final double? latitude;
  final double? longitude;
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
    required this.getRoute,
    required this.getProfile,
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
  final GetBookingRoute getRoute;
  final GetProfileUseCase getProfile;
  final RealtimeService realtimeService;

  /// Dispatch drops providers whose position has gone stale, and an idle Online
  /// provider never moves enough to trigger the position stream. This republishes
  /// on a cadence well inside the server's freshness window so simply waiting for
  /// work does not quietly remove them from matching.
  static const Duration _onlineHeartbeat = Duration(minutes: 5);

  Timer? _countdown;
  Timer? _jobStatusPoll;
  Timer? _locationHeartbeat;
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
        await _setAvailability(
          command.online!,
          latitude: command.latitude,
          longitude: command.longitude,
        );
        break;
      case ProviderJobsAction.setWorkingLocation:
        await _setWorkingLocation(command.latitude!, command.longitude!);
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
      case ProviderJobsAction.loadRoute:
        await _loadRoute(command.bookingId!);
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
    // The availability endpoint is write-only, so the assigned point is read
    // back off the profile. A failure here is swallowed on purpose: not knowing
    // the working location should not blank out the jobs screen.
    final profileResult = await getProfile();
    final profile = profileResult.fold<ProfileEntity?>(
      (_) => null,
      (value) => value,
    );
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
    // Built directly rather than with copyWith so a job that ended while the app
    // was closed actually clears: copyWith keeps the old value on null.
    final next = ProviderJobsSnapshot(
      pendingJobs: _mergeOffers(state.snapshot.pendingJobs, pending),
      history: history,
      historyHasNextPage: historyHasNextPage,
      availabilityStatus:
          _availabilityFrom(profile?.availabilityStatus) ??
          snapshot.availabilityStatus,
      currentJob: await _restoreCurrentJob(history),
      workingLatitude: profile?.workingLatitude ?? snapshot.workingLatitude,
      workingLongitude: profile?.workingLongitude ?? snapshot.workingLongitude,
    );
    if (failure != null) {
      emit(ProviderJobsFailure(next, _message(failure!)));
    } else {
      emit(ProviderJobsSuccess(next));
      _synchronizeDeadlines(next.pendingJobs);
      _startCountdown();
    }
    // Started only after the emit. The heartbeat reads the working point off
    // the current snapshot, so running it any earlier would publish the
    // pre-recovery state - which on a cold start has no working point at all.
    //
    // Availability itself is stored server-side, so a provider who was already
    // online comes back online without passing through _setAvailability, the
    // only other place the heartbeat starts. Without this their position is
    // never refreshed: it ages past the server's freshness window and dispatch
    // drops them while the app still says "Online".
    //
    // Ordered after the en-route stream below so the heartbeat's first tick
    // already sees it running and stands down.
    if (next.currentJob?.stage == ProviderJobStage.enRoute) {
      // The customer's live tracking map is fed by this stream, so a restart
      // mid-journey has to pick it back up rather than leaving them watching a
      // provider that never moves again.
      await _startPublishing();
    }
    if (next.isOnline) {
      _startLocationHeartbeat();
    } else {
      _stopLocationHeartbeat();
    }
  }

  /// The booking statuses the server counts as in-flight, mapped to the stage
  /// the job screen drives its actions from.
  static const Map<int, ProviderJobStage> _stageByStatus =
      <int, ProviderJobStage>{
        2: ProviderJobStage.accepted,
        3: ProviderJobStage.enRoute,
        4: ProviderJobStage.arrived,
        5: ProviderJobStage.inProgress,
      };

  /// Rebuilds the active job from the server.
  ///
  /// Without this a job is lost whenever the cubit is recreated - a restart, a
  /// re-login - and that is worse than a missing card: dispatch excludes any
  /// provider still holding an in-flight booking, so they quietly stop being
  /// offered work with no way to close the job and nothing in the UI to explain
  /// it. Recovering it is also what lets server-side changes (a customer
  /// cancelling while the app was closed) land.
  Future<AcceptedJobEntity?> _restoreCurrentJob(
    List<BookingHistoryEntity> history,
  ) async {
    String? activeId;
    for (final booking in history) {
      if (_stageByStatus.containsKey(booking.status)) {
        activeId = booking.id;
        break;
      }
    }
    if (activeId == null) {
      return null;
    }
    final result = await getBooking(activeId);
    return result.fold((_) => state.snapshot.currentJob, (booking) {
      final stage = _stageByStatus[booking.status];
      if (stage == null) {
        return null;
      }
      return AcceptedJobEntity(
        bookingId: booking.id,
        accepted: true,
        address: booking.address,
        latitude: booking.latitude,
        longitude: booking.longitude,
        customerName: booking.customerName,
        customerPhone: booking.customerPhone,
        // The detail endpoint carries one service name, so both locales get it.
        serviceNameEn: booking.serviceName,
        serviceNameAr: booking.serviceName,
        providerEarning: booking.providerEarning ?? 0,
        currency: booking.currency ?? '',
        notes: booking.notes,
        scheduledTime: booking.scheduledTime,
        acceptedAt: booking.acceptedAt ?? booking.createAt,
        stage: stage,
      );
    });
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

  Future<void> _setAvailability(
    bool online, {
    double? latitude,
    double? longitude,
  }) async {
    emit(ProviderJobsLoading(state.snapshot));
    final snapshot = state.snapshot;
    ProviderCoordinatesEntity? coordinates;
    if (online && latitude != null && longitude != null) {
      // Confirmed on the map - trust it over a fresh device fix, which could
      // differ from the point the provider just chose.
      coordinates = ProviderCoordinatesEntity(
        latitude: latitude,
        longitude: longitude,
      );
    } else if (online && snapshot.hasWorkingLocation) {
      // Already assigned a location: go online for that, rather than wherever
      // the phone happens to be right now. A provider who set their shop as
      // their working point should not be silently re-homed because they
      // toggled online from the bus.
      coordinates = ProviderCoordinatesEntity(
        latitude: snapshot.workingLatitude!,
        longitude: snapshot.workingLongitude!,
      );
    } else if (online) {
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
      (availability) {
        if (online) {
          _startLocationHeartbeat();
        } else {
          _stopLocationHeartbeat();
        }
        emit(
          ProviderJobsSuccess(
            state.snapshot.copyWith(
              availabilityStatus: availability.status,
              workingLatitude: availability.latitude,
              workingLongitude: availability.longitude,
            ),
            messageKey: online ? 'provider_now_online' : 'provider_now_offline',
          ),
        );
      },
    );
  }

  /// The profile reports availability as an enum name while the snapshot keeps
  /// the wire integer. Anything unrecognised returns null so [copyWith] leaves
  /// the existing value alone rather than guessing the provider is offline.
  int? _availabilityFrom(String? status) => switch (status?.toLowerCase()) {
    'online' => 0,
    'offline' => 1,
    _ => null,
  };

  /// Moves the working point while leaving availability untouched, so a
  /// provider can correct where they are without being forced offline first.
  Future<void> _setWorkingLocation(double latitude, double longitude) async {
    final snapshot = state.snapshot;
    emit(ProviderJobsLoading(snapshot));
    final result = await updateAvailability(
      ProviderAvailabilityParams(
        status: snapshot.availabilityStatus,
        latitude: latitude,
        longitude: longitude,
      ),
    );
    result.fold(
      (failure) => emit(ProviderJobsFailure(snapshot, _message(failure))),
      (availability) => emit(
        ProviderJobsSuccess(
          snapshot.copyWith(
            availabilityStatus: availability.status,
            workingLatitude: availability.latitude ?? latitude,
            workingLongitude: availability.longitude ?? longitude,
          ),
          messageKey: 'provider_working_location_updated',
        ),
      ),
    );
  }

  void _startLocationHeartbeat() {
    _stopLocationHeartbeat();
    // Fires once up front, not only after the first interval: on a restart the
    // stored position may already be older than the server's freshness window,
    // and waiting a full cycle leaves the provider unmatchable until then.
    unawaited(_republishLocation());
    _locationHeartbeat = Timer.periodic(
      _onlineHeartbeat,
      (_) => unawaited(_republishLocation()),
    );
  }

  void _stopLocationHeartbeat() {
    _locationHeartbeat?.cancel();
    _locationHeartbeat = null;
  }

  /// Best-effort refresh. Deliberately does not reuse [_publishCoordinates]:
  /// that surfaces a failure state and tears down the en-route stream, which is
  /// far too heavy for a background tick. A missed heartbeat just retries next
  /// cycle, and dispatch keeps the last position until the window lapses.
  Future<void> _republishLocation() async {
    // While en route the position stream is already publishing real fixes, and
    // it is keeping the timestamp fresh on its own. A heartbeat on top would
    // shove the working point back over the live track.
    if (_positionSubscription != null) {
      return;
    }
    // Republishes the assigned working point and nothing else. There is
    // deliberately no GPS fallback: this exists to refresh the *timestamp* on a
    // point the provider already chose, and establishing a point is
    // [_setAvailability]'s job. Falling back to a device fix would silently
    // re-home a provider who set their shop as their working location to
    // wherever their phone happens to be - every five minutes, invisibly.
    final snapshot = state.snapshot;
    final latitude = snapshot.workingLatitude;
    final longitude = snapshot.workingLongitude;
    if (latitude == null || longitude == null) {
      return;
    }
    await publishLocation(
      ProviderLocationParams(latitude: latitude, longitude: longitude),
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
    // Kept in state as well as sent: the tracking map draws the provider's
    // marker from here, so it moves off this one stream rather than opening a
    // second GPS subscription of its own.
    emit(
      ProviderJobsSuccess(state.snapshot.copyWith(livePosition: coordinates)),
    );
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

  /// Fetches the drive for the tracking map.
  ///
  /// Failure is swallowed into a null route rather than an error state: the map
  /// still has both endpoints and falls back to a straight line, which is more
  /// use to a provider mid-journey than an error screen.
  Future<void> _loadRoute(String bookingId) async {
    final result = await getRoute(bookingId);
    result.fold((_) {}, (route) {
      if (!isClosed) {
        emit(ProviderJobsSuccess(state.snapshot.copyWith(route: route)));
      }
    });
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
    _stopLocationHeartbeat();
    for (final subscription in _realtimeSubscriptions) {
      await subscription.cancel();
    }
    await _stopPublishing();
    return super.close();
  }
}
