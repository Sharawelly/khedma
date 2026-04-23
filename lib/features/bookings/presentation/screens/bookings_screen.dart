import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/routes/app_routes.dart';
import '/core/widgets/gaps.dart';
import '/core/utils/values/img_manager.dart';
import '/features/bookings/presentation/widgets/booking_service_card.dart';
import '/features/bookings/presentation/widgets/bookings_empty_state.dart';
import '/features/bookings/presentation/widgets/bookings_tab_selector.dart';
import '/injection_container.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  BookingsTab selectedTab = BookingsTab.all;

  @override
  Widget build(BuildContext context) {
    final List<BookingServiceItemData> allBookings = <BookingServiceItemData>[
      BookingServiceItemData(
        serviceTitleKey: 'bookings_service_plumbing_title',
        providerNameKey: 'bookings_provider_fixit',
        dateTimeKey: 'bookings_time_1',
        status: BookingStatus.active,
        iconData: Icons.plumbing_rounded,
        iconColor: colors.pathsInfoAccent,
        serviceCategoryKey: 'bookings_category_plumbing',
        serviceDescriptionKey: 'bookings_service_plumbing_description',
        timeRangeKey: 'bookings_time_range_1',
        locationAddressKey: 'bookings_location_address_1',
        providerRatingText: '4.9',
        paymentAmountKey: 'bookings_payment_amount_1',
        paymentStatusKey: 'bookings_payment_status_paid',
        paymentMethodKey: 'bookings_payment_method_1',
        serviceImageUrl: ImageAssets.bookingsServiceFaucet,
        locationImageUrl: ImageAssets.bookingsLocationMap,
        providerImageUrl: ImageAssets.bookingsProviderAvatar,
      ),
      BookingServiceItemData(
        serviceTitleKey: 'bookings_service_electrical_title',
        providerNameKey: 'bookings_provider_sparky',
        dateTimeKey: 'bookings_time_2',
        status: BookingStatus.completed,
        iconData: Icons.flash_on_rounded,
        iconColor: colors.secondary,
        serviceCategoryKey: 'bookings_category_electrical',
        serviceDescriptionKey: 'bookings_service_electrical_description',
        timeRangeKey: 'bookings_time_range_2',
        locationAddressKey: 'bookings_location_address_2',
        providerRatingText: '4.8',
        paymentAmountKey: 'bookings_payment_amount_2',
        paymentStatusKey: 'bookings_payment_status_paid',
        paymentMethodKey: 'bookings_payment_method_2',
        serviceImageUrl: ImageAssets.bookingsServiceFaucet,
        locationImageUrl: ImageAssets.bookingsLocationMap,
        providerImageUrl: ImageAssets.bookingsProviderAvatar,
      ),
      BookingServiceItemData(
        serviceTitleKey: 'bookings_service_house_cleaning_title',
        providerNameKey: 'bookings_provider_pristine',
        dateTimeKey: 'bookings_time_3',
        status: BookingStatus.pending,
        iconData: Icons.cleaning_services_rounded,
        iconColor: colors.review,
        serviceCategoryKey: 'bookings_category_cleaning',
        serviceDescriptionKey: 'bookings_service_cleaning_description',
        timeRangeKey: 'bookings_time_range_3',
        locationAddressKey: 'bookings_location_address_3',
        providerRatingText: '4.7',
        paymentAmountKey: 'bookings_payment_amount_3',
        paymentStatusKey: 'bookings_payment_status_pending',
        paymentMethodKey: 'bookings_payment_method_3',
        serviceImageUrl: ImageAssets.bookingsServiceFaucet,
        locationImageUrl: ImageAssets.bookingsLocationMap,
        providerImageUrl: ImageAssets.bookingsProviderAvatar,
      ),
      BookingServiceItemData(
        serviceTitleKey: 'bookings_service_wall_painting_title',
        providerNameKey: 'bookings_provider_palette',
        dateTimeKey: 'bookings_time_4',
        status: BookingStatus.cancelled,
        iconData: Icons.format_paint_rounded,
        iconColor: colors.homeCaption,
        serviceCategoryKey: 'bookings_category_painting',
        serviceDescriptionKey: 'bookings_service_painting_description',
        timeRangeKey: 'bookings_time_range_4',
        locationAddressKey: 'bookings_location_address_4',
        providerRatingText: '4.6',
        paymentAmountKey: 'bookings_payment_amount_4',
        paymentStatusKey: 'bookings_payment_status_refunded',
        paymentMethodKey: 'bookings_payment_method_4',
        serviceImageUrl: ImageAssets.bookingsServiceFaucet,
        locationImageUrl: ImageAssets.bookingsLocationMap,
        providerImageUrl: ImageAssets.bookingsProviderAvatar,
      ),
    ];

    final List<BookingServiceItemData> bookings = allBookings
        .where((BookingServiceItemData item) {
          if (selectedTab == BookingsTab.all) {
            return true;
          }
          if (selectedTab == BookingsTab.active) {
            return item.status == BookingStatus.active;
          }
          if (selectedTab == BookingsTab.completed) {
            return item.status == BookingStatus.completed;
          }
          return item.status == BookingStatus.cancelled;
        })
        .toList();

    final bool showCancelledEmptyState =
        selectedTab == BookingsTab.cancelled && bookings.isEmpty;

    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 14.w, end: 14.w, top: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookingsTabSelector(
              selectedTab: selectedTab,
              onTabSelected: (BookingsTab value) {
                setState(() {
                  selectedTab = value;
                });
              },
            ),
            Gaps.vGap8,
            Expanded(
              child: showCancelledEmptyState
                  ? const BookingsEmptyState()
                  : ListView.separated(
                      padding: EdgeInsetsDirectional.only(
                        top: 8.h,
                        bottom: 24.h,
                      ),
                      itemCount: bookings.length,
                      separatorBuilder: (_, _) => Gaps.vGap12,
                      itemBuilder: (BuildContext context, int index) {
                        final BookingServiceItemData booking = bookings[index];
                        return BookingServiceCard(
                          booking: booking,
                          onTap: () => context.push(
                            Routes.bookingDetailsRoute,
                            extra: booking,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
