
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";

  static final _databaseVersion = 1;

  static final table = "my_table";

  static final columnId = "id";

  static final columnTitle = "birdName";

  static final columnDescription = "birdDescription";

  static final columnUrl = "url";

  static final latitude = "latitude";

  static final longitude = "longitude";


  // Create Singletone
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only one app-wide reference to database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {

    Directory documentDirectory = await getApplicationDocumentsDirectory();//getApplicationDocumentsDirectory() - метод path провайдера, дает нам путь приложения в телефоне

    String path = join(documentDirectory.path, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate (Database _database, int _databaseVersion) async {

    await _database.execute(
      //String на много полей: нужно вверху и внизу поставить по три скобки: """ """. Все между ними будет как стринг
      """
      CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnDescription TEXT NOT NULL,
      $columnUrl TEXT NOT NULL,
      $latitude REAL NOT NULL,
      $longitude REAL NOT NULL)
      """
    );
  }

  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  delete (int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: "$columnId = ?", whereArgs: [id]);//ЯЗЫК SQL (Удаляем ту запись, где columnId равен id
  }

}