import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/realtime/realtime_events.dart';
import '/core/realtime/realtime_service.dart';
import '../../domain/entities/customer_entities.dart';
import '../../domain/usecases/customer_use_cases.dart';
import '../../domain/usecases/params/customer_params.dart';

part 'booking_state.dart';

enum BookingAction {
  create,
  detail,
  history,
  cancel,
  eta,
  review,
  updateReview,
}

class BookingCommand {
  const BookingCommand._(
    this.action, {
    this.id,
    this.draft,
    this.historyQuery,
    this.reason,
    this.review,
    this.reviewId,
  });

  const BookingCommand.create(BookingDraft draft)
    : this._(BookingAction.create, draft: draft);
  const BookingCommand.detail(String id) : this._(BookingAction.detail, id: id);
  const BookingCommand.history([BookingHistoryQuery? query])
    : this._(BookingAction.history, historyQuery: query);
  const BookingCommand.cancel(String id, String reason)
    : this._(BookingAction.cancel, id: id, reason: reason);
  const BookingCommand.eta(String id) : this._(BookingAction.eta, id: id);
  const BookingCommand.review(ReviewParams review)
    : this._(BookingAction.review, review: review);
  const BookingCommand.updateReview(String reviewId, ReviewParams review)
    : this._(BookingAction.updateReview, reviewId: reviewId, review: review);

  final BookingAction action;
  final String? id;
  final BookingDraft? draft;
  final BookingHistoryQuery? historyQuery;
  final String? reason;
  final ReviewParams? review;
  final String? reviewId;
}

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required this.createBooking,
    required this.getBooking,
    required this.getBookingHistory,
    required this.cancelBooking,
    required this.getBookingEta,
    required this.createReview,
    required this.updateReview,
    required this.realtimeService,
  }) : super(const BookingInitial());

  final CreateBooking createBooking;
  final GetBooking getBooking;
  final GetBookingHistory getBookingHistory;
  final CancelBooking cancelBooking;
  final GetBookingEta getBookingEta;
  final CreateReview createReview;
  final UpdateReview updateReview;
  final RealtimeService realtimeService;
  final List<StreamSubscription<Object?>> _subscriptions =
      <StreamSubscription<Object?>>[];
  String? _activeBookingId;
  BookingRealtimeSnapshot _realtimeSnapshot = const BookingRealtimeSnapshot();

  Future<void> execute(BookingCommand command) async {
    if (_subscriptions.isEmpty) {
      _subscribeToRealtime();
    }
    if (command.action == BookingAction.detail) {
      await _openBooking(command.id!);
    }
    emit(const BookingLoading());
    switch (command.action) {
      case BookingAction.create:
        final result = await createBooking(command.draft!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (booking) => emit(BookingCreated(booking)),
        );
        break;
      case BookingAction.detail:
        final result = await getBooking(command.id!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (booking) => emit(BookingDetailSuccess(booking, _realtimeSnapshot)),
        );
        break;
      case BookingAction.history:
        final result = await getBookingHistory(
          command.historyQuery ?? const BookingHistoryQuery(),
        );
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (page) => emit(BookingHistorySuccess(page.items)),
        );
        break;
      case BookingAction.cancel:
        final result = await cancelBooking(command.id!, command.reason!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (_) => emit(const BookingCommandSuccess()),
        );
        break;
      case BookingAction.eta:
        final result = await getBookingEta(command.id!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (eta) => emit(BookingEtaSuccess(eta)),
        );
        break;
      case BookingAction.review:
        final result = await createReview(command.review!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (id) => emit(ReviewCreated(id)),
        );
        break;
      case BookingAction.updateReview:
        final result = await updateReview(command.reviewId!, command.review!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (id) => emit(ReviewCreated(id)),
        );
        break;
    }
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
      emit(BookingDetailSuccess(current.booking, realtimeSnapshot));
    }
  }

  Future<void> _refreshDetailSilently() async {
    final bookingId = _activeBookingId;
    if (bookingId == null) {
      return;
    }
    final response = await getBooking(bookingId);
    response.fold((_) {}, (booking) {
      if (!isClosed && _activeBookingId == bookingId) {
        emit(BookingDetailSuccess(booking, _realtimeSnapshot));
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
