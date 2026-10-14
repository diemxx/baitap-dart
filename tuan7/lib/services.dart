import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'models.dart';

/// OpenStreetMap services for classroom demos. Public endpoints are rate-limited,
/// have no uptime guarantee, and must not be used for high-volume production apps.
class MapsApi {
  static const _userAgent = 'Bai07FlutterClassroom/1.0 (educational demonstration)';
  DateTime? _lastSearch;
  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await http.get(uri, headers: {
      'User-Agent': _userAgent,
      'Accept': 'application/json',
      'Accept-Language': 'vi',
    }).timeout(const Duration(seconds: 25));
    if (response.statusCode != 200) {
      throw Exception('Máy chủ bản đồ trả HTTP ${response.statusCode}. Hãy thử lại sau.');
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic>) throw Exception('Dữ liệu định tuyến không hợp lệ.');
    return json;
  }

  Future<List<Place>> search(String query, {LatLng? center}) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    // Nominatim public usage policy: max 1 request/second, meaningful User-Agent.
    if (_lastSearch != null) {
      final elapsed = DateTime.now().difference(_lastSearch!);
      if (elapsed < const Duration(milliseconds: 1100)) {
        await Future.delayed(const Duration(milliseconds: 1100) - elapsed);
      }
    }
    _lastSearch = DateTime.now();
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': q, 'format': 'jsonv2', 'addressdetails': '1', 'limit': '8', 'accept-language': 'vi',
    });
    final response = await http.get(uri, headers: {'User-Agent': _userAgent, 'Accept': 'application/json'})
        .timeout(const Duration(seconds: 25));
    if (response.statusCode != 200) throw Exception('Tìm địa điểm HTTP ${response.statusCode}. Thử lại sau.');
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! List) throw Exception('Kết quả tìm kiếm không hợp lệ.');
    return data.map((e) => Place.fromJson({
      'name': (e['name'] as String?)?.isNotEmpty == true ? e['name'] : (e['display_name'] as String).split(',').first,
      'address': e['display_name'] ?? '',
      'lat': double.parse(e['lat'].toString()), 'lng': double.parse(e['lon'].toString()),
      'attributions': <String>[''],
    })).toList();
  }

  Future<LatLng> geocode(String address) async {
    final places = await search(address);
    if (places.isEmpty) throw Exception('Không tìm thấy tọa độ cho địa chỉ: $address');
    return places.first.position;
  }

  Future<List<RouteData>> route(LatLng start, LatLng end, String provider, {String mode = 'DRIVE'}) async {
    // The public OSRM profiles have distinct endpoints. TWO_WHEELER reuses car
    // routing: it is only an approximation, NOT motorcycle-specific instructions.
    final hostPath = mode == 'WALK' ? '/routed-foot/route/v1/driving/' :
        '/route/v1/driving/';
    final host = mode == 'WALK' ? 'routing.openstreetmap.de' : 'router.project-osrm.org';
    final coordinates = '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final uri = Uri.https(host, '$hostPath$coordinates', {
      'overview': 'full', 'geometries': 'polyline', 'alternatives': 'true', 'steps': 'false',
    });
    final result = await _getJson(uri);
    if (result['code'] != 'Ok') throw Exception('Không tìm thấy tuyến: ${result['message'] ?? result['code']}');
    final routes = result['routes'] as List? ?? [];
    return routes.map((r) => RouteData.fromJson({
      'polyline': r['geometry'], 'meters': r['distance'] ?? 0, 'seconds': r['duration'] ?? 0,
      'description': mode == 'WALK' ? 'Đi bộ' :
          mode == 'TWO_WHEELER' ? 'Xe máy (tham khảo tuyến ô tô)' : 'Ô tô (OSRM)',
      'warnings': <String>[
        if (mode == 'TWO_WHEELER') 'Tuyến xe máy chỉ tham khảo tuyến ô tô, chưa xét hạn chế xe máy.',

      ],

    })).toList();
  }
}
