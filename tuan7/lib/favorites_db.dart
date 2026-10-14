import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'models.dart';

class FavoritesDb {
  static Database? _db;
  static Future<Database> get db async {
    if (_db != null) return _db!;
    final file = path.join(await getDatabasesPath(), 'bai07_routes.db');
    _db = await openDatabase(file, version: 1, onCreate: (db, version) async {
      await db.execute('''CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_label TEXT NOT NULL,
        end_label TEXT NOT NULL,
        start_lat REAL NOT NULL,
        start_lng REAL NOT NULL,
        end_lat REAL NOT NULL,
        end_lng REAL NOT NULL,
        mode TEXT NOT NULL,
        polyline TEXT NOT NULL,
        meters REAL NOT NULL,
        seconds REAL NOT NULL,
        created_at TEXT NOT NULL
      )''');
    });
    return _db!;
  }

  static Future<int> insert({required String startLabel, required String endLabel,
      required LatLng start, required LatLng end, required String mode,
      required RouteData route}) async {
    return (await db).insert('favorites', {
      'start_label': startLabel, 'end_label': endLabel,
      'start_lat': start.latitude, 'start_lng': start.longitude,
      'end_lat': end.latitude, 'end_lng': end.longitude,
      'mode': mode, 'polyline': route.encoded,
      'meters': route.meters, 'seconds': route.seconds,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, Object?>>> all() async =>
      (await db).query('favorites', orderBy: 'id DESC');

  static Future<int> delete(int id) async =>
      (await db).delete('favorites', where: 'id = ?', whereArgs: [id]);
}
