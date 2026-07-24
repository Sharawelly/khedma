import 'package:flutter/material.dart';

import '/features/client/customer/presentation/widgets/booking_tracking_view.dart';

class ProviderTrackingScreen extends StatelessWidget {
  const ProviderTrackingScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return BookingTrackingView(
      bookingId: bookingId,
      mode: TrackingViewMode.waiting,
    );
  }
}
