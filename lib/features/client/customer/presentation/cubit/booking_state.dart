part of 'booking_cubit.dart';

sealed class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => <Object?>[];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingFailure extends BookingState {
  const BookingFailure(this.message);
  final String message;
  @override
  List<Object?> get props => <Object?>[message];
}

class BookingCreated extends BookingState {
  const BookingCreated(this.booking);
  final CreatedBookingEntity booking;
  @override
  List<Object?> get props => <Object?>[booking];
}

class BookingDetailSuccess extends BookingState {
  const BookingDetailSuccess(this.booking);
  final BookingEntity booking;
  @override
  List<Object?> get props => <Object?>[booking];
}

class BookingHistorySuccess extends BookingState {
  const BookingHistorySuccess(this.bookings);
  final List<BookingHistoryEntity> bookings;
  @override
  List<Object?> get props => <Object?>[bookings];
}

class BookingEtaSuccess extends BookingState {
  const BookingEtaSuccess(this.eta);
  final EtaEntity eta;
  @override
  List<Object?> get props => <Object?>[eta];
}

class BookingCommandSuccess extends BookingState {
  const BookingCommandSuccess();
}

class ReviewCreated extends BookingState {
  const ReviewCreated(this.id);
  final String id;
  @override
  List<Object?> get props => <Object?>[id];
}
