import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookRemoteDatasource {
  final http.Client client;

  BookRemoteDatasource(this.client);

  Future<List<BookModel>> searchBooks(String query, int page) async {
    final url = Uri.parse("https://openlibrary.org/search.json?q=$query&page=$page");
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final docs = data['docs'] as List;
      return docs.map((json) => BookModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
