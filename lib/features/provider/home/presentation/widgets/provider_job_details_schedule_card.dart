import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobDetailsScheduleCard extends StatelessWidget {
  const ProviderJobDetailsScheduleCard({super.key});

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _LeadingIcon(icon: Icons.calendar_month_outlined),
              Gaps.hGap10,
              Expanded(
                child: Text(
                  'provider_job_details_day'.tr,
                  style: TextStyles.semiBold20(
                    color: colors.onboardingTextStrong,
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap10,
          Row(
            children: <Widget>[
              _LeadingIcon(icon: Icons.watch_later_outlined),
              Gaps.hGap10,
              Expanded(
                child: Text(
                  'provider_job_details_time'.tr,
                  style: TextStyles.medium16(color: colors.homeCaption),
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          Row(
            children: [
              Spacer(),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: colors.authSignUpSelectedSurface,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.bolt, size: 16.r, color: colors.authBrandRed),
                    Gaps.hGap4,
                    Text(
                      'provider_job_details_immediate'.tr,
                      style: TextStyles.semiBold14(color: colors.authBrandRed),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        color: colors.authSignUpSelectedSurface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18.r, color: colors.authBrandRed),
    );
  }
}
