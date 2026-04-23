import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/features/client/bookings/presentation/widgets/booking_service_card.dart';
import '/injection_container.dart';

class ProviderProfileHeaderSection extends StatelessWidget {
  const ProviderProfileHeaderSection({super.key, required this.booking});

  final BookingServiceItemData booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 88.h,
            decoration: BoxDecoration(
              color: colors.errorColor.withValues(alpha: 0.08),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(18.r),
                topEnd: Radius.circular(18.r),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -26.h),
            child: ClipOval(
              child: AppImage.network(
                imageUrl: booking.providerImageUrl,
                width: 82.r,
                height: 82.r,
                fit: BoxFit.cover,
                isCircle: true,
                isCached: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: 14.w,
              end: 14.w,
              bottom: 14.h,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  booking.providerNameKey.tr,
                  style: TextStyles.bold24(color: colors.onboardingHeadline),
                  textAlign: TextAlign.center,
                ),
                Gaps.vGap4,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    const _ProfileTag(
                      labelKey: 'provider_profile_verified',
                      icon: Icons.verified_rounded,
                      iconColor: null,
                    ),
                    _ProfileTag(
                      labelKey: 'provider_profile_expert',
                      icon: Icons.build_circle_rounded,
                      iconColor: colors.errorColor,
                    ),
                    _ProfileTag(
                      labelKey: 'provider_profile_online_now',
                      icon: Icons.circle_rounded,
                      iconColor: colors.main,
                    ),
                  ],
                ),
                Gaps.vGap8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star_rounded, color: colors.review, size: 18.r),
                    Gaps.hGap4,
                    Text(
                      booking.providerRatingText,
                      style: TextStyles.bold16(color: colors.review),
                    ),
                    Gaps.hGap4,
                    Text(
                      'provider_profile_reviews_count'.tr,
                      style: TextStyles.medium14(color: colors.lightTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTag extends StatelessWidget {
  const _ProfileTag({
    required this.labelKey,
    required this.icon,
    required this.iconColor,
  });

  final String labelKey;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.upBackGround,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14.r, color: iconColor ?? colors.main),
          Gaps.hGap4,
          Text(
            labelKey.tr,
            style: TextStyles.medium11(color: colors.lightTextColor),
          ),
        ],
      ),
    );
  }
}
