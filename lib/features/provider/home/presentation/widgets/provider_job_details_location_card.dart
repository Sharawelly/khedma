import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobDetailsLocationCard extends StatelessWidget {
  const ProviderJobDetailsLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'provider_job_details_location_title'.tr,
            style: TextStyles.semiBold12(
              color: colors.onboardingTextStrong,
            ).copyWith(letterSpacing: 1.1),
          ),
          Gaps.vGap10,
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.upBackGround,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Icon(
                    Icons.map_outlined,
                    size: 66.r,
                    color: colors.homeCaption,
                  ),
                ),
                PositionedDirectional(
                  top: 30.h,
                  start: 110.w,
                  child: Icon(
                    Icons.location_on,
                    size: 28.r,
                    color: colors.authBrandRed,
                  ),
                ),
                PositionedDirectional(
                  bottom: 28.h,
                  end: 120.w,
                  child: Icon(
                    Icons.location_on,
                    size: 30.r,
                    color: colors.authBrandRed,
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap12,
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'provider_job_details_address'.tr,
                  style: TextStyles.medium16(
                    color: colors.onboardingTextStrong,
                  ),
                ),
              ),
              Text(
                'provider_job_details_open_maps'.tr,
                style: TextStyles.semiBold14(color: colors.authBrandRed),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
