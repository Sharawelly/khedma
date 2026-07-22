import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/provider/profile/presentation/widgets/provider_profile_section_card.dart';
import 'package:khedma/injection_container.dart';

class ProviderProfileCertificatesSection extends StatelessWidget {
  const ProviderProfileCertificatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderProfileSectionCard(
      titleKey: 'provider_profile_certificates'.tr,

      child: Column(
        children: const <Widget>[
          _ProviderCertificateTile(
            titleKey: 'provider_certificate_1_title',
            subTitleKey: 'provider_certificate_1_subtitle',
          ),
          _ProviderCertificateTile(
            titleKey: 'provider_certificate_2_title',
            subTitleKey: 'provider_certificate_2_subtitle',
          ),
        ],
      ),
    );
  }
}

class _ProviderCertificateTile extends StatelessWidget {
  const _ProviderCertificateTile({
    required this.titleKey,
    required this.subTitleKey,
  });

  final String titleKey;
  final String subTitleKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 8.h),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.authBrandRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.description_rounded,
            color: colors.authBrandRed,
            size: 20.r,
          ),
          Gaps.hGap8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titleKey.tr,
                  style: TextStyles.semiBold14(
                    color: colors.onboardingHeadline,
                  ).copyWith(height: 1.h),
                ),
                Gaps.vGap8,
                Text(
                  subTitleKey.tr,
                  style: TextStyles.regular12(
                    color: colors.homeCaption,
                  ).copyWith(height: 1.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
