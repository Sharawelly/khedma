import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }) : super(const BookingInitial());

  final CreateBooking createBooking;
  final GetBooking getBooking;
  final GetBookingHistory getBookingHistory;
  final CancelBooking cancelBooking;
  final GetBookingEta getBookingEta;
  final CreateReview createReview;
  final UpdateReview updateReview;

  Future<void> execute(BookingCommand command) async {
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
          (booking) => emit(BookingDetailSuccess(booking)),
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
}
