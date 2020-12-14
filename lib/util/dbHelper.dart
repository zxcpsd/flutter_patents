import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/patent.dart';

class DbHelper {
  final int version = 1;
  Database db;
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'patents.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE patents(id INTEGER PRIMARY KEY, pid TEXT UNIQUE, title TEXT, date TEXT, description TEXT)');
      }, version: version);
    }
    return db;
  }

  Future<int> insertPatent(Patent patent) async {
    db = await openDb();
    int id = await db.insert(
      'patents',
      patent.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Patent>> getPatents() async {
    db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('patents');
    return List.generate(
        maps.length,
        (index) => Patent(
            maps[index]['id'],
            maps[index]['pid'],
            maps[index]['date'],
            maps[index]['title'],
            maps[index]['description']));
  }

  Future<int> deletePatent(Patent patent) async {
    db = await openDb();
    int result =
        await db.delete("patents", where: "id = ?", whereArgs: [patent.id]);
    return result;
  }
}
