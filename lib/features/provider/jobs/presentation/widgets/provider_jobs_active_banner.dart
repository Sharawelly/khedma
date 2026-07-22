import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobsActiveBanner extends StatelessWidget {
  const ProviderJobsActiveBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: colors.authSignUpBackgroundWash,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: <Widget>[
          // Container(
          //   width: 4.w,
          //   height: 62.h,
          //   decoration: BoxDecoration(
          //     color: colors.authBrandRed,
          //     borderRadius: BorderRadius.circular(10.r),
          //   ),
          // ),
          // Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'provider_jobs_active_title'.tr,
                  style: TextStyles.bold16(color: colors.authBrandRed),
                ),
                Gaps.vGap4,
                Text(
                  'provider_jobs_active_subtitle'.tr,
                  style: TextStyles.medium14(color: colors.onboardingHeadline),
                ),
                Gaps.vGap4,
                Text(
                  'provider_jobs_view_details_arrow'.tr,
                  style: TextStyles.semiBold14(color: colors.authBrandRed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
