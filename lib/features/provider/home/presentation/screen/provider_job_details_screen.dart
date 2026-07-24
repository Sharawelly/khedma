import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/presentation/cubit/booking_cubit.dart';
import '/features/shared/chat/domain/entities/chat_entities.dart';
import '/injection_container.dart';
import '../../../domain/entities/provider_entities.dart';
import '../../../presentation/cubit/provider_jobs_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';

/// Job details for one booking.
///
/// Reads the booking from `GET /Booking/{id}` rather than from the jobs
/// snapshot, because the snapshot only ever holds the *active* job - a finished
/// job opened from history has no entry there at all. The server serves the
/// provider-only fields (customer phone, net earning) once it has confirmed the
/// caller is the assigned provider, so nothing here needs gating locally.
class ProviderJobDetailsScreen extends StatefulWidget {
  const ProviderJobDetailsScreen({super.key, this.bookingId});

  /// Null means "whichever job is currently active", which is how the accept
  /// flow arrives here - it has just taken the job and has no id to hand over.
  final String? bookingId;

  @override
  State<ProviderJobDetailsScreen> createState() =>
      _ProviderJobDetailsScreenState();
}

class _ProviderJobDetailsScreenState extends State<ProviderJobDetailsScreen> {
  late final BookingCubit bookingCubit = ServiceLocator.instance();
  String? bookingId;

  @override
  void initState() {
    super.initState();
    bookingId =
        widget.bookingId ??
        context.read<ProviderJobsCubit>().state.snapshot.currentJob?.bookingId;
    _load();
  }

  void _load() {
    final id = bookingId;
    if (id != null) {
      bookingCubit.execute(BookingCommand.detail(id));
    }
  }

  @override
  void dispose() {
    bookingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(
        title: Text('provider_job_details_title'.tr),
        leading: BackButton(onPressed: context.pop),
      ),
      body: BlocListener<ProviderJobsCubit, ProviderJobsState>(
        listener: (context, state) {
          final message = switch (state) {
            ProviderJobsFailure() => state.messageKey,
            ProviderJobsSuccess() => state.messageKey,
            _ => null,
          };
          if (message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(providerMessage(message))));
          }
        },
        child: bookingId == null
            ? ProviderErrorView('provider_no_active_job'.tr)
            : BlocBuilder<BookingCubit, BookingState>(
                bloc: bookingCubit,
                builder: (context, state) {
                  if (state is BookingFailure) {
                    return ListView(
                      children: <Widget>[
                        ProviderErrorView(state.message),
                        TextButton(onPressed: _load, child: Text('retry'.tr)),
                      ],
                    );
                  }
                  if (state is! BookingDetailSuccess) {
                    return const ProviderLoadingView();
                  }
                  return BlocBuilder<ProviderJobsCubit, ProviderJobsState>(
                    builder: (context, jobsState) {
                      final current = jobsState.snapshot.currentJob;
                      // The stage buttons drive the live job only. Opening a
                      // finished booking from history must not offer to advance
                      // whatever job happens to be running right now.
                      final active = current?.bookingId == state.booking.id
                          ? current
                          : null;
                      return Stack(
                        children: <Widget>[
                          _JobDetailsBody(booking: state.booking, job: active),
                          if (jobsState is ProviderJobsLoading)
                            const Positioned.fill(
                              child: ColoredBox(
                                color: Color(0x33000000),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _JobDetailsBody extends StatelessWidget {
  const _JobDetailsBody({required this.booking, required this.job});

  final BookingEntity booking;

  /// Null when this booking is not the provider's active job, which is what
  /// hides the stage-advancing button on a finished one.
  final AcceptedJobEntity? job;

  @override
  Widget build(BuildContext context) {
    final isArabic = appLocalizations.isArLocale;
    return ListView(
      padding: EdgeInsetsDirectional.all(20.r),
      children: <Widget>[
        Text(
          booking.localizedService(isArabic),
          style: TextStyles.bold28(color: colors.onboardingTextStrong),
        ),
        Gaps.vGap8,
        Text(
          booking.localizedStatus(isArabic),
          style: TextStyles.bold16(color: colors.authBrandRed),
        ),
        Gaps.vGap20,
        _section('provider_job_details_customer_title'.tr, <Widget>[
          _line('provider_customer_name'.tr, booking.customerName),
          if (booking.customerPhone?.isNotEmpty == true)
            _line('provider_customer_phone'.tr, booking.customerPhone!),
          Gaps.vGap8,
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.icon(
              onPressed: () => _openChat(context),
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: Text('provider_job_details_chat'.tr),
            ),
          ),
        ]),
        Gaps.vGap12,
        _section('provider_job_details_location_title'.tr, <Widget>[
          _line(
            'provider_address'.tr,
            booking.address?.isNotEmpty == true
                ? booking.address!
                : 'provider_address_unavailable'.tr,
          ),
          if (booking.latitude != null && booking.longitude != null)
            _line(
              'provider_coordinates'.tr,
              '${booking.latitude}, ${booking.longitude}',
            ),
        ]),
        Gaps.vGap12,
        _section('provider_job_information'.tr, <Widget>[
          if (booking.providerEarning != null)
            _line(
              'provider_earnings_net_label'.tr,
              '${booking.providerEarning!.toStringAsFixed(2)} ${booking.currency ?? ''}'
                  .trim(),
            ),
          if (booking.notes?.isNotEmpty == true)
            _line('provider_notes'.tr, booking.notes!),
          if (booking.scheduledTime != null)
            _line(
              'provider_scheduled_time'.tr,
              booking.scheduledTime!.toLocal().toString(),
            ),
          if (booking.cancelReason?.isNotEmpty == true)
            _line('provider_cancel_reason'.tr, booking.cancelReason!),
        ]),
        Gaps.vGap12,
        _section('provider_status_timeline'.tr, <Widget>[
          _step('provider_created_at'.tr, booking.createAt),
          _step('provider_accepted_at'.tr, booking.acceptedAt),
          _step('provider_stage_en_route'.tr, booking.enRouteAt),
          _step('provider_stage_arrived'.tr, booking.arrivedAt),
          _step('provider_stage_in_progress'.tr, booking.startedAt),
          _step('provider_stage_completed'.tr, booking.completedAt),
          _step('provider_stage_cancelled'.tr, booking.cancelledAt),
        ]),
        Gaps.vGap24,
        if (job != null &&
            job!.stage != ProviderJobStage.completed &&
            job!.stage != ProviderJobStage.cancelled)
          FilledButton(
            onPressed: () => _advance(context),
            child: Text(_actionKey(job!.stage).tr),
          ),
      ],
    );
  }

  /// Chat threads are implicit: every message endpoint is keyed on the booking,
  /// so there is no conversation to create first - the peer is simply the other
  /// party on this booking.
  void _openChat(BuildContext context) {
    context.pushNamed(
      Routes.chatDetailsRoute,
      extra: ChatThreadEntity(
        bookingId: booking.id,
        peerId: booking.customerId,
        peerName: booking.customerName,
        unreadCount: 0,
        isOnline: false,
        // Finished jobs open the conversation read-only, matching the server's
        // completed/cancelled lock.
        isLocked: booking.completedAt != null || booking.cancelledAt != null,
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Container(
    padding: EdgeInsetsDirectional.all(16.r),
    decoration: BoxDecoration(
      color: colors.whiteColor,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: colors.onboardingBorderNeutral),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyles.bold18(color: colors.onboardingTextStrong),
        ),
        Gaps.vGap8,
        ...children,
      ],
    ),
  );

  Widget _line(String label, String value) => Padding(
    padding: EdgeInsetsDirectional.only(bottom: 6.h),
    child: SelectableText(
      '$label: $value',
      style: TextStyles.medium16(color: colors.onboardingBody),
    ),
  );

  /// Stages the booking never reached are left out rather than shown blank - the
  /// list is a record of what happened, not a checklist.
  Widget _step(String label, DateTime? time) => time == null
      ? const SizedBox.shrink()
      : _line(label, time.toLocal().toString());

  Future<void> _advance(BuildContext context) async {
    final cubit = context.read<ProviderJobsCubit>();
    switch (job!.stage) {
      case ProviderJobStage.accepted:
        await cubit.execute(ProviderJobsCommand.enRoute(job!.bookingId));
        if (context.mounted &&
            cubit.state.snapshot.currentJob?.stage ==
                ProviderJobStage.enRoute) {
          context.pushNamed(Routes.providerTrackLiveRoute);
        }
        break;
      case ProviderJobStage.enRoute:
        await cubit.execute(ProviderJobsCommand.arrived(job!.bookingId));
        break;
      case ProviderJobStage.arrived:
        await cubit.execute(ProviderJobsCommand.inProgress(job!.bookingId));
        break;
      case ProviderJobStage.inProgress:
        await cubit.execute(ProviderJobsCommand.complete(job!.bookingId));
        break;
      case ProviderJobStage.completed:
      case ProviderJobStage.cancelled:
        break;
    }
  }
}

String _actionKey(ProviderJobStage stage) => switch (stage) {
  ProviderJobStage.accepted => 'provider_action_mark_en_route',
  ProviderJobStage.enRoute => 'provider_action_mark_arrived',
  ProviderJobStage.arrived => 'provider_action_start_work',
  ProviderJobStage.inProgress => 'provider_action_complete_job',
  ProviderJobStage.completed => 'provider_stage_completed',
  ProviderJobStage.cancelled => 'provider_stage_cancelled',
};
