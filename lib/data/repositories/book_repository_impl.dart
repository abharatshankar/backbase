import 'package:backbase/data/datasources/bool_remote_datasource.dart';
import 'dart:io';

import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_datasource.dart';
import '../models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDatasource remote;
  final BookLocalDatasource local;

  BookRepositoryImpl(this.remote, this.local);

  @override
  Future<List<Book>> searchBooks(String query, int page) async {
    try {
      // Try remote first
      return await remote.searchBooks(query, page);
    } catch (e) {
      // If offline or error, fallback to local
      return await local.searchBooks(query);
    }
  }

  @override
  Future<void> saveBook(Book book) async {
    await local.saveBook(book as BookModel);
  }

  @override
  Future<List<Book>> getSavedBooks() {
    return local.getSavedBooks();
  }
}
