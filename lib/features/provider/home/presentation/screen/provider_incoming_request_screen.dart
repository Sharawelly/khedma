import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';
import '../../../domain/entities/provider_entities.dart';
import '../../../presentation/cubit/provider_jobs_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';

class ProviderIncomingRequestScreen extends StatelessWidget {
  const ProviderIncomingRequestScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('provider_request_new_job_title'.tr),
        leading: BackButton(onPressed: context.pop),
      ),
      body: BlocConsumer<ProviderJobsCubit, ProviderJobsState>(
        listener: (context, state) {
          if (state case ProviderJobsFailure(:final messageKey)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(providerMessage(messageKey))),
            );
          }
        },
        builder: (context, state) {
          final job = _findJob(state.snapshot.pendingJobs);
          if (job == null) {
            return Center(
              child: Text(
                'provider_offer_expired'.tr,
                style: TextStyles.medium16(color: colors.homeCaption),
              ),
            );
          }
          return _OfferBody(job: job);
        },
      ),
    );
  }

  PendingJobEntity? _findJob(List<PendingJobEntity> jobs) {
    for (final job in jobs) {
      if (job.bookingId == bookingId) {
        return job;
      }
    }
    return null;
  }
}

class _OfferBody extends StatelessWidget {
  const _OfferBody({required this.job});

  final PendingJobEntity job;

  @override
  Widget build(BuildContext context) {
    final isArabic = appLocalizations.isArLocale;
    return ListView(
      padding: EdgeInsetsDirectional.all(24.r),
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 110.r,
            height: 110.r,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 110.r,
                  height: 110.r,
                  child: CircularProgressIndicator(
                    value: job.secondsRemaining > 0
                        ? (job.secondsRemaining.clamp(0, 60) / 60)
                        : 0,
                    strokeWidth: 8.r,
                    color: colors.authBrandRed,
                    backgroundColor: colors.onboardingSurfaceMuted,
                  ),
                ),
                Text(
                  '${job.secondsRemaining}',
                  style: TextStyles.bold30(color: colors.onboardingTextStrong),
                ),
              ],
            ),
          ),
        ),
        Gaps.vGap24,
        Text(
          job.localizedService(isArabic),
          style: TextStyles.bold28(color: colors.onboardingTextStrong),
        ),
        Gaps.vGap4,
        Text(
          job.localizedCategory(isArabic),
          style: TextStyles.medium16(color: colors.homeCaption),
        ),
        Gaps.vGap20,
        _line('provider_customer_first_name'.tr, job.customerFirstName),
        _line(
          'provider_distance_label'.tr,
          '${job.distanceKm.toStringAsFixed(1)} ${'provider_km'.tr}',
        ),
        _line(
          'provider_earnings_net_label'.tr,
          '${job.providerEarning.toStringAsFixed(2)} ${job.currency}',
        ),
        _line('provider_booking_type'.tr, job.bookingType),
        if (job.estimatedDurationMin != null ||
            job.estimatedDurationMax != null)
          _line(
            'provider_estimated_duration'.tr,
            '${job.estimatedDurationMin ?? ''}'
            '${job.estimatedDurationMax == null ? '' : ' - ${job.estimatedDurationMax}'} '
            '${'provider_minutes'.tr}',
          ),
        if (job.scheduledTime != null)
          _line(
            'provider_scheduled_time'.tr,
            job.scheduledTime!.toLocal().toString(),
          ),
        Gaps.vGap24,
        FilledButton(
          onPressed: () => _accept(context),
          child: Text('provider_accept'.tr),
        ),
        Gaps.vGap8,
        OutlinedButton(
          onPressed: () async {
            await context.read<ProviderJobsCubit>().execute(
              ProviderJobsCommand.reject(job.bookingId),
            );
            if (context.mounted) {
              context.pop();
            }
          },
          child: Text('provider_decline'.tr),
        ),
      ],
    );
  }

  Widget _line(String label, String value) => Padding(
    padding: EdgeInsetsDirectional.only(bottom: 10.h),
    child: Text(
      '$label: $value',
      style: TextStyles.medium16(color: colors.onboardingBody),
    ),
  );

  Future<void> _accept(BuildContext context) async {
    await context.read<ProviderJobsCubit>().execute(
      ProviderJobsCommand.accept(job.bookingId),
    );
    if (!context.mounted) {
      return;
    }
    final current = context.read<ProviderJobsCubit>().state.snapshot.currentJob;
    if (current?.bookingId == job.bookingId) {
      context.pushReplacementNamed(Routes.providerJobDetailsRoute);
    }
  }
}
