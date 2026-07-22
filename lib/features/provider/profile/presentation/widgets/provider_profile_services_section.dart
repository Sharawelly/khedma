import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_section_card.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileServicesSection extends StatelessWidget {
  const ProviderProfileServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderProfileSectionCard(
      titleKey: 'provider_my_services'.tr,

      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: const <Widget>[
          _ProviderServiceChip(
            labelKey: 'provider_service_plumbing',
            enabled: true,
          ),
          _ProviderServiceChip(
            labelKey: 'provider_service_electrical',
            enabled: true,
          ),
          _ProviderServiceChip(
            labelKey: 'provider_service_carpentry',
            enabled: false,
          ),
          _ProviderServiceChip(
            labelKey: 'provider_service_painting',
            enabled: false,
          ),
        ],
      ),
    );
  }
}

class _ProviderServiceChip extends StatelessWidget {
  const _ProviderServiceChip({required this.labelKey, required this.enabled});

  final String labelKey;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: enabled
            ? colors.authBrandRed.withValues(alpha: 0.1)
            : colors.backGround,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            labelKey.tr,
            style: TextStyles.medium12(
              color: enabled ? colors.authBrandRed : colors.lightTextColor,
            ),
          ),
          Gaps.hGap6,
          Icon(
            enabled ? Icons.toggle_on : Icons.toggle_off,
            color: enabled
                ? colors.authBrandRed
                : colors.onboardingBorderNeutral,
            size: 40.r,
          ),
        ],
      ),
    );
  }
}
