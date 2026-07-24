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

/// Checkout.
///
/// The price is quoted, not booked. Creating the booking is what starts the
/// dispatch broadcast, so it must not happen until the customer actually
/// confirms - previously the figures on this screen came back from the creation
/// call itself, which meant providers were already being paged while the
/// customer was still reading the total, and backing out left a live booking
/// broadcasting with nobody watching it.
class AlmostDoneScreen extends StatefulWidget {
  const AlmostDoneScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<AlmostDoneScreen> createState() => _AlmostDoneScreenState();
}

class _AlmostDoneScreenState extends State<AlmostDoneScreen> {
  late final BookingCubit bookingCubit = ServiceLocator.instance();
  final notesController = TextEditingController();

  /// Held separately from the cubit state: confirming replaces the quote state
  /// with the creation result, and the breakdown must stay on screen while the
  /// request is in flight.
  PriceBreakdownEntity? price;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  void _loadQuote() =>
      bookingCubit.execute(BookingCommand.quote(widget.draft.serviceId));

  @override
  void dispose() {
    notesController.dispose();
    bookingCubit.close();
    super.dispose();
  }

  void _confirm() => bookingCubit.execute(
    BookingCommand.create(
      widget.draft.copyWith(notes: notesController.text.trim()),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>.value(
      value: bookingCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text('home_almost_done_title'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: BlocConsumer<BookingCubit, BookingState>(
          bloc: bookingCubit,
          listener: (context, state) {
            if (state is BookingQuoteSuccess) {
              setState(() => price = state.price);
            }
            // Only now does a booking exist and dispatch begin, so this is the
            // right moment to hand over to tracking.
            if (state is BookingCreated) {
              context.goNamed(
                Routes.providerTrackingRoute,
                extra: state.booking.bookingId,
              );
            }
          },
          builder: (context, state) {
            if (state is BookingFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomerErrorView(state.message),
                  TextButton(
                    onPressed: price == null ? _loadQuote : _confirm,
                    child: Text('retry'.tr),
                  ),
                ],
              );
            }
            if (price == null) {
              return const CustomerLoadingView();
            }
            return Padding(
              padding: EdgeInsetsDirectional.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'home_almost_done_add_notes'.tr,
                      hintText: 'home_almost_done_notes_hint'.tr,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'customer_price_breakdown'.tr,
                    style: TextStyles.bold24(color: colors.onboardingHeadline),
                  ),
                  ListTile(
                    title: Text('customer_service_fee'.tr),
                    trailing: Text('${price!.serviceFee} ${price!.currency}'),
                  ),
                  ListTile(
                    title: Text('customer_vat'.tr),
                    trailing: Text('${price!.vatAmount} ${price!.currency}'),
                  ),
                  ListTile(
                    title: Text('customer_total'.tr),
                    trailing: Text('${price!.total} ${price!.currency}'),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BookingCubit, BookingState>(
          bloc: bookingCubit,
          builder: (context, state) {
            if (price == null) {
              return const SizedBox.shrink();
            }
            final isBusy = state is BookingLoading || state is BookingCreated;
            return SafeArea(
              minimum: EdgeInsets.all(16.r),
              child: FilledButton(
                // Disabled while in flight so a second tap cannot create a
                // second booking and a second dispatch.
                onPressed: isBusy ? null : _confirm,
                child: isBusy
                    ? SizedBox.square(
                        dimension: 20.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('home_almost_done_confirm_pay'.tr),
              ),
            );
          },
        ),
      ),
    );
  }
}
