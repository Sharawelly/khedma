import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/bookings/presentation/widgets/bookings_tab_selector.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/client/customer/presentation/cubit/booking_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  BookingsTab selectedTab = BookingsTab.all;
  late final BookingCubit bookingCubit = ServiceLocator.instance()
    ..execute(const BookingCommand.history());

  @override
  void dispose() {
    bookingCubit.close();
    super.dispose();
  }

  int? get status {
    switch (selectedTab) {
      case BookingsTab.completed:
        return 6;
      case BookingsTab.cancelled:
        return 7;
      case BookingsTab.all:
      case BookingsTab.active:
        return null;
    }
  }

  void _load() {
    bookingCubit.execute(
      BookingCommand.history(BookingHistoryQuery(status: status)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>.value(
      value: bookingCubit,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(14.r),
          child: Column(
            children: <Widget>[
              BookingsTabSelector(
                selectedTab: selectedTab,
                onTabSelected: (value) {
                  setState(() => selectedTab = value);
                  _load();
                },
              ),
              Expanded(
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (_, state) {
                    if (state is BookingFailure) {
                      return CustomerErrorView(state.message);
                    }
                    if (state is! BookingHistorySuccess) {
                      return const CustomerLoadingView();
                    }
                    final items = selectedTab == BookingsTab.active
                        ? state.bookings
                              .where((booking) => booking.status < 6)
                              .toList()
                        : state.bookings;
                    if (items.isEmpty) {
                      return Center(child: Text('customer_no_bookings'.tr));
                    }
                    return ListView.separated(
                      padding: EdgeInsetsDirectional.only(top: 12.h),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (_, index) =>
                          _BookingTile(booking: items[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.booking});
  final BookingHistoryEntity booking;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () =>
            context.pushNamed(Routes.bookingDetailsRoute, extra: booking.id),
        title: Text(
          booking.serviceName,
          style: TextStyles.bold18(color: colors.onboardingHeadline),
        ),
        subtitle: Text(
          booking.providerName ?? 'customer_waiting_for_provider'.tr,
        ),
        trailing: Text('${booking.totalPrice}'),
      ),
    );
  }
}
