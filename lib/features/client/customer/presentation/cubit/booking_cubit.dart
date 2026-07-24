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
  moreHistory,
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
  const BookingCommand.moreHistory() : this._(BookingAction.moreHistory);
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
  BookingEntity? _activeBooking;
  String? _activeReviewId;
  ReviewParams? _activeReview;
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
        result.fold((failure) => emit(BookingFailure(failure.message ?? '')), (
          booking,
        ) {
          _activeBooking = booking;
          emit(
            BookingDetailSuccess(
              booking,
              realtime: _realtimeSnapshot,
              reviewId: _activeReviewId,
              review: _activeReview,
            ),
          );
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
          (id) => _showSavedReview(id, command.review!),
        );
        break;
      case BookingAction.updateReview:
        final result = await updateReview(command.reviewId!, command.review!);
        result.fold(
          (failure) => emit(BookingFailure(failure.message ?? '')),
          (id) => _showSavedReview(id, command.review!),
        );
        break;
    }
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
    _activeBooking = null;
    _activeReviewId = null;
    _activeReview = null;
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
      emit(
        BookingDetailSuccess(
          current.booking,
          realtime: realtimeSnapshot,
          reviewId: current.reviewId,
          review: current.review,
        ),
      );
    }
  }

  void _showSavedReview(String reviewId, ReviewParams review) {
    _activeReviewId = reviewId;
    _activeReview = review;
    final booking = _activeBooking;
    if (booking != null) {
      emit(
        BookingDetailSuccess(
          booking,
          realtime: _realtimeSnapshot,
          reviewId: reviewId,
          review: review,
        ),
      );
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
        _activeBooking = booking;
        emit(
          BookingDetailSuccess(
            booking,
            realtime: _realtimeSnapshot,
            reviewId: _activeReviewId,
            review: _activeReview,
          ),
        );
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
