import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/routes/app_routes.dart';
import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/app_image.dart';
import '/core/widgets/gaps.dart';
import '/core/widgets/my_default_button.dart';
import '/features/bookings/presentation/widgets/booking_service_card.dart';
import '/injection_container.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.booking});

  final BookingServiceItemData booking;

  @override
  Widget build(BuildContext context) {
    final bool isActiveBooking = booking.status == BookingStatus.active;
    return Scaffold(
      backgroundColor: colors.backGround,
      body: Column(
        children: <Widget>[
          AppCenteredHeaderBar(
            title: 'bookings_details_title'.tr,
            onBack: context.pop,
            contentPadding: EdgeInsetsDirectional.only(
              start: 8.w,
              end: 8.w,
              top: MediaQuery.paddingOf(context).top + 8.h,
              bottom: 14.h,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                top: 0,
                bottom: isActiveBooking ? 24.h : 34.h,
              ),
              children: <Widget>[
                if (isActiveBooking) ...<Widget>[
                  Container(
                    margin: EdgeInsetsDirectional.only(bottom: 14.h),
                    padding: EdgeInsetsDirectional.symmetric(vertical: 12.h),
                    alignment: AlignmentDirectional.center,
                    color: colors.errorColor.withValues(alpha: 0.08),
                    child: Text(
                      'bookings_active_booking'.tr,
                      style: TextStyles.bold14(color: colors.errorColor),
                    ),
                  ),
                ] else ...<Widget>[Gaps.vGap16],
                _BookingServiceOverviewCard(booking: booking),
                Gaps.vGap16,
                _BookingDateCard(booking: booking),
                Gaps.vGap16,
                _BookingLocationCard(booking: booking),
                Gaps.vGap16,
                _BookingProviderCard(
                  booking: booking,
                  onViewProfile: () => context.push(
                    Routes.providerProfileRoute,
                    extra: booking,
                  ),
                ),
                Gaps.vGap16,
                _BookingPaymentCard(booking: booking),
              ],
            ),
          ),
          if (isActiveBooking)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                bottom: 22.h,
              ),
              child: SizedBox(
                height: 50.h,
                child: MyDefaultButton(
                  btnText: 'bookings_track_provider',
                  onPressed: () {},
                  color: colors.errorColor,
                  borderColor: colors.errorColor,
                  borderRadius: 18,
                  height: 50.h,
                  textStyle: TextStyles.bold22(color: colors.whiteColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BookingServiceOverviewCard extends StatelessWidget {
  const _BookingServiceOverviewCard({required this.booking});

  final BookingServiceItemData booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(12.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: AppImage.network(
              imageUrl: booking.serviceImageUrl,
              width: 84.r,
              height: 84.r,
              fit: BoxFit.cover,
              isCached: true,
            ),
          ),
          Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.errorColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    booking.serviceCategoryKey.tr,
                    style: TextStyles.bold10(color: colors.errorColor),
                  ),
                ),
                Gaps.vGap8,
                Text(
                  booking.serviceTitleKey.tr,
                  style: TextStyles.bold20(color: colors.onboardingHeadline),
                ),
                Gaps.vGap4,
                Text(
                  booking.serviceDescriptionKey.tr,
                  style: TextStyles.regular14(color: colors.lightTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingDateCard extends StatelessWidget {
  const _BookingDateCard({required this.booking});

  final BookingServiceItemData booking;

  @override
  Widget build(BuildContext context) {
    return _BookingDetailCardShell(
      child: Row(
        children: <Widget>[
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: colors.errorColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              size: 20.r,
              color: colors.errorColor,
            ),
          ),
          Gaps.hGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  booking.dateTimeKey.tr,
                  style: TextStyles.bold18(color: colors.onboardingHeadline),
                ),
                Gaps.vGap2,
                Text(
                  booking.timeRangeKey.tr,
                  style: TextStyles.regular14(color: colors.lightTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingLocationCard extends StatelessWidget {
  const _BookingLocationCard({required this.booking});

  final BookingServiceItemData booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(14.r),
              topEnd: Radius.circular(14.r),
            ),
            child: AppImage.network(
              imageUrl: booking.locationImageUrl,
              width: double.infinity,
              height: 158.h,
              fit: BoxFit.cover,
              isCached: true,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'bookings_service_location'.tr,
                  style: TextStyles.bold20(color: colors.onboardingHeadline),
                ),
                Gaps.vGap4,
                Text(
                  booking.locationAddressKey.tr,
                  style: TextStyles.regular17(color: colors.textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingProviderCard extends StatelessWidget {
  const _BookingProviderCard({
    required this.booking,
    required this.onViewProfile,
  });

  final BookingServiceItemData booking;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    return _BookingDetailCardShell(
      child: Row(
        children: <Widget>[
          ClipOval(
            child: AppImage.network(
              imageUrl: booking.providerImageUrl,
              width: 44.r,
              height: 44.r,
              fit: BoxFit.cover,
              isCached: true,
              isCircle: true,
            ),
          ),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  booking.providerNameKey.tr,
                  style: TextStyles.bold20(color: colors.onboardingHeadline),
                ),
                Gaps.vGap2,
                Row(
                  children: <Widget>[
                    Icon(Icons.star_rounded, size: 14.r, color: colors.review),
                    Gaps.hGap4,
                    Text(
                      booking.providerRatingText,
                      style: TextStyles.semiBold16(
                        color: colors.lightTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onViewProfile,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 4.w,
                vertical: 4.h,
              ),
              child: Text(
                'bookings_view_profile'.tr,
                style: TextStyles.bold18(color: colors.errorColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingPaymentCard extends StatelessWidget {
  const _BookingPaymentCard({required this.booking});

  final BookingServiceItemData booking;

  @override
  Widget build(BuildContext context) {
    return _BookingDetailCardShell(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      booking.paymentAmountKey.tr,
                      style: TextStyles.bold24(color: colors.errorColor),
                    ),
                    Gaps.hGap8,
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.mainAlpha20,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        booking.paymentStatusKey.tr,
                        style: TextStyles.bold11(color: colors.main),
                      ),
                    ),
                  ],
                ),
                Gaps.vGap4,
                Text(
                  booking.paymentMethodKey.tr,
                  style: TextStyles.regular16(color: colors.lightTextColor),
                ),
              ],
            ),
          ),
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 26.r,
            color: colors.homeCaption,
          ),
        ],
      ),
    );
  }
}

class _BookingDetailCardShell extends StatelessWidget {
  const _BookingDetailCardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 14.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: child,
    );
  }
}
