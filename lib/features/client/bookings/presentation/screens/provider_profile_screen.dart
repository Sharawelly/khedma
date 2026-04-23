import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/core/widgets/app_centered_header_bar.dart';
import '/core/widgets/gaps.dart';
import '/features/client/bookings/presentation/widgets/booking_service_card.dart';
import '/features/client/bookings/presentation/widgets/provider_profile_about_section.dart';
import '/features/client/bookings/presentation/widgets/provider_profile_bottom_actions.dart';
import '/features/client/bookings/presentation/widgets/provider_profile_certificate_card.dart';
import '/features/client/bookings/presentation/widgets/provider_profile_header_section.dart';
import '/features/client/bookings/presentation/widgets/provider_profile_portfolio_section.dart';
import '/features/client/bookings/presentation/widgets/provider_profile_reviews_section.dart';
import '/features/client/bookings/presentation/widgets/provider_profile_stats_row.dart';
import '/injection_container.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key, required this.booking});

  final BookingServiceItemData booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: Column(
        children: <Widget>[
          AppCenteredHeaderBar(
            title: 'provider_profile_title'.tr,
            onBack: context.pop,
            showBottomBorder: false,
            trailing: Icon(Icons.favorite_rounded, color: colors.errorColor),
            contentPadding: EdgeInsetsDirectional.only(
              start: 8.w,
              end: 18.w,
              top: MediaQuery.paddingOf(context).top + 8.h,
              bottom: 12.h,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                top: 0,
                bottom: 20.h,
              ),
              children: <Widget>[
                ProviderProfileHeaderSection(booking: booking),
                Gaps.vGap12,
                const ProviderProfileStatsRow(),
                Gaps.vGap18,
                const ProviderProfileAboutSection(),
                Gaps.vGap18,
                ProviderProfileServicesSection(
                  primaryServiceKey: booking.serviceTitleKey,
                ),
                Gaps.vGap18,
                const ProviderProfileWorkingAreasSection(),
                Gaps.vGap18,
                ProviderProfilePortfolioSection(
                  imageUrls: <String>[
                    booking.serviceImageUrl,
                    booking.locationImageUrl,
                    'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=500&q=80',
                    'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?auto=format&fit=crop&w=500&q=80',
                  ],
                ),
                Gaps.vGap18,
                const ProviderProfileCertificateCard(),
                Gaps.vGap18,
                const ProviderProfileReviewsSection(),
              ],
            ),
          ),
          const ProviderProfileBottomActions(),
        ],
      ),
    );
  }
}
