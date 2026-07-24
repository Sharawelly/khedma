import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/presentation/cubit/booking_cubit.dart';
import '/injection_container.dart';
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
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    timer = Timer.periodic(const Duration(seconds: 10), (_) => _refresh());
  }

  void _refresh() {
    bookingCubit.execute(BookingCommand.detail(widget.bookingId));
    if (widget.mode == TrackingViewMode.live) {
      etaCubit.execute(BookingCommand.eta(widget.bookingId));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    bookingCubit.close();
    etaCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('customer_booking_tracking'.tr)),
      body: MultiBlocListener(
        listeners: <BlocListener<BookingCubit, BookingState>>[
          BlocListener<BookingCubit, BookingState>(
            bloc: bookingCubit,
            listener: (context, state) {
              if (state is! BookingDetailSuccess) {
                return;
              }
              if (widget.mode == TrackingViewMode.waiting &&
                  state.booking.providerId != null) {
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
          builder: (_, state) {
            if (state is BookingFailure) {
              return CustomerErrorView(state.message);
            }
            if (state is! BookingDetailSuccess) {
              return const CustomerLoadingView();
            }
            return _TrackingBody(
              booking: state.booking,
              mode: widget.mode,
              etaCubit: etaCubit,
              onRefresh: _refresh,
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
    required this.mode,
    required this.etaCubit,
    required this.onRefresh,
  });

  final BookingEntity booking;
  final TrackingViewMode mode;
  final BookingCubit etaCubit;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: EdgeInsetsDirectional.all(20.r),
        children: <Widget>[
          Container(
            height: 190.h,
            color: colors.onboardingSurfaceMuted,
            child: const Center(
              child: Icon(Icons.location_on_rounded, size: 64),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            booking.localizedStatus(isArabic),
            style: TextStyles.bold24(color: colors.errorColor),
          ),
          Text(
            booking.providerName ?? 'customer_waiting_for_provider'.tr,
            style: TextStyles.bold20(color: colors.onboardingHeadline),
          ),
          if (booking.providerRating != null)
            Text('${booking.providerRating!.toStringAsFixed(1)} ★'),
          if (mode == TrackingViewMode.live)
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
          if (mode == TrackingViewMode.found)
            FilledButton(
              onPressed: () =>
                  context.goNamed(Routes.trackLiveRoute, extra: booking.id),
              child: Text('home_provider_found_track_live'.tr),
            ),
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
