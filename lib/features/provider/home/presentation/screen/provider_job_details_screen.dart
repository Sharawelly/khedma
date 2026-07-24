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

class ProviderJobDetailsScreen extends StatelessWidget {
  const ProviderJobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      appBar: AppBar(
        title: Text('provider_job_details_title'.tr),
        leading: BackButton(onPressed: context.pop),
      ),
      body: BlocConsumer<ProviderJobsCubit, ProviderJobsState>(
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
        builder: (context, state) {
          final job = state.snapshot.currentJob;
          if (job == null) {
            return ProviderErrorView('provider_no_active_job'.tr);
          }
          return Stack(
            children: <Widget>[
              _JobDetailsBody(job: job),
              if (state is ProviderJobsLoading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0x33000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _JobDetailsBody extends StatelessWidget {
  const _JobDetailsBody({required this.job});

  final AcceptedJobEntity job;

  @override
  Widget build(BuildContext context) {
    final isArabic = appLocalizations.isArLocale;
    return ListView(
      padding: EdgeInsetsDirectional.all(20.r),
      children: <Widget>[
        Text(
          job.localizedService(isArabic),
          style: TextStyles.bold28(color: colors.onboardingTextStrong),
        ),
        Gaps.vGap8,
        Text(
          _stageKey(job.stage).tr,
          style: TextStyles.bold16(color: colors.authBrandRed),
        ),
        Gaps.vGap20,
        _section('provider_job_details_customer_title'.tr, <Widget>[
          _line('provider_customer_name'.tr, job.customerName),
          if (job.customerPhone?.isNotEmpty == true)
            _line('provider_customer_phone'.tr, job.customerPhone!),
        ]),
        Gaps.vGap12,
        _section('provider_job_details_location_title'.tr, <Widget>[
          if (job.address?.isNotEmpty == true)
            _line('provider_address'.tr, job.address!)
          else
            _line('provider_address'.tr, 'provider_address_unavailable'.tr),
          if (job.latitude != null && job.longitude != null)
            _line(
              'provider_coordinates'.tr,
              '${job.latitude}, ${job.longitude}',
            ),
        ]),
        Gaps.vGap12,
        _section('provider_job_information'.tr, <Widget>[
          _line(
            'provider_earnings_net_label'.tr,
            '${job.providerEarning.toStringAsFixed(2)} ${job.currency}',
          ),
          if (job.notes?.isNotEmpty == true)
            _line('provider_notes'.tr, job.notes!),
          if (job.scheduledTime != null)
            _line(
              'provider_scheduled_time'.tr,
              job.scheduledTime!.toLocal().toString(),
            ),
          _line('provider_accepted_at'.tr, job.acceptedAt.toLocal().toString()),
        ]),
        Gaps.vGap24,
        if (job.stage != ProviderJobStage.completed &&
            job.stage != ProviderJobStage.cancelled)
          FilledButton(
            onPressed: () => _advance(context),
            child: Text(_actionKey(job.stage).tr),
          ),
      ],
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

  Future<void> _advance(BuildContext context) async {
    final cubit = context.read<ProviderJobsCubit>();
    switch (job.stage) {
      case ProviderJobStage.accepted:
        await cubit.execute(ProviderJobsCommand.enRoute(job.bookingId));
        if (context.mounted &&
            cubit.state.snapshot.currentJob?.stage ==
                ProviderJobStage.enRoute) {
          context.pushNamed(Routes.providerTrackLiveRoute);
        }
        break;
      case ProviderJobStage.enRoute:
        await cubit.execute(ProviderJobsCommand.arrived(job.bookingId));
        break;
      case ProviderJobStage.arrived:
        await cubit.execute(ProviderJobsCommand.inProgress(job.bookingId));
        break;
      case ProviderJobStage.inProgress:
        await cubit.execute(ProviderJobsCommand.complete(job.bookingId));
        break;
      case ProviderJobStage.completed:
      case ProviderJobStage.cancelled:
        break;
    }
  }
}

String _stageKey(ProviderJobStage stage) => switch (stage) {
  ProviderJobStage.accepted => 'provider_stage_accepted',
  ProviderJobStage.enRoute => 'provider_stage_en_route',
  ProviderJobStage.arrived => 'provider_stage_arrived',
  ProviderJobStage.inProgress => 'provider_stage_in_progress',
  ProviderJobStage.completed => 'provider_stage_completed',
  ProviderJobStage.cancelled => 'provider_stage_cancelled',
};

String _actionKey(ProviderJobStage stage) => switch (stage) {
  ProviderJobStage.accepted => 'provider_action_mark_en_route',
  ProviderJobStage.enRoute => 'provider_action_mark_arrived',
  ProviderJobStage.arrived => 'provider_action_start_work',
  ProviderJobStage.inProgress => 'provider_action_complete_job',
  ProviderJobStage.completed => 'provider_stage_completed',
  ProviderJobStage.cancelled => 'provider_stage_cancelled',
};
