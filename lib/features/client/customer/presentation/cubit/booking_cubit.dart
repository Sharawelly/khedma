import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/error/failures.dart';
import '/core/realtime/realtime_events.dart';
import '/core/realtime/realtime_service.dart';
import '../../domain/entities/customer_entities.dart';
import '../../domain/usecases/customer_use_cases.dart';
import '../../domain/usecases/params/customer_params.dart';

part 'booking_state.dart';

enum BookingAction {
  quote,
  create,
  detail,
  history,
  moreHistory,
  cancel,
  eta,
  route,
  review,
  updateReview,
}

class BookingCommand {
  const BookingCommand._(
    this.action, {
    this.id,
    this.serviceId,
    this.draft,
    this.historyQuery,
    this.reason,
    this.review,
    this.reviewId,
  });

  /// What the service costs, without creating anything.
  const BookingCommand.quote(String serviceId)
    : this._(BookingAction.quote, serviceId: serviceId);

  const BookingCommand.create(BookingDraft draft)
    : this._(BookingAction.create, draft: draft);
  const BookingCommand.detail(String id) : this._(BookingAction.detail, id: id);
  const BookingCommand.history([BookingHistoryQuery? query])
    : this._(BookingAction.history, historyQuery: query);
  const BookingCommand.moreHistory() : this._(BookingAction.moreHistory);
  const BookingCommand.cancel(String id, String reason)
    : this._(BookingAction.cancel, id: id, reason: reason);
  const BookingCommand.eta(String id) : this._(BookingAction.eta, id: id);

  /// The drive from the provider to the address, for the tracking map.
  const BookingCommand.route(String id) : this._(BookingAction.route, id: id);
  const BookingCommand.review(ReviewParams review)
    : this._(BookingAction.review, review: review);
  const BookingCommand.updateReview(String reviewId, ReviewParams review)
    : this._(BookingAction.updateReview, reviewId: reviewId, review: review);

  final BookingAction action;
  final String? id;
  final String? serviceId;
  final BookingDraft? draft;
  final BookingHistoryQuery? historyQuery;
  final String? reason;
  final ReviewParams? review;
  final String? reviewId;
}

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required this.getBookingQuote,
    required this.createBooking,
    required this.getBooking,
    required this.getBookingHistory,
    required this.cancelBooking,
    required this.getBookingEta,
    required this.getBookingRoute,
    required this.createReview,
    required this.updateReview,
    required this.realtimeService,
  }) : super(const BookingInitial());

  final GetBookingQuote getBookingQuote;
  final CreateBooking createBooking;
  final GetBooking getBooking;
  final GetBookingHistory getBookingHistory;
  final CancelBooking cancelBooking;
  final GetBookingEta getBookingEta;
  final GetBookingRoute getBookingRoute;
  final CreateReview createReview;
  final UpdateReview updateReview;
  final RealtimeService realtimeService;
  final List<StreamSubscription<Object?>> _subscriptions =
      <StreamSubscription<Object?>>[];
  String? _activeBookingId;
  BookingRealtimeSnapshot _realtimeSnapshot = const BookingRealtimeSnapshot();
  final List<BookingHistoryEntity> _history = <BookingHistoryEntity>[];
  BookingHistoryQuery _historyQuery = const BookingHistoryQuery();
  int _historyPage = 1;
  bool _historyHasNextPage = false;
  bool _isLoadingMoreHistory = false;

  Future<void> execute(BookingCommand command) async {
    if (_subscriptions.isEmpty) {
      _subscribeToRealtime();
    }
    if (command.action == BookingAction.detail) {
      await _openBooking(command.id!);
    }
    if (command.action == BookingAction.moreHistory) {
      await _loadMoreHistory();
      return;
    }
    final silent = _isRepeatRead(command);
    if (!silent) {
      emit(const BookingLoading());
    }
    switch (command.action) {
      case BookingAction.quote:
        final result = await getBookingQuote(command.serviceId!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (price) => emit(BookingQuoteSuccess(price)),
        );
        break;
      case BookingAction.create:
        final result = await createBooking(command.draft!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (booking) => emit(BookingCreated(booking)),
        );
        break;
      case BookingAction.detail:
        final result = await getBooking(command.id!);
        result.fold((failure) {
          // A background poll that fails keeps the last good booking on screen.
          // Replacing a live tracking view with an error because one tick lost
          // the network is worse than showing data a few seconds stale.
          if (!silent) {
            emit(BookingFailure(failure.message ?? ''));
          }
        }, (booking) {
          emit(BookingDetailSuccess(booking, realtime: _realtimeSnapshot));
        });
        break;
      case BookingAction.history:
        _historyQuery = command.historyQuery ?? const BookingHistoryQuery();
        final result = await getBookingHistory(_historyQuery);
        result.fold((failure) => emit(BookingFailure(failure.message ?? '')), (
          page,
        ) {
          _history
            ..clear()
            ..addAll(page.items);
          _historyPage = page.pagination.page ?? 1;
          _historyHasNextPage = page.pagination.hasNextPage ?? false;
          emit(
            BookingHistorySuccess(
              List<BookingHistoryEntity>.unmodifiable(_history),
              _historyHasNextPage,
            ),
          );
        });
        break;
      case BookingAction.moreHistory:
        break;
      case BookingAction.cancel:
        final result = await cancelBooking(command.id!, command.reason!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (_) => emit(const BookingCommandSuccess()),
        );
        break;
      case BookingAction.route:
        final result = await getBookingRoute(command.id!);
        // A missing route leaves the last one on screen rather than replacing
        // the map with an error: the customer still has both pins and a usable
        // straight-line fallback.
        result.fold((_) {}, (route) => emit(BookingRouteSuccess(route)));
        break;
      case BookingAction.eta:
        final result = await getBookingEta(command.id!);
        result.fold((failure) {
          if (!silent) {
            emit(BookingFailure(failure.message ?? ''));
          }
        }, (eta) => emit(BookingEtaSuccess(eta)));
        break;
      case BookingAction.review:
        await _saveReview(createReview(command.review!));
        break;
      case BookingAction.updateReview:
        await _saveReview(updateReview(command.reviewId!, command.review!));
        break;
    }
  }

  /// True when this read is refreshing something already on screen.
  ///
  /// The tracking view re-reads the booking every ten seconds and the ETA
  /// alongside it. Emitting [BookingLoading] on each tick dropped the whole
  /// screen back to a shimmer a second after it had rendered, so a poll now
  /// leaves the current state alone and only replaces it once new data arrives.
  /// The first load of a booking, and any switch to a different booking, still
  /// shows the loading state.
  bool _isRepeatRead(BookingCommand command) {
    final current = state;
    return switch (command.action) {
      BookingAction.detail =>
        current is BookingDetailSuccess && current.booking.id == command.id,
      BookingAction.eta => current is BookingEtaSuccess,
      BookingAction.route => current is BookingRouteSuccess,
      _ => false,
    };
  }

  Future<void> _loadMoreHistory() async {
    if (_isLoadingMoreHistory || !_historyHasNextPage) {
      return;
    }
    _isLoadingMoreHistory = true;
    final query = BookingHistoryQuery(
      status: _historyQuery.status,
      from: _historyQuery.from,
      to: _historyQuery.to,
      page: _historyPage + 1,
    );
    final response = await getBookingHistory(query);
    response.fold((failure) => emit(BookingFailure(failure.message ?? '')), (
      page,
    ) {
      _historyQuery = query;
      _history.addAll(page.items);
      _historyPage = page.pagination.page ?? query.page;
      _historyHasNextPage = page.pagination.hasNextPage ?? false;
      emit(
        BookingHistorySuccess(
          List<BookingHistoryEntity>.unmodifiable(_history),
          _historyHasNextPage,
        ),
      );
    });
    _isLoadingMoreHistory = false;
  }

  void _subscribeToRealtime() {
    _subscriptions
      ..add(realtimeService.bookingStatusChanged.listen(_statusChanged))
      ..add(realtimeService.providerAssigned.listen(_providerAssigned))
      ..add(realtimeService.providerLocation.listen(_providerLocation))
      ..add(realtimeService.noProviderFound.listen(_noProviderFound))
      ..add(realtimeService.paymentStatusChanged.listen(_paymentStatusChanged))
      ..add(
        realtimeService.connected
            .where((event) => event.hub == RealtimeHub.booking)
            .listen((_) => unawaited(_refreshDetailSilently())),
      );
  }

  Future<void> _openBooking(String bookingId) async {
    final previous = _activeBookingId;
    if (previous == bookingId) {
      return;
    }
    if (previous != null) {
      await realtimeService.leaveBookingGroup(previous);
    }
    _activeBookingId = bookingId;
    _realtimeSnapshot = const BookingRealtimeSnapshot();
    await realtimeService.joinBookingGroup(bookingId);
  }

  void _statusChanged(BookingStatusChangedEvent event) {
    if (!_isActive(event.bookingId)) {
      return;
    }
    _emitRealtime(
      _realtimeSnapshot.copyWith(
        statusChanged: event,
        etaMinutes: event.etaMinutes,
      ),
    );
    unawaited(_refreshDetailSilently());
  }

  void _providerAssigned(ProviderAssignedEvent event) {
    if (_activeBookingId == null) {
      return;
    }
    _emitRealtime(
      _realtimeSnapshot.copyWith(
        providerAssigned: event,
        etaMinutes: event.etaMinutes,
      ),
    );
    unawaited(_refreshDetailSilently());
  }

  void _providerLocation(ProviderLocationEvent event) {
    if (!_isActive(event.bookingId)) {
      return;
    }
    _emitRealtime(
      _realtimeSnapshot.copyWith(
        providerLocation: event,
        etaMinutes: event.etaMinutes,
      ),
    );
  }

  void _noProviderFound(NoProviderFoundEvent event) {
    if (_isActive(event.bookingId)) {
      _emitRealtime(_realtimeSnapshot.copyWith(noProviderFound: event));
    }
  }

  void _paymentStatusChanged(PaymentStatusChangedEvent event) {
    if (_activeBookingId != null) {
      _emitRealtime(_realtimeSnapshot.copyWith(paymentStatus: event));
    }
  }

  bool _isActive(String bookingId) => _activeBookingId == bookingId;

  void _emitRealtime(BookingRealtimeSnapshot realtimeSnapshot) {
    _realtimeSnapshot = realtimeSnapshot;
    final current = state;
    if (current is BookingDetailSuccess) {
      emit(BookingDetailSuccess(current.booking, realtime: realtimeSnapshot));
    }
  }

  /// Re-reads the booking after a write so the rendered review comes back from
  /// the server rather than being mirrored locally.
  Future<void> _saveReview<T>(Future<Either<Failure, T>> request) async {
    final result = await request;
    final failure = result.fold<Failure?>((failure) => failure, (_) => null);
    if (failure != null) {
      emit(BookingFailure(failure.message ?? ''));
      return;
    }
    await _refreshDetailSilently();
  }

  Future<void> _refreshDetailSilently() async {
    final bookingId = _activeBookingId;
    if (bookingId == null) {
      return;
    }
    final response = await getBooking(bookingId);
    response.fold((_) {}, (booking) {
      if (!isClosed && _activeBookingId == bookingId) {
        emit(BookingDetailSuccess(booking, realtime: _realtimeSnapshot));
      }
    });
  }

  @override
  Future<void> close() async {
    final bookingId = _activeBookingId;
    if (bookingId != null) {
      await realtimeService.leaveBookingGroup(bookingId);
    }
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
