import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/presentation/cubit/booking_cubit.dart';
import '/features/shared/location/presentation/widgets/route_map.dart';
import '/injection_container.dart';
import 'cancel_booking_dialog.dart';
import 'customer_state_widgets.dart';

enum TrackingViewMode { waiting, found, live }

class BookingTrackingView extends StatefulWidget {
  const BookingTrackingView({
    super.key,
    required this.bookingId,
    required this.mode,
  });

  final String bookingId;
  final TrackingViewMode mode;

  @override
  State<BookingTrackingView> createState() => _BookingTrackingViewState();
}

class _BookingTrackingViewState extends State<BookingTrackingView> {
  late final BookingCubit bookingCubit = ServiceLocator.instance();
  late final BookingCubit etaCubit = ServiceLocator.instance();
  late final BookingCubit routeCubit = ServiceLocator.instance();
  Timer? timer;
  Timer? routeTimer;

  /// Slower than the detail poll on purpose: every tick is a billable Routes
  /// call, and a road route does not change meaningfully in ten seconds.
  static const Duration _routeRefresh = Duration(seconds: 60);

  /// Backend BookingStatus: Completed=6, Cancelled=7, NoProviderFound=8,
  /// Failed=9. Nothing further can arrive for any of them.
  static bool isFinished(int status) => status >= 6;

  @override
  void initState() {
    super.initState();
    _refresh();
    timer = Timer.periodic(const Duration(seconds: 10), (_) => _refresh());
    if (widget.mode == TrackingViewMode.live) {
      _refreshRoute();
      routeTimer = Timer.periodic(_routeRefresh, (_) => _refreshRoute());
    }
  }

  void _refresh() {
    bookingCubit.execute(BookingCommand.detail(widget.bookingId));
    if (widget.mode == TrackingViewMode.live) {
      etaCubit.execute(BookingCommand.eta(widget.bookingId));
    }
  }

  void _refreshRoute() =>
      routeCubit.execute(BookingCommand.route(widget.bookingId));

  /// A finished booking never changes again, so the pollers are shut down rather
  /// than re-reading the detail every ten seconds and billing a Routes call
  /// every minute for a job that is already over.
  void _stopPolling() {
    timer?.cancel();
    timer = null;
    routeTimer?.cancel();
    routeTimer = null;
  }

  /// The reason is required by the API, so an empty one is treated as backing
  /// out. A failed cancel is left on screen rather than refreshed away - the
  /// message is the only thing telling the customer why it was refused.
  Future<void> _cancel() async {
    final reason = await showCancelBookingDialog(context);
    if (reason == null || reason.isEmpty || !mounted) {
      return;
    }
    await bookingCubit.execute(
      BookingCommand.cancel(widget.bookingId, reason),
    );
    if (mounted && bookingCubit.state is BookingCommandSuccess) {
      _refresh();
    }
  }

  /// The booking flow arrives here through `go`, which leaves nothing on the
  /// navigator to pop - so falling back to the shell is the only way off this
  /// screen. Reached from booking details through `push` instead, the pop keeps
  /// the customer where they came from.
  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.appShellRoute);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    routeTimer?.cancel();
    bookingCubit.close();
    etaCubit.close();
    routeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('customer_booking_tracking'.tr),
        leading: BackButton(onPressed: _leave),
      ),
      body: MultiBlocListener(
        listeners: <BlocListener<BookingCubit, BookingState>>[
          BlocListener<BookingCubit, BookingState>(
            bloc: bookingCubit,
            listener: (context, state) {
              if (state is! BookingDetailSuccess) {
                return;
              }
              // Checked before the hand-off below: a booking that completed
              // while this screen was open must not be forwarded to the
              // provider-found step.
              if (isFinished(state.booking.status)) {
                _stopPolling();
                return;
              }
              if (widget.mode == TrackingViewMode.waiting &&
                  state.providerId != null) {
                context.goNamed(
                  Routes.providerFoundRoute,
                  extra: widget.bookingId,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<BookingCubit, BookingState>(
          bloc: bookingCubit,
          builder: (context, state) {
            if (state is BookingFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomerErrorView(state.message),
                  TextButton(onPressed: _refresh, child: Text('retry'.tr)),
                ],
              );
            }
            if (state is! BookingDetailSuccess) {
              return const CustomerLoadingView();
            }
            return _TrackingBody(
              booking: state.booking,
              realtimeSnapshot: state.realtime,
              mode: widget.mode,
              etaCubit: etaCubit,
              routeCubit: routeCubit,
              onRefresh: _refresh,
              onLeave: _leave,
              onCancel: _cancel,
            );
          },
        ),
      ),
    );
  }
}

class _TrackingBody extends StatelessWidget {
  const _TrackingBody({
    required this.booking,
    required this.realtimeSnapshot,
    required this.mode,
    required this.etaCubit,
    required this.routeCubit,
    required this.onRefresh,
    required this.onLeave,
    required this.onCancel,
  });

  final BookingEntity booking;
  final BookingRealtimeSnapshot realtimeSnapshot;
  final TrackingViewMode mode;
  final BookingCubit etaCubit;
  final BookingCubit routeCubit;
  final VoidCallback onRefresh;
  final VoidCallback onLeave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: EdgeInsetsDirectional.all(20.r),
        children: <Widget>[
          SizedBox(
            height: 240.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: _TrackingMap(
                booking: booking,
                realtimeSnapshot: realtimeSnapshot,
                routeCubit: routeCubit,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            realtimeSnapshot.statusChanged?.localizedLabel(isArabic) ??
                booking.localizedStatus(isArabic),
            style: TextStyles.bold24(color: colors.errorColor),
          ),
          Text(
            realtimeSnapshot.providerAssigned?.fullName ??
                booking.providerName ??
                'customer_waiting_for_provider'.tr,
            style: TextStyles.bold20(color: colors.onboardingHeadline),
          ),
          if ((realtimeSnapshot.providerAssigned?.rating ??
                  booking.providerRating) !=
              null)
            Text(
              '${(realtimeSnapshot.providerAssigned?.rating ?? booking.providerRating)!.toStringAsFixed(1)} ★',
            ),
          if (realtimeSnapshot.noProviderFound != null)
            Text(
              'customer_no_provider_found'.tr,
              style: TextStyles.medium16(color: colors.errorColor),
            ),
          if (mode == TrackingViewMode.live &&
              realtimeSnapshot.etaMinutes != null)
            ListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              leading: const Icon(Icons.schedule_rounded),
              title: Text(
                '${realtimeSnapshot.etaMinutes} ${'customer_minutes'.tr}',
              ),
            )
          else if (mode == TrackingViewMode.live)
            BlocBuilder<BookingCubit, BookingState>(
              bloc: etaCubit,
              builder: (_, state) {
                if (state is! BookingEtaSuccess) {
                  return const SizedBox.shrink();
                }
                final eta = state.eta;
                return ListTile(
                  contentPadding: EdgeInsetsDirectional.zero,
                  leading: const Icon(Icons.schedule_rounded),
                  title: Text(
                    '${eta.isApproximate ? '${'customer_approximately'.tr} ' : ''}${eta.etaMinutes} ${'customer_minutes'.tr}',
                  ),
                  subtitle: Text(
                    '${eta.distanceKm.toStringAsFixed(1)} ${'customer_km'.tr}',
                  ),
                );
              },
            ),
          SizedBox(height: 12.h),
          _step('customer_created'.tr, booking.createAt),
          _step('customer_accepted'.tr, booking.acceptedAt),
          _step('customer_en_route'.tr, booking.enRouteAt),
          _step('customer_arrived'.tr, booking.arrivedAt),
          _step('customer_started'.tr, booking.startedAt),
          _step('customer_completed'.tr, booking.completedAt),
          if (_BookingTrackingViewState.isFinished(booking.status))
            FilledButton(
              onPressed: onLeave,
              child: Text('customer_back_to_home'.tr),
            )
          else ...<Widget>[
            if (mode == TrackingViewMode.found)
              FilledButton(
                onPressed: () =>
                    context.goNamed(Routes.trackLiveRoute, extra: booking.id),
                child: Text('home_provider_found_track_live'.tr),
              ),
            // Whether the cancellation policy actually allows it is the server's
            // call; the button stays offered until the booking is over so the
            // customer is told why rather than left without the option.
            TextButton(
              onPressed: onCancel,
              child: Text('customer_cancel_booking'.tr),
            ),
          ],
        ],
      ),
    );
  }

  Widget _step(String label, DateTime? time) {
    return ListTile(
      contentPadding: EdgeInsetsDirectional.zero,
      leading: Icon(
        time == null
            ? Icons.radio_button_unchecked
            : Icons.check_circle_rounded,
        color: time == null ? colors.lightTextColor : colors.main,
      ),
      title: Text(label),
      subtitle: time == null ? null : Text(time.toLocal().toString()),
    );
  }
}

/// The provider's approach, drawn on the same shared map the provider sees.
class _TrackingMap extends StatelessWidget {
  const _TrackingMap({
    required this.booking,
    required this.realtimeSnapshot,
    required this.routeCubit,
  });

  final BookingEntity booking;
  final BookingRealtimeSnapshot realtimeSnapshot;
  final BookingCubit routeCubit;

  @override
  Widget build(BuildContext context) {
    final destinationLat = booking.latitude;
    final destinationLng = booking.longitude;
    if (destinationLat == null || destinationLng == null) {
      return Container(
        color: colors.onboardingSurfaceMuted,
        alignment: Alignment.center,
        child: Text('customer_no_map_location'.tr),
      );
    }

    return BlocBuilder<BookingCubit, BookingState>(
      bloc: routeCubit,
      buildWhen: (_, state) => state is BookingRouteSuccess,
      builder: (_, state) {
        final route = state is BookingRouteSuccess ? state.route : null;
        // The pushed position is fresher than anything the route carries, so it
        // wins: the marker keeps moving between route refreshes.
        final live = realtimeSnapshot.providerLocation;
        final origin = live != null
            ? LatLng(live.latitude, live.longitude)
            : route != null
            ? LatLng(route.originLatitude, route.originLongitude)
            : null;

        return RouteMap(
          origin: origin,
          destination: LatLng(destinationLat, destinationLng),
          route: route,
          originLabel: 'customer_provider'.tr,
          destinationLabel: 'customer_address'.tr,
        );
      },
    );
  }
}
