import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/client/customer/presentation/cubit/booking_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      create: (_) =>
          ServiceLocator.instance()..execute(BookingCommand.detail(bookingId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('bookings_details_title'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (_, state) {
            if (state is BookingFailure) {
              return CustomerErrorView(state.message);
            }
            if (state is! BookingDetailSuccess) {
              return const CustomerLoadingView();
            }
            return _BookingBody(
              booking: state.booking,
              realtimeSnapshot: state.realtime,
            );
          },
        ),
      ),
    );
  }
}

class _BookingBody extends StatelessWidget {
  const _BookingBody({required this.booking, required this.realtimeSnapshot});
  final BookingEntity booking;
  final BookingRealtimeSnapshot realtimeSnapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsetsDirectional.all(20.r),
      children: <Widget>[
        Text(
          booking.serviceName,
          style: TextStyles.bold28(color: colors.onboardingHeadline),
        ),
        SizedBox(height: 8.h),
        Text(
          realtimeSnapshot.statusChanged?.localizedLabel(isArabic) ??
              booking.localizedStatus(isArabic),
          style: TextStyles.bold18(color: colors.errorColor),
        ),
        SizedBox(height: 16.h),
        _line(
          'customer_provider'.tr,
          realtimeSnapshot.providerAssigned?.fullName ?? booking.providerName,
        ),
        _line(
          'customer_provider_phone'.tr,
          realtimeSnapshot.providerAssigned?.phoneNumber ??
              booking.providerPhone,
        ),
        _line('customer_address'.tr, booking.address),
        _line('customer_notes'.tr, booking.notes),
        _line('customer_total'.tr, booking.totalPrice.toStringAsFixed(2)),
        SizedBox(height: 20.h),
        Text(
          'customer_status_timeline'.tr,
          style: TextStyles.bold22(color: colors.onboardingHeadline),
        ),
        _time('customer_created'.tr, booking.createAt),
        _time('customer_accepted'.tr, booking.acceptedAt),
        _time('customer_en_route'.tr, booking.enRouteAt),
        _time('customer_arrived'.tr, booking.arrivedAt),
        _time('customer_started'.tr, booking.startedAt),
        _time('customer_completed'.tr, booking.completedAt),
        _time('customer_cancelled'.tr, booking.cancelledAt),
        SizedBox(height: 24.h),
        if (booking.status < 6)
          FilledButton(
            onPressed: () =>
                context.pushNamed(Routes.trackLiveRoute, extra: booking.id),
            child: Text('bookings_track_provider'.tr),
          ),
        if (booking.status < 6)
          TextButton(
            onPressed: () => _cancel(context),
            child: Text('customer_cancel_booking'.tr),
          ),
        if (booking.status == 6)
          FilledButton(
            onPressed: () => _review(context),
            child: Text('customer_leave_review'.tr),
          ),
      ],
    );
  }

  Widget _line(String label, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8.h),
      child: Text('$label: $value'),
    );
  }

  Widget _time(String label, DateTime? value) {
    if (value == null) {
      return const SizedBox.shrink();
    }
    return ListTile(
      contentPadding: EdgeInsetsDirectional.zero,
      leading: const Icon(Icons.check_circle_rounded),
      title: Text(label),
      subtitle: Text(value.toLocal().toString()),
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('customer_cancel_booking'.tr),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'customer_cancel_reason'.tr),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => dialogContext.pop(controller.text),
            child: Text('yes'.tr),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason != null && reason.trim().isNotEmpty && context.mounted) {
      await context.read<BookingCubit>().execute(
        BookingCommand.cancel(booking.id, reason.trim()),
      );
    }
  }

  Future<void> _review(BuildContext context) async {
    var rating = 5;
    final comment = TextEditingController();
    final submit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setState) => AlertDialog(
          title: Text('customer_leave_review'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButton<int>(
                value: rating,
                items: List<DropdownMenuItem<int>>.generate(
                  5,
                  (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('${index + 1} ★'),
                  ),
                ),
                onChanged: (value) => setState(() => rating = value ?? 5),
              ),
              TextField(
                controller: comment,
                decoration: InputDecoration(
                  hintText: 'customer_review_comment'.tr,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => dialogContext.pop(true),
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
    final value = comment.text.trim();
    comment.dispose();
    if (submit == true && context.mounted) {
      await context.read<BookingCubit>().execute(
        BookingCommand.review(
          ReviewParams(
            bookingId: booking.id,
            rating: rating,
            comment: value.isEmpty ? null : value,
          ),
        ),
      );
    }
  }
}
