import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProviderProfileStatsRow extends StatelessWidget {
  const ProviderProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: _ProviderProfileStatItem(
              valueKey: 'provider_profile_jobs_done_value',
              labelKey: 'provider_profile_jobs_done',
            ),
          ),
          Expanded(
            child: _ProviderProfileStatItem(
              valueKey: 'provider_profile_rating_value',
              labelKey: 'provider_profile_rating',
            ),
          ),
          Expanded(
            child: _ProviderProfileStatItem(
              valueKey: 'provider_profile_experience_value',
              labelKey: 'provider_profile_experience',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderProfileStatItem extends StatelessWidget {
  const _ProviderProfileStatItem({required this.valueKey, required this.labelKey});

  final String valueKey;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          valueKey.tr,
          style: TextStyles.bold20(color: colors.onboardingHeadline),
          textAlign: TextAlign.center,
        ),
        Gaps.vGap2,
        Text(
          labelKey.tr,
          style: TextStyles.regular12(color: colors.lightTextColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
