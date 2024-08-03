import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER';

    await db.execute('''
    CREATE TABLE ${NoteFields.tableName} (
      ${NoteFields.id} $idType,
      number INTEGER NOT NULL,
      ${NoteFields.title} $textType,
      ${NoteFields.content} $textType,
      ${NoteFields.isFavorite} $boolType,
      ${NoteFields.createdTime} $textType
    )
    ''');
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;

    final id = await db.insert(NoteFields.tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<NoteModel> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      NoteFields.tableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return NoteModel.fromJson(maps.first);
    } else {
      throw Exception('Note ID $id not found');
    }
  }

  Future<List<NoteModel>> readAllNotes() async {
    final db = await instance.database;

    final result = await db.query(NoteFields.tableName);

    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<int> update(NoteModel note) async {
    final db = await instance.database;

    return db.update(
      NoteFields.tableName,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      NoteFields.tableName,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllNotes() async {
    final db = await instance.database;

    await db.delete(
      NoteFields.tableName,
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null; // نضمن عدم استخدام قاعدة بيانات مغلقة
  }
}
