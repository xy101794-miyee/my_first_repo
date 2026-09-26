import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/grocery.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('grocery.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // bumped version for new columns
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        category TEXT NOT NULL,
        isPurchased INTEGER NOT NULL DEFAULT 0,
        price REAL NOT NULL DEFAULT 0
      )
    ''');
  }

  // Migration from v1 → v2
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE groceries ADD COLUMN isPurchased INTEGER NOT NULL DEFAULT 0');
      await db.execute(
          'ALTER TABLE groceries ADD COLUMN price REAL NOT NULL DEFAULT 0');
    }
  }

  // CREATE
  Future<int> insertGrocery(Grocery grocery) async {
    final db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  // READ ALL
  Future<List<Grocery>> getAllGroceries() async {
    final db = await instance.database;
    final result = await db.query('groceries', orderBy: 'id DESC');
    return result.map((json) => Grocery.fromMap(json)).toList();
  }

  // UPDATE
  Future<int> updateGrocery(Grocery grocery) async {
    final db = await instance.database;
    return await db.update(
      'groceries',
      grocery.toMap(),
      where: 'id = ?',
      whereArgs: [grocery.id],
    );
  }

  // TOGGLE PURCHASED (quick update)
  Future<int> togglePurchased(int id, bool isPurchased) async {
    final db = await instance.database;
    return await db.update(
      'groceries',
      {'isPurchased': isPurchased ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> deleteGrocery(int id) async {
    final db = await instance.database;
    return await db.delete(
      'groceries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL PURCHASED
  Future<int> deletePurchased() async {
    final db = await instance.database;
    return await db.delete(
      'groceries',
      where: 'isPurchased = ?',
      whereArgs: [1],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
