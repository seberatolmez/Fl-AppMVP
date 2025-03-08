import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'denemeler.db');
    return await openDatabase(
      path,
      version: 3, // Güncel versiyon
      onCreate: (db, version) async {
        // Tablo oluşturma işlemleri
        await db.execute('''
          CREATE TABLE ayt_deneme (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            denemeAdi TEXT,
            bolum TEXT,
            edebiyatDogru INTEGER,
            edebiyatYanlis INTEGER,
            edebiyatBos INTEGER,
            matematikDogru INTEGER,
            matematikYanlis INTEGER,
            matematikBos INTEGER,
            sosyalDogru INTEGER,
            sosyalYanlis INTEGER,
            sosyalBos INTEGER,
            fenDogru INTEGER,
            fenYanlis INTEGER,
            fenBos INTEGER,
            net REAL
          );
        ''');

        await db.execute('''
          CREATE TABLE denemeler (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            denemeAdi TEXT,
            turkceDogru INTEGER,
            turkceYanlis INTEGER,
            turkceBos INTEGER,
            matematikDogru INTEGER,
            matematikYanlis INTEGER,
            matematikBos INTEGER,
            sosyalDogru INTEGER,
            sosyalYanlis INTEGER,
            sosyalBos INTEGER,
            fenDogru INTEGER,
            fenYanlis INTEGER,
            fenBos INTEGER,
            net REAL
          );
        ''');

        await db.execute('''
          CREATE TABLE denemeler_ayt (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            denemeAdi TEXT,
            ders TEXT,
            dogru INTEGER,
            yanlis INTEGER,
            bos INTEGER,
            net REAL
          );
        ''');

        await db.execute('''
          CREATE TABLE denemeler_tyt (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            denemeAdi TEXT,
            ders TEXT,
            dogru INTEGER,
            yanlis INTEGER,
            bos INTEGER,
            net REAL
          );
        ''');
      },
    );
  }

  // AYT Deneme İşlemleri
  Future<int> insertAytDeneme(Map<String, dynamic> deneme) async {
    final db = await database;
    return await db.insert('ayt_deneme', deneme);
  }

  Future<List<Map<String, dynamic>>> getAllAytDenemeler() async {
    final db = await database;
    return await db.query('ayt_deneme');
  }

  Future<int> updateAytDeneme(Map<String, dynamic> deneme, int id) async {
    final db = await database;
    return await db.update(
      'ayt_deneme',
      deneme,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAytDeneme(int id) async {
    final db = await database;
    return await db.delete('ayt_deneme', where: 'id = ?', whereArgs: [id]);
  }

  // Denemeler İşlemleri
  Future<int> insertDeneme(
      String denemeAdi,
      int turkceDogru,
      int turkceYanlis,
      int turkceBos,
      int matematikDogru,
      int matematikYanlis,
      int matematikBos,
      int sosyalDogru,
      int sosyalYanlis,
      int sosyalBos,
      int fenDogru,
      int fenYanlis,
      int fenBos,
      double Net // double türünde
      ) async {
    final db = await database;
    return await db.insert(
      'denemeler',
      {
        'denemeAdi': denemeAdi,
        'turkceDogru': turkceDogru,
        'turkceYanlis': turkceYanlis,
        'turkceBos': turkceBos,
        'matematikDogru': matematikDogru,
        'matematikYanlis': matematikYanlis,
        'matematikBos': matematikBos,
        'sosyalDogru': sosyalDogru,
        'sosyalYanlis': sosyalYanlis,
        'sosyalBos': sosyalBos,
        'fenDogru': fenDogru,
        'fenYanlis': fenYanlis,
        'fenBos': fenBos,
        'net': Net, // double olarak kaydediliyor
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 📌 **Tüm Denemeleri Getirme**
  Future<List<Map<String, dynamic>>> getAllDenemeler() async {
    final db = await database;
    return await db.query('denemeler', orderBy: 'id DESC');
  }

  // 📌 **Deneme Güncelleme**
  Future<int> updateDeneme(
      int id,
      String denemeAdi,
      int turkceDogru,
      int turkceYanlis,
      int turkceBos,
      int matematikDogru,
      int matematikYanlis,
      int matematikBos,
      int sosyalDogru,
      int sosyalYanlis,
      int sosyalBos,
      int fenDogru,
      int fenYanlis,
      int fenBos,
      double toplamNet) async {
    final db = await database;
    return await db.update(
      'denemeler',
      {
        'denemeAdi': denemeAdi,
        'turkceDogru': turkceDogru,
        'turkceYanlis': turkceYanlis,
        'turkceBos': turkceBos,
        'matematikDogru': matematikDogru,
        'matematikYanlis': matematikYanlis,
        'matematikBos': matematikBos,
        'sosyalDogru': sosyalDogru,
        'sosyalYanlis': sosyalYanlis,
        'sosyalBos': sosyalBos,
        'fenDogru': fenDogru,
        'fenYanlis': fenYanlis,
        'fenBos': fenBos,
        'toplamNet': toplamNet,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 📌 **Deneme Silme**
  Future<int> deleteDeneme(int id) async {
    final db = await database;
    return await db.delete('denemeler', where: 'id = ?', whereArgs: [id]);
  }

  // AYT Denemeler İşlemleri
  Future<int> insertBransAytDeneme(Map<String, dynamic> deneme) async {
    final db = await database;
    return await db.insert('denemeler_ayt', deneme);
  }

  Future<List<Map<String, dynamic>>> getAllBransAytDenemeler() async {
    final db = await database;
    return await db.query('denemeler_ayt', orderBy: 'id DESC');
  }

  Future<int> updateBransAytDeneme(Map<String, dynamic> deneme, int id) async {
    final db = await database;
    return await db.update(
      'denemeler_ayt',
      deneme,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBransAytDeneme(int id) async {
    final db = await database;
    return await db.delete('denemeler_ayt', where: 'id = ?', whereArgs: [id]);
  }

  // TYT Denemeler İşlemleri
  Future<int> insertBransTytDeneme(Map<String, dynamic> deneme) async {
    final db = await database;
    return await db.insert('denemeler_tyt', deneme);
  }

  Future<List<Map<String, dynamic>>> getAllBransTytDenemeler() async {
    final db = await database;
    return await db.query('denemeler_tyt', orderBy: 'id DESC');
  }

  Future<int> updateBransTytDeneme(Map<String, dynamic> deneme, int id) async {
    final db = await database;
    return await db.update(
      'denemeler_tyt',
      deneme,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBransTytDeneme(int id) async {
    final db = await database;
    return await db.delete('denemeler_tyt', where: 'id = ?', whereArgs: [id]);
  }
}
