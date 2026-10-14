import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'models.dart';
import 'services.dart';
import 'favorites_db.dart';

void main() => runApp(const MapsApp());
class MapsApp extends StatelessWidget {
  const MapsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Tuần 7',
    theme: ThemeData(colorSchemeSeed: const Color(0xFF176B58), useMaterial3: true),
    home: const HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tuần 7')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Thực hành bản đồ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
      const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Chọn phần bài tập để bắt đầu.')),
      for (final item in const [
        (1, 'Bài 1 · Vị trí hiện tại', 'Bản đồ, cấp quyền GPS và đánh dấu vị trí.', Icons.my_location),
        (2, 'Bài 2 · Tìm đường', 'Nhập hai tọa độ, đánh dấu và vẽ tuyến đường.', Icons.route),
        (3, 'Bài 3 · Mở rộng', 'Chọn điểm trên bản đồ, GPS làm đích, tìm địa điểm.', Icons.place),
        (4, 'Bài 4 · Trên lớp', 'GPS làm đích, khoảng cách, thời gian, tìm địa điểm.', Icons.school),
        (5, 'Bài tập về nhà', 'Địa chỉ, phương tiện, tuyến tối ưu, SQLite yêu thích.', Icons.home_work),
      ]) Card(child: ListTile(contentPadding: const EdgeInsets.all(16), leading: Icon(item.$4),
        title: Text(item.$2), subtitle: Text(item.$3), trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen(level: item.$1))))),
      const Padding(padding: EdgeInsets.only(top: 20), child: Text('Lưu ý đề: phần trên lớp ghi “Bài 4 bổ sung Bài 3”, nhưng không có bài 3 riêng. Trong ứng dụng, phần này được đặt tên Bài 3 theo yêu cầu của bạn.')),
    ]));
}

class MapScreen extends StatefulWidget {
  final int level;
  const MapScreen({super.key, required this.level});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _startText = TextEditingController();
  final _endText = TextEditingController();
  final _query = TextEditingController();
  final _api = MapsApi();
  final MapController _map = MapController();
  bool _mapReady = false;
  LatLng? _gps, _start, _end;
  LatLng _center = const LatLng(10.7769, 106.7009);
  List<RouteData> _routes = [];
  List<Place> _places = [];
  int _selectedRoute = 0;
  String _provider = 'osrm';
  String _mode = 'DRIVE';
  bool _busy = false, _permission = false, _pickStart = false, _expanded = true;
  String? _message;
  RouteData? get _route => _routes.isEmpty ? null : _routes[_selectedRoute];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _locate(true); });
  }
  @override
  void dispose() {
    _startText.dispose(); _endText.dispose(); _query.dispose(); _map.dispose();
    super.dispose();
  }

  Future<void> _work(Future<void> Function() fn) async {
    if (_busy) return;
    setState(() { _busy = true; _message = null; });
    try { await fn(); }
    on TimeoutException { if (mounted) setState(() => _message = 'Hết thời gian chờ. Kiểm tra GPS và Internet.'); }
    catch (e) { if (mounted) setState(() => _message = e.toString().replaceFirst('Exception: ', '').replaceFirst('FormatException: ', '')); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  void _clearRoute() { _routes = []; _selectedRoute = 0; }
  void _assign(LatLng p, bool start, {String? label}) {
    setState(() {
      if (start) { _start = p; _startText.text = label ?? coordinates(p); }
      else { _end = p; _endText.text = label ?? coordinates(p); }
      _clearRoute();
    });
  }
  Future<void> _locate(bool asStart) => _work(() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('GPS đang tắt. Bật Vị trí trên điện thoại rồi bấm lại.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Quyền vị trí bị chặn. Bấm biểu tượng cài đặt để cấp lại quyền.');
    }
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      throw Exception('Chưa được cấp quyền vị trí. Bạn vẫn có thể nhập tọa độ.');
    }
    final p = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 20)));
    if (!mounted) return;
    final point = LatLng(p.latitude, p.longitude);
    setState(() { _gps = point; _permission = true; });
    _assign(point, asStart);
    if (_mapReady) _map.move(point, 15);
  });

  Future<LatLng> _resolve(TextEditingController text, LatLng? selected) async {
    if (selected != null) return selected;
    final input = text.text.trim();
    if (input.isEmpty) throw Exception('Nhập đủ điểm xuất phát và điểm đến.');
    final parsed = parseCoordinates(input);
    if (parsed != null) return parsed;
    if (widget.level >= 5) return _api.geocode(input);
    throw Exception('Nhập đúng dạng vĩ độ, kinh độ. Ví dụ: 10.7769, 106.7009');
  }
  Future<Place?> _choosePlace(List<Place> places, String title) => showModalBottomSheet<Place>(
    context: context, isScrollControlled: true,
    builder: (ctx) => SafeArea(child: SizedBox(height: MediaQuery.sizeOf(ctx).height * .65,
      child: Column(children: [Padding(padding: const EdgeInsets.all(16), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
        Expanded(child: ListView(children: [for (final p in places) ListTile(
          leading: const Icon(Icons.place), title: Text(p.name), subtitle: Text([p.address, ...p.attributions].join('\n')),
          onTap: () => Navigator.pop(ctx, p))])),
        const Padding(padding: EdgeInsets.all(8), child: Text('Kết quả từ OpenStreetMap')),
      ]))));

  void _sortRoutes() {
    _routes.sort((a, b) => a.seconds.compareTo(b.seconds));
    _selectedRoute = 0;
  }
  Future<void> _find() => _work(() async {
    FocusScope.of(context).unfocus();
    final start = await _resolve(_startText, _start);
    final end = await _resolve(_endText, _end);
    if (!mounted) return;
    if (Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude) < 1) {
      throw Exception('Hai điểm đang trùng nhau. Chọn điểm đến khác.');
    }
    setState(() { _start = start; _end = end; _clearRoute(); });
    final routes = await _api.route(start, end, _provider, mode: widget.level >= 5 ? _mode : 'DRIVE');
    if (!mounted) return;
    if (routes.isEmpty) throw Exception('Không có tuyến phù hợp với phương tiện này tại khu vực đã chọn.');
    // Validate encoded geometry before displaying.
    for (final r in routes) { if (r.points.isEmpty) throw Exception('Tuyến trả về không có hình học.'); }
    setState(() { _routes = routes; _sortRoutes(); _expanded = false; });
    await _fitRoute();
  });
  Future<void> _fitRoute() async {
    final points = _route?.points;
    if (points == null || points.isEmpty || !_mapReady) return;
    if (points.length == 1) { _map.move(points.first, 14); return; }
    _map.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(points), padding: const EdgeInsets.all(40)));
  }

  Future<void> _search() => _work(() async {
    FocusScope.of(context).unfocus();
    if (_query.text.trim().isEmpty) throw Exception('Nhập địa điểm cần tìm.');
    final places = await _api.search(_query.text.trim(), center: _center);
    if (!mounted) return;
    setState(() => _places = places);
    if (places.isEmpty) throw Exception('Không tìm thấy địa điểm phù hợp.');
    final selected = await _choosePlace(places, 'Chọn địa điểm làm ${_pickStart ? 'xuất phát' : 'đích đến'}');
    if (!mounted || selected == null) return;
    _assign(selected.position, _pickStart, label: selected.name);
    if (_mapReady) _map.move(selected.position, 15);
  });

  Future<void> _saveFavorite() async {
    if (_route == null || _start == null || _end == null) return;
    try {
      await FavoritesDb.insert(
        startLabel: _startText.text.trim(), endLabel: _endText.text.trim(),
        start: _start!, end: _end!, mode: _mode, route: _route!,
      );
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu tuyến đường yêu thích bằng SQLite')));
    } catch (e) {
      if (mounted) setState(() => _message = 'Lưu SQLite thất bại: $e');
    }
  }

  Future<void> _showFavorites() async {
    try {
      final data = await FavoritesDb.all();
      if (!mounted) return;
      await showModalBottomSheet<void>(context: context, isScrollControlled: true, builder: (ctx) => SafeArea(
        child: SizedBox(height: MediaQuery.sizeOf(ctx).height * .65,
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('Tuyến đường đã lưu (SQLite)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Expanded(child: data.isEmpty ? const Center(child: Text('Chưa có tuyến đường yêu thích')) :
              ListView(children: [for (final item in data) ListTile(
                title: Text('${item['start_label']} → ${item['end_label']}', maxLines: 2),
                subtitle: Text('${item['mode']} • ${((item['meters'] as num) / 1000).toStringAsFixed(2)} km • ${((item['seconds'] as num) / 60).ceil()} phút'),
                leading: const Icon(Icons.route),
                onTap: () {
                  final a = LatLng(item['start_lat'] as double, item['start_lng'] as double);
                  final b = LatLng(item['end_lat'] as double, item['end_lng'] as double);
                  final r = RouteData.fromJson({
                    'polyline': item['polyline'], 'meters': item['meters'], 'seconds': item['seconds'],
                    'description': 'Tuyến đã lưu',
                  });
                  setState(() {
                    _start = a; _end = b; _mode = item['mode'] as String;
                    _startText.text = item['start_label'] as String; _endText.text = item['end_label'] as String;
                    _routes = [r]; _selectedRoute = 0; _expanded = false;
                  });
                  Navigator.pop(ctx);
                  WidgetsBinding.instance.addPostFrameCallback((_) => _fitRoute());
                },
                trailing: IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Xóa yêu thích', onPressed: () async {
                  await FavoritesDb.delete(item['id'] as int);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  _showFavorites();
                }),
              )])),
          ]))));
    } catch (e) { if (mounted) setState(() => _message = 'Đọc SQLite thất bại: $e'); }
  }

  Widget _input(bool start) => TextField(
    controller: start ? _startText : _endText, enabled: !_busy,
    decoration: InputDecoration(isDense: true, border: const OutlineInputBorder(),
      labelText: '${start ? 'Xuất phát' : 'Đích đến'} ${widget.level >= 5 ? '(địa chỉ hoặc lat, lng)' : '(lat, lng)'}',
      suffixIcon: (start || widget.level >= 3) ? IconButton(tooltip: 'Lấy GPS làm ${start ? 'xuất phát' : 'đích'}', onPressed: _busy ? null : () => _locate(start), icon: const Icon(Icons.my_location)) : null),
    onChanged: (_) => setState(() { if (start) _start = null; else _end = null; _clearRoute(); }));

  List<Marker> get _markers => [
    if (_gps != null) Marker(point: _gps!, width: 42, height: 42,
        child: const Icon(Icons.my_location, color: Colors.blue, size: 30)),
    if (_start != null && widget.level > 1) Marker(point: _start!, width: 45, height: 45,
        child: const Icon(Icons.location_on, color: Colors.green, size: 42)),
    if (_end != null) Marker(point: _end!, width: 45, height: 45,
        child: const Icon(Icons.location_on, color: Colors.red, size: 42)),
    for (final place in _places) Marker(point: place.position, width: 40, height: 40,
        child: GestureDetector(onTap: () { if (!_busy) _assign(place.position, _pickStart, label: place.name); },
          child: const Icon(Icons.place, color: Colors.orange, size: 38))),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(switch (widget.level) {1 => 'Bài 1 · GPS', 2 => 'Bài 2 · Tìm đường', 3 => 'Bài 3 · Mở rộng', 4 => 'Bài 4 · Trên lớp', _ => 'Bài về nhà · SQLite'}),
      actions: [
        IconButton(tooltip: 'Cấp lại quyền vị trí', onPressed: () => Geolocator.openAppSettings(), icon: const Icon(Icons.settings))]),
    body: SafeArea(child: Column(children: [
      if (_busy) const LinearProgressIndicator(),
      if (_message != null) Material(color: Theme.of(context).colorScheme.errorContainer, child: ListTile(
        dense: true, title: Text(_message!), trailing: IconButton(onPressed: () => setState(() => _message = null), icon: const Icon(Icons.close)))),
      if (widget.level > 1) ...[
        ListTile(dense: true, title: const Text('Điểm đi và điểm đến'), trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => _expanded = !_expanded)),
        if (_expanded) ConstrainedBox(constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .42),
          child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
            _input(true), const SizedBox(height: 8), _input(false),
            if (widget.level >= 3) Wrap(spacing: 8, children: [
              ChoiceChip(label: const Text('Chạm: xuất phát'), selected: _pickStart, onSelected: _busy ? null : (_) => setState(() => _pickStart = true)),
              ChoiceChip(label: const Text('Chạm: đích đến'), selected: !_pickStart, onSelected: _busy ? null : (_) => setState(() => _pickStart = false)),
            ]),
            if (widget.level >= 3) Row(children: [Expanded(child: TextField(controller: _query, enabled: !_busy,
              decoration: const InputDecoration(labelText: 'Khách sạn, quán ăn, bệnh viện…'), onSubmitted: (_) => _search())),
              IconButton(tooltip: 'Tìm địa điểm', onPressed: _busy ? null : _search, icon: const Icon(Icons.search))]),
            if (widget.level >= 5) DropdownButton<String>(isExpanded: true, value: _mode,
              items: const [
                DropdownMenuItem(value: 'DRIVE', child: Text('Ô tô')),
                DropdownMenuItem(value: 'WALK', child: Text('Đi bộ')),
                DropdownMenuItem(value: 'TWO_WHEELER', child: Text('Xe máy (2 bánh)')),
              ],
              onChanged: _busy ? null : (v) => setState(() { _mode = v!; _provider = 'osrm'; _clearRoute(); })),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('', style: TextStyle(fontSize: 12))),
          ]))),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: Row(children: [
          Expanded(child: FilledButton.icon(onPressed: _busy ? null : _find, icon: const Icon(Icons.route), label: const Text('Tìm đường'))),
        ])),
      ],
      if (widget.level >= 5) Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: _showFavorites, icon: const Icon(Icons.bookmarks), label: const Text('Tuyến đã lưu'))),
        if (_route != null) Expanded(child: FilledButton.tonalIcon(onPressed: _saveFavorite, icon: const Icon(Icons.bookmark_add), label: const Text('Lưu yêu thích'))),
      ])),
      if (_route != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
        DropdownButton<int>(isExpanded: true, value: _selectedRoute,
          items: [for (var i = 0; i < _routes.length; i++) DropdownMenuItem(value: i, child: Text('${i + 1}. ${_routes[i].summary}${i == 0 ? ' · Ưu tiên' : ''}', overflow: TextOverflow.ellipsis))],
          onChanged: _busy ? null : (v) { setState(() => _selectedRoute = v!); _fitRoute(); }),
        if (_route!.warnings.isNotEmpty) Text(_route!.warnings.join(' '), maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
        if (_route!.copyright.isNotEmpty) Text(_route!.copyright, style: const TextStyle(fontSize: 10)),
      ])),
      Expanded(child: Stack(children: [
        FlutterMap(
          mapController: _map,
          options: MapOptions(
            initialCenter: _center, initialZoom: 13,
            onMapReady: () { _mapReady = true; if (_gps != null) _map.move(_gps!, 15); },
            onPositionChanged: (camera, _) => _center = camera.center,
            onTap: (tap, point) { if (widget.level >= 3 && !_busy) {
              FocusScope.of(context).unfocus(); _assign(point, _pickStart);
            } },
          ),
          children: [
            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.bai07_123'),
            if (_route != null) PolylineLayer(polylines: [
              Polyline(points: _route!.points, color: Colors.blue, strokeWidth: 5),
            ]),
            MarkerLayer(markers: _markers),
          ],
        ),
        Positioned(left: 8, bottom: 4, child: ColoredBox(color: Colors.white70,
          child: const Text('', style: TextStyle(fontSize: 11)))),
        Positioned(right: 8, top: 8, child: Column(children: [
          FloatingActionButton.small(heroTag: 'gps', tooltip: 'Về vị trí hiện tại',
            onPressed: () { if (_gps != null && _mapReady) _map.move(_gps!, 15); },
            child: const Icon(Icons.my_location)),
          FloatingActionButton.small(heroTag: 'plus', tooltip: 'Phóng to',
            onPressed: () { if (_mapReady) _map.move(_map.camera.center, _map.camera.zoom + 1); },
            child: const Icon(Icons.add)),
          FloatingActionButton.small(heroTag: 'minus', tooltip: 'Thu nhỏ',
            onPressed: () { if (_mapReady) _map.move(_map.camera.center, _map.camera.zoom - 1); },
            child: const Icon(Icons.remove)),
        ])),
        if (widget.level == 1) Positioned(left: 12, bottom: 30, child: FilledButton.icon(
          onPressed: _busy ? null : () => _locate(true), icon: const Icon(Icons.my_location), label: const Text('Lấy vị trí hiện tại'))),
      ])),
    ])));
}

