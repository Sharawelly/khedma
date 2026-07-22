import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/img_manager.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/jobs/presentation/widgets/provider_jobs_active_banner.dart';
import 'package:khedma/features/provider/jobs/presentation/widgets/provider_jobs_job_card.dart';
import 'package:khedma/injection_container.dart';

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
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 8.h),
              child: Text(
                'provider_jobs_title'.tr,
                style: TextStyles.bold22(color: colors.onboardingHeadline),
              ),
            ),
            _JobsTabs(
              selectedTab: _selectedTab,
              onSelect: (int index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 20.h),
                children: <Widget>[
                  if (_selectedTab == 0) ...<Widget>[
                    const ProviderJobsActiveBanner(),
                    Gaps.vGap16,
                  ],
                  ProviderJobsJobCard(
                    titleKey: 'provider_jobs_card_1_title',
                    customerNameKey: 'provider_jobs_card_1_customer',
                    locationKey: 'provider_jobs_card_1_location',
                    dateTimeKey: 'provider_jobs_card_1_time',
                    durationKey: 'provider_jobs_card_1_duration',
                    priceKey: 'provider_jobs_card_1_price',
                    statusKey: 'provider_jobs_card_1_status',
                    statusBg: colors.pathsInfoSurface,
                    statusColor: colors.pathsInfoAccent,
                    avatarUrl: ImageAssets.bookingsProviderAvatar,
                  ),
                  Gaps.vGap16,
                  ProviderJobsJobCard(
                    titleKey: 'provider_jobs_card_2_title',
                    customerNameKey: 'provider_jobs_card_2_customer',
                    locationKey: 'provider_jobs_card_2_location',
                    dateTimeKey: 'provider_jobs_card_2_time',
                    durationKey: 'provider_jobs_card_2_duration',
                    priceKey: 'provider_jobs_card_2_price',
                    statusKey: 'provider_jobs_card_2_status',
                    statusBg: colors.blocksHeroChipBg,
                    statusColor: colors.strengthFair,
                    avatarUrl: ImageAssets.profileProviderAvatar2,
                  ),
                ],
              ),
            ),
          ],
        ),
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
    final List<String> labels = <String>[
      'provider_jobs_tab_today',
      'provider_jobs_tab_upcoming',
      'provider_jobs_tab_past',
    ];

    return Row(
      children: List<Widget>.generate(labels.length, (int index) {
        final bool selected = selectedTab == index;
        return Expanded(
          child: GestureDetector(
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
