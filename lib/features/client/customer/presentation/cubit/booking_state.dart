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
    this.booking, {
    this.realtime = const BookingRealtimeSnapshot(),
    this.reviewId,
    this.review,
  });
  final BookingEntity booking;
  @override
  final BookingRealtimeSnapshot realtime;
  final String? reviewId;
  final ReviewParams? review;

  String? get providerId =>
      realtime.providerAssigned?.providerId ?? booking.providerId;

  @override
  List<Object?> get props => <Object?>[booking, realtime, reviewId, review];
}

class BookingHistorySuccess extends BookingState {
  const BookingHistorySuccess(this.bookings, this.hasNextPage);
  final List<BookingHistoryEntity> bookings;
  final bool hasNextPage;
  @override
  List<Object?> get props => <Object?>[bookings, hasNextPage];
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
