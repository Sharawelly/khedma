import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '/core/utils/polyline_codec.dart';
import '/features/client/customer/domain/entities/customer_entities.dart';
import '/injection_container.dart';

/// A journey drawn on a map: a pin at each end and the road route between them.
///
/// Shared by the provider's tracking screen and the customer's, so both sides of
/// a booking see the same geometry rather than two drifting implementations.
class RouteMap extends StatefulWidget {
  const RouteMap({
    super.key,
    required this.origin,
    required this.destination,
    required this.route,
    required this.originLabel,
    required this.destinationLabel,
  });

  /// Where the provider is. Null until the first position is known.
  final LatLng? origin;
  final LatLng destination;
  final BookingRouteEntity? route;
  final String originLabel;
  final String destinationLabel;

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool _framed = false;

  @override
  void didUpdateWidget(RouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-frame once the origin first becomes known; after that the camera is
    // left alone so it does not fight a user who has panned or zoomed.
    if (oldWidget.origin == null && widget.origin != null) {
      unawaited(_fit());
    }
  }

  Future<void> _fit() async {
    final controller = await _controller.future;
    final origin = widget.origin;
    if (origin == null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(widget.destination, 15),
      );
      return;
    }
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            origin.latitude < widget.destination.latitude
                ? origin.latitude
                : widget.destination.latitude,
            origin.longitude < widget.destination.longitude
                ? origin.longitude
                : widget.destination.longitude,
          ),
          northeast: LatLng(
            origin.latitude > widget.destination.latitude
                ? origin.latitude
                : widget.destination.latitude,
            origin.longitude > widget.destination.longitude
                ? origin.longitude
                : widget.destination.longitude,
          ),
        ),
        64,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final road = decodePolyline(widget.route?.encodedPolyline);
    // Without geometry from Directions, a dashed straight hop still shows the
    // relationship between the two points - better than an empty map, and the
    // dashes say it is not a real route.
    final line = road.isNotEmpty
        ? road
        : <LatLng>[?widget.origin, widget.destination];

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.origin ?? widget.destination,
        zoom: 14,
      ),
      onMapCreated: (created) {
        if (!_controller.isCompleted) {
          _controller.complete(created);
        }
        if (!_framed) {
          _framed = true;
          unawaited(_fit());
        }
      },
      zoomControlsEnabled: false,
      markers: <Marker>{
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destination,
          infoWindow: InfoWindow(title: widget.destinationLabel),
        ),
        if (widget.origin != null)
          Marker(
            markerId: const MarkerId('origin'),
            position: widget.origin!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: InfoWindow(title: widget.originLabel),
          ),
      },
      polylines: <Polyline>{
        if (line.length > 1)
          Polyline(
            polylineId: const PolylineId('route'),
            points: line,
            width: 5,
            color: colors.authBrandRed,
            patterns: road.isEmpty
                ? <PatternItem>[PatternItem.dash(20), PatternItem.gap(10)]
                : const <PatternItem>[],
          ),
      },
    );
  }
}
