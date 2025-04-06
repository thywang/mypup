import 'package:flutter/foundation.dart';
import 'package:my_pup_simple/schedule/model/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._internal();
  static final DBHelper instance = DBHelper._internal();
  static Database? _db;
  static const version = 1;
  static const tableName = 'tasks';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      version: version,
      onCreate: (db, version) {
        debugPrint('creating a new database');
        return db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            title TEXT,
            note TEXT,
            startTime TEXT,
            endTime TEXT,
            selectedDays TEXT,
            remind INTEGER,
            color INTEGER
          )
          ''');
      },
    );
  }

  static Future<int> addTask(Task task) async {
    final db = await instance.db;
    final id = await db.insert(
      tableName,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Task>> getTasks() async {
    final db = await instance.db;
    final tasks = await db.query(tableName);
    return tasks.map(Task.fromJson).toList();
  }

  static Future<Task?> getTask({required int id}) async {
    final db = await instance.db;
    final tasks = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (tasks.isNotEmpty) {
      return Task.fromJson(tasks.first);
    }
    return null;
  }

  static Future<void> deleteTask({required int id}) async {
    final db = await instance.db;
    await db.delete(
      tableName,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<void> updateTask(Task task) async {
    final db = await instance.db;
    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
