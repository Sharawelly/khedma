import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';
import '../../../domain/entities/provider_entities.dart';
import '../../../presentation/cubit/provider_jobs_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';

class ProviderTrackLiveScreen extends StatelessWidget {
  const ProviderTrackLiveScreen({super.key});

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
        },
        builder: (context, state) {
          final job = state.snapshot.currentJob;
          if (job == null) {
            return ProviderErrorView('provider_no_active_job'.tr);
          }
          return ListView(
            padding: EdgeInsetsDirectional.all(20.r),
            children: <Widget>[
              Container(
                height: 220.h,
                decoration: BoxDecoration(
                  color: colors.pathsInfoSurface,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.navigation_rounded,
                  size: 72.r,
                  color: colors.authBrandRed,
                ),
              ),
              Gaps.vGap20,
              Text(
                job.address ?? 'provider_address_unavailable'.tr,
                style: TextStyles.bold20(color: colors.onboardingTextStrong),
              ),
              Gaps.vGap8,
              Text(
                _trackingStatus(job.stage).tr,
                style: TextStyles.medium16(color: colors.homeCaption),
              ),
              Gaps.vGap24,
              if (job.stage == ProviderJobStage.enRoute)
                FilledButton(
                  onPressed: state is ProviderJobsLoading
                      ? null
                      : () {
                          context.read<ProviderJobsCubit>().execute(
                            ProviderJobsCommand.arrived(job.bookingId),
                          );
                        },
                  child: Text('provider_action_mark_arrived'.tr),
                ),
              if (job.stage != ProviderJobStage.enRoute)
                OutlinedButton(
                  onPressed: context.pop,
                  child: Text('provider_back_to_job_details'.tr),
                ),
            ],
          );
        },
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
