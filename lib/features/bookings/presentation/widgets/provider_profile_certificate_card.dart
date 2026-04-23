import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProviderProfileCertificateCard extends StatelessWidget {
  const ProviderProfileCertificateCard({super.key});

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
            'provider_profile_certificates_title'.tr,
            style: TextStyles.bold20(color: colors.onboardingHeadline),
          ),
          Gaps.vGap10,
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: colors.upBackGround,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.description_rounded, size: 20.r, color: colors.errorColor),
                Gaps.hGap8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'provider_profile_certificate_name'.tr,
                        style: TextStyles.semiBold14(color: colors.onboardingHeadline),
                      ),
                      Text(
                        'provider_profile_certificate_issuer'.tr,
                        style: TextStyles.regular12(color: colors.lightTextColor),
                      ),
                    ],
                  ),
                ),
                Text(
                  'provider_profile_view'.tr,
                  style: TextStyles.bold14(color: colors.errorColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
