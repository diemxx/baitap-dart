import 'package:latlong2/latlong.dart';

String coordinates(LatLng p) => '${p.latitude.toStringAsFixed(6)}, ${p.longitude.toStringAsFixed(6)}';
Map<String, double> pointJson(LatLng p) => {'lat': p.latitude, 'lng': p.longitude};

LatLng? parseCoordinates(String text) {
  final parts = text.trim().split(',');
  if (parts.length != 2) return null;
  final lat = double.tryParse(parts[0].trim());
  final lng = double.tryParse(parts[1].trim());
  if (lat == null || lng == null) return null;
  if (!lat.isFinite || !lng.isFinite || lat.abs() > 90 || lng.abs() > 180) {
    throw const FormatException('Vĩ độ phải từ -90 đến 90; kinh độ từ -180 đến 180.');
  }
  return LatLng(lat, lng);
}

// Google encoded polyline: each signed delta is represented by 5-bit groups.
List<LatLng> decodePolyline(String encoded) {
  var index = 0, lat = 0, lng = 0;
  int delta() {
    var result = 0, shift = 0;
    while (true) {
      if (index >= encoded.length || shift > 30) {
        throw const FormatException('Polyline không hợp lệ.');
      }
      final b = encoded.codeUnitAt(index++) - 63;
      if (b < 0 || b > 63) throw const FormatException('Polyline không hợp lệ.');
      result |= (b & 31) << shift;
      shift += 5;
      if (b < 32) break;
    }
    return result.isOdd ? ~(result >> 1) : result >> 1;
  }
  final points = <LatLng>[];
  while (index < encoded.length) {
    lat += delta();
    lng += delta();
    points.add(LatLng(lat / 1e5, lng / 1e5));
  }
  return points;
}

class RouteData {
  final String encoded, description, copyright;
  final double meters, seconds;
  final List<String> warnings;
  RouteData.fromJson(Map<String, dynamic> j)
      : encoded = j['polyline'] as String,
        description = j['description'] as String? ?? 'Tuyến đường',
        copyright = j['copyright'] as String? ?? '',
        meters = (j['meters'] as num).toDouble(),
        seconds = (j['seconds'] as num).toDouble(),
        warnings = (j['warnings'] as List? ?? []).map((e) => e.toString()).toList();
  List<LatLng> get points => decodePolyline(encoded);
  String get summary => '${(meters / 1000).toStringAsFixed(2)} km • ${(seconds / 60).ceil()} phút';
}

class Place {
  final String name, address;
  final LatLng position;
  final List<String> attributions;
  Place.fromJson(Map<String, dynamic> j)
      : name = j['name'] as String,
        address = j['address'] as String? ?? '',
        position = LatLng((j['lat'] as num).toDouble(), (j['lng'] as num).toDouble()),
        attributions = (j['attributions'] as List? ?? []).map((e) => e.toString()).toList();
}
