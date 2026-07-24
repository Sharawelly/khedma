import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

/// Shows where the provider is currently available from, and lets them move it.
///
/// The server stores only coordinates for a provider, so the readable address is
/// resolved here for display. It is presentation only - the coordinates remain
/// the source of truth for dispatch.
class ProviderWorkingLocationCard extends StatefulWidget {
  const ProviderWorkingLocationCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onChange,
  });

  final double? latitude;
  final double? longitude;
  final VoidCallback onChange;

  @override
  State<ProviderWorkingLocationCard> createState() =>
      _ProviderWorkingLocationCardState();
}

class _ProviderWorkingLocationCardState
    extends State<ProviderWorkingLocationCard> {
  String? _address;
  bool _resolving = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(ProviderWorkingLocationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _resolve();
    }
  }

  Future<void> _resolve() async {
    final latitude = widget.latitude;
    final longitude = widget.longitude;
    if (latitude == null || longitude == null) {
      setState(() {
        _address = null;
        _resolving = false;
      });
      return;
    }
    setState(() => _resolving = true);
    String? line;
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        line = <String?>[
          place.street,
          place.subLocality,
          place.locality,
        ].where((part) => part != null && part.isNotEmpty).join(', ');
      }
    } on Exception {
      // No readable name is not an error - the coordinates below still show.
      line = null;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _address = line == null || line.isEmpty ? null : line;
      _resolving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final latitude = widget.latitude;
    final longitude = widget.longitude;
    final hasLocation = latitude != null && longitude != null;
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(14.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.onboardingBorderNeutral),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.location_on_rounded,
            size: 22.r,
            color: hasLocation ? colors.authBrandRed : colors.onboardingCaption,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'provider_working_location'.tr,
                  style: TextStyles.regular13(color: colors.onboardingCaption),
                ),
                SizedBox(height: 2.h),
                Text(
                  _label(hasLocation, latitude, longitude),
                  style: TextStyles.bold16(color: colors.onboardingHeadline),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: widget.onChange,
            child: Text(
              hasLocation
                  ? 'provider_change_location'.tr
                  : 'provider_set_location'.tr,
            ),
          ),
        ],
      ),
    );
  }

  String _label(bool hasLocation, double? latitude, double? longitude) {
    if (!hasLocation) {
      return 'provider_no_working_location'.tr;
    }
    if (_resolving) {
      return 'location_picker_resolving'.tr;
    }
    return _address ??
        '${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}';
  }
}
