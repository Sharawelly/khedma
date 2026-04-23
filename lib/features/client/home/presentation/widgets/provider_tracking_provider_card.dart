import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProviderTrackingProviderCard extends StatelessWidget {
  const ProviderTrackingProviderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: AppImage.network(
                  imageUrl:
                      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
                  width: 48.r,
                  height: 48.r,
                  fit: BoxFit.cover,
                  isCircle: true,
                  isCached: true,
                ),
              ),
              Gaps.hGap10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'home_provider_tracking_provider_name'.tr,
                      style: TextStyles.bold18(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    Text(
                      'home_provider_tracking_provider_role'.tr,
                      style: TextStyles.medium14(color: colors.lightTextColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.star_rounded, color: colors.review, size: 16.r),
              Gaps.hGap4,
              Text(
                'home_provider_tracking_provider_rating'.tr,
                style: TextStyles.bold16(color: colors.secondary),
              ),
            ],
          ),
          Gaps.vGap12,
          Divider(color: colors.onboardingBorderNeutral, height: 1.h),
          Gaps.vGap12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'home_provider_tracking_service'.tr,
                      style: TextStyles.medium12(color: colors.homeCaption),
                    ),
                    Gaps.vGap4,
                    Text(
                      'home_almost_done_service_title'.tr,
                      style: TextStyles.bold18(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'home_provider_tracking_price'.tr,
                    style: TextStyles.medium12(color: colors.homeCaption),
                  ),
                  Gaps.vGap4,
                  Text(
                    'home_provider_tracking_price_value'.tr,
                    style: TextStyles.bold22(color: colors.errorColor),
                  ),
                ],
              ),
            ],
          ),
          Gaps.vGap12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.location_on_rounded,
                      size: 18.r,
                      color: colors.homeCaption,
                    ),
                    Gaps.hGap6,
                    Expanded(
                      child: Text(
                        'home_provider_tracking_home_address'.tr,
                        style: TextStyles.medium14(
                          color: colors.lightTextColor,
                        ).copyWith(height: 1.h),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.hGap12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'home_provider_tracking_eta'.tr,
                    style: TextStyles.medium12(color: colors.homeCaption),
                  ),
                  Gaps.vGap4,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 14.r,
                        color: colors.errorColor,
                      ),
                      Gaps.hGap4,
                      Text(
                        'home_provider_tracking_eta_value'.tr,
                        style: TextStyles.bold22(color: colors.errorColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          Gaps.vGap10,
        ],
      ),
    );
  }
}
