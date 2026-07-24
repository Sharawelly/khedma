import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/shared/location/presentation/widgets/route_map.dart';
import '/injection_container.dart';
import '../../../domain/entities/provider_entities.dart';
import '../../../presentation/cubit/provider_jobs_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';

/// The drive to the customer: both pins, the road route between them, and the
/// distance/ETA.
///
/// The provider's marker is driven by the same position stream that publishes to
/// the customer, so what the provider sees here is what the customer's map is
/// being fed.
class ProviderTrackLiveScreen extends StatefulWidget {
  const ProviderTrackLiveScreen({super.key});

  @override
  State<ProviderTrackLiveScreen> createState() =>
      _ProviderTrackLiveScreenState();
}

class _ProviderTrackLiveScreenState extends State<ProviderTrackLiveScreen> {
  /// Refetched as the provider drives so the line follows the road ahead rather
  /// than trailing behind them. Long enough not to burn Directions quota.
  static const Duration _routeRefresh = Duration(minutes: 2);
  Timer? _refresh;
  String? _routeBookingId;

  @override
  void dispose() {
    _refresh?.cancel();
    super.dispose();
  }

  void _watchRoute(String bookingId) {
    if (_routeBookingId == bookingId) {
      return;
    }
    _routeBookingId = bookingId;
    _refresh?.cancel();
    final cubit = context.read<ProviderJobsCubit>();
    void load() =>
        unawaited(cubit.execute(ProviderJobsCommand.loadRoute(bookingId)));
    load();
    _refresh = Timer.periodic(_routeRefresh, (_) => load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('provider_live_location_title'.tr),
        leading: BackButton(onPressed: context.pop),
      ),
      body: BlocConsumer<ProviderJobsCubit, ProviderJobsState>(
        listener: (context, state) {
          if (state case ProviderJobsFailure(:final messageKey)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(providerMessage(messageKey))),
            );
          }
          final job = state.snapshot.currentJob;
          if (job != null && job.latitude != null && job.longitude != null) {
            _watchRoute(job.bookingId);
          }
        },
        builder: (context, state) {
          final job = state.snapshot.currentJob;
          if (job == null) {
            return ProviderErrorView('provider_no_active_job'.tr);
          }
          if (job.latitude == null || job.longitude == null) {
            return ProviderErrorView('provider_job_no_coordinates'.tr);
          }

          final route = state.snapshot.route;
          final live = state.snapshot.livePosition;
          // Prefer the live fix; before the first one arrives the server's idea
          // of where the provider is still gives the map something to draw.
          final origin = live != null
              ? LatLng(live.latitude, live.longitude)
              : route != null
              ? LatLng(route.originLatitude, route.originLongitude)
              : null;

          return Column(
            children: <Widget>[
              Expanded(
                child: RouteMap(
                  origin: origin,
                  destination: LatLng(job.latitude!, job.longitude!),
                  route: route,
                  originLabel: 'provider_your_position'.tr,
                  destinationLabel: 'provider_customer_location'.tr,
                ),
              ),
              _Panel(job: job, route: route, state: state),
            ],
          );
        },
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.job, required this.route, required this.state});

  final AcceptedJobEntity job;
  final BookingRouteEntity? route;
  final ProviderJobsState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(20.r),
          topEnd: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              job.address ?? 'provider_address_unavailable'.tr,
              style: TextStyles.bold18(color: colors.onboardingTextStrong),
            ),
            Gaps.vGap8,
            if (route != null)
              Text(
                route!.isApproximate
                    ? 'provider_route_approximate'.tr
                    : '${route!.distanceKm.toStringAsFixed(1)} ${'provider_km_away'.tr} • ${route!.etaMinutes} ${'provider_minutes'.tr}',
                style: TextStyles.medium16(color: colors.homeCaption),
              ),
            Text(
              _trackingStatus(job.stage).tr,
              style: TextStyles.medium16(color: colors.homeCaption),
            ),
            Gaps.vGap16,
            if (job.stage == ProviderJobStage.enRoute)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state is ProviderJobsLoading
                      ? null
                      : () => context.read<ProviderJobsCubit>().execute(
                          ProviderJobsCommand.arrived(job.bookingId),
                        ),
                  child: Text('provider_action_mark_arrived'.tr),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: context.pop,
                  child: Text('provider_back_to_job_details'.tr),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _trackingStatus(ProviderJobStage stage) => switch (stage) {
  ProviderJobStage.accepted => 'provider_stage_accepted',
  ProviderJobStage.enRoute => 'provider_location_publishing',
  ProviderJobStage.arrived => 'provider_location_stopped_arrived',
  ProviderJobStage.inProgress => 'provider_stage_in_progress',
  ProviderJobStage.completed => 'provider_stage_completed',
  ProviderJobStage.cancelled => 'provider_stage_cancelled',
};
