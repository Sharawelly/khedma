import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class ProviderFoundProviderCard extends StatelessWidget {
  const ProviderFoundProviderCard({super.key});

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
          InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () => context.pushNamed(Routes.providerProfileRoute),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 2.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 58.r,
                    height: 58.r,
                    padding: EdgeInsetsDirectional.all(2.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.main, width: 2.w),
                    ),
                    child: ClipOval(
                      child: AppImage.network(
                        imageUrl:
                            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=240&q=80',
                        isCached: true,
                        isCircle: true,
                        fit: BoxFit.cover,
                        width: 54.r,
                        height: 54.r,
                      ),
                    ),
                  ),
                  Gaps.hGap12,
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
                        Gaps.vGap2,
                        Text(
                          'home_provider_found_provider_rating_reviews'.tr,
                          style: TextStyles.medium14(color: colors.lightTextColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'home_provider_found_verified'.tr,
                    style: TextStyles.bold14(color: colors.main),
                  ),
                ],
              ),
            ),
          ),
          Gaps.vGap12,
          Gaps.vGap2,
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.onboardingSurfaceMuted,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.plumbing_rounded,
                        size: 16.r,
                        color: colors.homeCaption,
                      ),
                      Gaps.hGap6,
                      Flexible(
                        child: Text(
                          'home_provider_found_plumbing_service'.tr,
                          style: TextStyles.medium14(
                            color: colors.onboardingHeadline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.hGap10,
              Expanded(
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 14.r,
                        color: colors.secondary,
                      ),
                      Gaps.hGap6,
                      Text(
                        'home_provider_found_eta_value'.tr,
                        style: TextStyles.bold14(color: colors.secondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gaps.vGap12,
          Gaps.vGap2,
          Container(
            height: 250.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.main.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.route_rounded,
                      size: 130.r,
                      color: colors.whiteColor.withValues(alpha: 0.75),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 14.w,
                  end: 14.w,
                  bottom: 14.h,
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'home_provider_found_heading_to'.tr,
                          style: TextStyles.medium12(color: colors.homeCaption),
                        ),
                        Text(
                          'home_provider_found_heading_address'.tr,
                          style: TextStyles.bold18(
                            color: colors.onboardingHeadline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
