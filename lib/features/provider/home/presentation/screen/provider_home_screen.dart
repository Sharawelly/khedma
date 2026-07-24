import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';
import '../../../presentation/cubit/provider_jobs_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';
import '../widgets/provider_availability_earnings_card.dart';
import '../widgets/provider_home_header.dart';
import '../widgets/provider_incoming_request_card.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderJobsCubit>().execute(
      const ProviderJobsCommand.recover(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ProviderJobsCubit, ProviderJobsState>(
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
          final snapshot = state.snapshot;
          return RefreshIndicator(
            onRefresh: () => context.read<ProviderJobsCubit>().execute(
              const ProviderJobsCommand.recover(),
            ),
            child: ListView(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 20.w,
                vertical: 8.h,
              ),
              children: <Widget>[
                const ProviderHomeHeader(),
                Gaps.vGap20,
                ProviderAvailabilityEarningsCard(
                  isOnline: snapshot.isOnline,
                  onChanged: (online) {
                    context.read<ProviderJobsCubit>().execute(
                      ProviderJobsCommand.availability(online),
                    );
                  },
                ),
                Gaps.vGap24,
                Text(
                  'provider_incoming_section'.tr,
                  style: TextStyles.bold16(color: colors.onboardingTextStrong),
                ),
                Gaps.vGap12,
                if (state is ProviderJobsFailure &&
                    snapshot.pendingJobs.isEmpty &&
                    snapshot.history.isEmpty)
                  SizedBox(
                    height: 160.h,
                    child: ProviderErrorView(state.messageKey),
                  )
                else if (state is ProviderJobsLoading &&
                    snapshot.pendingJobs.isEmpty)
                  SizedBox(height: 220.h, child: const ProviderLoadingView())
                else if (snapshot.pendingJobs.isEmpty)
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 24.h),
                    child: Text(
                      'provider_no_pending_jobs'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium16(color: colors.homeCaption),
                    ),
                  )
                else
                  ...snapshot.pendingJobs.map(
                    (job) => Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 12.h),
                      child: ProviderIncomingRequestCard(
                        job: job,
                        onTap: () => context.pushNamed(
                          Routes.providerIncomingRequestRoute,
                          extra: job.bookingId,
                        ),
                        onDecline: () {
                          context.read<ProviderJobsCubit>().execute(
                            ProviderJobsCommand.reject(job.bookingId),
                          );
                        },
                        onAccept: () => _accept(job.bookingId),
                      ),
                    ),
                  ),
                Gaps.vGap12,
                Text(
                  'provider_recent_jobs'.tr,
                  style: TextStyles.bold16(color: colors.onboardingTextStrong),
                ),
                Gaps.vGap8,
                if (snapshot.history.isEmpty)
                  Text(
                    'provider_no_job_history'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyles.medium16(color: colors.homeCaption),
                  )
                else
                  ...snapshot.history
                      .take(3)
                      .map(
                        (booking) => Card(
                          color: colors.whiteColor,
                          child: ListTile(
                            title: Text(booking.serviceName),
                            subtitle: Text(booking.customerName),
                            trailing: Text(
                              booking.scheduledTime?.toLocal().toString() ??
                                  booking.createAt.toLocal().toString(),
                              style: TextStyles.regular10(
                                color: colors.homeCaption,
                              ),
                            ),
                          ),
                        ),
                      ),
                Gaps.vGap20,
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _accept(String bookingId) async {
    await context.read<ProviderJobsCubit>().execute(
      ProviderJobsCommand.accept(bookingId),
    );
    if (!mounted) {
      return;
    }
    final current = context.read<ProviderJobsCubit>().state.snapshot.currentJob;
    if (current?.bookingId == bookingId) {
      context.pushNamed(Routes.providerJobDetailsRoute);
    }
  }
}
