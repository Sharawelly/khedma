import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '../../../domain/entities/provider_entities.dart';
import '../../../presentation/cubit/provider_jobs_cubit.dart';
import '../../../presentation/widgets/provider_state_widgets.dart';

class ProviderJobsScreen extends StatefulWidget {
  const ProviderJobsScreen({super.key});

  @override
  State<ProviderJobsScreen> createState() => _ProviderJobsScreenState();
}

class _ProviderJobsScreenState extends State<ProviderJobsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: BlocBuilder<ProviderJobsCubit, ProviderJobsState>(
          builder: (context, state) {
            final jobs = _filtered(state.snapshot.history);
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    20.w,
                    12.h,
                    20.w,
                    8.h,
                  ),
                  child: Text(
                    'provider_jobs_title'.tr,
                    style: TextStyles.bold22(color: colors.onboardingHeadline),
                  ),
                ),
                _JobsTabs(
                  selectedTab: _selectedTab,
                  onSelect: (index) => setState(() => _selectedTab = index),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => context.read<ProviderJobsCubit>().execute(
                      const ProviderJobsCommand.recover(),
                    ),
                    child: switch (state) {
                      ProviderJobsFailure()
                          when state.snapshot.history.isEmpty =>
                        ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            ProviderErrorView(state.messageKey),
                            TextButton(
                              onPressed: () => context
                                  .read<ProviderJobsCubit>()
                                  .execute(const ProviderJobsCommand.recover()),
                              child: Text('retry'.tr),
                            ),
                          ],
                        ),
                      ProviderJobsLoading()
                          when state.snapshot.history.isEmpty =>
                        const ProviderLoadingView(),
                      _ => ListView(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          20.w,
                          16.h,
                          20.w,
                          20.h,
                        ),
                        children: <Widget>[
                          if (state.snapshot.currentJob != null &&
                              state.snapshot.currentJob!.stage !=
                                  ProviderJobStage.completed &&
                              state.snapshot.currentJob!.stage !=
                                  ProviderJobStage.cancelled) ...<Widget>[
                            Card(
                              color: colors.authBrandRed,
                              child: ListTile(
                                title: Text(
                                  state.snapshot.currentJob!.localizedService(
                                    appLocalizations.isArLocale,
                                  ),
                                  style: TextStyles.bold18(
                                    color: colors.whiteColor,
                                  ),
                                ),
                                subtitle: Text(
                                  'provider_jobs_active_title'.tr,
                                  style: TextStyles.medium14(
                                    color: colors.whiteColor,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right_rounded,
                                  color: colors.whiteColor,
                                ),
                                onTap: () => context.pushNamed(
                                  Routes.providerJobDetailsRoute,
                                ),
                              ),
                            ),
                            Gaps.vGap16,
                          ],
                          if (jobs.isEmpty)
                            Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                vertical: 40.h,
                              ),
                              child: Text(
                                'provider_no_job_history'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyles.medium16(
                                  color: colors.homeCaption,
                                ),
                              ),
                            )
                          else
                            ...jobs.map(
                              (job) => Padding(
                                padding: EdgeInsetsDirectional.only(
                                  bottom: 12.h,
                                ),
                                child: _HistoryCard(job: job),
                              ),
                            ),
                          if (state.snapshot.historyHasNextPage)
                            TextButton(
                              onPressed: () =>
                                  context.read<ProviderJobsCubit>().execute(
                                    const ProviderJobsCommand.loadMoreHistory(),
                                  ),
                              child: Text('load_more'.tr),
                            ),
                        ],
                      ),
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<BookingHistoryEntity> _filtered(List<BookingHistoryEntity> history) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return history.where((job) {
      final value = job.scheduledTime ?? job.createAt;
      final date = DateTime(value.year, value.month, value.day);
      return switch (_selectedTab) {
        0 => date == today,
        1 => date.isAfter(today),
        _ => date.isBefore(today),
      };
    }).toList();
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.job});

  final BookingHistoryEntity job;

  @override
  Widget build(BuildContext context) {
    final time = job.scheduledTime ?? job.createAt;
    return Container(
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
            job.serviceName,
            style: TextStyles.bold18(color: colors.onboardingHeadline),
          ),
          Gaps.vGap4,
          Text(
            job.customerName,
            style: TextStyles.medium14(color: colors.homeCaption),
          ),
          Gaps.vGap8,
          Text(
            time.toLocal().toString(),
            style: TextStyles.regular13(color: colors.homeCaption),
          ),
        ],
      ),
    );
  }
}

class _JobsTabs extends StatelessWidget {
  const _JobsTabs({required this.selectedTab, required this.onSelect});

  final int selectedTab;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final labels = <String>[
      'provider_jobs_tab_today',
      'provider_jobs_tab_upcoming',
      'provider_jobs_tab_past',
    ];
    return Row(
      children: List<Widget>.generate(labels.length, (index) {
        final selected = selectedTab == index;
        return Expanded(
          child: InkWell(
            onTap: () => onSelect(index),
            child: Container(
              padding: EdgeInsetsDirectional.only(bottom: 10.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected
                        ? colors.authBrandRed
                        : colors.onboardingBorderNeutral,
                    width: selected ? 2 : 1,
                  ),
                ),
              ),
              child: Text(
                labels[index].tr,
                textAlign: TextAlign.center,
                style: selected
                    ? TextStyles.bold16(color: colors.authBrandRed)
                    : TextStyles.medium16(color: colors.homeCaption),
              ),
            ),
          ),
        );
      }),
    );
  }
}
