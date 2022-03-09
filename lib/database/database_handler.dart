import 'package:calculator/model/history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'claculator.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT NOT NULL,result TEXT NOT NULL)''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertHistory(History history) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('history', history.toMap());
    return result;
  }

  Future<int> deleteHistory() async {
    final db = await initializeDB();
    int result = await db.delete(
      'history',
    );
    return result;
  }

  Future<List<History>> getHistory() async {
    // Get a reference to the database.
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
    );
    // Convert the List<Map<String, dynamic> into a List<History>.
    return List.generate(maps.length, (i) {
      return History(
          id: maps[i]['id'],
          expression: maps[i]['expression'],
          result: maps[i]['result']);
    });
  }
}
