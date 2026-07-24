import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/core/utils/values/text_styles.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/client/customer/presentation/cubit/booking_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class AlmostDoneScreen extends StatefulWidget {
  const AlmostDoneScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<AlmostDoneScreen> createState() => _AlmostDoneScreenState();
}

class _AlmostDoneScreenState extends State<AlmostDoneScreen> {
  final notesController = TextEditingController();

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      create: (_) => ServiceLocator.instance(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('home_almost_done_title'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingFailure) {
              return CustomerErrorView(state.message);
            }
            if (state is BookingLoading) {
              return const CustomerLoadingView();
            }
            if (state is BookingCreated) {
              final price = state.booking.priceBreakdown;
              return Padding(
                padding: EdgeInsetsDirectional.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'customer_price_breakdown'.tr,
                      style: TextStyles.bold24(
                        color: colors.onboardingHeadline,
                      ),
                    ),
                    ListTile(
                      title: Text('customer_service_fee'.tr),
                      trailing: Text('${price.serviceFee} ${price.currency}'),
                    ),
                    ListTile(
                      title: Text('customer_vat'.tr),
                      trailing: Text('${price.vatAmount} ${price.currency}'),
                    ),
                    ListTile(
                      title: Text('customer_total'.tr),
                      trailing: Text('${price.total} ${price.currency}'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => context.goNamed(
                        Routes.providerTrackingRoute,
                        extra: state.booking.bookingId,
                      ),
                      child: Text('customer_continue'.tr),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsetsDirectional.all(20.r),
              child: TextField(
                controller: notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'home_almost_done_add_notes'.tr,
                  hintText: 'home_almost_done_notes_hint'.tr,
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingCreated || state is BookingLoading) {
              return const SizedBox.shrink();
            }
            return SafeArea(
              minimum: EdgeInsets.all(16.r),
              child: FilledButton(
                onPressed: () => context.read<BookingCubit>().execute(
                  BookingCommand.create(
                    widget.draft.copyWith(notes: notesController.text.trim()),
                  ),
                ),
                child: Text('home_almost_done_confirm_pay'.tr),
              ),
            );
          },
        ),
      ),
    );
  }
}
