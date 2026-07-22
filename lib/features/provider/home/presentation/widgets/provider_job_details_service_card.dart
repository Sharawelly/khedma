import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobDetailsServiceCard extends StatelessWidget {
  const ProviderJobDetailsServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 75.r,
            height: 75.r,
            decoration: BoxDecoration(
              color: colors.onboardingTextStrong,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.plumbing_rounded,
              size: 38.r,
              color: colors.whiteColor,
            ),
          ),
          Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'provider_job_details_service_name'.tr,
                  style: TextStyles.bold20(color: colors.onboardingTextStrong),
                ),
                Text(
                  'provider_job_details_service_type'.tr,
                  style: TextStyles.semiBold12(color: colors.authBrandRed),
                ),
                Gaps.vGap4,
                Text(
                  'provider_job_details_price'.tr,
                  style: TextStyles.bold24(color: colors.authBrandRed),
                ),
                Gaps.hGap4,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
