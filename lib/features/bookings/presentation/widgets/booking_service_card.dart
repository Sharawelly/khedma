import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/gaps.dart';
import '/injection_container.dart';

class BookingServiceCard extends StatelessWidget {
  const BookingServiceCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  final BookingServiceItemData booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool showActions = booking.status == BookingStatus.completed;
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsetsDirectional.only(
          start: 12.w,
          end: 12.w,
          top: 12.h,
          bottom: showActions ? 12.h : 14.h,
        ),
        decoration: BoxDecoration(
          color: colors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.onboardingBorderNeutral),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: colors.upBackGround,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    booking.iconData,
                    size: 20.r,
                    color: booking.iconColor,
                  ),
                ),
                Gaps.hGap12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        booking.serviceTitleKey.tr,
                        style: TextStyles.bold16(
                          color: colors.onboardingHeadline,
                        ),
                      ),
                      Gaps.vGap2,
                      Text(
                        booking.providerNameKey.tr,
                        style: TextStyles.medium14(color: colors.lightTextColor),
                      ),
                      Gaps.vGap2,
                      Text(
                        booking.dateTimeKey.tr,
                        style: TextStyles.regular12(color: colors.homeCaption),
                      ),
                    ],
                  ),
                ),
                Gaps.hGap8,
                _BookingStatusChip(status: booking.status),
              ],
            ),
            if (showActions) ...<Widget>[
              Gaps.vGap12,
              Row(
                children: <Widget>[
                  Expanded(
                    child: _BookingActionButton(
                      titleKey: 'bookings_action_rate',
                      iconData: Icons.star_rounded,
                      foregroundColor: colors.errorColor,
                      backgroundColor: colors.errorColor.withValues(alpha: 0.1),
                    ),
                  ),
                  Gaps.hGap8,
                  Expanded(
                    child: _BookingActionButton(
                      titleKey: 'bookings_action_rebook',
                      iconData: Icons.refresh_rounded,
                      foregroundColor: colors.lightTextColor,
                      backgroundColor: colors.backGround,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BookingActionButton extends StatelessWidget {
  const _BookingActionButton({
    required this.titleKey,
    required this.iconData,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final String titleKey;
  final IconData iconData;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(iconData, size: 16.r, color: foregroundColor),
          Gaps.hGap6,
          Text(
            titleKey.tr,
            style: TextStyles.semiBold12(color: foregroundColor),
          ),
        ],
      ),
    );
  }
}

class _BookingStatusChip extends StatelessWidget {
  const _BookingStatusChip({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final ({Color backgroundColor, Color textColor, String labelKey}) style =
        status.style;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        style.labelKey.tr,
        style: TextStyles.bold11(color: style.textColor),
      ),
    );
  }
}

class BookingServiceItemData {
  const BookingServiceItemData({
    required this.serviceTitleKey,
    required this.providerNameKey,
    required this.dateTimeKey,
    required this.status,
    required this.iconData,
    required this.iconColor,
    required this.serviceCategoryKey,
    required this.serviceDescriptionKey,
    required this.timeRangeKey,
    required this.locationAddressKey,
    required this.providerRatingText,
    required this.paymentAmountKey,
    required this.paymentStatusKey,
    required this.paymentMethodKey,
    required this.serviceImageUrl,
    required this.locationImageUrl,
    required this.providerImageUrl,
  });

  final String serviceTitleKey;
  final String providerNameKey;
  final String dateTimeKey;
  final BookingStatus status;
  final IconData iconData;
  final Color iconColor;
  final String serviceCategoryKey;
  final String serviceDescriptionKey;
  final String timeRangeKey;
  final String locationAddressKey;
  final String providerRatingText;
  final String paymentAmountKey;
  final String paymentStatusKey;
  final String paymentMethodKey;
  final String serviceImageUrl;
  final String locationImageUrl;
  final String providerImageUrl;
}

enum BookingStatus {
  active,
  completed,
  pending,
  cancelled;

  ({Color backgroundColor, Color textColor, String labelKey}) get style {
    switch (this) {
      case BookingStatus.active:
        return (
          backgroundColor: colors.pathsInfoSurface.withValues(alpha: 0.55),
          textColor: colors.pathsInfoAccent,
          labelKey: 'bookings_status_active',
        );
      case BookingStatus.completed:
        return (
          backgroundColor: colors.mainAlpha20,
          textColor: colors.main,
          labelKey: 'bookings_status_completed',
        );
      case BookingStatus.pending:
        return (
          backgroundColor: colors.secondary.withValues(alpha: 0.2),
          textColor: colors.secondary,
          labelKey: 'bookings_status_pending',
        );
      case BookingStatus.cancelled:
        return (
          backgroundColor: colors.onboardingBorderNeutral,
          textColor: colors.lightTextColor,
          labelKey: 'bookings_status_cancelled',
        );
    }
  }
}
