import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_section_card.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileHourlyRateSection extends StatelessWidget {
  const ProviderProfileHourlyRateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderProfileSectionCard(
      titleKey: 'provider_hourly_rate'.tr,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: colors.backGround,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
        ),
        child: Text(
          'provider_hourly_rate_value'.tr,
          style: TextStyles.medium16(color: colors.onboardingHeadline),
        ),
      ),
    );
  }
}
