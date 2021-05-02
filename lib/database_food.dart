import 'package:sqflite/sqflite.dart';

class DatabaseFoods{
  Database? _database;

  DatabaseFoods._();

  static final DatabaseFoods db = DatabaseFoods._();

  Future<Database?> get database async {
    if (_database != null && _database!.isOpen) {
      return _database;
    } else {
      _database = await connectDatabase();
    }
    return _database;
  }

  set setDataBase(Database db) {
    _database = db;
  }

  Future<Database?> connectDatabase() async {
    return await openDatabase("dbFoods.db",
        version: 1, onOpen: _onOpenDB, onCreate: _onCreateDB);
  }

  void _onOpenDB(Database db) async {
    await db.execute("PRAGMA foreign_keys=ON");
  }

  void _onCreateDB(Database db, int versionDB) async {
    await db.execute(
        "CREATE TABLE IF NOT EXISTS task (idLocal Number PRIMARY KEY, idServer Number, name Text, calories double);");
  }
}