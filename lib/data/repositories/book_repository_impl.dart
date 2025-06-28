import 'package:backbase/data/datasources/book_remote_datasource.dart';

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
      // First try to get from remote
      final remoteBooks = await remote.searchBooks(query, page);
      
      // Save all remote books to local database
      for (final book in remoteBooks) {
        await local.saveBook(book);
      }
      
      // Then get from local database
      return await local.searchBooks(query);
    } catch (e) {
      // If remote fails, try local only
      try {
        final localBooks = await local.searchBooks(query);
        if (localBooks.isEmpty) {
          throw Exception('No books found. Check your internet connection and try again.');
        }
        return localBooks;
      } catch (e) {
        throw Exception('Failed to load books: ${e.toString()}');
      }
    }
  }

  @override
  Future<void> saveBook(Book book) async {
    try {
      await local.saveBook(book as BookModel);
    } catch (e) {
      throw Exception('Failed to save book: ${e.toString()}');
    }
  }

  @override
  Future<List<Book>> getSavedBooks() async {
    try {
      return await local.getSavedBooks();
    } catch (e) {
      throw Exception('Failed to load saved books: ${e.toString()}');
    }
  }
}