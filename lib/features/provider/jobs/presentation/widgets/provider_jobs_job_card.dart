import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/config/locale/app_localizations.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/app_image.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/injection_container.dart';

class ProviderJobsJobCard extends StatelessWidget {
  const ProviderJobsJobCard({
    super.key,
    required this.titleKey,
    required this.customerNameKey,
    required this.locationKey,
    required this.dateTimeKey,
    required this.durationKey,
    required this.priceKey,
    required this.statusKey,
    required this.statusBg,
    required this.statusColor,
    required this.avatarUrl,
  });

  final String titleKey;
  final String customerNameKey;
  final String locationKey;
  final String dateTimeKey;
  final String durationKey;
  final String priceKey;
  final String statusKey;
  final Color statusBg;
  final Color statusColor;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadowCardLight,
            blurRadius: 8,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  titleKey.tr,
                  style: TextStyles.bold20(color: colors.onboardingTextStrong),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 10.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  statusKey.tr,
                  style: TextStyles.semiBold10(color: statusColor),
                ),
              ),
            ],
          ),
          Gaps.vGap4,
          Row(
            children: <Widget>[
              AppImage.network(
                imageUrl: avatarUrl,
                width: 36.r,
                height: 36.r,
                isCircle: true,
                isCached: true,
                fit: BoxFit.cover,
              ),
              Gaps.hGap10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      customerNameKey.tr,
                      style: TextStyles.medium17(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    Text(
                      locationKey.tr,
                      style: TextStyles.regular12(color: colors.homeCaption),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          Row(
            children: <Widget>[
              Icon(
                Icons.calendar_month_outlined,
                size: 18.r,
                color: colors.authBrandRed,
              ),
              Gaps.hGap8,
              Text(
                dateTimeKey.tr,
                style: TextStyles.medium14(color: colors.onboardingHeadline),
              ),
              Spacer(),
              Icon(
                Icons.timelapse_rounded,
                size: 18.r,
                color: colors.authBrandRed,
              ),
              Gaps.hGap8,
              Text(
                durationKey.tr,
                style: TextStyles.medium14(color: colors.onboardingHeadline),
              ),
            ],
          ),
          Gaps.vGap12,
          Divider(color: colors.onboardingBorderNeutral),
          Gaps.vGap6,
          Row(
            children: <Widget>[
              Text(
                priceKey.tr,
                style: TextStyles.bold18(color: colors.authBrandRed),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                size: 24.r,
                color: colors.authBrandRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
