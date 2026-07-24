import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/config/locale/app_localizations.dart';
import '/core/utils/values/text_styles.dart';
import '/injection_container.dart';

/// What the picker hands back once the user confirms.
class PickedLocation {
  const PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

/// Map screen for choosing a point, shared by the customer address book and the
/// provider going online.
///
/// The pin is a fixed overlay at the centre of the viewport rather than a
/// draggable [Marker]: the user pans the map under a stationary pin. That avoids
/// the marker-drag gesture fighting the map pan, and means the selected point is
/// always exactly the camera target, so the two can never disagree.
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key, this.initial, this.title});

  /// Where to open. When null the picker asks the device for a fix.
  final LatLng? initial;
  final String? title;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  /// Downtown Cairo. Only used when there is no initial point and the device
  /// will not give a fix - an arbitrary but recognisable place to pan from beats
  /// dropping the user in the middle of the ocean at 0,0.
  static const LatLng _fallback = LatLng(30.0444, 31.2357);
  static const double _zoom = 16;

  GoogleMapController? _controller;
  LatLng? _target;
  String _address = '';
  bool _resolving = false;
  bool _locating = true;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final initial = widget.initial ?? await _devicePosition() ?? _fallback;
    if (!mounted) {
      return;
    }
    setState(() {
      _target = initial;
      _locating = false;
    });
    await _resolveAddress(initial);
  }

  /// Null rather than throwing when location is unavailable: an unusable fix is
  /// not an error here, it just means the user pans to their spot manually.
  Future<LatLng?> _devicePosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return null;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } on Exception {
      return null;
    }
  }

  Future<void> _resolveAddress(LatLng point) async {
    setState(() => _resolving = true);
    var line = '';
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      line = _line(placemarks);
    } on Exception {
      // Geocoding is a convenience - a point with no readable label is still a
      // perfectly valid point to book against.
      line = '';
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _address = line;
      _resolving = false;
    });
  }

  String _line(List<Placemark> placemarks) {
    if (placemarks.isEmpty) {
      return '';
    }
    final place = placemarks.first;
    return <String?>[
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
    ].where((part) => part != null && part.isNotEmpty).join(', ');
  }

  Future<void> _goToDevice() async {
    setState(() => _locating = true);
    final position = await _devicePosition();
    if (!mounted) {
      return;
    }
    setState(() => _locating = false);
    if (position == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('location_permission_denied'.tr)));
      return;
    }
    await _controller?.animateCamera(
      CameraUpdate.newLatLngZoom(position, _zoom),
    );
  }

  void _confirm() {
    final target = _target;
    if (target == null) {
      return;
    }
    context.pop(
      PickedLocation(
        latitude: target.latitude,
        longitude: target.longitude,
        address: _address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final target = _target;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'location_picker_title'.tr),
        leading: BackButton(onPressed: context.pop),
      ),
      body: target == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: target,
                    zoom: _zoom,
                  ),
                  onMapCreated: (controller) => _controller = controller,
                  // Cheaper than onCameraMove: fires once when the gesture
                  // settles, so geocoding runs per stop instead of per frame.
                  onCameraMove: (position) => _target = position.target,
                  onCameraIdle: () {
                    final moved = _target;
                    if (moved != null) {
                      unawaited(_resolveAddress(moved));
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                // Sits half its own height above centre so the pin's tip, not
                // its middle, marks the camera target.
                IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 40.h),
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 44.r,
                        color: colors.errorColor,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  end: 16.w,
                  bottom: 170.h,
                  child: FloatingActionButton.small(
                    onPressed: _locating ? null : _goToDevice,
                    child: _locating
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.my_location_rounded),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: _Sheet(
                    address: _address,
                    resolving: _resolving,
                    onConfirm: _confirm,
                  ),
                ),
              ],
            ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.address,
    required this.resolving,
    required this.onConfirm,
  });

  final String address;
  final bool resolving;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16.r),
      decoration: BoxDecoration(
        color: colors.whiteColor,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(20.r),
          topEnd: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'location_picker_selected'.tr,
              style: TextStyles.bold16(color: colors.onboardingHeadline),
            ),
            SizedBox(height: 6.h),
            Text(
              resolving
                  ? 'location_picker_resolving'.tr
                  : address.isEmpty
                  ? 'location_picker_unnamed'.tr
                  : address,
              style: TextStyles.regular14(color: colors.onboardingHeadline),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: resolving ? null : onConfirm,
                child: Text('location_picker_confirm'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
