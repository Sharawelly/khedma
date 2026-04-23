import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class AlmostDoneBookingSummaryCard extends StatelessWidget {
  const AlmostDoneBookingSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(12.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AppImage.network(
                  imageUrl:
                      'https://images.unsplash.com/photo-1635321593217-40050ad13c74?auto=format&fit=crop&w=400&q=80',
                  width: 92.r,
                  height: 92.r,
                  fit: BoxFit.cover,
                  isCached: true,
                ),
              ),
              Gaps.hGap12,
              Expanded(
                child: Text(
                  'home_almost_done_service_title'.tr,
                  style: TextStyles.bold18(color: colors.onboardingHeadline),
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.location_on_rounded,
                size: 18.r,
                color: colors.errorColor,
              ),
              Gaps.hGap6,
              Expanded(
                child: Text(
                  'home_almost_done_address'.tr,
                  style: TextStyles.medium14(
                    color: colors.lightTextColor,
                  ).copyWith(height: 1.h),
                ),
              ),
            ],
          ),
          Gaps.vGap6,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.access_time_filled_rounded,
                size: 16.r,
                color: colors.errorColor,
              ),
              Gaps.hGap6,
              Expanded(
                child: Text(
                  'home_almost_done_time'.tr,
                  style: TextStyles.medium14(
                    color: colors.lightTextColor,
                  ).copyWith(height: 1.h),
                ),
              ),
            ],
          ),
          Gaps.vGap6,
          Row(
            children: <Widget>[
              const Spacer(),
              Gaps.hGap8,
              Text(
                'home_almost_done_service_price'.tr,
                style: TextStyles.bold22(color: colors.errorColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
