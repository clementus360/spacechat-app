import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final uuid = Uuid();

    _database = (await _initDatabase())!;

    _database!
        .insert("chats", {'id': uuid.v4(), 'name': 'Paul', 'receiver': '1'});
    _database!.insert(
        "chats", {'id': uuid.v4(), 'name': 'Annie', 'receiver': 'test2'});
    _database!.insert(
        "chats", {'id': uuid.v4(), 'name': 'Lisa', 'receiver': 'test3'});
    return _database!;
  }

  static Future<Database?> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');

    try {
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE chats (
              id TEXT PRIMARY KEY,
              name TEXT,
              receiver TEXT,
              image TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE messages (
              id TEXT PRIMARY KEY,
              payload TEXT,
              sender TEXT,
              receiver TEXT,
              timestamp TEXT,
              chatId TEXT,
              FOREIGN KEY (chatId) REFERENCES chats (id)
            )
          ''');
        },
      );

      return database;
    } catch (error) {
      return null;
    }
  }
}
