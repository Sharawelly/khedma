import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '/config/locale/app_localizations.dart';
import '/config/routes/app_routes.dart';
import '/features/client/customer/domain/usecases/params/customer_params.dart';
import '/features/shared/location/presentation/screen/location_picker_screen.dart';
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

  /// Adds a location without leaving the booking flow. A customer with no saved
  /// address would otherwise have to abandon the booking, go to Profile, add one
  /// there, and start over.
  Future<void> _addAddress(BuildContext context) async {
    final cubit = context.read<ProfileManagementCubit>();
    final picked = await Navigator.of(context).push<PickedLocation>(
      MaterialPageRoute<PickedLocation>(
        builder: (_) => const LocationPickerScreen(),
      ),
    );
    if (picked == null) {
      return;
    }
    await cubit.execute(
      SavePickedAddress(
        label: 'location_picked_label'.tr,
        addressLine: picked.address,
        latitude: picked.latitude,
        longitude: picked.longitude,
      ),
    );
    if (!mounted) {
      return;
    }
    // Preselect what was just added so the CTA enables immediately instead of
    // making the user hunt for their new row and tap it.
    final state = cubit.state;
    if (state is! ProfileAddressesSuccess) {
      return;
    }
    final matches = state.addresses
        .where((address) => _samePoint(address, picked))
        .toList();
    if (matches.isNotEmpty) {
      setState(() => selected = matches.last);
    }
  }

  /// Coordinates survive a JSON round-trip as doubles, so compare with a
  /// tolerance rather than on equality.
  ///
  /// 0.0001 degrees is roughly 11 metres. Comfortably absorbs any rounding the
  /// server applies, while staying well under the distance between two
  /// addresses a user would bother saving separately - go much wider and this
  /// starts preselecting the neighbouring pin instead of the new one.
  bool _samePoint(SavedAddressEntity address, PickedLocation picked) {
    const tolerance = 0.0001;
    return (address.latitude - picked.latitude).abs() < tolerance &&
        (address.longitude - picked.longitude).abs() < tolerance;
  }

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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomerErrorView(state.message.tr),
                  TextButton(
                    onPressed: () => context
                        .read<ProfileManagementCubit>()
                        .execute(const LoadAddresses()),
                    child: Text('retry'.tr),
                  ),
                ],
              );
            }
            if (state is! ProfileAddressesSuccess) {
              return const CustomerLoadingView();
            }
            return RadioGroup<String>(
              groupValue: selected?.id,
              onChanged: (id) {
                if (id != null) {
                  setState(
                    () => selected = state.addresses.firstWhere(
                      (address) => address.id == id,
                    ),
                  );
                }
              },
              child: ListView(
                padding: EdgeInsetsDirectional.all(16.r),
                children: <Widget>[
                  if (state.addresses.isEmpty)
                    Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 12.h),
                      child: Text('location_none_yet'.tr),
                    ),
                  ...state.addresses.map(
                    (address) => RadioListTile<String>(
                      value: address.id,
                      title: Text(address.label),
                      subtitle: Text(address.addressLine),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => unawaited(_addAddress(context)),
                    icon: const Icon(Icons.add_location_alt_rounded),
                    label: Text('location_add_new'.tr),
                  ),
                ],
              ),
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
