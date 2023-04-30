import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = (await _initDatabase())!;

    _database!.insert("chats", {'name': 'Paul', 'receiver': 'test1'});
    _database!.insert("chats", {'name': 'Annie', 'receiver': 'test2'});
    _database!.insert("chats", {'name': 'Lisa', 'receiver': 'test3'});
    _database!.insert("messages", {
      'payload': 'test',
      'sender': '1',
      'timestamp': DateTime.now().toIso8601String(),
      'chatId': 1
    });
    _database!.insert("messages", {
      'payload': 'testoooo',
      'sender': '1',
      'timestamp': DateTime.now().toIso8601String(),
      'chatId': 2
    });
    _database!.insert("messages", {
      'payload': 'test',
      'sender': '1',
      'timestamp': DateTime.now().toIso8601String(),
      'chatId': 1
    });
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
              id INTEGER PRIMARY KEY,
              name TEXT,
              receiver TEXT,
              image TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE messages (
              id INTEGER PRIMARY KEY,
              payload TEXT,
              sender TEXT,
              timestamp TEXT,
              chatId INTEGER,
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
