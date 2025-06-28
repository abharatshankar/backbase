import 'package:backbase/data/datasources/book_local_datasource.dart';
import 'package:backbase/data/models/book_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BookLocalDatasource datasource;
  late Database db;

  setUpAll(() async {
    // Initialize sqflite for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Use in-memory database for testing
    db = await openDatabase(
      inMemoryDatabasePath,
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
    datasource = BookLocalDatasource(testDb: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('saveBook and getSavedBooks', () async {
    final book = BookModel(
      title: 'SQLTest',
      author: 'SQLAuthor',
      coverUrl: '',
      olid: 'sql123',
    );
    await datasource.saveBook(book);
    final books = await datasource.getSavedBooks();
    expect(books.length, 1);
    expect(books.first.title, 'SQLTest');
  });
}
