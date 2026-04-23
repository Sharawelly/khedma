import 'package:flutter/material.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/presentation/widgets/provider_today_job_row.dart';
import 'package:khedma/injection_container.dart';

class ProviderTodaysJobsSection extends StatelessWidget {
  const ProviderTodaysJobsSection({super.key, this.onViewSchedule});

  final VoidCallback? onViewSchedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'provider_todays_jobs'.tr,
              style: TextStyles.bold16(color: colors.onboardingTextStrong),
            ),
            GestureDetector(
              onTap: onViewSchedule,
              child: Text(
                'provider_view_schedule'.tr,
                style: TextStyles.semiBold14(color: colors.authBrandRed),
              ),
            ),
          ],
        ),
        Gaps.vGap12,
        ProviderTodayJobRow(
          leadIcon: Icons.electrical_services_rounded,
          leadIconBg: colors.pathsInfoSurface,
          leadIconColor: colors.pathsInfoAccent,
          titleKey: 'provider_job_ac_title',
          metaKey: 'provider_job_ac_meta',
          badgeKey: 'provider_badge_in_progress',
          inProgress: true,
        ),
        Gaps.vGap10,
        ProviderTodayJobRow(
          leadIcon: Icons.brush_rounded,
          leadIconBg: colors.blocksHeroChipBg,
          leadIconColor: colors.strengthFair,
          titleKey: 'provider_job_cleaning_title',
          metaKey: 'provider_job_cleaning_meta',
          badgeKey: 'provider_badge_pending',
          inProgress: false,
        ),
      ],
    );
  }
}
