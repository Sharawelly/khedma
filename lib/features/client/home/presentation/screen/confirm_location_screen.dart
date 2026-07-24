import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/shared/profile/domain/entities/saved_address_entity.dart';
import '/features/shared/profile/presentation/cubit/profile_management_cubit.dart';
import '/features/client/customer/presentation/widgets/customer_state_widgets.dart';
import '/injection_container.dart';

class ConfirmLocationScreen extends StatefulWidget {
  const ConfirmLocationScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<ConfirmLocationScreen> createState() => _ConfirmLocationScreenState();
}

class _ConfirmLocationScreenState extends State<ConfirmLocationScreen> {
  SavedAddressEntity? selected;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileManagementCubit>(
      create: (_) => ServiceLocator.instance()..execute(const LoadAddresses()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('home_confirm_location_header_title'.tr),
          leading: BackButton(onPressed: context.pop),
        ),
        body: BlocBuilder<ProfileManagementCubit, ProfileManagementState>(
          builder: (context, state) {
            if (state is ProfileManagementFailure) {
              return CustomerErrorView(state.message.tr);
            }
            if (state is! ProfileAddressesSuccess) {
              return const CustomerLoadingView();
            }
            return ListView(
              padding: EdgeInsetsDirectional.all(16.r),
              children: <Widget>[
                ...state.addresses.map(
                  (address) => RadioListTile<String>(
                    value: address.id,
                    groupValue: selected?.id,
                    title: Text(address.label),
                    subtitle: Text(address.addressLine),
                    onChanged: (_) => setState(() => selected = address),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => context
                      .read<ProfileManagementCubit>()
                      .execute(CaptureCurrentAddress('current_location'.tr)),
                  icon: const Icon(Icons.my_location_rounded),
                  label: Text('current_location'.tr),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.all(16.r),
          child: Builder(
            builder: (context) => FilledButton(
              onPressed: selected == null
                  ? null
                  : () => context.pushNamed(
                      Routes.chooseDateTimeRoute,
                      extra: widget.draft.copyWith(addressId: selected!.id),
                    ),
              child: Text('home_confirm_location_cta'.tr),
            ),
          ),
        ),
      ),
    );
  }
}
