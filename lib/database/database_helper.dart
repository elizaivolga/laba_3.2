import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Новая версия базы данных
  final int _databaseVersion = 2; // Увеличиваем версию

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Инициализация базы данных
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'students.db');
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // Создание базы данных при первом запуске
  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Одногруппники(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surname TEXT,
        name TEXT,
        patronymic TEXT,
        time_added TEXT
      );
    ''');

    // Заполнение базы 5 записями
    var students = [
      ['Рыжков', 'А.', 'С.', DateTime.now().toString()],
      ['Тамбовцева', 'Н.', 'Т.', DateTime.now().toString()],
      ['Петров', 'П.', 'П.', DateTime.now().toString()],
      ['Сидоров', 'С.', 'С.', DateTime.now().toString()],
      ['Михайлов', 'М.', 'М.', DateTime.now().toString()],
    ];

    for (var student in students) {
      await db.insert('Одногруппники', {
        'surname': student[0],
        'name': student[1],
        'patronymic': student[2],
        'time_added': student[3],
      });
    }
  }

  // Миграция при изменении версии базы данных
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Удаляем старую таблицу
      await db.execute('DROP TABLE IF EXISTS Одногруппники');

      // Создаем новую таблицу с обновленной схемой
      await db.execute('''
        CREATE TABLE Одногруппники(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          surname TEXT,
          name TEXT,
          patronymic TEXT,
          time_added TEXT
        );
      ''');

      // Добавление 5 начальных записей в новую таблицу
      var students = [
        ['Рыжков', 'А.', 'С.', DateTime.now().toString()],
        ['Тамбовцева', 'Н.', 'Т.', DateTime.now().toString()],
        ['Петров', 'П.', 'П.', DateTime.now().toString()],
        ['Сидоров', 'С.', 'С.', DateTime.now().toString()],
        ['Михайлов', 'М.', 'М.', DateTime.now().toString()],
      ];

      for (var student in students) {
        await db.insert('Одногруппники', {
          'surname': student[0],
          'name': student[1],
          'patronymic': student[2],
          'time_added': student[3],
        });
      }
    }
  }

  // Добавление записи
  Future<void> addRecord(String fullName) async {
    final db = await database;

    // Разделение строки на фамилию, имя и отчество
    var nameParts = fullName.split(' ');
    String surname = nameParts[0];
    String name = nameParts.length > 1 ? nameParts[1] : '';
    String patronymic = nameParts.length > 2 ? nameParts[2] : '';

    await db.insert('Одногруппники', {
      'surname': surname,
      'name': name,
      'patronymic': patronymic,
      'time_added': DateTime.now().toString(),
    });
  }

  // Обновление записи
  Future<void> updateLastRecord() async {
    final db = await database;
    var lastRecord = await db.rawQuery('SELECT * FROM Одногруппники ORDER BY id DESC LIMIT 1');
    if (lastRecord.isNotEmpty) {
      await db.update(
        'Одногруппники',
        {'surname': 'Иванов', 'name': 'Иван', 'patronymic': 'Иванович'},
        where: 'id = ?',
        whereArgs: [lastRecord[0]['id']],
      );
    }
  }

  // Получить все записи
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await database;
    return await db.query('Одногруппники');
  }

  // Очистить таблицу
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('Одногруппники');
  }
}
