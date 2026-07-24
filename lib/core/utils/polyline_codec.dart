import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Decodes Google's encoded polyline format into map points.
///
/// Implemented here rather than pulled in as a package: it is one well-specified
/// loop, and the alternative packages bundle a Directions client we deliberately
/// do not want in the app — the route is fetched server-side so the billable key
/// stays off the device.
///
/// Returns an empty list for malformed input rather than throwing: a bad route
/// string should degrade to a straight line, not take down the tracking screen.
List<LatLng> decodePolyline(String? encoded) {
  if (encoded == null || encoded.isEmpty) {
    return const <LatLng>[];
  }

  final points = <LatLng>[];
  var index = 0;
  var latitude = 0;
  var longitude = 0;

  while (index < encoded.length) {
    final latitudeDelta = _nextValue(encoded, index);
    if (latitudeDelta == null) {
      return const <LatLng>[];
    }
    index = latitudeDelta.nextIndex;
    latitude += latitudeDelta.value;

    final longitudeDelta = _nextValue(encoded, index);
    if (longitudeDelta == null) {
      return const <LatLng>[];
    }
    index = longitudeDelta.nextIndex;
    longitude += longitudeDelta.value;

    // The format stores fixed-point values at 1e5.
    points.add(LatLng(latitude / 1e5, longitude / 1e5));
  }

  return points;
}

class _Chunk {
  const _Chunk(this.value, this.nextIndex);
  final int value;
  final int nextIndex;
}

/// Reads one zig-zag encoded varint: 5 bits per character, low chunk first,
/// continuing while bit 0x20 is set.
_Chunk? _nextValue(String encoded, int start) {
  var index = start;
  var shift = 0;
  var result = 0;
  int chunk;

  do {
    if (index >= encoded.length || shift > 30) {
      return null;
    }
    chunk = encoded.codeUnitAt(index++) - 63;
    if (chunk < 0) {
      return null;
    }
    result |= (chunk & 0x1f) << shift;
    shift += 5;
  } while (chunk >= 0x20);

  // Odd values are negative, shifted left by one.
  final value = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
  return _Chunk(value, index);
}
