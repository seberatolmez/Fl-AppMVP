import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/Task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            type TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  // Yeni görev ekleme
  Future<int> insertTask(Task task) async {
    Database db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Görev güncelleme
  Future<int> updateTask(Task task) async {
    Database db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Tamamlanmış görevleri getirme
  Future<List<Task>> getCompletedTasks() async {
    Database db = await database;
    var tasks = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  // Tamamlanmamış görevleri getirme
  Future<List<Task>> getIncompleteTasks() async {
    Database db = await database;
    var tasks = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [0],
    );
    return tasks.map((task) => Task.fromMap(task)).toList();
  }
  Future<void> deleteTask(int id) async{
    final db = await database;
    await db.delete("tasks",where: "id=?",whereArgs: [id]);
  }
}