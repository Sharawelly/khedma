import 'package:flutter/material.dart';

import '/features/client/customer/presentation/widgets/booking_tracking_view.dart';

class ProviderFoundScreen extends StatelessWidget {
  const ProviderFoundScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return BookingTrackingView(
      bookingId: bookingId,
      mode: TrackingViewMode.found,
    );
  }
}
