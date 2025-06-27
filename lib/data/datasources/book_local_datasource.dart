import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book_model.dart';

class BookLocalDatasource {
  Database? _database;
  final Database? testDb; // Add this line

  BookLocalDatasource({this.testDb});

  Future<Database> get database async {
    if (testDb != null) return testDb!; 
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            olid TEXT PRIMARY KEY,
            title TEXT,
            author TEXT,
            coverUrl TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveBook(BookModel book) async {
    final db = await database;
    await db.insert('books', book.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BookModel>> getSavedBooks() async {
    final db = await database;
    final maps = await db.query('books');
    return maps.map((m) => BookModel.fromMap(m)).toList();
  }

  Future<List<BookModel>> searchBooks(String query) async {
    final db = await database;
    final maps = await db.query(
      'books',
      where: 'title LIKE ? OR author LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((m) => BookModel.fromMap(m)).toList();
  }
}
