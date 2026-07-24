part of 'booking_cubit.dart';

sealed class BookingState extends Equatable {
  const BookingState();
  BookingRealtimeSnapshot get realtime => const BookingRealtimeSnapshot();

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
  const BookingDetailSuccess(
    this.booking, [
    this.realtime = const BookingRealtimeSnapshot(),
  ]);
  final BookingEntity booking;
  @override
  final BookingRealtimeSnapshot realtime;

  String? get providerId =>
      realtime.providerAssigned?.providerId ?? booking.providerId;

  @override
  List<Object?> get props => <Object?>[booking, realtime];
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

class BookingRealtimeSnapshot {
  const BookingRealtimeSnapshot({
    this.statusChanged,
    this.providerAssigned,
    this.providerLocation,
    this.noProviderFound,
    this.paymentStatus,
    this.etaMinutes,
  });

  final BookingStatusChangedEvent? statusChanged;
  final ProviderAssignedEvent? providerAssigned;
  final ProviderLocationEvent? providerLocation;
  final NoProviderFoundEvent? noProviderFound;
  final PaymentStatusChangedEvent? paymentStatus;
  final int? etaMinutes;

  BookingRealtimeSnapshot copyWith({
    BookingStatusChangedEvent? statusChanged,
    ProviderAssignedEvent? providerAssigned,
    ProviderLocationEvent? providerLocation,
    NoProviderFoundEvent? noProviderFound,
    PaymentStatusChangedEvent? paymentStatus,
    int? etaMinutes,
  }) => BookingRealtimeSnapshot(
    statusChanged: statusChanged ?? this.statusChanged,
    providerAssigned: providerAssigned ?? this.providerAssigned,
    providerLocation: providerLocation ?? this.providerLocation,
    noProviderFound: noProviderFound ?? this.noProviderFound,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    etaMinutes: etaMinutes ?? this.etaMinutes,
  );
}
