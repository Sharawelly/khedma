import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProviderProfileAboutSection extends StatelessWidget {
  const ProviderProfileAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProviderProfileSectionShell(
      titleKey: 'provider_profile_about_title',
      child: Text(
        'provider_profile_about_description'.tr,
        style: TextStyles.regular14(
          color: colors.lightTextColor,
        ).copyWith(height: 1.5),
      ),
    );
  }
}

class ProviderProfileServicesSection extends StatelessWidget {
  const ProviderProfileServicesSection({super.key, required this.primaryServiceKey});

  final String primaryServiceKey;

  @override
  Widget build(BuildContext context) {
    final List<String> serviceKeys = <String>[
      primaryServiceKey,
      'provider_profile_service_drain_unblocking',
      'provider_profile_service_pipe_repair',
      'provider_profile_service_water_heater',
    ];
    return _ProviderProfileSectionShell(
      titleKey: 'provider_profile_services_title',
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: serviceKeys
            .map(
              (String key) => Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: colors.errorColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  key.tr,
                  style: TextStyles.medium12(color: colors.errorColor),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ProviderProfileWorkingAreasSection extends StatelessWidget {
  const ProviderProfileWorkingAreasSection({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> areaKeys = <String>[
      'provider_profile_area_nasr_city',
      'provider_profile_area_maadi',
      'provider_profile_area_heliopolis',
    ];
    return _ProviderProfileSectionShell(
      titleKey: 'provider_profile_working_areas_title',
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: areaKeys
            .map(
              (String key) => Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: colors.upBackGround,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.location_on_rounded,
                      size: 14.r,
                      color: colors.errorColor,
                    ),
                    Gaps.hGap4,
                    Text(
                      key.tr,
                      style: TextStyles.medium12(color: colors.lightTextColor),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProviderProfileSectionShell extends StatelessWidget {
  const _ProviderProfileSectionShell({
    required this.titleKey,
    required this.child,
  });

  final String titleKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            titleKey.tr,
            style: TextStyles.bold20(color: colors.onboardingHeadline),
          ),
          Gaps.vGap10,
          child,
        ],
      ),
    );
  }
}
